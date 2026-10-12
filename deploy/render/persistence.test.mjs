import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import path from 'node:path';
import { tmpdir } from 'node:os';
import { EnterpriseDatabase } from '../../dist/db.js';

test('verification binding survives closing and reopening the storefront database', async () => {
  const dir = await mkdtemp(path.join(tmpdir(),'render-otp-'));
  const file = path.join(dir,'test.sqlite');
  const previousType = process.env.DB_TYPE;
  process.env.DB_TYPE = 'SQLITE';
  let db = new EnterpriseDatabase(file);
  try {
    await db.init();
    const expires = Date.now() + 600000;
    await db.run('INSERT INTO privacy_verification_challenges (user_id, verification_id, expires_at) VALUES ($1,$2,$3)',
      ['usr-mumbai-101','test-binding',expires]);
    await db.close();
    db = new EnterpriseDatabase(file);
    await db.init();
    const binding = await db.get('SELECT verification_id, expires_at FROM privacy_verification_challenges WHERE user_id = $1',
      ['usr-mumbai-101']);
    assert.equal(binding.verification_id,'test-binding');
    assert.equal(Number(binding.expires_at),expires);
  } finally {
    await db.close();
    if (previousType === undefined) delete process.env.DB_TYPE; else process.env.DB_TYPE = previousType;
    await rm(dir,{recursive:true,force:true});
  }
});
