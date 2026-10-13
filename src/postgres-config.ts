import type pg from 'pg';

export function postgresConfig(connectionString: string): pg.PoolConfig {
  const url = new URL(connectionString);
  const supabase = url.hostname.endsWith('.supabase.co') || url.hostname.endsWith('.supabase.com');
  const verifiedTls = supabase || process.env.DATABASE_SSL === 'true';
  const schema = process.env.DATABASE_SCHEMA || 'public';
  if (!/^[a-z][a-z0-9_]*$/.test(schema)) throw new Error('Invalid DATABASE_SCHEMA');
  const max = Number(process.env.DATABASE_POOL_MAX || (process.env.VERCEL ? '2' : '10'));
  if (!Number.isInteger(max) || max < 1 || max > 10) throw new Error('DATABASE_POOL_MAX must be between 1 and 10');
  if (verifiedTls) {
    // pg connection-string SSL parameters otherwise override the explicit TLS object.
    for (const key of ['sslmode','sslcert','sslkey','sslrootcert']) url.searchParams.delete(key);
  }
  return {
    connectionString: url.toString(),
    ssl: verifiedTls ? {
      rejectUnauthorized: true,
      ...(process.env.DATABASE_SSL_CA ? { ca:process.env.DATABASE_SSL_CA.replace(/\\n/g,'\n') } : {}),
    } : connectionString.includes('sslmode=require') || url.hostname.endsWith('render.com')
      ? {rejectUnauthorized:false} : undefined,
    options: schema !== 'public' ? `-c search_path=${schema}` : undefined,
    max,
    idleTimeoutMillis: 10000,
    connectionTimeoutMillis: 10000,
  };
}
