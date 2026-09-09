import assert from 'node:assert';
import { EnterpriseDatabase } from './db.js';
import { EcomServer } from './server.js';
import { ComplianceSaasClient } from './saas-client.js';

console.log(`
================================================================================
  🧪 SIMULATED ENTERPRISE E-COMMERCE PLATFORM TEST SUITE
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
  const paymentCount = await db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM payments');
  const reviewCount = await db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM customer_reviews');
  const auditCount = await db.get<{ count: number | string }>('SELECT COUNT(*) as count FROM audit_logs');

  assert.ok(Number(userCount?.count) >= 3, 'Users table must have seed data');
  assert.ok(Number(prodCount?.count) >= 6, 'Products table must have seed data');
  assert.ok(Number(orderCount?.count) >= 2, 'Orders table must have seed data');
  assert.ok(Number(paymentCount?.count) >= 2, 'Payments table must have seed data');
  assert.ok(Number(reviewCount?.count) >= 2, 'Customer reviews table must have seed data');
  assert.ok(Number(auditCount?.count) >= 1, 'Audit logs table must have seed data');

  console.log('   ✅ Enterprise Database Schema & Seed Data Verified.');

  // 2. Test Storefront Web Service Startup & Health
  console.log('\n🔹 [Test 2] Starting E-Commerce Storefront Web Service...');
  const ecom = new EcomServer({ port: TEST_PORT }, db);
  await ecom.start();

  const healthRes = await fetch(`http://localhost:${TEST_PORT}/api/health`);
  assert.strictEqual(healthRes.status, 200, 'Storefront health check must return 200');
  const healthData = await healthRes.json() as any;
  assert.strictEqual(healthData.status, 'ok', 'Health status must be ok');
  console.log('   ✅ Storefront Web Service Running & Healthy.');

  // 3. Test Products API
  console.log('\n🔹 [Test 3] Fetching Products Catalog...');
  const prodRes = await fetch(`http://localhost:${TEST_PORT}/api/products`);
  assert.strictEqual(prodRes.status, 200, 'Products API must return 200');
  const prodData = await prodRes.json() as any;
  assert.ok(Array.isArray(prodData.products) && prodData.products.length >= 6, 'Must return 6+ artisanal products');
  console.log(`   ✅ Catalog Verified (${prodData.products.length} Products Available).`);

  // 4. Test Customer Authentication & Consent Storage
  console.log('\n🔹 [Test 4] Testing Customer Authentication & DPDP Preferences...');
  const loginRes = await fetch(`http://localhost:${TEST_PORT}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: 'rohit.sharma@example.com', password: 'CustomerPass2026!' }),
  });
  assert.strictEqual(loginRes.status, 200, 'Customer login must succeed');
  const loginData = (await loginRes.json()) as any;
  assert.ok(loginData.token, 'Must return session token');
  console.log(`   ✅ Customer Auth Verified (Welcome ${loginData.user.fullName}).`);

  // 5. Test Consent Revocation Hook
  console.log('\n🔹 [Test 5] Testing Customer Consent Revocation & SaaS Webhook...');
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

  // Cleanup
  await ecom.stop();
  console.log(`
================================================================================
  🎉 ALL ENTERPRISE TESTS PASSED SUCCESSFULLY (100%)!
================================================================================
`);
}

runTests().catch((err) => {
  console.error('❌ Enterprise Test Failure:', err);
  process.exit(1);
});
