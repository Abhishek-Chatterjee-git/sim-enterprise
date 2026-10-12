"""Snapshot the local fixture and prepare its existing test agent for erasure."""
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path

private = Path(__file__).resolve().parents[2] / '.d-fortress-ecommerce'
info = json.loads(subprocess.run(['docker','inspect','dfortress-ecommerce-test-postgres'],
    check=True,capture_output=True,text=True).stdout)[0]
if info['Config'].get('Labels',{}).get('dfortress.fixture') != 'ecommerce':
    raise SystemExit('Refusing to operate on an unrelated database')
stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
backup = private / f'before-erasure-{stamp}.sql'
with backup.open('xb') as output:
    backup.chmod(0o600)
    subprocess.run(['docker','exec','dfortress-ecommerce-test-postgres','pg_dump',
        '-U','ecom_owner','-d','ecommerce_test','--no-owner','--no-acl'],stdout=output,check=True)
file = private / 'agent.env'
values = dict(line.split('=',1) for line in file.read_text().splitlines() if line and not line.startswith('#'))
discovery = private/'agent-discovery.env'
if not discovery.exists():
    discovery.touch(mode=0o600)
    discovery.write_text(file.read_text())
local = dict(line.split('=',1) for line in (private/'local.env').read_text().splitlines() if line and not line.startswith('#'))
values['DATABASE_URL'] = f"postgres://ecom_erasure:{local['ERASURE_DB_PASSWORD']}@127.0.0.1:55432/ecommerce_test"
values['AGENT_ALLOW_DSR_EXECUTION'] = 'true'
values['AGENT_MAX_ERASURE_ROWS'] = '5'
file.write_text(''.join(f'{key}={value}\n' for key,value in values.items()))
file.chmod(0o600)
print(f'Local database snapshot saved: {backup.name}')
print('Prepared local erasure role with a five-row limit; restart the test agent to activate it.')
