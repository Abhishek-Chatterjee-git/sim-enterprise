import secrets
from pathlib import Path

file = Path(__file__).resolve().parents[2] / '.d-fortress-ecommerce/agent.env'
values = dict(line.split('=',1) for line in file.read_text().splitlines() if line)
values['AGENT_LOCAL_API_TOKEN'] = secrets.token_hex(24)
file.write_text(''.join(f'{key}={value}\n' for key,value in values.items()))
file.chmod(0o600)
print('Generated a private local agent API token; secret omitted.')
