import type { IncomingMessage, ServerResponse } from 'node:http';
import { EnterpriseDatabase } from './db.js';
import { EcomServer } from './server.js';
import { loadEnterpriseConfig } from './config.js';

let application: Promise<EcomServer> | undefined;

export function apiRequestUrl(rawUrl: string): string {
  const url = new URL(rawUrl,'https://simulator.invalid');
  const routes = url.searchParams.getAll('__route');
  const route = routes[0];
  if (routes.length > 1 || (route && !/^[a-zA-Z0-9_/-]+$/.test(route))) throw new Error('Invalid API route');
  url.searchParams.delete('__route');
  if (route) url.pathname = `/api/${route}`;
  if (!url.pathname.startsWith('/api/') || url.pathname === '/api/handler') throw new Error('API route required');
  return url.pathname + url.search;
}

async function getApplication(): Promise<EcomServer> {
  if (!application) application = (async () => {
    const config = loadEnterpriseConfig();
    if (config.dbType !== 'POSTGRES' || !process.env.DATABASE_URL) throw new Error('Configure the simulator PostgreSQL database');
    const db = new EnterpriseDatabase(config.dbConnectionString);
    try {
      // Migrations/seeding run separately with privileged credentials, never on an HTTP request.
      await db.init({initializeSchema:false});
      return new EcomServer({config},db);
    } catch (error) { await db.close(); throw error; }
  })().catch(error => { application = undefined; throw error; });
  return application;
}

export default async function handler(req: IncomingMessage, res: ServerResponse): Promise<void> {
  try { req.url = apiRequestUrl(req.url || ''); }
  catch { res.writeHead(400,{'Content-Type':'application/json'}); res.end(JSON.stringify({error:'Invalid API route'})); return; }
  try {
    const app = await getApplication();
    res.setHeader('Cache-Control','no-store');
    await app.handleRequest(req,res);
  } catch {
    res.writeHead(503,{'Content-Type':'application/json','Cache-Control':'no-store'});
    res.end(JSON.stringify({error:'Simulator database unavailable. Check configuration and run the deployment migration.'}));
  }
}
