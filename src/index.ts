import { EnterpriseDatabase } from './db.js';
import { EcomServer } from './server.js';
import { loadEnterpriseConfig } from './config.js';

export {
  EnterpriseDatabase,
  EcomServer,
  loadEnterpriseConfig,
};

async function main() {
  const config = loadEnterpriseConfig();
  const db = new EnterpriseDatabase(config.dbConnectionString);
  await db.init();

  console.log(`
================================================================================
  🛍️  ARTISAN LUXE — ENTERPRISE E-COMMERCE PLATFORM
  Database: ${config.dbType} | Port: ${config.port}
================================================================================
`);

  const ecom = new EcomServer({ config }, db);
  await ecom.start();

  console.log(`
  🌐  Storefront & Products: http://localhost:${config.port}
  🔒  Customer Account & Privacy: http://localhost:${config.port}/privacy
  ☁️  Compliance SaaS Connected: ${config.controlPlaneUrl}
================================================================================
`);

  const shutdown = async () => {
    console.log('\n[Enterprise App] Graceful shutdown initiated...');
    await ecom.stop();
    process.exit(0);
  };

  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);
}

if (process.argv[1] && (process.argv[1].endsWith('index.js') || process.argv[1].endsWith('index.ts') || process.env.RUN_STANDALONE === 'true')) {
  main().catch((err) => {
    console.error('Fatal Enterprise Startup Error:', err);
    process.exit(1);
  });
}
