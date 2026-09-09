import assert from 'node:assert';
import { EnterpriseDatabase } from './db.js';
import { EcomServer } from './server.js';
import { ZoneAgentWorker } from './agent-worker.js';
import { ComplianceSaasClient } from './saas-client.js';

console.log(`
================================================================================
  🧪 SIMULATED ENTERPRISE & IN-VPC ZONE AGENT TEST SUITE
================================================================================
`);

async function runTests() {
  const TEST_PORT = 3199;
  const AGENT_PORT = 5199;

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

  // 2. Test In-VPC Zone Agent Schema Inspection & PII Discovery
  console.log('\n🔹 [Test 2] Testing In-VPC Zone Agent Local PII Discovery & DDL Hashing...');
  const agent = new ZoneAgentWorker(
    {
      agentId: 'test-agent-mumbai-01',
      agentPort: AGENT_PORT,
      dbConnectionString: ':memory:',
      organizationSlug: 'test-enterprise',
    },
    db
  );
  await agent.start();

  const { tables, overallChecksum } = await agent.inspectLocalSchemaAndPii();
  assert.ok(tables.length >= 7, 'Must inspect all enterprise tables');
  assert.ok(overallChecksum.length === 64, 'DDL Checksum must be valid SHA-256');

  const usersTable = tables.find((t) => t.tableName === 'users');
  assert.ok(usersTable, 'users table must be inspected');

  const aadhaarCol = usersTable.columns.find((c) => c.name === 'aadhaar_no');
  const panCol = usersTable.columns.find((c) => c.name === 'pan_no');
  const phoneCol = usersTable.columns.find((c) => c.name === 'phone');
  const emailCol = usersTable.columns.find((c) => c.name === 'email');

  assert.strictEqual(aadhaarCol?.detectedPii?.piiType, 'AADHAAR', 'Aadhaar column must be classified with Verhoeff validation');
  assert.strictEqual(panCol?.detectedPii?.piiType, 'PAN', 'PAN column must be classified');
  assert.strictEqual(phoneCol?.detectedPii?.piiType, 'PHONE', 'Phone column must be classified');
  assert.strictEqual(emailCol?.detectedPii?.piiType, 'EMAIL', 'Email column must be classified');

  console.log(`   ✅ In-Memory PII Classification: Classified ${usersTable.columns.filter((c) => c.detectedPii).length} sensitive fields in 'users' table.`);

  // 3. Test Storefront Web Server & DPDP Onboarding
  console.log('\n🔹 [Test 3] Testing Storefront Web Server & DPDP Onboarding...');
  const ecom = new EcomServer(
    {
      port: TEST_PORT,
      config: {
        port: TEST_PORT,
        agentPort: AGENT_PORT,
        organizationSlug: 'test-enterprise',
      },
    },
    db
  );
  await ecom.start();

  // Test Customer Signup with Granular DPDP Notice
  const signupRes = await fetch(`http://localhost:${TEST_PORT}/api/auth/signup`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      fullName: 'Ananya Deshmukh',
      email: 'ananya.deshmukh@enterprise.in',
      phone: '+919876543210',
      password: 'SecurePass2026!',
      aadhaarNo: '367598324157',
      panNo: 'ABCDE1234F',
      consents: ['essential', 'marketing', 'analytics'],
    }),
  });

  const signupData = await signupRes.json() as any;
  assert.strictEqual(signupRes.status, 201);
  assert.ok(signupData.token, 'Must return session token');
  console.log(`   ✅ Customer Onboarding: Created account for ${signupData.user.fullName} with DPDP consent notices.`);

  // 4. Test Orders & Product Catalog
  console.log('\n🔹 [Test 4] Testing Product Catalog & Order Placement...');
  const prodRes = await fetch(`http://localhost:${TEST_PORT}/api/products`);
  const prodData = await prodRes.json() as any;
  assert.ok(prodData.products.length >= 6);

  const orderRes = await fetch(`http://localhost:${TEST_PORT}/api/orders`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${signupData.token}`,
    },
    body: JSON.stringify({
      userId: signupData.user.id,
      items: [{ productId: 'prod-01', productName: 'Kashmiri Shawl', sku: 'LUXE-KASH-001', quantity: 1, unitPrice: 18500 }],
    }),
  });

  const orderData = await orderRes.json() as any;
  assert.strictEqual(orderRes.status, 201);
  assert.ok(orderData.orderNumber);
  console.log(`   ✅ Order Placement: Order #${orderData.orderNumber} placed for ₹${orderData.totalAmount}.`);

  // 5. Test Live DPDP Enforcement Gate (Marketing Check)
  console.log('\n🔹 [Test 5] Testing Live DPDP Enforcement & Real-Time Agent Gating...');
  // Check 1: Marketing Allowed
  const promoRes1 = await fetch(`http://localhost:${TEST_PORT}/api/marketing/dispatch-promo`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ recipientEmail: 'ananya.deshmukh@enterprise.in' }),
  });
  const promoData1 = await promoRes1.json() as any;
  assert.strictEqual(promoRes1.status, 200);
  assert.strictEqual(promoData1.success, true);
  console.log(`   ✅ Marketing Dispatch 1: PERMITTED (Consent is Active, Latency: ${promoData1.complianceCheck.latencyMs} ms)`);

  // Revoke Marketing Consent in Privacy Center
  console.log('   🔹 Revoking marketing consent in Customer Privacy Center...');
  const revokeRes = await fetch(`http://localhost:${TEST_PORT}/api/privacy/consent/update`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${signupData.token}`,
    },
    body: JSON.stringify({
      userId: signupData.user.id,
      purposeId: 'marketing',
      isGranted: false,
    }),
  });
  assert.strictEqual(revokeRes.status, 200);

  // Check 2: Marketing Blocked
  const promoRes2 = await fetch(`http://localhost:${TEST_PORT}/api/marketing/dispatch-promo`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ recipientEmail: 'ananya.deshmukh@enterprise.in' }),
  });
  const promoData2 = await promoRes2.json() as any;
  assert.strictEqual(promoRes2.status, 403);
  assert.strictEqual(promoData2.blockedByDpdp, true);
  console.log(`   ✅ Marketing Dispatch 2: BLOCKED by DPDP In-VPC Edge Agent (403 Forbidden: ${promoData2.message.slice(0, 45)}...)`);

  // 6. Test DPDP Act §12 Right to Erasure
  console.log('\n🔹 [Test 6] Testing DPDP Act §12 Right to Erasure Workflow...');
  const erasureRes = await fetch(`http://localhost:${TEST_PORT}/api/privacy/dsr/erasure`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${signupData.token}`,
    },
    body: JSON.stringify({
      userId: signupData.user.id,
      reason: 'Customer exercised right to be forgotten via Privacy Portal',
    }),
  });

  const erasureData = await erasureRes.json() as any;
  assert.strictEqual(erasureRes.status, 200);
  assert.strictEqual(erasureData.status, 'QUARANTINED_PENDING_ERASURE');

  const updatedUser = await db.get<any>('SELECT * FROM users WHERE id = $1', [signupData.user.id]);
  assert.strictEqual(updatedUser.status, 'SOFT_DELETED', 'User status must be quarantined/soft-deleted');
  console.log(`   ✅ Right to Erasure: Account quarantined with 30-day statutory grace period.`);

  // 7. Test Account Restoration
  console.log('\n🔹 [Test 7] Testing Account Reactivation during Grace Period...');
  const restoreRes = await fetch(`http://localhost:${TEST_PORT}/api/privacy/dsr/reactivate`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: 'ananya.deshmukh@enterprise.in' }),
  });
  const restoreData = await restoreRes.json() as any;
  assert.strictEqual(restoreRes.status, 200);
  assert.strictEqual(restoreData.success, true);

  const restoredUser = await db.get<any>('SELECT * FROM users WHERE id = $1', [signupData.user.id]);
  assert.strictEqual(restoredUser.status, 'ACTIVE');
  console.log(`   ✅ Account Restoration: Restored user back to ACTIVE status.`);

  // Cleanup
  await ecom.stop();
  await agent.stop();

  console.log(`
================================================================================
  🎉 ALL 7 ENTERPRISE INTEGRATION TESTS PASSED WITH 100% SUCCESS!
================================================================================
`);
}

runTests().catch((err) => {
  console.error('❌ Test execution failed:', err);
  process.exit(1);
});
