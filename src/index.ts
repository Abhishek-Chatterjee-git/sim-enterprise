import { EnterpriseDatabase } from './db.js';
import { EcomServer } from './server.js';
import { ZoneAgentWorker } from './agent-worker.js';
import { AdminServer } from './admin-server.js';
import { ComplianceSaasClient } from './saas-client.js';
import { loadEnterpriseConfig } from './config.js';

export {
  EnterpriseDatabase,
  EcomServer,
  ZoneAgentWorker,
  AdminServer,
  ComplianceSaasClient,
  loadEnterpriseConfig,
};

async function main() {
  const config = loadEnterpriseConfig();
  const db = new EnterpriseDatabase(config.dbConnectionString);
  await db.init();

  console.log(`
================================================================================
  🏛️  SIMULATED ENTERPRISE PLATFORM (DPDP ACT 2025 & ISO 27001 READY)
  Mode: ${config.appMode.toUpperCase()} | Database: ${config.dbType}
================================================================================
`);

  if (config.appMode === 'worker') {
    const worker = new ZoneAgentWorker(config, db);
    await worker.start();
  } else if (config.appMode === 'admin') {
    const admin = new AdminServer(config, db);
    await admin.start();
  } else if (config.appMode === 'storefront') {
    const ecom = new EcomServer({ config }, db);
    await ecom.start();
  } else {
    // Mode 'all': run Storefront + Zone Agent + Admin together
    const worker = new ZoneAgentWorker(config, db);
    await worker.start();

    const ecom = new EcomServer({ config }, db);
    await ecom.start();

    const admin = new AdminServer(config, db);
    await admin.start();

    console.log(`
  🛍️  Storefront: http://localhost:${config.port}
  🔒  Privacy Center: http://localhost:${config.port}/privacy
  🛡️  Zone Agent Daemon: http://localhost:${config.agentPort}
  📊  Admin Portal: http://localhost:${config.adminPort}
  ☁️  Compliance SaaS: ${config.controlPlaneUrl}
================================================================================
`);
  }

  // Graceful shutdown
  const shutdown = async () => {
    console.log('\nShutting down enterprise services...');
    await db.close();
    process.exit(0);
  };
  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);
}

if (process.argv[1] && (process.argv[1].endsWith('index.js') || process.argv[1].endsWith('index.ts'))) {
  main().catch((err) => {
    console.error('Fatal Enterprise Startup Error:', err);
    process.exit(1);
  });
}
