"""Compare local users against the pre-erasure snapshot without displaying PII."""
import hashlib
import json
import subprocess
from pathlib import Path

private = Path(__file__).resolve().parents[2] / '.d-fortress-ecommerce'
snapshot = sorted(private.glob('before-erasure-*.sql'))[-1]
def users(dump):
    lines = dump.splitlines()
    start = next(i for i,line in enumerate(lines) if line.startswith('COPY public.users ('))
    rows = {}
    for line in lines[start+1:]:
        if line == '\\.': break
        rows[line.split('\t',1)[0]] = hashlib.sha256(line.encode()).hexdigest()
    return rows
before = users(snapshot.read_text())
now = users(subprocess.run(['docker','exec','dfortress-ecommerce-test-postgres','pg_dump',
    '-U','ecom_owner','-d','ecommerce_test','--no-owner','--no-acl'],check=True,capture_output=True,text=True).stdout)
changed = [key for key in before.keys() & now.keys() if before[key] != now[key]]
print(json.dumps({'baselineCustomers':len(before),'currentCustomers':len(now),
    'changedCustomerIds':changed,'removedCustomerCount':len(before.keys()-now.keys()),
    'addedCustomerCount':len(now.keys()-before.keys()),
    'onlyExpectedCustomerChanged':changed == ['usr-495aaeee286a']},indent=2))
