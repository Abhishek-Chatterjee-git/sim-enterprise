#!/usr/bin/env python3
"""Package the demo's reviewed source paths; exclude local credentials/state."""
import argparse
import hashlib
from pathlib import Path
import tarfile

root = Path(__file__).resolve().parents[2]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('output', type=Path)
args = parser.parse_args()
files = [root / name for name in (
    'package.json', 'package-lock.json', 'tsconfig.json', 'Dockerfile', '.dockerignore',
    'deploy/aws/compose.yml', 'deploy/aws/Caddyfile', 'deploy/aws/init-roles.sh',
    'deploy/aws/prepare-env.py', 'deploy/aws/package-source.py',
    'deploy/aws/README.md', 'deploy/aws/COMMANDS.md',
    'deploy/render/Agent.Dockerfile', 'deploy/render/start-agent.mjs', 'deploy/render/README.md',
)]
for directory, suffixes in [('src', {'.ts'}), ('public', {'.html', '.js', '.css', '.svg', '.png', '.jpg', '.jpeg', '.webp', '.ico'})]:
    files.extend(path for path in (root / directory).rglob('*') if path.is_file() and path.suffix in suffixes)
if args.output.exists():
    parser.error('Output already exists; choose a new filename to preserve it.')
for path in files:
    if not path.is_file() or path.is_symlink():
        parser.error(f'Missing or symlinked input: {path.relative_to(root)}')
args.output.parent.mkdir(parents=True, exist_ok=True)
with tarfile.open(args.output, 'w:gz') as archive:
    for path in sorted(set(files)):
        archive.add(path, arcname='sim-enterprise/' + path.relative_to(root).as_posix(), recursive=False)
digest = hashlib.sha256(args.output.read_bytes()).hexdigest()
print(f'Created {args.output.name}: {len(set(files))} source files')
print(f'SHA-256: {digest}')
print('Excluded environment files, Git metadata, installed dependencies, local databases and agent identities.')
