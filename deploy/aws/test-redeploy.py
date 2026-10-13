#!/usr/bin/env python3
"""Verify the manual updater's service ordering and state-preserving commands."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT=Path(__file__).with_name('redeploy.sh')
FAKE_DOCKER='''#!/usr/bin/env python3
import json,os,sys
a=sys.argv[1:]
with open(os.environ['COMMAND_LOG'],'a') as log: log.write(' '.join(a)+'\\n')
if '--format' in a and 'json' in a:
 print(json.dumps({'services':{'proxy':{'environment':{'DEMO_HOSTNAME':os.environ.get('TEST_HOSTNAME','test.digitalfortress.in')}}}}))
elif a[:4]==['compose','ps','-q','storefront']: print('storefront-before-update')
elif a and a[0]=='inspect': print('sha256:previous-image')
elif a and a[0]=='build' and os.environ.get('FAIL_BUILD')=='1': sys.exit(1)
elif 'run' in a and os.environ.get('NO_INSTALLED_AGENT')=='1': sys.exit(1)
elif a[-2:]==['agent','status']: print('live: yes; ready: yes; enrolled ACTIVE')
'''
FAKE_CURL='''#!/usr/bin/env python3
print('{"status":"ok"}')
'''

class RedeployTests(unittest.TestCase):
    def execute(self,flags=None,override=None):
        with tempfile.TemporaryDirectory() as temporary:
            root=Path(temporary); directory=root/'deploy'/'aws'; directory.mkdir(parents=True)
            # Script resolves its own repository/deployment paths, as on the server.
            script=directory/'redeploy.sh'; script.write_bytes(SCRIPT.read_bytes())
            binaries=root/'bin'; binaries.mkdir()
            for name,content in [('docker',FAKE_DOCKER),('curl',FAKE_CURL)]:
                target=binaries/name; target.write_text(content); target.chmod(0o755)
            for name in ['compose.yml','.env','agent-bootstrap.env']:
                (directory/name).write_text('preserved-test-content\n')
            if override is not None: (directory/'compose.override.yml').write_text(override)
            env=os.environ.copy(); env.update(flags or {})
            env['PATH']=str(binaries)+os.pathsep+env['PATH']; env['COMMAND_LOG']=str(root/'commands.log')
            result=subprocess.run(['bash',str(script)],env=env,capture_output=True,text=True)
            commands=(root/'commands.log').read_text()
            self.assertEqual((directory/'.env').read_text(),'preserved-test-content\n')
            self.assertEqual((directory/'agent-bootstrap.env').read_text(),'preserved-test-content\n')
            self.assertNotIn(' down',commands)
            self.assertNotIn('volume rm',commands)
            new_override=(directory/'compose.override.yml').read_text() if (directory/'compose.override.yml').exists() else ''
            return result,commands,new_override

    def test_restarts_services_in_order_and_replaces_managed_image(self):
        result,commands,override=self.execute(override='# Managed by deploy-storefront.sh\nservices:\n  storefront:\n    image: old-ci-image\n')
        self.assertEqual(result.returncode,0,result.stderr)
        starts=[line for line in commands.splitlines() if ' up ' in line]
        self.assertEqual([line.split()[-1] for line in starts],['postgres','storefront','agent','proxy'])
        self.assertLess(commands.index('build -t'),commands.index('stop agent storefront'))
        self.assertIn('manual-',override)
        self.assertNotIn('old-ci-image',override)
        self.assertIn('agent status',commands)

    def test_build_failure_leaves_running_services_untouched(self):
        result,commands,_=self.execute({'FAIL_BUILD':'1'})
        self.assertNotEqual(result.returncode,0)
        self.assertNotIn(' stop ',commands)
        self.assertNotIn(' up ',commands)

    def test_missing_install_does_not_stop_services(self):
        result,commands,_=self.execute({'NO_INSTALLED_AGENT':'1'})
        self.assertNotEqual(result.returncode,0)
        self.assertNotIn(' stop ',commands)

    def test_unmanaged_override_is_not_replaced(self):
        original='services:\n  storefront:\n    environment:\n      CUSTOM: preserve\n'
        result,commands,override=self.execute(override=original)
        self.assertNotEqual(result.returncode,0)
        self.assertEqual(override,original)
        self.assertNotIn('build -t',commands)

    def test_demo_without_hostname_does_not_start_proxy(self):
        result,commands,_=self.execute({'TEST_HOSTNAME':'localhost'})
        self.assertEqual(result.returncode,0,result.stderr)
        starts=[line for line in commands.splitlines() if ' up ' in line]
        self.assertEqual([line.split()[-1] for line in starts],['postgres','storefront','agent'])

if __name__=='__main__': unittest.main()
