import assert from 'node:assert';
import { EnterpriseDatabase } from './db.js';
import { EcomServer } from './server.js';
import { createServer } from 'node:http';
import { createHash, createHmac } from 'node:crypto';
import { returnDeadline } from './account-return.js';

console.log(`
================================================================================
  🧪 SIMULATED ENTERPRISE E-COMMERCE SECURITY & INTEGRITY TEST SUITE
================================================================================
`);

async function runTests() {
  const TEST_PORT = 3199;
  process.env.DB_TYPE = 'SQLITE';
  process.env.COMPLIANCE_API_KEY_ID = 'dpk_0000000000000001';
  process.env.COMPLIANCE_API_KEY_SECRET = 'local-test-secret';
  const portalCalls: string[] = [];
  let refuseWithdrawal = false;
  const mockPortal = createServer(async (req,res) => {
    let body = ''; for await (const chunk of req) body += chunk;
    const path = new URL(req.url!, 'http://localhost').pathname;
    portalCalls.push(path);
    if (path !== '/api/v1/public/dsr/verify') {
      const timestamp = req.headers['x-dpdpos-timestamp'];
      const digest = createHash('sha256').update(body).digest('hex');
      const expected = createHmac('sha256','local-test-secret')
        .update(`${timestamp}\nPOST\n${req.url}\n${digest}`).digest('hex');
      if (req.headers['x-dpdpos-key-id'] !== 'dpk_0000000000000001' || req.headers['x-dpdpos-signature'] !== expected) {
        res.writeHead(401); res.end(JSON.stringify({success:false,error:'Invalid signature'})); return;
      }
    }
    const payload = JSON.parse(body);
    let data: object = {status:path.endsWith('/grant') ? 'GRANTED' : 'WITHDRAWN'};
    if (path.endsWith('/dsr/start')) {
      assert.strictEqual(payload.requesterEmail,'rohit.sharma@example.com');
      data = {verificationId:'test-verification',expiresInSeconds:600};
    }
    if (path.endsWith('/dsr/verify')) {
      if (payload.code !== '123456') { res.writeHead(400); res.end(JSON.stringify({error:'Invalid code'})); return; }
      data = {reference:'test-dsr',status:'OPEN',statusToken:'dsrst_test_capability_for_mock_only'};
    }
    if (path.endsWith('/dsr/withdraw')) {
      if (refuseWithdrawal) {res.writeHead(409);res.end(JSON.stringify({error:'Erasure already dispatched'}));return;}
      data = {withdrawn:true,reference:'test-dsr'};
    }
    res.writeHead(200,{'Content-Type':'application/json'});
    res.end(JSON.stringify({success:true,data}));
  });
  await new Promise<void>(resolve => mockPortal.listen(0,'127.0.0.1',resolve));
  const mockPort = (mockPortal.address() as {port:number}).port;

  // 1. Test Database & Schema Initialization
  console.log('🔹 [Test 1] Initializing Enterprise Database & Verifying Schema...');
  const db = new EnterpriseDatabase(':memory:');
  await db.init();

  const userCount = await db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM users');
  const prodCount = await db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM products');
  const orderCount = await db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM orders');

  assert.ok(Number(userCount?.count) >= 3, 'Users table must have seed data');
  assert.ok(Number(prodCount?.count) >= 6, 'Products table must have seed data');
  assert.ok(Number(orderCount?.count) >= 2, 'Orders table must have seed data');

  console.log('   ✅ Enterprise Database Schema & Seed Data Verified.');

  // 2. Test Storefront Web Service Startup & Health
  console.log('\n🔹 [Test 2] Starting E-Commerce Storefront Web Service...');
  const ecom = new EcomServer({ port: TEST_PORT, config:{controlPlaneUrl:`http://127.0.0.1:${mockPort}`} }, db);
  await ecom.start();

  const healthRes = await fetch(`http://localhost:${TEST_PORT}/api/health`);
  assert.strictEqual(healthRes.status, 200, 'Storefront health check must return 200');
  console.log('   ✅ Storefront Web Service Running & Healthy.');

  // 3. Test Products API (Public)
  console.log('\n🔹 [Test 3] Fetching Products Catalog (Public Access)...');
  const prodRes = await fetch(`http://localhost:${TEST_PORT}/api/products`);
  assert.strictEqual(prodRes.status, 200, 'Products API must return 200');
  const prodData = (await prodRes.json()) as any;
  assert.ok(Array.isArray(prodData.products) && prodData.products.length >= 6, 'Must return 6+ artisanal products');
  console.log(`   ✅ Public Catalog Verified (${prodData.products.length} Products Available).`);

  // 4. Test Security Gate: Unauthenticated Order Placement
  console.log('\n🔹 [Test 4] Security Check: Unauthenticated Order Placement...');
  const unauthOrderRes = await fetch(`http://localhost:${TEST_PORT}/api/orders`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      items: [{ productId: 'prod-01', productName: 'Shawl', sku: 'SKU-001', quantity: 1, unitPrice: 18500 }],
    }),
  });
  assert.strictEqual(unauthOrderRes.status, 401, 'Unauthenticated order placement must be rejected with 401');
  const unauthOrderData = (await unauthOrderRes.json()) as any;
  assert.ok(unauthOrderData.error, 'Must return clean error message without leaking DB info');
  assert.ok(!unauthOrderData.error.includes('violates foreign key'), 'Must not leak foreign key details');
  console.log('   ✅ Unauthenticated Order Blocked (401 Unauthorized, zero DB info leaked).');

  // 5. Test Security Gate: Unauthenticated Privacy Access & Erasure
  console.log('\n🔹 [Test 5] Security Check: Unauthenticated Privacy Status & Erasure...');
  const unauthPrivRes = await fetch(`http://localhost:${TEST_PORT}/api/privacy/status`);
  assert.strictEqual(unauthPrivRes.status, 401, 'Unauthenticated privacy status must be rejected with 401');

  const unauthEraseRes = await fetch(`http://localhost:${TEST_PORT}/api/privacy/dsr/erasure`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ reason: 'Malicious erasure attempt' }),
  });
  assert.strictEqual(unauthEraseRes.status, 401, 'Unauthenticated erasure request must be rejected with 401');
  console.log('   ✅ Unauthenticated Privacy & Erasure Blocked (401 Unauthorized).');

  // 6. Test Customer Authentication
  console.log('\n🔹 [Test 6] Authenticating Registered Customer (Rohit Sharma)...');
  const loginRes = await fetch(`http://localhost:${TEST_PORT}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: 'rohit.sharma@example.com', password: 'CustomerPass2026!' }),
  });
  assert.strictEqual(loginRes.status, 200, 'Customer login must succeed');
  const loginData = (await loginRes.json()) as any;
  assert.ok(loginData.token, 'Must return valid session JWT token');
  console.log(`   ✅ Customer Auth Verified (Welcome ${loginData.user.fullName}).`);

  // 7. Test Authenticated Order Placement
  console.log('\n🔹 [Test 7] Authenticated Order Placement...');
  const authOrderRes = await fetch(`http://localhost:${TEST_PORT}/api/orders`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${loginData.token}`,
    },
    body: JSON.stringify({
      items: [{ productId: 'prod-03', productName: 'Mysore Sandalwood', sku: 'WELL-SAND-003', quantity: 1, unitPrice: 5200 }],
      shippingAddress: 'Flat 14B, Sea Breeze Apartments, Worli Sea Face, Mumbai 400018',
    }),
  });
  assert.strictEqual(authOrderRes.status, 201, 'Authenticated order must succeed with 201');
  const authOrderData = (await authOrderRes.json()) as any;
  assert.ok(authOrderData.orderNumber, 'Must return order number');
  assert.strictEqual(authOrderData.totalAmount, 5200, 'Total amount must match');
  console.log(`   ✅ Authenticated Order Placed Successfully (Order: ${authOrderData.orderNumber}, Amount: ₹${authOrderData.totalAmount}).`);

  // 8. Test Authenticated Consent Revocation
  console.log('\n🔹 [Test 8] Authenticated Consent Revocation...');
  const revokeRes = await fetch(`http://localhost:${TEST_PORT}/api/privacy/consent/update`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${loginData.token}`,
    },
    body: JSON.stringify({
      purposeId: 'marketing',
      isGranted: false,
    }),
  });
  assert.strictEqual(revokeRes.status, 200, 'Consent update must return 200');
  assert.strictEqual((await revokeRes.json() as any).portalSynced,true);
  const localConsent = await db.get<any>("SELECT is_granted FROM consent_preferences WHERE user_id = $1 AND purpose_id = 'marketing'",['usr-mumbai-101']);
  assert.strictEqual(Number(localConsent.is_granted),0);
  console.log('   ✅ Customer Consent Successfully Revoked in DB & Webhook Dispatched.');

  // 9. Test Authenticated Right to Erasure
  console.log('\n🔹 [Test 9] Authenticated Right to Erasure ("Delete My Account")...');
  const eraseRes = await fetch(`http://localhost:${TEST_PORT}/api/privacy/dsr/erasure`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${loginData.token}`,
    },
    body: JSON.stringify({ reason: 'Customer requested account erasure' }),
  });
  assert.strictEqual(eraseRes.status, 202, 'Erasure request must start verification');
  const eraseData = (await eraseRes.json()) as any;
  assert.strictEqual(eraseData.status, 'VERIFICATION_REQUIRED');
  assert.strictEqual((await db.get<any>('SELECT status FROM users WHERE id = $1',['usr-mumbai-101'])).status,'ACTIVE',
    'Starting email verification must not quarantine the customer');
  const wrongCode = await fetch(`http://localhost:${TEST_PORT}/api/privacy/dsr/verify`,{
    method:'POST',headers:{'Content-Type':'application/json',Authorization:`Bearer ${loginData.token}`},
    body:JSON.stringify({code:'000000'}),
  });
  assert.strictEqual(wrongCode.status,502);
  assert.strictEqual((await db.get<any>('SELECT status FROM users WHERE id = $1',['usr-mumbai-101'])).status,'ACTIVE');
  const verified = await fetch(`http://localhost:${TEST_PORT}/api/privacy/dsr/verify`,{
    method:'POST',headers:{'Content-Type':'application/json',Authorization:`Bearer ${loginData.token}`},
    body:JSON.stringify({code:'123456'}),
  });
  assert.strictEqual(verified.status,201);
  assert.strictEqual((await verified.json() as any).reference,'test-dsr');
  assert.strictEqual((await db.get<any>('SELECT status FROM users WHERE id = $1',['usr-mumbai-101'])).status,'QUARANTINED');
  console.log('   ✅ Email confirmation required before portal request creation and local quarantine.');

  // 10. Test Account Reactivation
  console.log('\n🔹 [Test 10] Restoring Quarantined Account with Valid Password...');
  const returnBody = {email:'rohit.sharma@example.com',password:'CustomerPass2026!',privacyAccepted:true,noticeVersion:'2.1',consents:['essential']};
  const attemptReturn = (body: object) => fetch(`http://localhost:${TEST_PORT}/api/privacy/dsr/reactivate`,{
    method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body),
  });
  const pendingLogin = await fetch(`http://localhost:${TEST_PORT}/api/auth/login`,{
    method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(returnBody),
  });
  assert.strictEqual(pendingLogin.status,403);
  assert.strictEqual((await pendingLogin.json() as any).requiresPrivacyAcceptance,true);
  assert.strictEqual((await attemptReturn({...returnBody,privacyAccepted:false})).status,400);
  assert.strictEqual((await attemptReturn({...returnBody,password:'wrong'})).status,401);
  const recent = Date.now();
  await db.run('UPDATE privacy_account_returns SET requested_at=$1 WHERE user_id=$2',[Date.UTC(2020,0,31),'usr-mumbai-101']);
  assert.strictEqual((await attemptReturn(returnBody)).status,409);
  await db.run('UPDATE privacy_account_returns SET requested_at=$1 WHERE user_id=$2',[recent,'usr-mumbai-101']);
  refuseWithdrawal = true;
  assert.strictEqual((await attemptReturn(returnBody)).status,409);
  assert.strictEqual((await db.get<any>('SELECT status FROM users WHERE id=$1',['usr-mumbai-101'])).status,'QUARANTINED');
  refuseWithdrawal = false;
  const originalHash = (await db.get<any>('SELECT password_hash FROM users WHERE id=$1',['usr-mumbai-101'])).password_hash;
  await db.run('UPDATE users SET password_hash=$1 WHERE id=$2',['[ERASED:test]','usr-mumbai-101']);
  assert.strictEqual((await attemptReturn(returnBody)).status,401);
  await db.run('UPDATE users SET password_hash=$1 WHERE id=$2',[originalHash,'usr-mumbai-101']);
  const reactivateRes = await attemptReturn(returnBody);
  assert.strictEqual(reactivateRes.status, 200, 'Reactivation must return 200');
  assert.strictEqual((await db.get<any>('SELECT status FROM users WHERE id=$1',['usr-mumbai-101'])).status,'ACTIVE');
  const preferences = await db.all<any>('SELECT purpose_id,is_granted FROM consent_preferences WHERE user_id=$1',['usr-mumbai-101']);
  assert.ok(preferences.every(p=>Boolean(p.is_granted)===(p.purpose_id==='essential')));
  assert.strictEqual(new Date(returnDeadline(Date.UTC(2026,7,31))).toISOString(),'2027-02-28T00:00:00.000Z');
  console.log('   ✅ Account Restored to ACTIVE status.');

  // Cleanup
  await ecom.stop();
  assert.ok(portalCalls.includes('/api/v1/public/consent/revoke'));
  assert.ok(portalCalls.includes('/api/v1/public/dsr/start'));
  assert.ok(portalCalls.includes('/api/v1/public/dsr/verify'));
  assert.ok(portalCalls.includes('/api/v1/public/dsr/withdraw'));
  await new Promise<void>(resolve => mockPortal.close(() => resolve()));
  console.log(`
================================================================================
  🎉 ALL SECURITY & INTEGRITY TESTS PASSED (100%)!
================================================================================
`);
}

runTests().catch((err) => {
  console.error('❌ Enterprise Test Failure:', err);
  process.exit(1);
});
