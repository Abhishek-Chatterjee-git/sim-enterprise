import pg from 'pg';
import { postgresConfig } from '../../dist/postgres-config.js';

const appPassword = process.env.SIM_APP_DB_PASSWORD;
const agentPassword = process.env.SIM_AGENT_DB_PASSWORD;
if (!process.env.DATABASE_URL || !appPassword || !agentPassword || appPassword.length < 32 || agentPassword.length < 32)
  throw new Error('Set admin DATABASE_URL and separate SIM_APP_DB_PASSWORD/SIM_AGENT_DB_PASSWORD (32+ characters)');
if (process.env.DATABASE_SCHEMA !== 'sim_enterprise') throw new Error('Use DATABASE_SCHEMA=sim_enterprise');
const client = new pg.Client(postgresConfig(process.env.DATABASE_URL));
await client.connect();
try {
  await client.query('BEGIN');
  for (const [role,password] of [['sim_app',appPassword],['sim_agent',agentPassword]]) {
    const exists = await client.query('SELECT 1 FROM pg_roles WHERE rolname=$1',[role]);
    if (!exists.rowCount) await client.query(`CREATE ROLE ${role} LOGIN`);
    await client.query(`ALTER ROLE ${role} PASSWORD ${pg.escapeLiteral(password)}`);
    await client.query(`ALTER ROLE ${role} SET search_path TO sim_enterprise`);
    await client.query(`GRANT USAGE ON SCHEMA sim_enterprise TO ${role}`);
  }
  await client.query('GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sim_enterprise TO sim_app');
  await client.query('GRANT SELECT ON ALL TABLES IN SCHEMA sim_enterprise TO sim_agent');
  await client.query('GRANT UPDATE ON sim_enterprise.users TO sim_agent');
  await client.query('COMMIT');
  console.log('Restricted simulator application and discovery/masking roles prepared. No role passwords were printed.');
} catch(error) { await client.query('ROLLBACK'); throw error; }
finally { await client.end(); }
