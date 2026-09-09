import { createServer, IncomingMessage, ServerResponse, Server } from 'node:http';
import { URL } from 'node:url';
import { createHash, createHmac } from 'node:crypto';
import { EnterpriseDatabase } from './db.js';
import { loadEnterpriseConfig, EnterpriseConfig } from './config.js';
import { classifyColumnSample, maskSensitiveValue } from '@dpdp/shared';

export interface ColumnSchemaInfo {
  name: string;
  dataType: string;
  isNullable: boolean;
  isPrimaryKey: boolean;
  detectedPii?: {
    piiType: string;
    confidence: number;
    sampleMasked?: string;
    reason?: string;
  };
}

export interface TableSchemaInfo {
  tableName: string;
  rowCount: number;
  columns: ColumnSchemaInfo[];
  ddlChecksum: string;
}

export interface CachedConsentEntry {
  principalId: string;
  purposeId: string;
  allowed: boolean;
  noticeVersion: string;
  updatedAt: number;
}

/**
 * In-VPC Zone Agent Daemon
 * Runs within enterprise network boundary. Zero raw customer PII ever egresses to SaaS Control Plane.
 */
export class ZoneAgentWorker {
  private config: EnterpriseConfig;
  private db: EnterpriseDatabase;
  private consentCache: Map<string, CachedConsentEntry> = new Map();
  private status: 'ACTIVE' | 'SCANNING' | 'DORMANT' | 'ERROR' = 'ACTIVE';
  private agentToken: string = '';
  private lastDdlChecksum: string = '';
  private server: Server | null = null;
  private isRunning: boolean = false;
  private heartbeatTimer: NodeJS.Timeout | null = null;
  private ddlTimer: NodeJS.Timeout | null = null;

  constructor(config?: Partial<EnterpriseConfig>, db?: EnterpriseDatabase) {
    this.config = { ...loadEnterpriseConfig(), ...config };
    this.db = db || new EnterpriseDatabase(this.config.dbConnectionString);
  }

  async start(): Promise<void> {
    if (this.isRunning) return;
    this.isRunning = true;

    await this.db.init();

    // 1. Start local HTTP API for enterprise microservices sub-ms consent checks
    await this.startHttpServer();

    // 2. Outbound Enrollment with SaaS Compliance Control Plane
    await this.enrollWithControlPlane();

    // 3. Initial Local Schema Discovery & PII Classification
    await this.triggerScanAndReport();

    // 4. Start Outbound Heartbeat & Task Polling loop
    this.heartbeatTimer = setInterval(
      () => this.sendHeartbeat(),
      this.config.heartbeatIntervalMs
    );

    // 5. Start Schema Drift Watcher
    this.ddlTimer = setInterval(
      () => this.checkDdlDrift(),
      this.config.ddlCheckIntervalMs
    );

    console.log(`[In-VPC Zone Agent] Daemon '${this.config.agentId}' active on port ${this.config.agentPort} (DB: ${this.config.dbType})`);
  }

  async stop(): Promise<void> {
    this.isRunning = false;
    if (this.heartbeatTimer) clearInterval(this.heartbeatTimer);
    if (this.ddlTimer) clearInterval(this.ddlTimer);

    if (this.server) {
      await new Promise<void>((resolve) => this.server?.close(() => resolve()));
      this.server = null;
    }

    await this.db.close();
    console.log('[In-VPC Zone Agent] Daemon stopped gracefully.');
  }

  getConsentCacheSize(): number {
    return this.consentCache.size;
  }

  // --------------------------------------------------------------------------
  // Local HTTP API (Port 5000) for Sub-millisecond Hot-Path Microservice Gating
  // --------------------------------------------------------------------------
  private async startHttpServer(): Promise<void> {
    return new Promise((resolve) => {
      this.server = createServer((req, res) => this.handleLocalRequest(req, res));
      this.server.listen(this.config.agentPort, () => resolve());
    });
  }

