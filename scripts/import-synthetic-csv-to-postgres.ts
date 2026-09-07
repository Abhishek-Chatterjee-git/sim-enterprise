import { readFileSync, existsSync } from 'node:fs';
import { resolve } from 'node:path';
import { createHash, randomBytes } from 'node:crypto';
import pg from 'pg';

function parseCsv(content: string): Record<string, string>[] {
  const lines = content.split('\n').filter((l) => l.trim().length > 0);
  if (lines.length < 2) return [];

  const headers = lines[0].split(',').map((h) => h.trim().replace(/^"|"$/g, ''));
  const records: Record<string, string>[] = [];

  for (let i = 1; i < lines.length; i++) {
    const line = lines[i];
    const values: string[] = [];
    let insideQuotes = false;
    let curVal = '';

    for (let charIdx = 0; charIdx < line.length; charIdx++) {
      const char = line[charIdx];
      if (char === '"' && line[charIdx + 1] === '"') {
        curVal += '"';
        charIdx++;
      } else if (char === '"') {
        insideQuotes = !insideQuotes;
      } else if (char === ',' && !insideQuotes) {
        values.push(curVal);
        curVal = '';
      } else {
        curVal += char;
      }
    }
    values.push(curVal);

    const record: Record<string, string> = {};
    headers.forEach((h, idx) => {
      record[h] = values[idx] !== undefined ? values[idx].trim() : '';
    });
    records.push(record);
  }

  return records;
}

