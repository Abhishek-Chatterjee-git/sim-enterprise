#!/usr/bin/env python3
"""Generate private first-run configuration; never replace existing credentials."""
import os
import secrets
from pathlib import Path

directory = Path(__file__).resolve().parent
os.umask(0o077)
values = {
    'POSTGRES_PASSWORD': secrets.token_hex(32),
    'APP_DB_PASSWORD': secrets.token_hex(32),
    'AGENT_DB_PASSWORD': secrets.token_hex(32),
    'SESSION_SECRET': secrets.token_hex(32),
    'AGENT_LOCAL_API_TOKEN': secrets.token_hex(32),
    'COMPLIANCE_API_KEY_ID': '',
    'COMPLIANCE_API_KEY_SECRET': '',
    'COMPLIANCE_NOTICE_ID': '',
    'DEMO_HOSTNAME': '',
}
for name, content in (
    ('.env', ''.join(f'{key}={value}\n' for key, value in values.items())),
    ('agent-bootstrap.env', '# Add fresh portal bootstrap values after the image build.\n'),
):
    target = directory / name
    try:
        with target.open('x') as file:
            file.write(content)
        print(f'Created private {name}')
    except FileExistsError:
        print(f'Preserved existing {name}')