  private async handleLocalRequest(req: IncomingMessage, res: ServerResponse): Promise<void> {
    const parsedUrl = new URL(req.url || '/', `http://localhost:${this.config.agentPort}`);
    const pathname = parsedUrl.pathname;
    const method = req.method?.toUpperCase();

    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Access-Control-Allow-Origin', '*');

    // 1. Health: GET /health
    if (method === 'GET' && pathname === '/health') {
      res.writeHead(200);
      res.end(JSON.stringify({
        status: this.status,
        agentId: this.config.agentId,
        agentName: this.config.agentName,
        tenantId: this.config.organizationSlug,
        dbType: this.config.dbType,
        cachedConsentCount: this.consentCache.size,
        timestamp: new Date().toISOString(),
      }));
      return;
    }

    // 2. Hot-Path Consent Check: GET /consent/check?principalId=...&purpose=...
    if (method === 'GET' && pathname === '/consent/check') {
      const principalId = parsedUrl.searchParams.get('principalId') || parsedUrl.searchParams.get('principal_id');
      const purpose = parsedUrl.searchParams.get('purpose') || parsedUrl.searchParams.get('purposeId') || 'marketing';

      if (!principalId) {
        res.writeHead(400);
        res.end(JSON.stringify({ allowed: false, error: 'principalId is required' }));
        return;
      }

      const key = `${principalId.toLowerCase()}:${purpose.toLowerCase()}`;
      const cached = this.consentCache.get(key);

      if (cached) {
        res.writeHead(200);
        res.end(JSON.stringify({
          allowed: cached.allowed,
          principalId,
          purpose,
          noticeVersion: cached.noticeVersion,
          source: 'AGENT_IN_MEMORY_CACHE',
          checkedAt: new Date().toISOString(),
        }));
        return;
      }

      // If not in cache, fallback to local database consent_preferences table
      const dbRecord = await this.db.get<{ is_granted: boolean | number; notice_version: string }>(
        `SELECT is_granted, notice_version FROM consent_preferences WHERE LOWER(user_id) = LOWER($1) AND LOWER(purpose_id) = LOWER($2)`,
        [principalId, purpose]
      );

      const isAllowed = Boolean(dbRecord?.is_granted);
      this.consentCache.set(key, {
        principalId,
        purposeId: purpose,
        allowed: isAllowed,
        noticeVersion: dbRecord?.notice_version || '2.1',
        updatedAt: Date.now(),
      });

      res.writeHead(200);
      res.end(JSON.stringify({
        allowed: isAllowed,
        principalId,
        purpose,
        noticeVersion: dbRecord?.notice_version || '2.1',
        source: 'LOCAL_DATABASE_FALLBACK',
        checkedAt: new Date().toISOString(),
      }));
      return;
    }

    // 3. Local Invalidation / Cache Sync: POST /consent/sync
    if (method === 'POST' && pathname === '/consent/sync') {
      const body = await this.readJsonBody(req);
      const { principalId, purposeId, allowed, noticeVersion } = body;
      if (principalId && purposeId) {
        const key = `${principalId.toLowerCase()}:${purposeId.toLowerCase()}`;
        this.consentCache.set(key, {
          principalId,
          purposeId,
          allowed: Boolean(allowed),
          noticeVersion: noticeVersion || '2.1',
          updatedAt: Date.now(),
        });
        res.writeHead(200);
        res.end(JSON.stringify({ success: true, message: 'Local consent cache synced' }));
        return;
      }
      res.writeHead(400);
      res.end(JSON.stringify({ error: 'principalId and purposeId are required' }));
      return;
    }

    // 4. Force Scan Trigger: POST /scan/trigger
    if (method === 'POST' && pathname === '/scan/trigger') {
      try {
        const report = await this.triggerScanAndReport();
        res.writeHead(200);
        res.end(JSON.stringify({ success: true, report }));
      } catch (err: any) {
        res.writeHead(500);
        res.end(JSON.stringify({ success: false, error: err.message }));
      }
      return;
    }

    res.writeHead(404);
    res.end(JSON.stringify({ error: 'Route not found' }));
  }

