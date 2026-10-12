import fs from 'node:fs/promises';
import pg from 'pg';
import { hashPassword } from '../dist/auth.js';

// CSV parsing supports quoted fields, escaped quotes and embedded newlines.
function parseCsv(text) {
  const rows = []; let row = []; let field = ''; let quoted = false;
  for (let i = 0; i < text.length; i++) {
    const char = text[i];
    if (char === '"') {
      if (quoted && text[i + 1] === '"') { field += '"'; i++; }
      else quoted = !quoted;
    } else if (!quoted && char === ',') { row.push(field); field = ''; }
    else if (!quoted && (char === '\n' || char === '\r')) {
      if (char === '\r' && text[i + 1] === '\n') i++;
      row.push(field); if (row.some(Boolean)) rows.push(row); row = []; field = '';
    } else field += char;
  }
  if (quoted) throw new Error('Unclosed CSV quote');
  if (field || row.length) { row.push(field); rows.push(row); }
  const headers = rows.shift();
  return rows.map(values => {
    if (values.length !== headers.length) throw new Error('CSV column count mismatch');
    return Object.fromEntries(headers.map((header, i) => [header, values[i]]));
  });
}

const customers = parseCsv(await fs.readFile(new URL('../data/synthetic_customers.csv', import.meta.url), 'utf8'));
const employees = parseCsv(await fs.readFile(new URL('../data/synthetic_employees.csv', import.meta.url), 'utf8'));
if (customers.length !== 1000 || employees.length !== 100) throw new Error('Unexpected fixture row counts');
const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  await client.query('BEGIN');
  await client.query(`CREATE TABLE IF NOT EXISTS employees (
    id VARCHAR(64) PRIMARY KEY, full_name TEXT NOT NULL, email TEXT NOT NULL,
    department TEXT, role TEXT, salary NUMERIC(12,2), pan_no TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  )`);
  for (const customer of customers) {
    // Conflicts are skipped so rerunning this importer preserves test changes.
    const result = await client.query(`INSERT INTO users
      (id, full_name, email, phone, password_hash, aadhaar_no, pan_no, address, city, status, created_at)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,'ACTIVE',$10) ON CONFLICT DO NOTHING RETURNING id`,
      [customer.id, customer.full_name, customer.email, customer.phone,
        hashPassword(customer.password), customer.aadhaar_no, customer.pan_no,
        customer.street_address, customer.city, customer.created_at]);
    if (result.rowCount) {
      const fixturePurposes = JSON.parse(customer.consent_purposes);
      const purposeMap = { ORDER_FULFILLMENT: 'essential', MARKETING_SMS: 'marketing', CUSTOMER_ANALYTICS: 'analytics' };
      const purposes = fixturePurposes.map(p => purposeMap[p] ?? p);
      for (const purpose of ['essential', 'marketing', 'analytics']) {
        await client.query(`INSERT INTO consent_preferences (id,user_id,purpose_id,is_granted,notice_version)
          VALUES ($1,$2,$3,$4,'2.1') ON CONFLICT (user_id,purpose_id) DO NOTHING`,
          [`cp-${customer.id}-${purpose}`, customer.id, purpose, purposes.includes(purpose)]);
      }
    }
  }
  for (const employee of employees) {
    await client.query(`INSERT INTO employees (id,full_name,email,department,role,salary,pan_no,created_at)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8) ON CONFLICT DO NOTHING`,
      [employee.id, employee.full_name, employee.email, employee.department, employee.role,
        employee.salary, employee.pan_no, employee.created_at]);
  }
  await client.query('COMMIT');
  const counts = {};
  for (const table of ['users','employees','products','orders','order_items','payments','customer_reviews','consent_preferences','audit_logs']) {
    counts[table] = Number((await client.query(`SELECT count(*) FROM ${table}`)).rows[0].count);
  }
  console.log(JSON.stringify({ importedFixtures: { customers: customers.length, employees: employees.length }, counts }, null, 2));
} catch (error) { await client.query('ROLLBACK'); throw error; }
finally { await client.end(); }
