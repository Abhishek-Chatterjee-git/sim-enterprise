import { createServer, IncomingMessage, ServerResponse, Server } from 'node:http';
import { URL } from 'node:url';
import { readFileSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { randomBytes } from 'node:crypto';
import { EnterpriseDatabase } from './db.js';
import { ComplianceSaasClient } from './saas-client.js';
import { loadEnterpriseConfig, EnterpriseConfig } from './config.js';
import { hashPassword, verifyPassword, createSessionToken, verifySessionToken, SessionPayload } from './auth.js';

export interface EcomServerOptions {
  port?: number;
  config?: Partial<EnterpriseConfig>;
}

export class EcomServer {
  private config: EnterpriseConfig;
  private db: EnterpriseDatabase;
  private saasClient: ComplianceSaasClient;
  private server: Server | null = null;
  private isRunning: boolean = false;
  private publicDir: string;

  constructor(options?: EcomServerOptions, db?: EnterpriseDatabase) {
    this.config = { ...loadEnterpriseConfig(), ...(options?.config || {}) };
    if (options?.port) {
      this.config.port = options.port;
    }
    this.db = db || new EnterpriseDatabase(this.config.dbConnectionString);
    this.saasClient = new ComplianceSaasClient(
      this.config.controlPlaneUrl,
      this.config.organizationSlug,
      this.config.organizationId
    );
    this.publicDir = resolve(process.cwd(), 'sim-enterprise', 'ecom-app', 'public');
    if (!existsSync(this.publicDir)) {
      this.publicDir = resolve(process.cwd(), 'public');
    }
  }

  async start(): Promise<void> {
    if (this.isRunning) return;
    this.isRunning = true;

    await this.db.init();

    return new Promise((res) => {
      this.server = createServer((req, res) => this.handleRequest(req, res));
      this.server.listen(this.config.port, () => {
        console.log(`[Storefront Web Service] Running on http://localhost:${this.config.port}`);
        res();
      });
    });
  }

  async stop(): Promise<void> {
    this.isRunning = false;
    if (this.server) {
      await new Promise<void>((resolve) => this.server?.close(() => resolve()));
      this.server = null;
    }
    await this.db.close();
  }

  private async handleRequest(req: IncomingMessage, res: ServerResponse): Promise<void> {
    const parsedUrl = new URL(req.url || '/', `http://localhost:${this.config.port}`);
    const pathname = parsedUrl.pathname;
    const method = req.method?.toUpperCase();

    // CORS & JSON Headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');

    if (method === 'OPTIONS') {
      res.writeHead(204);
      res.end();
      return;
    }

    try {
      // ----------------------------------------------------------------------
      // API ROUTES (/api/...)
      // ----------------------------------------------------------------------
      if (pathname.startsWith('/api/')) {
        res.setHeader('Content-Type', 'application/json');

        // 1. Health
        if (pathname === '/api/health' && method === 'GET') {
          res.writeHead(200);
          res.end(JSON.stringify({ status: 'ok', service: 'storefront-web', dbType: this.config.dbType }));
          return;
        }

        // 2. Auth: Signup
        if (pathname === '/api/auth/signup' && method === 'POST') {
          const body = await this.readJsonBody(req);
          const { fullName, email, phone, password, aadhaarNo, panNo, address, city, state, pincode, consents } = body;

          if (!fullName || !email || !password) {
            res.writeHead(400);
            res.end(JSON.stringify({ error: 'Full name, email, and password are required' }));
            return;
          }

          const existing = await this.db.get('SELECT id FROM users WHERE LOWER(email) = LOWER($1)', [email]);
          if (existing) {
            res.writeHead(409);
            res.end(JSON.stringify({ error: 'An account with this email already exists' }));
            return;
          }

          const userId = `usr-${randomBytes(6).toString('hex')}`;
          const passHash = hashPassword(password);

          await this.db.run(
            `INSERT INTO users (id, full_name, email, phone, password_hash, aadhaar_no, pan_no, address, city, state, pincode, status)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, 'ACTIVE')`,
            [
              userId,
              fullName,
              email.trim().toLowerCase(),
              phone || '+919800000000',
              passHash,
              aadhaarNo || '367598324157',
              panNo || 'ABCDE1234F',
              address || '12 MG Road',
              city || 'Mumbai',
              state || 'Maharashtra',
              pincode || '400001',
            ]
          );

          // Save consents in local DB
          const consentedPurposes: string[] = Array.isArray(consents) ? consents : ['essential', 'marketing', 'analytics'];
          for (const p of ['essential', 'marketing', 'analytics']) {
            const isGranted = consentedPurposes.includes(p);
            await this.db.run(
              `INSERT INTO consent_preferences (id, user_id, purpose_id, is_granted, notice_version)
               VALUES ($1, $2, $3, $4, '2.1')`,
              [`cp-${userId}-${p}`, userId, p, this.db.isPostgres() ? isGranted : (isGranted ? 1 : 0)]
            );

            // Sync with local Zone Agent cache
            await this.syncWithLocalAgent(email, p, isGranted);
          }

          // Outbound Webhook to SaaS Compliance Control Plane
          await this.saasClient.notifyConsentGrant({
            dataSubjectIdentifier: email,
            purposes: consentedPurposes,
            purpose: consentedPurposes.join(', '),
            noticeId: 'DPDP-NOTICE-2025-V2.1',
          });

          // Audit log
          await this.db.run(
            `INSERT INTO audit_logs (id, action, user_id, ip_address, user_agent, details)
             VALUES ($1, 'CUSTOMER_SIGNUP', $2, $3, $4, $5)`,
            [`log-${Date.now()}`, userId, req.socket.remoteAddress || '127.0.0.1', req.headers['user-agent'] || '', `Customer registered with consents: ${consentedPurposes.join(', ')}`]
          );

          const token = createSessionToken({ userId, email, fullName }, this.config.sessionSecret);
          res.writeHead(201);
          res.end(JSON.stringify({
            success: true,
            token,
            user: { id: userId, fullName, email, phone: phone || '+919800000000', consents: consentedPurposes },
          }));
          return;
        }

        // 3. Auth: Login
        if (pathname === '/api/auth/login' && method === 'POST') {
          const body = await this.readJsonBody(req);
          const { email, password } = body;

          if (!email || !password) {
            res.writeHead(400);
            res.end(JSON.stringify({ error: 'Email and password are required' }));
            return;
          }

          const user = await this.db.get<any>('SELECT * FROM users WHERE LOWER(email) = LOWER($1)', [email]);
          if (!user || !verifyPassword(password, user.password_hash)) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Invalid email or password' }));
            return;
          }

          if (user.status === 'SOFT_DELETED' || user.status === 'QUARANTINED') {
            res.writeHead(403);
            res.end(JSON.stringify({
              error: 'Account is pending erasure (Quarantined)',
              status: user.status,
              canReactivate: true,
              email: user.email,
            }));
            return;
          }

          const token = createSessionToken({ userId: user.id, email: user.email, fullName: user.full_name }, this.config.sessionSecret);
          res.writeHead(200);
          res.end(JSON.stringify({
            success: true,
            token,
            user: {
              id: user.id,
              fullName: user.full_name,
              email: user.email,
              phone: user.phone,
              address: user.address,
              city: user.city,
              state: user.state,
              pincode: user.pincode,
              status: user.status,
            },
          }));
          return;
        }

        // 4. Auth: Me
        if (pathname === '/api/auth/me' && method === 'GET') {
          const auth = this.authenticateRequest(req);
          if (!auth) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Authentication required. Please sign in.' }));
            return;
          }

          const user = await this.db.get<any>('SELECT * FROM users WHERE id = $1', [auth.userId]);
          if (!user) {
            res.writeHead(404);
            res.end(JSON.stringify({ error: 'User not found' }));
            return;
          }

          const consents = await this.db.all<{ purpose_id: string; is_granted: boolean | number }>(
            'SELECT purpose_id, is_granted FROM consent_preferences WHERE user_id = $1',
            [auth.userId]
          );

          res.writeHead(200);
          res.end(JSON.stringify({
            user: {
              id: user.id,
              fullName: user.full_name,
              email: user.email,
              phone: user.phone,
              aadhaarNoMasked: user.aadhaar_no ? `XXXX-XXXX-${user.aadhaar_no.slice(-4)}` : null,
              panNoMasked: user.pan_no ? `${user.pan_no.slice(0, 2)}XXXXX${user.pan_no.slice(-2)}` : null,
              address: user.address,
              city: user.city,
              state: user.state,
              pincode: user.pincode,
              status: user.status,
            },
            consents: consents.map((c) => ({ purposeId: c.purpose_id, isGranted: Boolean(c.is_granted) })),
          }));
          return;
        }

        // 5. Products Catalog (Public)
        if (pathname === '/api/products' && method === 'GET') {
          const products = await this.db.all('SELECT * FROM products ORDER BY price DESC');
          res.writeHead(200);
          res.end(JSON.stringify({ products }));
          return;
        }

        // 6. Orders: Place Order (Authentication Required)
        if (pathname === '/api/orders' && method === 'POST') {
          const auth = this.authenticateRequest(req);
          if (!auth) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Please sign in or create an account to complete your purchase.' }));
            return;
          }

          const user = await this.db.get<any>('SELECT * FROM users WHERE id = $1', [auth.userId]);
          if (!user) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Session expired or user not found. Please sign in again.' }));
            return;
          }

          if (user.status === 'SOFT_DELETED' || user.status === 'QUARANTINED') {
            res.writeHead(403);
            res.end(JSON.stringify({ error: 'Your account is scheduled for erasure. Orders cannot be placed.' }));
            return;
          }

          const body = await this.readJsonBody(req);
          const items = Array.isArray(body.items) ? body.items : [];
          if (items.length === 0) {
            res.writeHead(400);
            res.end(JSON.stringify({ error: 'Cart is empty. Please add items before placing an order.' }));
            return;
          }

          const shippingAddress = body.shippingAddress || user.address || '12 MG Road, Mumbai 400001';
          const paymentMethod = body.paymentMethod || 'UPI (Razorpay)';

          let totalAmount = 0;
          for (const itm of items) {
            const up = Number(itm.unitPrice) || Number(itm.price) || 1000;
            const qty = Number(itm.quantity) || 1;
            totalAmount += up * qty;
          }
          if (totalAmount <= 0) totalAmount = 3800;

          const orderId = `ord-${Date.now()}`;
          const orderNum = `ART-2026-${Math.floor(1000 + Math.random() * 9000)}`;

          await this.db.run(
            `INSERT INTO orders (id, user_id, order_number, total_amount, currency, status, shipping_address, payment_method)
             VALUES ($1, $2, $3, $4, 'INR', 'CONFIRMED', $5, $6)`,
            [orderId, user.id, orderNum, totalAmount, shippingAddress, paymentMethod]
          );

          for (const itm of items) {
            const up = Number(itm.unitPrice) || Number(itm.price) || 1000;
            const qty = Number(itm.quantity) || 1;
            await this.db.run(
              `INSERT INTO order_items (id, order_id, product_name, sku, quantity, unit_price, total_price)
               VALUES ($1, $2, $3, $4, $5, $6, $7)`,
              [`item-${randomBytes(4).toString('hex')}`, orderId, itm.productName || itm.name || 'Artisan Product', itm.sku || 'SKU-001', qty, up, qty * up]
            );
          }

          // Payment record
          await this.db.run(
            `INSERT INTO payments (id, order_id, user_id, transaction_id, payment_gateway, amount, currency, status, upi_id)
             VALUES ($1, $2, $3, $4, 'Razorpay', $5, 'INR', 'SUCCESS', $6)`,
            [`pay-${randomBytes(4).toString('hex')}`, orderId, user.id, `txn_rzp_${randomBytes(6).toString('hex')}`, totalAmount, body.upiId || 'customer@okhdfcbank']
          );

          res.writeHead(201);
          res.end(JSON.stringify({ success: true, orderId, orderNumber: orderNum, totalAmount }));
          return;
        }

        // 7. Orders: List for authenticated user
        if (pathname === '/api/orders' && method === 'GET') {
          const auth = this.authenticateRequest(req);
          if (!auth) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Authentication required. Please sign in.' }));
            return;
          }

          const orders = await this.db.all<any>('SELECT * FROM orders WHERE user_id = $1 ORDER BY created_at DESC', [auth.userId]);
          for (const o of orders) {
            o.items = await this.db.all('SELECT * FROM order_items WHERE order_id = $1', [o.id]);
          }
          res.writeHead(200);
          res.end(JSON.stringify({ orders }));
          return;
        }

        // 8. Privacy Center: Status (Authentication Required)
        if (pathname === '/api/privacy/status' && method === 'GET') {
          const auth = this.authenticateRequest(req);
          if (!auth) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Authentication required. Please sign in to view privacy settings.' }));
            return;
          }

          const user = await this.db.get<any>('SELECT * FROM users WHERE id = $1', [auth.userId]);
          if (!user) {
            res.writeHead(404);
            res.end(JSON.stringify({ error: 'User not found' }));
            return;
          }

          const consents = await this.db.all<any>('SELECT * FROM consent_preferences WHERE user_id = $1', [auth.userId]);

          res.writeHead(200);
          res.end(JSON.stringify({
            userId: user.id,
            email: user.email,
            fullName: user.full_name,
            status: user.status,
            noticeVersion: '2.1',
            consents: consents.map((c: any) => ({ purposeId: c.purpose_id, isGranted: Boolean(c.is_granted) })),
            noticeDetails: {
              title: 'Customer Privacy & Preference Notice (v2.1)',
              purposes: [
                {
                  purposeId: 'essential',
                  name: 'Essential Order Fulfillment & Statutory Compliance',
                  description: 'Necessary for processing payments, invoicing, courier delivery, and customer warranty support.',
                  isMandatory: true,
                  retentionDays: 2555,
                },
                {
                  purposeId: 'marketing',
                  name: 'Personalized Recommendations & Promotional Alerts',
                  description: 'Special discounts, curated artisan collections, and SMS/Email previews.',
                  isMandatory: false,
                  retentionDays: 365,
                },
                {
                  purposeId: 'analytics',
                  name: 'Behavioral Insights & Storefront Experience Optimization',
                  description: 'Anonymous telemetry to enhance storefront performance and product search relevance.',
                  isMandatory: false,
                  retentionDays: 180,
                },
              ],
            },
          }));
          return;
        }

        // 9. Privacy Center: Consent Update (Authentication Required)
        if (pathname === '/api/privacy/consent/update' && method === 'POST') {
          const auth = this.authenticateRequest(req);
          if (!auth) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Authentication required. Please sign in to update privacy settings.' }));
            return;
          }

          const body = await this.readJsonBody(req);
          const { purposeId, isGranted } = body;

          if (!purposeId) {
            res.writeHead(400);
            res.end(JSON.stringify({ error: 'Purpose ID is required.' }));
            return;
          }

          const user = await this.db.get<any>('SELECT * FROM users WHERE id = $1', [auth.userId]);
          if (!user) {
            res.writeHead(404);
            res.end(JSON.stringify({ error: 'User not found' }));
            return;
          }

          // Update local DB
          const grantedVal = this.db.isPostgres() ? Boolean(isGranted) : (isGranted ? 1 : 0);
          await this.db.run(
            `INSERT INTO consent_preferences (id, user_id, purpose_id, is_granted, notice_version, updated_at)
             VALUES ($1, $2, $3, $4, '2.1', CURRENT_TIMESTAMP)
             ON CONFLICT(user_id, purpose_id) DO UPDATE SET is_granted = $4, updated_at = CURRENT_TIMESTAMP`,
            [`cp-${auth.userId}-${purposeId}`, auth.userId, purposeId, grantedVal]
          );

          // Update local Zone Agent in-memory cache
          await this.syncWithLocalAgent(user.email, purposeId, Boolean(isGranted));

          // Call External SaaS Webhook
          if (!isGranted) {
            await this.saasClient.notifyConsentRevocation({
              dataSubjectIdentifier: user.email,
              purpose: purposeId,
              reason: `Customer revoked consent for ${purposeId} in Privacy Center`,
            });
          } else {
            await this.saasClient.notifyConsentGrant({
              dataSubjectIdentifier: user.email,
              purpose: purposeId,
              purposes: [purposeId],
            });
          }

          // Audit log
          await this.db.run(
            `INSERT INTO audit_logs (id, action, user_id, ip_address, user_agent, details)
             VALUES ($1, $2, $3, $4, $5, $6)`,
            [`log-${Date.now()}`, isGranted ? 'CONSENT_GRANTED' : 'CONSENT_REVOKED', auth.userId, req.socket.remoteAddress || '127.0.0.1', req.headers['user-agent'] || '', `Consent for purpose '${purposeId}' set to ${isGranted}`]
          );

          res.writeHead(200);
          res.end(JSON.stringify({
            success: true,
            message: `Consent for '${purposeId}' successfully ${isGranted ? 'granted' : 'revoked'}`,
            purposeId,
            isGranted: Boolean(isGranted),
          }));
          return;
        }

        // 10. Privacy Center: Right to Erasure / "Delete My Account" (Authentication Required)
        if (pathname === '/api/privacy/dsr/erasure' && method === 'POST') {
          const auth = this.authenticateRequest(req);
          if (!auth) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Authentication required. You must sign in to request account erasure.' }));
            return;
          }

          const body = await this.readJsonBody(req);
          const reason = body.reason || 'Customer initiated account erasure request';

          const user = await this.db.get<any>('SELECT * FROM users WHERE id = $1', [auth.userId]);
          if (!user) {
            res.writeHead(404);
            res.end(JSON.stringify({ error: 'User not found' }));
            return;
          }

          // Step 1: Quarantine / Soft-delete in local database
          await this.db.run(
            `UPDATE users SET status = 'SOFT_DELETED', updated_at = CURRENT_TIMESTAMP WHERE id = $1`,
            [auth.userId]
          );

          // Step 2: Invalidate local agent consent cache
          await this.syncWithLocalAgent(user.email, 'marketing', false);
          await this.syncWithLocalAgent(user.email, 'analytics', false);

          // Step 3: Outbound webhook to SaaS Compliance Control Plane
          await this.saasClient.submitDsrErasure({
            requesterReference: user.email,
            requestType: 'ERASURE',
            description: reason,
          });
          await this.saasClient.notifyConsentRevocation({
            dataSubjectIdentifier: user.email,
            purpose: 'ALL_PROCESSING',
            reason: 'Account deletion requested',
          });

          // Step 4: Audit log
          await this.db.run(
            `INSERT INTO audit_logs (id, action, user_id, ip_address, user_agent, details)
             VALUES ($1, 'DSR_ERASURE_REQUESTED', $2, $3, $4, $5)`,
            [`log-${Date.now()}`, auth.userId, req.socket.remoteAddress || '127.0.0.1', req.headers['user-agent'] || '', `Right to Erasure submitted for ${user.email}. Grace period: 30 days.`]
          );

          res.writeHead(200);
          res.end(JSON.stringify({
            success: true,
            status: 'QUARANTINED_PENDING_ERASURE',
            message: 'Your account has been scheduled for erasure. You have a 30-day grace period to restore access.',
            gracePeriodDays: 30,
            requestedAt: new Date().toISOString(),
          }));
          return;
        }

        // 11. Privacy Center: Reactivate Account during grace period (Requires Credentials)
        if (pathname === '/api/privacy/dsr/reactivate' && method === 'POST') {
          const body = await this.readJsonBody(req);
          const { email, password } = body;

          if (!email || !password) {
            res.writeHead(400);
            res.end(JSON.stringify({ error: 'Email and password are required to restore your account.' }));
            return;
          }

          const user = await this.db.get<any>('SELECT * FROM users WHERE LOWER(email) = LOWER($1)', [email]);
          if (!user || !verifyPassword(password, user.password_hash)) {
            res.writeHead(401);
            res.end(JSON.stringify({ error: 'Invalid email or password.' }));
            return;
          }

          await this.db.run(`UPDATE users SET status = 'ACTIVE', updated_at = CURRENT_TIMESTAMP WHERE id = $1`, [user.id]);
          await this.syncWithLocalAgent(user.email, 'essential', true);

          const token = createSessionToken({ userId: user.id, email: user.email, fullName: user.full_name }, this.config.sessionSecret);

          res.writeHead(200);
          res.end(JSON.stringify({
            success: true,
            message: 'Account restored successfully to ACTIVE status.',
            token,
            user: {
              id: user.id,
              fullName: user.full_name,
              email: user.email,
              phone: user.phone,
              status: 'ACTIVE',
            },
          }));
          return;
        }

        res.writeHead(404);
        res.end(JSON.stringify({ error: 'Endpoint not found' }));
        return;
      }

      // ----------------------------------------------------------------------
      // STATIC WEB ASSETS (HTML/CSS/JS)
      // ----------------------------------------------------------------------
      let filePath = join(this.publicDir, pathname === '/' ? 'index.html' : pathname);
      if (pathname === '/privacy' || pathname === '/privacy-center') {
        filePath = join(this.publicDir, 'privacy-center.html');
      }

      if (existsSync(filePath)) {
        let contentType = 'text/html';
        if (filePath.endsWith('.js')) contentType = 'application/javascript';
        else if (filePath.endsWith('.css')) contentType = 'text/css';
        else if (filePath.endsWith('.json')) contentType = 'application/json';
        else if (filePath.endsWith('.svg')) contentType = 'image/svg+xml';
        else if (filePath.endsWith('.png')) contentType = 'image/png';
        else if (filePath.endsWith('.jpg')) contentType = 'image/jpeg';

        const content = readFileSync(filePath);
        res.setHeader('Content-Type', contentType);
        res.writeHead(200);
        res.end(content);
        return;
      }

      // Fallback to index.html for SPA routing
      const indexFile = join(this.publicDir, 'index.html');
      if (existsSync(indexFile)) {
        res.setHeader('Content-Type', 'text/html');
        res.writeHead(200);
        res.end(readFileSync(indexFile));
        return;
      }

      res.writeHead(404);
      res.end('Page not found');
    } catch (err: any) {
      // Secure Error Handler: Log full internal details internally; return sanitized error to client
      console.error('[Storefront Server] Internal error:', err);
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'An unexpected internal error occurred. Please try again later.' }));
    }
  }

  private authenticateRequest(req: IncomingMessage): SessionPayload | null {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) return null;
    const token = authHeader.replace('Bearer ', '').trim();
    return verifySessionToken(token, this.config.sessionSecret);
  }

  private async syncWithLocalAgent(principalId: string, purposeId: string, allowed: boolean): Promise<void> {
    try {
      await fetch(`http://localhost:${this.config.agentPort}/consent/sync`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ principalId, purposeId, allowed, noticeVersion: '2.1' }),
        signal: AbortSignal.timeout(1000),
      });
    } catch {
      // Local agent will load from DB on next cache miss
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

// Standalone execution (e.g. for Render Web Service)
if (process.argv[1] && process.argv[1].endsWith('server.js')) {
  const ecom = new EcomServer();
  ecom.start().catch((err) => {
    console.error('Failed to start Ecom Server:', err);
    process.exit(1);
  });
}