  // --------------------------------------------------------------------------
  // Local Schema Inspection & Statistical In-Memory PII Classification
  // --------------------------------------------------------------------------
  async inspectLocalSchemaAndPii(): Promise<{ tables: TableSchemaInfo[]; overallChecksum: string }> {
    const tableNames: string[] = [];

    if (this.db.isPostgres()) {
      const rows = await this.db.all<{ table_name: string }>(`
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
        ORDER BY table_name;
      `);
      tableNames.push(...rows.map((r) => r.table_name));
    } else {
      const rows = await this.db.all<{ name: string }>(`
        SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name;
      `);
      tableNames.push(...rows.map((r) => r.name));
    }

    const tables: TableSchemaInfo[] = [];

    for (const tbl of tableNames) {
      const cols: ColumnSchemaInfo[] = [];

      if (this.db.isPostgres()) {
        const colRows = await this.db.all<{ column_name: string; data_type: string; is_nullable: string; is_pk: boolean }>(`
          SELECT 
            c.column_name, 
            c.data_type, 
            c.is_nullable,
            CASE WHEN pk.column_name IS NOT NULL THEN true ELSE false END as is_pk
          FROM information_schema.columns c
          LEFT JOIN (
            SELECT kcu.column_name
            FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu
              ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
            WHERE tc.constraint_type = 'PRIMARY KEY' AND tc.table_name = $1
          ) pk ON c.column_name = pk.column_name
          WHERE c.table_name = $1 AND c.table_schema = 'public'
          ORDER BY c.ordinal_position;
        `, [tbl]);

        for (const cr of colRows) {
          cols.push({
            name: cr.column_name,
            dataType: cr.data_type,
            isNullable: cr.is_nullable === 'YES',
            isPrimaryKey: cr.is_pk,
          });
        }
      } else {
        const pragmaRows = await this.db.all<{ name: string; type: string; notnull: number; pk: number }>(
          `PRAGMA table_info("${tbl}")`
        );
        for (const pr of pragmaRows) {
          cols.push({
            name: pr.name,
            dataType: pr.type || 'TEXT',
            isNullable: pr.notnull === 0,
            isPrimaryKey: pr.pk > 0,
          });
        }
      }

      // Sample rows locally in RAM (Zero egress to external SaaS)
      let sampleRows: Record<string, unknown>[] = [];
      try {
        sampleRows = await this.db.all(`SELECT * FROM "${tbl}" LIMIT 50`);
      } catch {}

      // Classify columns in RAM using Verhoeff / Luhn / Regex
      const enrichedCols: ColumnSchemaInfo[] = cols.map((col) => {
        const values = sampleRows.map((r) => r[col.name]).filter((v) => v !== null && v !== undefined);
        const classification = classifyColumnSample(col.name, values);

        return {
          ...col,
          detectedPii: classification.piiType !== 'UNKNOWN' ? {
            piiType: classification.piiType,
            confidence: classification.confidence,
            sampleMasked: classification.sampleMasked,
            reason: classification.reason,
          } : undefined,
        };
      });

      const tableDdlStr = `${tbl}:${cols.map((c) => `${c.name}:${c.dataType}`).join(',')}`;
      const ddlChecksum = createHash('sha256').update(tableDdlStr).digest('hex');

      tables.push({
        tableName: tbl,
        rowCount: sampleRows.length,
        columns: enrichedCols,
        ddlChecksum,
      });
    }

    const overallStr = tables.map((t) => `${t.tableName}:${t.ddlChecksum}`).join(';');
    const overallChecksum = createHash('sha256').update(overallStr).digest('hex');

    return { tables, overallChecksum };
  }

  // --------------------------------------------------------------------------
  // Outbound SaaS Heartbeat, Discovery & DSR Task Processing
  // --------------------------------------------------------------------------
  private async enrollWithControlPlane(): Promise<void> {
    try {
      const payload = {
        agentId: this.config.agentId,
        agentName: this.config.agentName,
        tenantId: this.config.organizationSlug,
        targetType: this.config.dbType,
        targetUriMasked: this.config.dbConnectionString.replace(/:[^:@]+@/, ':****@'),
        environment: this.config.nodeEnv,
        version: '1.0.0',
      };

      const res = await fetch(`${this.config.controlPlaneUrl}/api/v1/agents/enroll`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
        signal: AbortSignal.timeout(4000),
      }).catch(async () => {
        // Try legacy route
        return fetch(`${this.config.controlPlaneUrl}/api/agent/enroll`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
          signal: AbortSignal.timeout(4000),
        }).catch(() => null);
      });