export async function importSyntheticCsvToPostgres(
  dbUrl: string = process.env.DATABASE_URL || process.env.DB_CONNECTION_STRING || 'postgres://app_user:SecurePass2025@127.0.0.1:5432/enterprise_ecom',
  csvDir: string = './data'
) {
  const absCsvDir = resolve(csvDir);
  const customersPath = resolve(absCsvDir, 'synthetic_customers.csv');
  const employeesPath = resolve(absCsvDir, 'synthetic_employees.csv');

  if (!existsSync(customersPath) || !existsSync(employeesPath)) {
    throw new Error(`CSV files not found in ${absCsvDir}. Run generate-synthetic-pii-csv.ts first.`);
  }

  console.log('====================================================================');
  console.log('🚀 DPDPOS Enterprise E-Commerce Data Importer');
  console.log(`🎯 Target Database: ${dbUrl.replace(/:[^:@]+@/, ':****@')}`);
  console.log(`📂 Source Directory: ${absCsvDir}`);
  console.log('====================================================================\n');

  const pool = new pg.Pool({ connectionString: dbUrl, connectionTimeoutMillis: 5000 });
  const client = await pool.connect();

  try {
    // 1. Initialize Tables
    console.log('1️⃣ Ensuring Schema & Foreign Keys Exist in PostgreSQL...');
    await client.query(`
      CREATE TABLE IF NOT EXISTS products (
        id VARCHAR(64) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        category VARCHAR(100) NOT NULL,
        price NUMERIC(10,2) NOT NULL,
        stock INTEGER NOT NULL,
        description TEXT NOT NULL,
        emoji VARCHAR(32) NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(64) PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        full_name VARCHAR(255) NOT NULL,
        phone VARCHAR(32) NOT NULL,
        aadhaar_no VARCHAR(32),
        pan_no VARCHAR(32),
        street_address TEXT,
        city VARCHAR(100),
        consent_purposes TEXT NOT NULL DEFAULT '["essential"]',
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS customer_credentials (
        user_id VARCHAR(64) PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
        password_hash VARCHAR(255) NOT NULL,
        salt VARCHAR(255) NOT NULL,
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS orders (
        id VARCHAR(64) PRIMARY KEY,
        user_id VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        items TEXT NOT NULL,
        total_amount NUMERIC(10,2) NOT NULL,
        shipping_address TEXT NOT NULL,
        status VARCHAR(64) NOT NULL DEFAULT 'CONFIRMED',
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS employees (
        id VARCHAR(64) PRIMARY KEY,
        full_name VARCHAR(255) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        department VARCHAR(100) NOT NULL,
        role VARCHAR(100) NOT NULL,
        salary NUMERIC(12,2) NOT NULL,
        pan_no VARCHAR(32) NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS admin_credentials (
        employee_id VARCHAR(64) PRIMARY KEY REFERENCES employees(id) ON DELETE CASCADE,
        password_hash VARCHAR(255) NOT NULL,
        salt VARCHAR(255) NOT NULL,
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );
    `);
    console.log('   ✅ Database schema initialized.');

    // 2. Seed Default Products (for Storefront & Admin Inventory)
    console.log('2️⃣ Seeding E-Commerce Product Catalog...');
    const catalog = [
      {
        id: 'prod_vase_01',
        title: 'Hand-thrown Terracotta Indigo Vase',
        category: 'Home & Living',
        price: 2499.00,
        stock: 25,
        description: 'Sculpted by master potters from Jaipur using organic earthen clay and natural botanical indigo glaze.',
        emoji: '🏺',
      },
      {
        id: 'prod_mug_02',
        title: 'Wabi-Sabi Ceramic Teaware (Set of 2)',
        category: 'Kitchen & Dining',
        price: 1499.00,
        stock: 40,
        description: 'Double-fired stoneware mugs featuring unique reactive glaze finishes. Microwave and dishwasher safe.',
        emoji: '🍵',
      },
      {
        id: 'prod_blanket_03',
        title: 'Pure Cashmere Organic Throw Blanket',
        category: 'Textiles & Apparel',
        price: 4999.00,
        stock: 18,
        description: 'Hand-loomed in the Himalayan valleys from ethically gathered grade-A mountain cashmere wool.',
        emoji: '🧣',
      },
      {
        id: 'prod_lamp_04',
        title: 'Hammered Brass Moroccan Table Lantern',
        category: 'Lighting & Decor',
        price: 3299.00,
        stock: 30,
        description: 'Intricately perforated brass casing creates warm, mesmerizing ambient geometric shadow projections.',
        emoji: '🏮',
      },
      {
        id: 'prod_incense_05',
        title: 'Handmade Mysore Sandalwood Incense & Burner',
        category: 'Aromatherapy',
        price: 899.00,
        stock: 50,
        description: 'Traditional temple-grade organic sandalwood rolled in aged vetiver root and natural tree resins.',
        emoji: '🪔',
      },
    ];

    for (const p of catalog) {
      await client.query(`
        INSERT INTO products (id, title, category, price, stock, description, emoji, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
        ON CONFLICT (id) DO UPDATE SET stock = EXCLUDED.stock, price = EXCLUDED.price
      `, [p.id, p.title, p.category, p.price, p.stock, p.description, p.emoji]);
    }
    console.log(`   ✅ Catalog ready (${catalog.length} artisan products in inventory).`);

    // 3. Seed Master Admin for Admin Portal
    console.log('3️⃣ Ensuring Master Store Manager Credentials for Admin Portal...');
    const adminEmpId = 'emp_admin_01';
    await client.query(`
      INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
      VALUES ($1, 'Rajesh Kumar (Store Manager)', 'admin@artisan-crafts.in', 'Operations', 'STORE_MANAGER', 85000, 'ABCDE1234F', NOW())
      ON CONFLICT (email) DO NOTHING
    `, [adminEmpId]);

    const adminSalt = randomBytes(16).toString('hex');
    const adminHash = createHash('sha256').update('Admin@2025' + adminSalt).digest('hex');
    await client.query(`
      INSERT INTO admin_credentials (employee_id, password_hash, salt, updated_at)
      VALUES ($1, $2, $3, NOW())
      ON CONFLICT (employee_id) DO NOTHING
    `, [adminEmpId, adminHash, adminSalt]);
    console.log('   ✅ Admin Portal Login: admin@artisan-crafts.in / Admin@2025');

    // 4. Import Customers from CSV
    console.log(`4️⃣ Importing Customers & Generating Login Credentials from ${customersPath}...`);
    const customerContent = readFileSync(customersPath, 'utf8');
    const customerRecords = parseCsv(customerContent);
    let importedUsers = 0;

    for (const c of customerRecords) {
      if (!c.email || !c.full_name) continue;

      const userId = c.id || `usr_${randomBytes(6).toString('hex')}`;
      const password = c.password || 'Customer@2025';

      await client.query(`
        INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        ON CONFLICT (email) DO UPDATE SET
          full_name = EXCLUDED.full_name,
          phone = EXCLUDED.phone,
          aadhaar_no = EXCLUDED.aadhaar_no,
          pan_no = EXCLUDED.pan_no
      `, [
        userId,
        c.email,
        c.full_name,
        c.phone || '',
        c.aadhaar_no || null,
        c.pan_no || null,
        c.street_address || null,
        c.city || null,
        c.consent_purposes || '["essential"]',
        c.created_at || new Date().toISOString()
      ]);

      const salt = randomBytes(16).toString('hex');
      const hash = createHash('sha256').update(password + salt).digest('hex');

      await client.query(`
        INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
        VALUES ($1, $2, $3, NOW())
        ON CONFLICT (user_id) DO UPDATE SET
          password_hash = EXCLUDED.password_hash,
          salt = EXCLUDED.salt,
          updated_at = NOW()
      `, [userId, hash, salt]);

      importedUsers++;
    }
    console.log(`   ✅ Successfully imported ${importedUsers} customers with active login credentials.`);

    // 5. Import Employees from CSV
    console.log(`5️⃣ Importing Employee Directory from ${employeesPath}...`);
    const employeeContent = readFileSync(employeesPath, 'utf8');
    const employeeRecords = parseCsv(employeeContent);
    let importedEmployees = 0;

    for (const e of employeeRecords) {
      if (!e.email || !e.full_name) continue;

      const empId = e.id || `emp_${randomBytes(5).toString('hex')}`;
      const salary = parseFloat(e.salary) || 50000;

      await client.query(`
        INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        ON CONFLICT (email) DO UPDATE SET
          full_name = EXCLUDED.full_name,
          department = EXCLUDED.department,
          role = EXCLUDED.role,
          salary = EXCLUDED.salary,
          pan_no = EXCLUDED.pan_no
      `, [
        empId,
        e.full_name,
        e.email,
        e.department || 'General',
        e.role || 'Staff',
        salary,
        e.pan_no || 'ABCDE1234F',
        e.created_at || new Date().toISOString()
      ]);

      importedEmployees++;
    }
    console.log(`   ✅ Successfully imported ${importedEmployees} employees to HR Directory.`);

    // 6. Print Summary
    const totalUsers = await client.query('SELECT COUNT(*) FROM users');
    const totalEmps = await client.query('SELECT COUNT(*) FROM employees');
    const totalProducts = await client.query('SELECT COUNT(*) FROM products');

    console.log('\n====================================================================');
    console.log('🎉 Enterprise Data Ingestion Complete!');
    console.log(`   👥 Total Customers in DB: ${totalUsers.rows[0].count} (All can sign into E-Com Storefront)`);
    console.log(`   👔 Total Employees in DB: ${totalEmps.rows[0].count} (Visible in Admin Portal Directory)`);
    console.log(`   📦 Total Products in DB:  ${totalProducts.rows[0].count} (Active in Inventory Catalog)`);
    console.log('====================================================================\n');
  } finally {
    client.release();
    await pool.end();
  }
}

if (process.argv[1] && process.argv[1].endsWith('import-synthetic-csv-to-postgres.ts')) {
  const dbUrl = process.env.DATABASE_URL || process.env.DB_CONNECTION_STRING || 'postgres://app_user:SecurePass2025@127.0.0.1:5432/enterprise_ecom';
  const csvDir = process.argv[2] || './data';

  importSyntheticCsvToPostgres(dbUrl, csvDir).catch((err) => {
    console.error('Fatal import error:', err);
    process.exit(1);
  });
}
