"""Select a supported agent authentication mode without changing the server."""
import sys
from pathlib import Path

mode = sys.argv[1]
if mode not in ['auto','required','off']: raise SystemExit('Expected auto|required|off')
file = Path(__file__).resolve().parents[2] / '.d-fortress-ecommerce/agent.env'
values = dict(line.split('=',1) for line in file.read_text().splitlines() if line)
values['AGENT_MTLS'] = mode
file.write_text(''.join(f'{key}={value}\n' for key,value in values.items()))
file.chmod(0o600)
print(f'Local agent client-certificate mode: {mode}. HTTPS certificate verification is unchanged.')
