"""Redeem and verify only the signed install assets from portal commands.

The provided command file is parsed as data and never executed as a script.
"""
import hashlib
import re
import shlex
import secrets
import subprocess
import sys
from pathlib import Path
from urllib.parse import urlsplit

root = Path(__file__).resolve().parents[2]
private = root / '.d-fortress-ecommerce'
text = Path(sys.argv[1]).read_text().replace('\\\n',' ')
destination = private / 'installer'
destination.mkdir(mode=0o700,exist_ok=True)
prefix = private / 'installed'
links = {}
for line in text.splitlines():
    if line.strip().startswith('curl '):
        args = shlex.split(line)
        if '-o' in args:
            name = args[args.index('-o')+1]
            if name in ['install.sh','verify-release.mjs']: links[name] = args[-1]
digests = re.findall(r'(?<![0-9a-f])[0-9a-f]{64}(?![0-9a-f])',text)
if len(links) != 2 or len(digests) != 2: raise SystemExit('Expected two installer links and their SHA-256 digests')
def token(flag):
    parts = shlex.split(text,comments=True)
    return parts[parts.index(flag)+1]
for name,link in links.items():
    url = urlsplit(link)
    if url.scheme != 'https' or url.netloc != 'd-fortress.digitalfortress.in' or url.path != '/api/v1/distribution/download':
        raise SystemExit('Unexpected download destination')
    file = destination / name
    expected = digests[0 if name == 'install.sh' else 1]
    if file.exists() and hashlib.sha256(file.read_bytes()).hexdigest() == expected: continue
    result = subprocess.run(['curl','-fsSL','--connect-timeout','10','--max-time','60','-o',str(file),link],capture_output=True,text=True)
    if result.returncode:
        print(f'Download failed for {name}; curl exit code {result.returncode}.')
        # curl -f prints an HTTP status without the credential-bearing URL.
        print(re.sub(r'https?://\S+','<redacted URL>',result.stderr))
        raise SystemExit(1)
    if hashlib.sha256(file.read_bytes()).hexdigest() != expected:
        raise SystemExit(f'SHA-256 mismatch for {name}; refusing installation')
print('Installer and verifier SHA-256 digests verified.',flush=True)
args = ['sh',str(destination/'install.sh'),'--console-url','https://d-fortress.digitalfortress.in',
        '--manifest-token',token('--manifest-token'),'--tarball-token',token('--tarball-token'),'--prefix',str(prefix)]
log = private/'installation.log'
with log.open('w') as output:
    log.chmod(0o600)
    result = subprocess.run(args,cwd=destination,stdout=output,stderr=subprocess.STDOUT)
if result.returncode:
    safe = log.read_text()
    safe = re.sub(r'https?://\S+','<redacted URL>',safe)
    safe = re.sub(r'agent_enroll_\S+|dpsk_\S+','<redacted credential>',safe)
    print(safe[-3000:])
    raise SystemExit(result.returncode)
enrollment = re.search(r'agent_enroll_[A-Za-z0-9_-]+',text)
local_token = re.search(r'AGENT_LOCAL_API_TOKEN\s*=\s*["\x27]?([^\s"\x27]+)',text)
if not enrollment: raise SystemExit('Agent installed but no enrollment token found')
env_file = private/'agent.env'
values = dict(line.split('=',1) for line in env_file.read_text().splitlines() if line)
values['AGENT_ENROLLMENT_TOKEN'] = enrollment.group()
values['AGENT_HOST'] = '127.0.0.1'
candidate = local_token.group(1) if local_token else ''
values['AGENT_LOCAL_API_TOKEN'] = candidate if len(candidate) >= 16 and '<' not in candidate else secrets.token_hex(24)
env_file.write_text(''.join(f'{key}={value}\n' for key,value in values.items()))
env_file.chmod(0o600)
subprocess.run([str(prefix/'bin/dpdp'),'--version'],check=True)
print('Verified portal release installed in the private test directory; credentials omitted.')
