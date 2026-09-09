import { createHash, randomBytes } from 'node:crypto';
import { existsSync, mkdirSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { DatabaseSync } from 'node:sqlite';
import pg from 'pg';
import { generateVerhoeffCheckDigit } from '@dpdp/shared';
import { hashPassword } from './auth.js';

export interface DbQueryResult<T = any> {
  rows: T[];
  rowCount: number;
}

/**
 * Enterprise Relational Database Layer
 * Supports PostgreSQL (Render/Cloud/Docker) with SQLite fallback for local demo.
 */
export class EnterpriseDatabase {
  private dbPathOrUri: string;
  private isPg: boolean = false;
  private pgPool: pg.Pool | null = null;
  private sqliteDb: DatabaseSync | null = null;
  private initialized: boolean = false;

  constructor(dbPathOrUri = './data/enterprise_data.sqlite') {
    this.dbPathOrUri = dbPathOrUri;
    if (
      this.dbPathOrUri.startsWith('postgres://') ||
      this.dbPathOrUri.startsWith('postgresql://') ||
      process.env.DB_TYPE?.toUpperCase() === 'POSTGRES'
    ) {
      this.isPg = true;
    }
  }

  isPostgres(): boolean {
    return this.isPg;
  }

  getPool(): pg.Pool | null {
    return this.pgPool;
  }

  getDb(): DatabaseSync | null {
    return this.sqliteDb;
  }

  async init(): Promise<void> {
    if (this.initialized) return;

    if (this.isPg) {
      const isCloud = this.dbPathOrUri.includes('render.com') || this.dbPathOrUri.includes('sslmode=require');
      this.pgPool = new pg.Pool({
        connectionString: this.dbPathOrUri,
        ssl: isCloud ? { rejectUnauthorized: false } : undefined,
        max: 10,
        idleTimeoutMillis: 10000,
        connectionTimeoutMillis: 5000,
      });

      const client = await this.pgPool.connect();
      try {
        await client.query('SELECT 1');
      } finally {
        client.release();
      }

      await this.initPostgresSchema();
      await this.seedData();
    } else {
      if (this.dbPathOrUri !== ':memory:') {
        const fullPath = resolve(this.dbPathOrUri);
        const dir = dirname(fullPath);
        if (dir && !existsSync(dir)) {
          mkdirSync(dir, { recursive: true });
        }
        this.sqliteDb = new DatabaseSync(fullPath);
      } else {
        this.sqliteDb = new DatabaseSync(':memory:');
      }
      this.sqliteDb.exec('PRAGMA journal_mode = WAL;');
      await this.initSqliteSchema();
      await this.seedData();
    }

    this.initialized = true;
    console.log(`[Enterprise DB] Connected and initialized using ${this.isPg ? 'PostgreSQL' : 'SQLite'}`);
  }

  private async initPostgresSchema(): Promise<void> {
    const ddl = `
      CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(64) PRIMARY KEY,
        full_name VARCHAR(255) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        phone VARCHAR(32) NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        aadhaar_no VARCHAR(32),
        pan_no VARCHAR(32),
        address TEXT,
        city VARCHAR(100),
        state VARCHAR(100),
        pincode VARCHAR(20),
        status VARCHAR(32) DEFAULT 'ACTIVE',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS orders (
        id VARCHAR(64) PRIMARY KEY,
        user_id VARCHAR(64) REFERENCES users(id),
        order_number VARCHAR(64) UNIQUE NOT NULL,
        total_amount NUMERIC(10, 2) NOT NULL,
        currency VARCHAR(8) DEFAULT 'INR',
        status VARCHAR(32) DEFAULT 'CONFIRMED',
        shipping_address TEXT,
        payment_method VARCHAR(64),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS order_items (
        id VARCHAR(64) PRIMARY KEY,
        order_id VARCHAR(64) REFERENCES orders(id),
        product_name VARCHAR(255) NOT NULL,
        sku VARCHAR(64) NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price NUMERIC(10, 2) NOT NULL,
        total_price NUMERIC(10, 2) NOT NULL
      );

      CREATE TABLE IF NOT EXISTS payments (
        id VARCHAR(64) PRIMARY KEY,
        order_id VARCHAR(64) REFERENCES orders(id),
        user_id VARCHAR(64) REFERENCES users(id),
        transaction_id VARCHAR(128) UNIQUE NOT NULL,
        payment_gateway VARCHAR(64) DEFAULT 'Razorpay',
        amount NUMERIC(10, 2) NOT NULL,
        currency VARCHAR(8) DEFAULT 'INR',
        status VARCHAR(32) DEFAULT 'SUCCESS',
        upi_id VARCHAR(128),
        card_last_four VARCHAR(8),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS customer_reviews (
        id VARCHAR(64) PRIMARY KEY,
        user_id VARCHAR(64) REFERENCES users(id),
        product_name VARCHAR(255) NOT NULL,
        rating INTEGER NOT NULL,
        review_text TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS audit_logs (
        id VARCHAR(64) PRIMARY KEY,
        action VARCHAR(128) NOT NULL,
        user_id VARCHAR(64),
        ip_address VARCHAR(64),
        user_agent VARCHAR(255),
        details TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS products (
        id VARCHAR(64) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        sku VARCHAR(64) UNIQUE NOT NULL,
        category VARCHAR(128) NOT NULL,
        price NUMERIC(10, 2) NOT NULL,
        rating NUMERIC(3, 1) DEFAULT 4.8,
        image VARCHAR(512),
        stock INTEGER DEFAULT 50,
        description TEXT
      );

      CREATE TABLE IF NOT EXISTS consent_preferences (
        id VARCHAR(64) PRIMARY KEY,
        user_id VARCHAR(64) REFERENCES users(id),
        purpose_id VARCHAR(128) NOT NULL,
        is_granted BOOLEAN DEFAULT FALSE,
        notice_version VARCHAR(32) DEFAULT '2.1',
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(user_id, purpose_id)
      );
    `;
    await this.pgPool!.query(ddl);
  }

  private async initSqliteSchema(): Promise<void> {
    const ddl = `
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT NOT NULL,
        password_hash TEXT NOT NULL,
        aadhaar_no TEXT,
        pan_no TEXT,
        address TEXT,
        city TEXT,
        state TEXT,
        pincode TEXT,
        status TEXT DEFAULT 'ACTIVE',
        created_at TEXT DEFAULT (datetime('now')),
        updated_at TEXT DEFAULT (datetime('now'))
      );

      CREATE TABLE IF NOT EXISTS orders (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        order_number TEXT UNIQUE NOT NULL,
        total_amount REAL NOT NULL,
        currency TEXT DEFAULT 'INR',
        status TEXT DEFAULT 'CONFIRMED',
        shipping_address TEXT,
        payment_method TEXT,
        created_at TEXT DEFAULT (datetime('now')),
        updated_at TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (user_id) REFERENCES users(id)
      );

      CREATE TABLE IF NOT EXISTS order_items (
        id TEXT PRIMARY KEY,
        order_id TEXT,
        product_name TEXT NOT NULL,
        sku TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders(id)
      );

      CREATE TABLE IF NOT EXISTS payments (
        id TEXT PRIMARY KEY,
        order_id TEXT,
        user_id TEXT,
        transaction_id TEXT UNIQUE NOT NULL,
        payment_gateway TEXT DEFAULT 'Razorpay',
        amount REAL NOT NULL,
        currency TEXT DEFAULT 'INR',
        status TEXT DEFAULT 'SUCCESS',
        upi_id TEXT,
        card_last_four TEXT,
        created_at TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (order_id) REFERENCES orders(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      );

      CREATE TABLE IF NOT EXISTS customer_reviews (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        product_name TEXT NOT NULL,
        rating INTEGER NOT NULL,
        review_text TEXT,
        created_at TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (user_id) REFERENCES users(id)
      );

      CREATE TABLE IF NOT EXISTS audit_logs (
        id TEXT PRIMARY KEY,
        action TEXT NOT NULL,
        user_id TEXT,
        ip_address TEXT,
        user_agent TEXT,
        details TEXT,
        created_at TEXT DEFAULT (datetime('now'))
      );

      CREATE TABLE IF NOT EXISTS products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        sku TEXT UNIQUE NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        rating REAL DEFAULT 4.8,
        image TEXT,
        stock INTEGER DEFAULT 50,
        description TEXT
      );

      CREATE TABLE IF NOT EXISTS consent_preferences (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        purpose_id TEXT NOT NULL,
        is_granted INTEGER DEFAULT 0,
        notice_version TEXT DEFAULT '2.1',
        updated_at TEXT DEFAULT (datetime('now')),
        UNIQUE(user_id, purpose_id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      );
    `;
    this.sqliteDb!.exec(ddl);
  }

  async seedData(): Promise<void> {
    // Check if products already seeded
    const existingProd = await this.get<{ count: number | string }>('SELECT COUNT(*) as count FROM products');
    if (Number(existingProd?.count || 0) > 0) {
      return;
    }

    console.log('[Enterprise DB] Seeding initial catalog and realistic Indian customer dataset...');

    // 1. Products
    const products = [
      {
        id: 'prod-01',
        name: 'Handcrafted Kashmiri Pashmina Shawl',
        sku: 'LUXE-KASH-001',
        category: 'Heritage Textiles',
        price: 18500,
        rating: 4.9,
        image: 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=800&auto=format&fit=crop&q=80',
        stock: 15,
        description: 'Authentic 100% Changthangi goat wool hand-spun in Srinagar. Pure luxury and timeless elegance.',
      },
      {
        id: 'prod-02',
        name: 'Organic Darjeeling First Flush (Estate Reserve)',
        sku: 'GOUR-DARJ-002',
        category: 'Gourmet Teas',
        price: 2400,
        rating: 4.8,
        image: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=800&auto=format&fit=crop&q=80',
        stock: 60,
        description: 'Single-estate loose leaf tea harvested at dawn from the misty Himalayan foothills of Darjeeling.',
      },
      {
        id: 'prod-03',
        name: 'Pure Mysore Sandalwood Essential Extract (50ml)',
        sku: 'WELL-SAND-003',
        category: 'Ayurvedic Wellness',
        price: 5200,
        rating: 5.0,
        image: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=800&auto=format&fit=crop&q=80',
        stock: 30,
        description: 'Steam-distilled from mature Santalum album heartwood. Deeply grounding therapeutic aroma.',
      },
      {
        id: 'prod-04',
        name: 'Jaipur Hand-Painted Cobalt Blue Pottery Vase',
        sku: 'DECO-JAIP-004',
        category: 'Artisan Decor',
        price: 3800,
        rating: 4.7,
        image: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800&auto=format&fit=crop&q=80',
        stock: 22,
        description: 'Crafted using quartz stone and natural copper oxide pigments by master craftsmen in Jaipur.',
      },
      {
        id: 'prod-05',
        name: 'Heritage Brass Mayur Hanging Diya (Set of 2)',
        sku: 'DECO-DIYA-005',
        category: 'Artisan Decor',
        price: 4600,
        rating: 4.9,
        image: 'https://images.unsplash.com/photo-1605371924599-2d0365da1ae0?w=800&auto=format&fit=crop&q=80',
        stock: 18,
        description: 'Lost-wax cast solid brass peacock lamps crafted in Thanjavur. Traditional handcrafted finish.',
      },
      {
        id: 'prod-06',
        name: 'Raw Single-Origin Malabar Forest Honey (500g)',
        sku: 'GOUR-HONY-006',
        category: 'Gourmet Teas',
        price: 1250,
        rating: 4.8,
        image: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=800&auto=format&fit=crop&q=80',
        stock: 45,
        description: 'Wild-harvested, unpasteurized forest honey from the Nilgiri biosphere reserve.',
      },
    ];

    for (const p of products) {
      await this.run(
        `INSERT INTO products (id, name, sku, category, price, rating, image, stock, description)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
        [p.id, p.name, p.sku, p.category, p.price, p.rating, p.image, p.stock, p.description]
      );
    }

    // 2. Realistic Indian Customer Seed Profiles
    const defaultPasswordHash = hashPassword('CustomerPass2026!');

    const rawA1 = '36759832415';
    const rawA2 = '45829103847';
    const rawA3 = '51823746501';

    const users = [
      {
        id: 'usr-mumbai-101',
        full_name: 'Rohit Sharma',
        email: 'rohit.sharma@example.com',
        phone: '+919820123456',
        aadhaar_no: `${rawA1}${generateVerhoeffCheckDigit(rawA1)}`,
        pan_no: 'ABCDE1234F',
        address: 'Flat 14B, Sea Breeze Apartments, Worli Sea Face',
        city: 'Mumbai',
        state: 'Maharashtra',
        pincode: '400018',
        status: 'ACTIVE',
      },
      {
        id: 'usr-blr-102',
        full_name: 'Pooja Venkatesh',
        email: 'pooja.venkatesh@example.com',
        phone: '+919845012345',
        aadhaar_no: `${rawA2}${generateVerhoeffCheckDigit(rawA2)}`,
        pan_no: 'BNZPK8472M',
        address: '42 Orchid Villa, 100ft Road, Indiranagar',
        city: 'Bengaluru',
        state: 'Karnataka',
        pincode: '560038',
        status: 'ACTIVE',
      },
      {
        id: 'usr-del-103',
        full_name: 'Aarav Choudhury',
        email: 'aarav.choudhury@example.com',
        phone: '+919811234567',
        aadhaar_no: `${rawA3}${generateVerhoeffCheckDigit(rawA3)}`,
        pan_no: 'CPDAR9102L',
        address: '88 Golf Links, Ground Floor',
        city: 'New Delhi',
        state: 'Delhi',
        pincode: '110003',
        status: 'ACTIVE',
      },
    ];

    for (const u of users) {
      await this.run(
        `INSERT INTO users (id, full_name, email, phone, password_hash, aadhaar_no, pan_no, address, city, state, pincode, status)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)`,
        [u.id, u.full_name, u.email, u.phone, defaultPasswordHash, u.aadhaar_no, u.pan_no, u.address, u.city, u.state, u.pincode, u.status]
      );

      // Seed default active consents
      await this.run(
        `INSERT INTO consent_preferences (id, user_id, purpose_id, is_granted, notice_version)
         VALUES ($1, $2, $3, $4, $5)`,
        [`cp-${u.id}-ess`, u.id, 'essential', this.isPg ? true : 1, '2.1']
      );
      await this.run(
        `INSERT INTO consent_preferences (id, user_id, purpose_id, is_granted, notice_version)
         VALUES ($1, $2, $3, $4, $5)`,
        [`cp-${u.id}-mkt`, u.id, 'marketing', this.isPg ? true : 1, '2.1']
      );
      await this.run(
        `INSERT INTO consent_preferences (id, user_id, purpose_id, is_granted, notice_version)
         VALUES ($1, $2, $3, $4, $5)`,
        [`cp-${u.id}-anl`, u.id, 'analytics', this.isPg ? true : 1, '2.1']
      );
    }

    // 3. Orders, Order Items, Payments & Reviews
    const orders = [
      {
        id: 'ord-1001',
        user_id: 'usr-mumbai-101',
        order_number: 'ART-2026-8941',
        total_amount: 20900,
        currency: 'INR',
        status: 'DELIVERED',
        shipping_address: 'Flat 14B, Sea Breeze Apartments, Worli Sea Face, Mumbai 400018',
        payment_method: 'UPI (rohit.sharma@okhdfcbank)',
        items: [
          { id: 'item-101', product_name: 'Handcrafted Kashmiri Pashmina Shawl', sku: 'LUXE-KASH-001', quantity: 1, unit_price: 18500, total_price: 18500 },
          { id: 'item-102', product_name: 'Organic Darjeeling First Flush (Estate Reserve)', sku: 'GOUR-DARJ-002', quantity: 1, unit_price: 2400, total_price: 2400 },
        ],
        payment: {
          id: 'pay-2001',
          transaction_id: 'txn_rzp_99482710492',
          payment_gateway: 'Razorpay',
          amount: 20900,
          currency: 'INR',
          status: 'SUCCESS',
          upi_id: 'rohit.sharma@okhdfcbank',
        },
      },
      {
        id: 'ord-1002',
        user_id: 'usr-blr-102',
        order_number: 'ART-2026-9102',
        total_amount: 5200,
        currency: 'INR',
        status: 'SHIPPED',
        shipping_address: '42 Orchid Villa, 100ft Road, Indiranagar, Bengaluru 560038',
        payment_method: 'Credit Card (ending in 4242)',
        items: [
          { id: 'item-201', product_name: 'Pure Mysore Sandalwood Essential Extract (50ml)', sku: 'WELL-SAND-003', quantity: 1, unit_price: 5200, total_price: 5200 },
        ],
        payment: {
          id: 'pay-2002',
          transaction_id: 'txn_rzp_77410294821',
          payment_gateway: 'Razorpay',
          amount: 5200,
          currency: 'INR',
          status: 'SUCCESS',
          card_last_four: '4242',
        },
      },
    ];

    for (const o of orders) {
      await this.run(
        `INSERT INTO orders (id, user_id, order_number, total_amount, currency, status, shipping_address, payment_method)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
        [o.id, o.user_id, o.order_number, o.total_amount, o.currency, o.status, o.shipping_address, o.payment_method]
      );

      for (const itm of o.items) {
        await this.run(
          `INSERT INTO order_items (id, order_id, product_name, sku, quantity, unit_price, total_price)
           VALUES ($1, $2, $3, $4, $5, $6, $7)`,
          [itm.id, o.id, itm.product_name, itm.sku, itm.quantity, itm.unit_price, itm.total_price]
        );
      }

      await this.run(
        `INSERT INTO payments (id, order_id, user_id, transaction_id, payment_gateway, amount, currency, status, upi_id, card_last_four)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
        [
          o.payment.id,
          o.id,
          o.user_id,
          o.payment.transaction_id,
          o.payment.payment_gateway,
          o.payment.amount,
          o.payment.currency,
          o.payment.status,
          o.payment.upi_id || null,
          o.payment.card_last_four || null,
        ]
      );
    }

    // 4. Customer Reviews
    await this.run(
      `INSERT INTO customer_reviews (id, user_id, product_name, rating, review_text)
       VALUES ($1, $2, $3, $4, $5)`,
      ['rev-01', 'usr-mumbai-101', 'Handcrafted Kashmiri Pashmina Shawl', 5, 'Exquisite softness and weave quality. Delivered in a beautiful mulberry gift box.']
    );
    await this.run(
      `INSERT INTO customer_reviews (id, user_id, product_name, rating, review_text)
       VALUES ($1, $2, $3, $4, $5)`,
      ['rev-02', 'usr-blr-102', 'Pure Mysore Sandalwood Essential Extract (50ml)', 5, 'Authentic fragrance, lasts all day. Highly recommended for meditation.']
    );

    // 5. Initial Audit Logs
    await this.run(
      `INSERT INTO audit_logs (id, action, user_id, ip_address, user_agent, details)
       VALUES ($1, $2, $3, $4, $5, $6)`,
      ['log-01', 'SYSTEM_INITIALIZATION', 'SYSTEM', '127.0.0.1', 'Enterprise-Seeder/1.0', 'Enterprise database seeded with Indian e-commerce catalog and customer profiles']
    );
  }

  // Cross-DB Query Helper: Translates $1, $2 -> ? for SQLite
  private formatSql(sql: string): string {
    if (this.isPg) return sql;
    return sql.replace(/\$(\d+)/g, '?');
  }

  async query<T = any>(sql: string, params: any[] = []): Promise<DbQueryResult<T>> {
    if (this.isPg) {
      const res = await this.pgPool!.query(sql, params);
      return { rows: res.rows, rowCount: res.rowCount || 0 };
    } else {
      const formatted = this.formatSql(sql);
      const isSelect = /^\s*(SELECT|PRAGMA)/i.test(formatted);
      const stmt = this.sqliteDb!.prepare(formatted);
      if (isSelect) {
        const rows = stmt.all(...params) as unknown as T[];
        return { rows, rowCount: rows.length };
      } else {
        const info = stmt.run(...params) as { changes: number | bigint };
        return { rows: [], rowCount: Number(info.changes) };
      }
    }
  }

  async all<T = any>(sql: string, params: any[] = []): Promise<T[]> {
    const res = await this.query<T>(sql, params);
    return res.rows;
  }

  async get<T = any>(sql: string, params: any[] = []): Promise<T | null> {
    const res = await this.query<T>(sql, params);
    return res.rows[0] || null;
  }

  async run(sql: string, params: any[] = []): Promise<{ rowCount: number }> {
    const res = await this.query(sql, params);
    return { rowCount: res.rowCount };
  }

  async exec(sql: string): Promise<void> {
    if (this.isPg) {
      await this.pgPool!.query(sql);
    } else {
      this.sqliteDb!.exec(sql);
    }
  }

  async close(): Promise<void> {
    if (this.pgPool) {
      await this.pgPool.end();
      this.pgPool = null;
    }
    if (this.sqliteDb) {
      try {
        this.sqliteDb.close();
      } catch {}
      this.sqliteDb = null;
    }
    this.initialized = false;
  }
}
