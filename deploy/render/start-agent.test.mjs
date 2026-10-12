import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, readFile, rm, access } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { createHash } from 'node:crypto';
import { validateDownloadUrl, downloadVerified } from './start-agent.mjs';

test('rejects non-platform downloads before contacting them', () => {
  const origin = 'https://console.example';
  assert.throws(() => validateDownloadUrl('https://other.example/api/v1/distribution/download?token=x',origin));
  assert.throws(() => validateDownloadUrl('https://console.example/other?token=x',origin));
  assert.throws(() => validateDownloadUrl('http://console.example/api/v1/distribution/download?token=x',origin));
});

test('verifies bootstrap content, reuses redeemed files, and refuses tampering', async () => {
  const dir = await mkdtemp(path.join(tmpdir(),'render-bootstrap-'));
  const originalFetch = globalThis.fetch;
  let calls = 0;
  globalThis.fetch = async () => { calls++; return new Response('verified installer'); };
  const digest = createHash('sha256').update('verified installer').digest('hex');
  const url = 'https://console.example/api/v1/distribution/download?token=x';
  try {
    const file = path.join(dir,'installer');
    await downloadVerified(url,digest,file,'https://console.example');
    await downloadVerified(url,digest,file,'https://console.example');
    assert.equal(calls,1);
    assert.equal(await readFile(file,'utf8'),'verified installer');
    const rejected = path.join(dir,'rejected');
    await assert.rejects(downloadVerified(url,'0'.repeat(64),rejected,'https://console.example'),/mismatch/);
    await assert.rejects(access(rejected));
  } finally { globalThis.fetch = originalFetch; await rm(dir,{recursive:true,force:true}); }
});