      if (res && res.ok) {
        const data = await res.json() as any;
        if (data.agentToken) {
          this.agentToken = data.agentToken;
        }
        console.log(`[In-VPC Zone Agent] Enrolled with Compliance SaaS successfully.`);
      }
    } catch (e: any) {
      console.log(`[In-VPC Zone Agent] SaaS not yet reachable for enrollment; will retry on heartbeat tick.`);
    }
  }

  public async sendHeartbeat(): Promise<void> {
    if (!this.isRunning) return;
    try {
      const memoryUsage = process.memoryUsage();
      const payload = {
        agentId: this.config.agentId,
        tenantId: this.config.organizationSlug,
        status: this.status,
        ddlChecksum: this.lastDdlChecksum,
        timestamp: new Date().toISOString(),
        memoryUsageMb: Math.round(memoryUsage.heapUsed / 1024 / 1024),
      };

      const res = await fetch(`${this.config.controlPlaneUrl}/api/v1/agents/heartbeat`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.agentToken || `agent_dev_${this.config.agentId}`}`,
        },
        body: JSON.stringify(payload),
        signal: AbortSignal.timeout(4000),
      }).catch(async () => {
        return fetch(`${this.config.controlPlaneUrl}/api/agent/heartbeat`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${this.agentToken || `agent_dev_${this.config.agentId}`}`,
          },
          body: JSON.stringify(payload),
          signal: AbortSignal.timeout(4000),
        }).catch(() => null);
      });

      if (res && res.ok) {
        const data = await res.json() as { pendingTasks?: any[] };
        if (data.pendingTasks && data.pendingTasks.length > 0) {
          for (const task of data.pendingTasks) {
            await this.processTask(task);
          }
        }
      }
    } catch (err) {
      // Outbound retry on next tick
    }
  }

  private async checkDdlDrift(): Promise<void> {
    try {
      const { overallChecksum } = await this.inspectLocalSchemaAndPii();
      if (this.lastDdlChecksum && this.lastDdlChecksum !== overallChecksum) {
        console.log(`[In-VPC Zone Agent] Schema drift detected (${this.lastDdlChecksum.slice(0, 8)} -> ${overallChecksum.slice(0, 8)}). Triggering re-scan.`);
        await this.triggerScanAndReport();
      }
      this.lastDdlChecksum = overallChecksum;
    } catch {}
  }

  async triggerScanAndReport(): Promise<any> {
    this.status = 'SCANNING';
    try {
      const { tables, overallChecksum } = await this.inspectLocalSchemaAndPii();
      this.lastDdlChecksum = overallChecksum;

      const report = {
        agentId: this.config.agentId,
        tenantId: this.config.organizationSlug,
        targetId: `target-${this.config.dbType.toLowerCase()}`,
        targetType: this.config.dbType,
        targetUriMasked: this.config.dbConnectionString.replace(/:[^:@]+@/, ':****@'),
        timestamp: new Date().toISOString(),
        tables,
        overallDdlChecksum: overallChecksum,
      };

      try {
        await fetch(`${this.config.controlPlaneUrl}/api/v1/agents/discovery`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${this.agentToken || `agent_dev_${this.config.agentId}`}`,
          },
          body: JSON.stringify(report),
          signal: AbortSignal.timeout(5000),
        }).catch(async () => {
          return fetch(`${this.config.controlPlaneUrl}/api/agent/discovery`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${this.agentToken || `agent_dev_${this.config.agentId}`}`,
            },
            body: JSON.stringify(report),
            signal: AbortSignal.timeout(5000),
          }).catch(() => null);
        });
      } catch {}

      this.status = 'ACTIVE';
      return report;
    } catch (e) {
      this.status = 'ACTIVE';
      throw e;
    }
  }

  // --------------------------------------------------------------------------
  // Execute In-VPC DSR Erasure Tasks (Masking, Deletions & Cryptographic Proofs)
  // --------------------------------------------------------------------------
  private async processTask(task: any): Promise<void> {
    console.log(`[In-VPC Zone Agent] Processing received task ${task.taskId || task.id} (${task.type})`);

    if (task.type === 'TASK_DISCOVERY_TRIGGER') {
      await this.triggerScanAndReport();
      return;
    }

    if (task.type === 'TASK_CONSENT_INVALIDATE') {
      const { principalId, purposes } = task.data || task.payload || {};
      if (principalId) {
        if (Array.isArray(purposes)) {
          for (const p of purposes) {
            this.consentCache.delete(`${principalId.toLowerCase()}:${p.toLowerCase()}`);
          }
        } else {
          // Clear all entries for this principal
          for (const k of Array.from(this.consentCache.keys())) {
            if (k.startsWith(`${principalId.toLowerCase()}:`)) {
              this.consentCache.delete(k);
            }
          }
        }
      }
      return;
    }

    if (task.type === 'DSR_ERASURE' || task.type === 'TASK_DSR_EXECUTE') {
      const taskId = task.taskId || task.id;
      const payload = task.payload || task.data || {};
      const targetRef = payload.requesterReference || payload.principalId || payload.filterValue;
      const targetTable = payload.targetTable || payload.tableName || 'users';

      let rowsAffected = 0;
      try {
        if (targetTable === 'users' && targetRef) {
          // In-Database Masking / Soft-Delete
          const res = await this.db.run(
            `UPDATE users 
             SET full_name = '[DELETED DATA PRINCIPAL]',
                 email = $1,
                 phone = '[ERASED]',
                 aadhaar_no = '[MASKED-DPDP-12]',
                 pan_no = '[MASKED-DPDP-12]',
                 address = '[ERASED]',
                 status = 'SOFT_DELETED',
                 updated_at = CURRENT_TIMESTAMP
             WHERE LOWER(email) = LOWER($2) OR id = $3`,
            [`deleted-${Date.now()}@redacted.internal`, targetRef, targetRef]
          );
          rowsAffected = res.rowCount;

          // Mask related customer reviews
          await this.db.run(
            `UPDATE customer_reviews SET review_text = '[Redacted by Data Principal]' WHERE user_id = $1`,
            [targetRef]
          );
        }

        // Generate Tamper-evident cryptographic receipt using SHA-384
        const receiptData = JSON.stringify({
          taskId,
          targetRef,
          targetTable,
          rowsAffected,
          completedAt: new Date().toISOString(),
        });
        const receiptDigestSha384 = createHash('sha384').update(receiptData).digest('hex');
        const hmacSignature = createHmac('sha256', this.config.agentSecret).update(receiptDigestSha384).digest('hex');

        // Post result back to Control Plane
        await fetch(`${this.config.controlPlaneUrl}/api/v1/agents/tasks/${taskId}/result`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${this.agentToken || `agent_dev_${this.config.agentId}`}`,
          },
          body: JSON.stringify({
            status: 'SUCCEEDED',
            result: {
              rowsAffected,
              maskedFields: ['full_name', 'email', 'phone', 'aadhaar_no', 'pan_no', 'address'],
              receiptSha384: `urn:sha384:${receiptDigestSha384}`,
              hmacSignature,
            },
          }),
          signal: AbortSignal.timeout(4000),
        }).catch(async () => {
          return fetch(`${this.config.controlPlaneUrl}/api/agent/receipt`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${this.agentToken || `agent_dev_${this.config.agentId}`}`,
            },
            body: JSON.stringify({
              taskId,
              dsrId: payload.requestId || payload.dsrId,
              agentId: this.config.agentId,
              status: 'SUCCESS',
              recordsAffected: rowsAffected,
              completedAt: new Date().toISOString(),
              executionSignature: hmacSignature,
            }),
          });
        });

        console.log(`[In-VPC Zone Agent] DSR Erasure task ${taskId} executed successfully (${rowsAffected} rows masked).`);
      } catch (err: any) {
        console.error(`[In-VPC Zone Agent] Failed executing DSR Erasure task ${taskId}:`, err);
      }
    }
  }

  private readJsonBody(req: IncomingMessage): Promise<any> {
    return new Promise((resolve, reject) => {
      let data = '';
      req.on('data', (chunk) => {
        data += chunk;
      });
      req.on('end', () => {
        try {
          resolve(data ? JSON.parse(data) : {});
        } catch {
          reject(new Error('Invalid JSON'));
        }
      });
      req.on('error', reject);
    });
  }
}

// Standalone executable execution (e.g. for Render Background Worker)
if (process.argv[1] && process.argv[1].endsWith('agent-worker.js')) {
  const worker = new ZoneAgentWorker();
  worker.start().catch((err) => {
    console.error('Failed to start Zone Agent Worker:', err);
    process.exit(1);
  });
}
