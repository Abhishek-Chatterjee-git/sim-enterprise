// Run in the storefront's Render shell after its schema has initialized.
import pg from 'pg';
const password = process.env.DEMO_AGENT_DB_PASSWORD;
if (!process.env.DATABASE_URL || !password || password.length < 32)
  throw new Error('Set DATABASE_URL and a DEMO_AGENT_DB_PASSWORD of at least 32 characters');
const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  await client.query('BEGIN');
  const found = await client.query("SELECT 1 FROM pg_roles WHERE rolname = 'demo_zone_agent'");
  if (!found.rowCount) await client.query('CREATE ROLE demo_zone_agent LOGIN');
  await client.query(`ALTER ROLE demo_zone_agent PASSWORD ${pg.escapeLiteral(password)}`);
  await client.query('GRANT USAGE ON SCHEMA public TO demo_zone_agent');
  await client.query('GRANT SELECT ON ALL TABLES IN SCHEMA public TO demo_zone_agent');
  await client.query('GRANT UPDATE ON users TO demo_zone_agent');
  await client.query('ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO demo_zone_agent');
  await client.query('COMMIT');
  console.log('Demo discovery and users soft-masking role ready. DELETE and schema modification are not granted.');
} catch (error) {
  await client.query('ROLLBACK');
  throw error;
} finally { await client.end(); }
