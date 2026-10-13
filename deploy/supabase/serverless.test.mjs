import { test } from 'node:test';
import assert from 'node:assert/strict';
import { Readable } from 'node:stream';
import { postgresConfig } from '../../dist/postgres-config.js';
import { apiRequestUrl } from '../../dist/vercel-handler.js';
import { EcomServer } from '../../dist/server.js';

test('restores rewritten API paths without losing other query parameters', () => {
  assert.equal(apiRequestUrl('/api/handler?__route=privacy/dsr/verify&x=1'),'/api/privacy/dsr/verify?x=1');
  assert.equal(apiRequestUrl('/api/products'),'/api/products');
  assert.throws(() => apiRequestUrl('/api/handler?__route=../secret'));
  assert.throws(() => apiRequestUrl('/api/handler?__route=auth/login&__route=products'));
});

test('Supabase connection verifies TLS even if URL requests weaker SSL', () => {
  const previous = process.env.DATABASE_SCHEMA;
  process.env.DATABASE_SCHEMA = 'sim_enterprise';
  try {
    const config = postgresConfig('postgres://sim_app:fake@aws-0-test.pooler.supabase.com:5432/postgres?sslmode=require');
    assert.equal(config.ssl.rejectUnauthorized,true);
    assert.ok(!config.connectionString.includes('sslmode='));
    assert.equal(config.options,'-c search_path=sim_enterprise');
    process.env.DATABASE_SCHEMA='public; DROP TABLE users';
    assert.throws(() => postgresConfig('postgres://fake:fake@localhost/test'));
  } finally { if (previous === undefined) delete process.env.DATABASE_SCHEMA; else process.env.DATABASE_SCHEMA=previous; }
});

test('login receives Vercel pre-parsed request bodies without waiting for a stream', async () => {
  const req = Readable.from([]);
  req.method='POST'; req.url='/api/auth/login'; req.headers={};
  req.body={email:'customer@example.test',password:'fake-password'};
  let queried=false;
  const db = { get: async () => { queried=true; return null; } };
  const app = new EcomServer({},db);
  const res = { setHeader(){},writeHead(code){this.status=code;},end(body){this.body=body;} };
  await app.handleRequest(req,res);
  assert.equal(queried,true);
  assert.equal(res.status,401);
  assert.match(res.body,/Invalid/);
});
