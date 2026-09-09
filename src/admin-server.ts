import { createServer, IncomingMessage, ServerResponse, Server } from 'node:http';
import { URL } from 'node:url';
import { EnterpriseDatabase } from './db.js';
import { loadEnterpriseConfig, EnterpriseConfig } from './config.js';

export class AdminServer {
  private config: EnterpriseConfig;
  private db: EnterpriseDatabase;
  private server: Server | null = null;
  private isRunning: boolean = false;

  constructor(config?: Partial<EnterpriseConfig>, db?: EnterpriseDatabase) {
    this.config = { ...loadEnterpriseConfig(), ...config };
    this.db = db || new EnterpriseDatabase(this.config.dbConnectionString);
  }

  async start(): Promise<void> {
    if (this.isRunning) return;
    this.isRunning = true;

    await this.db.init();

    return new Promise((res) => {
      this.server = createServer((req, res) => this.handleRequest(req, res));
      this.server.listen(this.config.adminPort, () => {
        console.log(`[Admin Operations Portal] Running on http://localhost:${this.config.adminPort}`);
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
    const parsedUrl = new URL(req.url || '/', `http://localhost:${this.config.adminPort}`);
    const pathname = parsedUrl.pathname;
    const method = req.method?.toUpperCase();

    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Access-Control-Allow-Origin', '*');

    if (method === 'GET' && pathname === '/health') {
      res.writeHead(200);
      res.end(JSON.stringify({ status: 'ok', service: 'admin-portal' }));
      return;
    }

    if (method === 'GET' && pathname === '/api/admin/overview') {
      const userCount = await this.db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM users');
      const orderCount = await this.db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM orders');
      const quarantinedUsers = await this.db.get<{ count: number | string }>("SELECT COUNT(*) as count FROM users WHERE status = 'SOFT_DELETED'");
      const auditLogCount = await this.db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM audit_logs');

      res.writeHead(200);
      res.end(JSON.stringify({
        totalCustomers: Number(userCount?.count || 0),
        totalOrders: Number(orderCount?.count || 0),
        quarantinedDsrUsers: Number(quarantinedUsers?.count || 0),
        securityAuditLogs: Number(auditLogCount?.count || 0),
      }));
      return;
    }

    if (method === 'GET' && pathname === '/api/admin/users') {
      const users = await this.db.all<any>('SELECT id, full_name, email, phone, status, city, state, created_at, updated_at FROM users ORDER BY created_at DESC');
      res.writeHead(200);
      res.end(JSON.stringify({ users }));
      return;
    }

    if (method === 'GET' && pathname === '/api/admin/orders') {
      const orders = await this.db.all<any>('SELECT * FROM orders ORDER BY created_at DESC LIMIT 50');
      res.writeHead(200);
      res.end(JSON.stringify({ orders }));
      return;
    }

    if (method === 'GET' && pathname === '/api/admin/audit-logs') {
      const logs = await this.db.all<any>('SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 100');
      res.writeHead(200);
      res.end(JSON.stringify({ logs }));
      return;
    }

    res.writeHead(404);
    res.end(JSON.stringify({ error: 'Admin route not found' }));
  }
}

if (process.argv[1] && process.argv[1].endsWith('admin-server.js')) {
  const admin = new AdminServer();
  admin.start().catch((err) => {
    console.error('Failed to start Admin Server:', err);
    process.exit(1);
  });
}
