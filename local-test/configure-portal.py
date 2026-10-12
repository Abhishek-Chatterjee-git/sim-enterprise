"""Import API credentials from a local file without printing secret values."""
import re
import sys
from pathlib import Path

private = Path(__file__).resolve().parents[2] / '.d-fortress-ecommerce'
source = Path(sys.argv[1]).read_text()
key_id = sys.argv[2]
if not re.fullmatch(r'dpk_[0-9a-f]{16}',key_id): raise SystemExit('Invalid key ID')
secrets = set(re.findall(r'dpsk_[A-Za-z0-9_-]+',source))
if len(secrets) != 1: raise SystemExit('Expected exactly one API secret in the input file')
file = private / 'local.env'
values = dict(line.split('=',1) for line in file.read_text().splitlines() if line and not line.startswith('#'))
values['COMPLIANCE_API_KEY_ID'] = key_id
values['COMPLIANCE_API_KEY_SECRET'] = secrets.pop()
file.write_text(''.join(f'{key}={value}\n' for key,value in values.items()))
file.chmod(0o600)
print('Portal API credentials saved locally; secret values omitted.')
