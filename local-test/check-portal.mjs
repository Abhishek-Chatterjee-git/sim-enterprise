import {createHash,createHmac,randomUUID} from 'node:crypto';

const keyId = process.env.COMPLIANCE_API_KEY_ID;
const secret = process.env.COMPLIANCE_API_KEY_SECRET;
if (!keyId || !secret) throw new Error('Missing portal API credentials');
const url = new URL('/api/v1/public/consent/lookup',process.env.CONTROL_PLANE_URL);
url.searchParams.set('requestId',randomUUID());
const body = JSON.stringify({dataSubjectIdentifier:'local-preflight@example.test'});
const timestamp = String(Math.floor(Date.now()/1000));
const signature = createHmac('sha256',secret)
  .update(`${timestamp}\nPOST\n${url.pathname}${url.search}\n${createHash('sha256').update(body).digest('hex')}`).digest('hex');
try {
  const response = await fetch(url,{method:'POST',headers:{'Content-Type':'application/json',
    'X-DPDPOS-Key-Id':keyId,'X-DPDPOS-Timestamp':timestamp,'X-DPDPOS-Signature':signature},
    body,redirect:'error',signal:AbortSignal.timeout(15000)});
  const result = await response.json();
  if (!response.ok) {
    const message = typeof result.error === 'string' ? result.error : result.error?.message ?? result.message;
    console.log(JSON.stringify({httpStatus:response.status,success:false,message}));
    process.exitCode = 1;
  } else console.log(JSON.stringify({httpStatus:response.status,success:true,
    check:'Signed consent lookup accepted; no portal data was created or changed.'}));
} catch (error) {
  console.log(JSON.stringify({success:false,message:'Portal connection failed',code:error.cause?.code ?? error.code}));
  process.exitCode = 1;
}
