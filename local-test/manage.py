#!/usr/bin/env python3
"""Start the isolated fixture with Docker; Docker Compose is not required."""
import json
import secrets
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT.parent / '.d-fortress-ecommerce'
NETWORK = 'dfortress-ecommerce-test'
DB = NETWORK + '-postgres'
APP = NETWORK + '-storefront'
IMAGE = NETWORK + ':local'
VOLUME = NETWORK + '-postgres-data'

def docker(*args, capture=False, check=True):
    return subprocess.run(['docker', *map(str, args)], check=check, text=True,
                          stdout=subprocess.PIPE if capture else None,
                          stderr=subprocess.PIPE if capture else None)

def configuration():
    PRIVATE.mkdir(mode=0o700, exist_ok=True)
    local = PRIVATE / 'local.env'
    if not local.exists():
        values = {name: secrets.token_hex(24) for name in
                  ['POSTGRES_PASSWORD','APP_DB_PASSWORD','DISCOVERY_DB_PASSWORD','ERASURE_DB_PASSWORD','SESSION_SECRET']}
        values.update(CONTROL_PLANE_URL='https://d-fortress.digitalfortress.in',
                      ORGANIZATION_SLUG='artison-sons', ORGANIZATION_ID='',
                      COMPLIANCE_API_KEY_ID='', COMPLIANCE_API_KEY_SECRET='', COMPLIANCE_NOTICE_ID='')
        local.touch(mode=0o600)
        local.write_text(''.join(f'{key}={value}\n' for key,value in values.items()))
    values = dict(line.split('=',1) for line in local.read_text().splitlines()
                  if line and not line.startswith('#'))
    agent = PRIVATE / 'agent.env'
    if not agent.exists():
        agent_values = dict(CONTROL_PLANE_URL=values['CONTROL_PLANE_URL'], DB_TYPE='POSTGRES',
            DATABASE_URL=f"postgres://ecom_discovery:{values['DISCOVERY_DB_PASSWORD']}@127.0.0.1:55432/ecommerce_test",
            DATA_DIR=str(PRIVATE / 'agent-data'), AGENT_NAME='artison-sons-local-ecommerce',
            AGENT_BIND_HOST='127.0.0.1', AGENT_PORT='5500', AGENT_ALLOW_DSR_EXECUTION='false')
        agent.touch(mode=0o600)
        agent.write_text(''.join(f'{key}={value}\n' for key,value in agent_values.items()))
    (PRIVATE / 'agent-data').mkdir(mode=0o700, exist_ok=True)
    for target in [local,agent]: target.chmod(0o600)
    return values

def exists(kind, name):
    return docker(kind,'inspect',name,capture=True,check=False).returncode == 0

def managed(name):
    info = json.loads(docker('container','inspect',name,capture=True).stdout)[0]
    if info['Config'].get('Labels',{}).get('dfortress.fixture') != 'ecommerce':
        raise RuntimeError(f'Refusing to operate on unrelated container {name}')

def start():
    values = configuration()
    if not exists('network',NETWORK): docker('network','create',NETWORK)
    if not exists('volume',VOLUME): docker('volume','create',VOLUME)
    if not exists('container',DB):
        db_env = PRIVATE / 'postgres.env'
        db_values = dict(POSTGRES_USER='ecom_owner',POSTGRES_DB='ecommerce_test',
            POSTGRES_PASSWORD=values['POSTGRES_PASSWORD'],APP_DB_PASSWORD=values['APP_DB_PASSWORD'],
            DISCOVERY_DB_PASSWORD=values['DISCOVERY_DB_PASSWORD'],ERASURE_DB_PASSWORD=values['ERASURE_DB_PASSWORD'])
        db_env.touch(mode=0o600,exist_ok=True)
        db_env.write_text(''.join(f'{key}={value}\n' for key,value in db_values.items()))
        docker('run','-d','--name',DB,'--label','dfortress.fixture=ecommerce',
            '--network',NETWORK,'--network-alias','postgres','-p','127.0.0.1:55432:5432',
            '--env-file',db_env,'-v',f'{VOLUME}:/var/lib/postgresql/data',
            '-v',f'{ROOT / "local-test/init-roles.sh"}:/docker-entrypoint-initdb.d/10-test-roles.sh:ro',
            'postgres:16-alpine')
    else: managed(DB); docker('start',DB)
    for _ in range(60):
        if docker('exec',DB,'pg_isready','-U','ecom_owner','-d','ecommerce_test',capture=True,check=False).returncode == 0: break
        time.sleep(1)
    else: raise RuntimeError('PostgreSQL did not become ready')
    if not exists('container',APP):
        docker('build','-t',IMAGE,'-f',ROOT/'local-test/Dockerfile',ROOT)
        app_env = PRIVATE / 'storefront.env'
        app_values = {key:value for key,value in values.items() if key.startswith('COMPLIANCE_') or key.startswith('ORGANIZATION_')}
        app_values.update(NODE_ENV='development',PORT='3000',APP_MODE='storefront',DB_TYPE='POSTGRES',
            DATABASE_URL=f"postgres://ecom_app:{values['APP_DB_PASSWORD']}@postgres:5432/ecommerce_test",
            SESSION_SECRET=values['SESSION_SECRET'],CONTROL_PLANE_URL=values['CONTROL_PLANE_URL'])
        app_env.touch(mode=0o600,exist_ok=True)
        app_env.write_text(''.join(f'{key}={value}\n' for key,value in app_values.items()))
        docker('run','-d','--name',APP,'--label','dfortress.fixture=ecommerce','--network',NETWORK,
            '-p','127.0.0.1:3300:3000','--env-file',app_env,IMAGE)
    else: managed(APP); docker('start',APP)
    for _ in range(60):
        result = docker('exec',APP,'node','-e',"fetch('http://127.0.0.1:3000/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))",capture=True,check=False)
        if result.returncode == 0: break
        time.sleep(1)
    else: raise RuntimeError('Storefront did not become ready')
    print('Storefront: http://localhost:3300 | PostgreSQL: localhost:55432', flush=True)

command = sys.argv[1] if len(sys.argv)>1 else 'start'
if command == 'start': start()
elif command == 'import': managed(APP); docker('exec',APP,'node','local-test/import-fixtures.mjs')
elif command == 'stop':
    for name in [APP,DB]:
        if exists('container',name): managed(name); docker('stop',name)
elif command == 'status':
    docker('ps','-a','--filter','label=dfortress.fixture=ecommerce','--format','{{.Names}}\t{{.Status}}\t{{.Ports}}')
elif command == 'refresh':
    # Only the owned, disposable web container is replaced; database stays intact.
    if exists('container',APP): managed(APP); docker('rm','-f',APP)
    start()
else: raise SystemExit('Usage: manage.py start|import|status|stop|refresh')
