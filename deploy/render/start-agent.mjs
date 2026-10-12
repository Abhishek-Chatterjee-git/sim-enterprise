import { mkdir, readFile, writeFile, access, rename, chmod } from 'node:fs/promises';
import { createHash } from 'node:crypto';
import { spawn } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

export function validateDownloadUrl(raw, consoleUrl) {
  const url = new URL(raw);
  const control = new URL(consoleUrl);
  if (control.protocol !== 'https:' || url.origin !== control.origin ||
      url.pathname !== '/api/v1/distribution/download' || !url.searchParams.get('token') ||
      url.username || url.password) throw new Error('Invalid portal download URL');
  return url;
}

export async function downloadVerified(raw, digest, destination, consoleUrl) {
  if (!/^[a-f0-9]{64}$/i.test(digest || '')) throw new Error('Expected a bootstrap SHA-256 digest');
  try {
    const existing = await readFile(destination);
    if (createHash('sha256').update(existing).digest('hex') === digest.toLowerCase()) return;
  } catch (error) { if (error.code !== 'ENOENT') throw error; }
  const response = await fetch(validateDownloadUrl(raw, consoleUrl), {
    redirect: 'error', signal: AbortSignal.timeout(60000),
  });
  if (!response.ok) throw new Error(`Bootstrap download failed (HTTP ${response.status}); regenerate portal commands`);
  const data = Buffer.from(await response.arrayBuffer());
  if (createHash('sha256').update(data).digest('hex') !== digest.toLowerCase())
    throw new Error('Bootstrap SHA-256 mismatch; refusing installation');
  await writeFile(destination, data, { mode: 0o600 });
}

async function exists(file) { try { await access(file); return true; } catch { return false; } }

function run(command, args, cwd) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, { cwd, stdio: 'inherit', env: process.env });
    const onTerm = () => child.kill('SIGTERM');
    const onInt = () => child.kill('SIGINT');
    process.on('SIGTERM', onTerm); process.on('SIGINT', onInt);
    child.once('error', reject);
    child.once('exit', (code, signal) => {
      process.off('SIGTERM', onTerm); process.off('SIGINT', onInt);
      if (code === 0) resolve(); else reject(new Error(`Agent process exited (${signal || code})`));
    });
  });
}

export async function main() {
  process.umask(0o077);
  const state = path.dirname(process.env.AGENT_DATA_DIR || '/var/lib/d-fortress/data');
  const prefix = path.join(state, 'installed');
  const bin = path.join(prefix, 'bin/dpdp');
  await mkdir(state, { recursive: true, mode: 0o700 });
  await mkdir(process.env.AGENT_DATA_DIR || path.join(state, 'data'), { recursive: true, mode: 0o700 });
  await chmod(state, 0o700);
  if (!(await exists(bin))) {
    const required = ['INSTALLER_URL', 'INSTALLER_SHA256', 'VERIFIER_URL', 'VERIFIER_SHA256',
      'RELEASE_MANIFEST_TOKEN', 'RELEASE_TARBALL_TOKEN', 'AGENT_ENROLLMENT_TOKEN'];
    if (required.some(key => !process.env[key])) {
      console.log('Waiting for fresh portal installation environment. Add bootstrap values and restart this worker.');
      await new Promise(resolve => { const timer = setInterval(() => {}, 30000);
        process.once('SIGTERM', () => { clearInterval(timer); resolve(); });
        process.once('SIGINT', () => { clearInterval(timer); resolve(); }); });
      return;
    }
    const bootstrap = path.join(state, 'bootstrap');
    await mkdir(bootstrap, { recursive: true, mode: 0o700 });
    await downloadVerified(process.env.INSTALLER_URL, process.env.INSTALLER_SHA256,
      path.join(bootstrap, 'install.sh'), process.env.CONTROL_PLANE_URL);
    await downloadVerified(process.env.VERIFIER_URL, process.env.VERIFIER_SHA256,
      path.join(bootstrap, 'verify-release.mjs'), process.env.CONTROL_PLANE_URL);
    const incoming = path.join(state, 'installation-incoming');
    await run('sh', [path.join(bootstrap, 'install.sh'), '--console-url', process.env.CONTROL_PLANE_URL,
      '--manifest-token', process.env.RELEASE_MANIFEST_TOKEN, '--tarball-token', process.env.RELEASE_TARBALL_TOKEN,
      '--prefix', incoming], bootstrap);
    await access(path.join(incoming, 'bin/dpdp'));
    await rename(incoming, prefix);
    console.log('Verified portal release installed on the persistent disk.');
  }
  if (!process.env.DATABASE_URL) throw new Error('Configure the dedicated agent database role URL');
  await run(bin, ['agent', 'start'], state);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main().catch(() => { console.error('Agent startup failed. Check bootstrap digests, token expiry, database access, and worker logs.'); process.exitCode = 1; });
}
