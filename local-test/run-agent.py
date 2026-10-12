"""Run the verified portal agent with private local configuration."""
import os
import re
import signal
import subprocess
import sys
import time
import json
import urllib.request
from pathlib import Path

private = Path(__file__).resolve().parents[2] / '.d-fortress-ecommerce'
binary = private / 'installed/bin/dpdp'
env = dict(os.environ)
env.update(dict(line.split('=',1) for line in (private/'agent.env').read_text().splitlines() if line and not line.startswith('#')))
pid_file = private/'agent.pid'

def existing():
    if not pid_file.exists(): return None
    pid = int(pid_file.read_text())
    try:
        args = Path(f'/proc/{pid}/cmdline').read_bytes().decode().replace('\x00',' ')
        if str(private/'installed') not in args or 'agent start' not in args: return None
        os.kill(pid,0)
        return pid
    except (FileNotFoundError,ProcessLookupError): return None

command = sys.argv[1] if len(sys.argv)>1 else 'start'
if command == 'start':
    if existing(): raise SystemExit('The local test agent is already running.')
    log = private/'agent.log'
    with log.open('a') as output:
        log.chmod(0o600)
        process = subprocess.Popen([str(binary),'agent','start'],env=env,cwd=private,
            stdin=subprocess.DEVNULL,stdout=output,stderr=subprocess.STDOUT,start_new_session=True)
    pid_file.write_text(str(process.pid)); pid_file.chmod(0o600)
    time.sleep(3)
    if process.poll() is not None: raise SystemExit('Agent exited during startup. Run run-agent.py logs for the sanitized error.')
    print(f'Agent process started (PID {process.pid}); local API port {env["AGENT_PORT"]}.')
elif command == 'status':
    raise SystemExit(subprocess.run([str(binary),'agent','status'],env=env,cwd=private).returncode)
elif command == 'logs':
    text = (private/'agent.log').read_text()[-6000:]
    for name in ['AGENT_ENROLLMENT_TOKEN','AGENT_LOCAL_API_TOKEN','DATABASE_URL']:
        if env.get(name): text = text.replace(env[name],'<redacted>')
    text = re.sub(r'agent_enroll_[A-Za-z0-9_-]+|dpsk_[A-Za-z0-9_-]+','<redacted>',text)
    print(text)
elif command == 'stop':
    pid = existing()
    if pid: os.kill(pid,signal.SIGTERM); print('Stopped the local test agent.')
    else: print('The local test agent is not running.')
elif command == 'scan':
    request = urllib.request.Request(f'http://127.0.0.1:{env["AGENT_PORT"]}/scan/trigger',data=b'{}',
        headers={'Content-Type':'application/json','Authorization':'Bearer '+env['AGENT_LOCAL_API_TOKEN']},method='POST')
    with urllib.request.urlopen(request,timeout=60) as response:
        result = json.load(response)
    (private/'discovery-result.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))
else: raise SystemExit('Usage: run-agent.py start|status|logs|stop|scan')
