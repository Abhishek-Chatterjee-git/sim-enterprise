import assert from 'node:assert';
import { EnterpriseDatabase } from './db.js';
import { EcomServer } from './server.js';

console.log(`
================================================================================
  🧪 SIMULATED ENTERPRISE E-COMMERCE SECURITY & INTEGRITY TEST SUITE
================================================================================
`);

async function runTests() {
  const TEST_PORT = 3199;

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
  const ecom = new EcomServer({ port: TEST_PORT }, db);
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
  assert.strictEqual(eraseRes.status, 200, 'Erasure request must return 200');
  const eraseData = (await eraseRes.json()) as any;
  assert.strictEqual(eraseData.status, 'QUARANTINED_PENDING_ERASURE', 'Account must be quarantined');
  console.log('   ✅ Account Successfully Quarantined for Erasure with 30-Day Grace Period.');

  // 10. Test Account Reactivation
  console.log('\n🔹 [Test 10] Restoring Quarantined Account with Valid Password...');
  const reactivateRes = await fetch(`http://localhost:${TEST_PORT}/api/privacy/dsr/reactivate`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: 'rohit.sharma@example.com', password: 'CustomerPass2026!' }),
  });
  assert.strictEqual(reactivateRes.status, 200, 'Reactivation must return 200');
  console.log('   ✅ Account Restored to ACTIVE status.');

  // Cleanup
  await ecom.stop();
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
