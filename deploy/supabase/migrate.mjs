import { EnterpriseDatabase } from '../../dist/db.js';

if (!process.env.DATABASE_URL || process.env.DATABASE_SCHEMA !== 'sim_enterprise')
  throw new Error('Set the dedicated Supabase project admin DATABASE_URL and DATABASE_SCHEMA=sim_enterprise');
const db = new EnterpriseDatabase(process.env.DATABASE_URL);
try {
  await db.init();
  const pool = db.getPool();
  const tables = await pool.query("SELECT tablename FROM pg_tables WHERE schemaname = 'sim_enterprise'");
  for (const {tablename} of tables.rows) {
    const name = `"${tablename.replaceAll('"','""')}"`;
    await pool.query(`REVOKE ALL ON sim_enterprise.${name} FROM anon, authenticated`);
  }
  await pool.query('REVOKE ALL ON SCHEMA sim_enterprise FROM PUBLIC, anon, authenticated');
  console.log('Simulator schema and seed prepared; browser API roles have no schema access.');
} finally { await db.close(); }
