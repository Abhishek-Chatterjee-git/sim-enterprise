#!/usr/bin/env python3
"""Exercise deployment and rollback orchestration without touching real services."""
import hashlib
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).with_name('deploy-storefront.sh')
REVISION = 'a' * 40
MARKER = '# Managed by deploy-storefront.sh'

FAKE_DOCKER = '''#!/usr/bin/env python3
import os, sys
from pathlib import Path
a=sys.argv[1:]
with open(os.environ['COMMAND_LOG'],'a') as log: log.write('docker '+ ' '.join(a)+'\\n')
if a[:3]==['compose','ps','-q']: print('existing-storefront')
elif a and a[0]=='inspect': print('sha256:old-image')
elif a and a[0]=='load' and os.environ.get('FAIL_LOAD')=='1': sys.exit(1)
elif a[:2]==['compose','up'] and os.environ.get('FAIL_NEW_UP')=='1':
 if ('a'*40) in Path('compose.override.yml').read_text(): sys.exit(1)
'''
FAKE_CURL = '''#!/usr/bin/env python3
import os,sys
with open(os.environ['COMMAND_LOG'],'a') as log: log.write('curl health\\n')
if os.environ.get('FAIL_HEALTH')=='1': sys.exit(22)
print('{"status":"ok"}')
'''

class DeploymentTests(unittest.TestCase):
    def run_deploy(self, flags=None, initial_override=None, bad_digest=False):
        with tempfile.TemporaryDirectory() as directory:
            base=Path(directory)
            binaries=base/'bin'; binaries.mkdir()
            for name,content in [('docker',FAKE_DOCKER),('curl',FAKE_CURL)]:
                target=binaries/name; target.write_text(content); target.chmod(0o755)
            for name in ['compose.yml','.env','agent-bootstrap.env']:
                (base/name).write_text('# isolated test\n')
            if initial_override is not None: (base/'compose.override.yml').write_text(initial_override)
            archive=base/'image.tar.gz'; archive.write_bytes(b'isolated fake image')
            digest='0'*64 if bad_digest else hashlib.sha256(archive.read_bytes()).hexdigest()
            env=os.environ.copy(); env['PATH']=str(binaries)+os.pathsep+env['PATH']
            env['COMMAND_LOG']=str(base/'commands.log'); env.update(flags or {})
            result=subprocess.run(['bash',str(SCRIPT),str(base),str(archive),REVISION,digest],env=env,capture_output=True,text=True)
            log=(base/'commands.log').read_text() if (base/'commands.log').exists() else ''
            override=(base/'compose.override.yml').read_text() if (base/'compose.override.yml').exists() else ''
            return result,log,override

    def assert_only_storefront_updated(self,log):
        updates=[line for line in log.splitlines() if line.startswith('docker compose up')]
        self.assertTrue(updates)
        for line in updates:
            self.assertIn('--no-deps --no-build --pull never',line)
            self.assertTrue(line.endswith(' storefront'))

    def test_healthy_deployment(self):
        result,log,override=self.run_deploy()
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertIn(REVISION,override)
        self.assert_only_storefront_updated(log)

    def test_unhealthy_image_rolls_back_first_deployment(self):
        result,log,override=self.run_deploy({'FAIL_NEW_UP':'1'})
        self.assertNotEqual(result.returncode,0)
        self.assertIn('image: dfortress-demo-storefront:rollback',override)
        self.assertEqual(log.count('docker compose up'),2)
        self.assert_only_storefront_updated(log)

    def test_failed_health_check_restores_existing_image_override(self):
        old=MARKER+'\nservices:\n  storefront:\n    image: dfortress-demo-storefront:'+('b'*40)+'\n'
        result,log,override=self.run_deploy({'FAIL_HEALTH':'1'},old)
        self.assertNotEqual(result.returncode,0)
        self.assertEqual(override,old)
        self.assert_only_storefront_updated(log)

    def test_bad_checksum_does_not_touch_docker(self):
        result,log,_=self.run_deploy(bad_digest=True)
        self.assertNotEqual(result.returncode,0)
        self.assertEqual(log,'')

    def test_unmanaged_override_is_preserved(self):
        old='services:\n  storefront:\n    environment:\n      CUSTOM_SETTING: keep\n'
        result,log,override=self.run_deploy(initial_override=old)
        self.assertNotEqual(result.returncode,0)
        self.assertEqual(override,old)
        self.assertNotIn('docker compose up',log)

if __name__=='__main__': unittest.main()
