# ARTISAN LUXE — Simulated Enterprise E-Commerce & DPDP In-VPC Zone Agent

An independent, production-ready enterprise e-commerce application with a dedicated **DPDP Act 2025 Customer Privacy Center** and an autonomous **In-VPC Zone Agent Daemon**, designed for direct deployment on **Render**, **Docker**, or **VMs/Kubernetes**.

---

## 🏛️ 1. Architecture & Isolation Guarantee

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                   EXTERNAL DPDP COMPLIANCE CONTROL PLANE (SAAS)                  │
│  - Central DPO Telemetry, Schema Catalog & Immutable Audit Ledger                │
│  - Zero raw customer personal data ever stored here                              │
└───────────────────────────────▲───────────────────────────────▲──────────────────┘
                                │                               │
                     Outbound HTTPS Webhooks            Outbound HTTPS Polling
                     (POST /public/consent/revoke)      (POST /agents/heartbeat)
                                │                               │
┌───────────────────────────────┼───────────────────────────────┼──────────────────┐
│ ENTERPRISE VPC / RENDER PRIVATE NETWORK                       │                  │
│                               │                               │                  │
│  ┌────────────────────────────┴──────────┐   ┌────────────────┴───────────────┐  │
│  │    E-COMMERCE STOREFRONT & BACKEND    │   │      IN-VPC ZONE AGENT DAEMON   │  │
│  │           (Port 3000 / Web)           │   │      (Port 5000 / Background)  │  │
│  │ • Customer Signup, Login & Catalog    │   │ • Inspects schema in RAM       │  │
│  │ • DPDP Granular Notice (v2.1)         │   │ • Verhoeff & Luhn PII detector │  │
│  │ • Self-Service Privacy Center         │   │ • DDL Hash schema drift watch  │  │
│  │ • Live Promotional Gating Bench       │   │ • Sub-ms hot-path consent cache│  │
│  │ • DSR §12 Right to Erasure Workflow   │   │ • Local atomic DSR SQL masking │  │
│  └───────────────────────┬───────────────┘   └────────────────┬───────────────┘  │
│                          │                                    │                  │
│                          │  Internal TCP 5432 / PostgreSQL    │                  │
│                          ▼                                    ▼                  │
│  ┌────────────────────────────────────────────────────────────────────────────┐  │
│  │                ENTERPRISE POSTGRESQL DATABASE (enterprise_db)              │  │
│  │  Tables: users, orders, order_items, payments, customer_reviews,           │  │
│  │          consent_preferences, products, audit_logs                         │  │
│  └────────────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────────────┘
```

### Complete Isolation Guarantee:
- **Zero Inbound Ingress**: The enterprise database has zero open firewall ports to the external internet or SaaS platform.
- **Zero Internal Backdoors**: The storefront and agent treat the DPDP Compliance Control Plane strictly as an external SaaS compliance provider over standard HTTPS endpoints.
- **Zero Raw PII Egress**: All PII detection and DSR erasure execution occurs inside the enterprise boundary in local memory; only anonymized schema metadata and cryptographic execution receipts leave the VPC.

---

## 🚀 2. Deploying to Render

You can deploy the entire enterprise stack on Render using the included Blueprint (`render.yaml`) or manually via the Render Dashboard.

### Option A: 1-Click Render Blueprint (Recommended)
1. Fork or push this repository to GitHub/GitLab.
2. Log in to [Render Dashboard](https://dashboard.render.com).
3. Click **New +** → **Blueprint**.
4. Connect your repository and select `sim-enterprise/ecom-app/render.yaml`.
5. Render will automatically provision:
   - **PostgreSQL Database** (`enterprise_db`)
   - **Web Service** (`sim-enterprise-storefront` on Port 3000)
   - **Background Worker** (`sim-enterprise-zone-agent`)
6. Update the `CONTROL_PLANE_URL` environment variable to point to your deployed DPDP SaaS instance.
7. Click **Apply**.

---

### Option B: Manual Setup on Render

#### Step 1: Create PostgreSQL Database
1. Go to **New +** → **PostgreSQL**.
2. **Name**: `enterprise-postgres`
3. **Database**: `enterprise_db`
4. **User**: `app_user`
5. **Region**: `Singapore` (or region closest to your users)
6. Copy the **Internal Database URL**.

#### Step 2: Create Storefront Web Service
1. Go to **New +** → **Web Service**.
2. Connect your Git repository.
3. **Environment**: `Node`
4. **Build Command**: `npm ci && npm run build:shared && npm run build:ecom`
5. **Start Command**: `npm --workspace=sim-enterprise/ecom-app run start:web`
6. Add Environment Variables:
   | Variable | Value |
   |---|---|
   | `NODE_ENV` | `production` |
   | `APP_MODE` | `storefront` |
   | `DB_TYPE` | `POSTGRES` |
   | `DATABASE_URL` | *Paste Internal Database URL from Step 1* |
   | `CONTROL_PLANE_URL` | `https://your-compliance-saas.onrender.com` |
   | `ORGANIZATION_SLUG` | `artisan-luxe-enterprise` |
   | `SESSION_SECRET` | *Click Generate* |

#### Step 3: Create In-VPC Zone Agent Background Worker
1. Go to **New +** → **Background Worker**.
2. Connect your Git repository.
3. **Environment**: `Node`
4. **Build Command**: `npm ci && npm run build:shared && npm run build:ecom`
5. **Start Command**: `npm --workspace=sim-enterprise/ecom-app run start:worker`
6. Add Environment Variables:
   | Variable | Value |
   |---|---|
   | `NODE_ENV` | `production` |
   | `APP_MODE` | `worker` |
   | `DB_TYPE` | `POSTGRES` |
   | `DATABASE_URL` | *Paste Internal Database URL from Step 1* |
   | `CONTROL_PLANE_URL` | `https://your-compliance-saas.onrender.com` |
   | `ORGANIZATION_SLUG` | `artisan-luxe-enterprise` |
   | `AGENT_ID` | `agent-render-mumbai-01` |
   | `AGENT_NAME` | `Render-InVPC-Zone-Agent` |

---

## 🐳 3. Docker & Local Compose Deployment

To run the complete isolated enterprise stack locally with PostgreSQL:

```bash
# 1. Navigate to the enterprise folder
cd sim-enterprise/ecom-app

# 2. Start PostgreSQL, Storefront, and In-VPC Zone Agent
docker compose up --build
```

Access:
- 🛍️ **Customer Storefront**: `http://localhost:3000`
- 🔒 **Customer Privacy Center**: `http://localhost:3000/privacy`
- 🛡️ **In-VPC Zone Agent Daemon**: `http://localhost:5000/health`

---

## 💻 4. Local Development (Zero-Dependency SQLite Mode)

For instant local testing without Docker or PostgreSQL:

```bash
# From workspace root:
npm install

# Run all test suites
npm run test:ecom

# Start all enterprise components in monolithic development mode
npm run start:ecom
```

---

## 📊 5. Database Schema & Pre-Populated Dataset

The application initializes the relational schema automatically on startup and seeds realistic Indian customer profiles, products, orders, payments, reviews, and audit logs:

| Table Name | Description | Key Columns |
|---|---|---|
| `users` | Customer personal profiles | `id`, `full_name`, `email`, `phone`, `password_hash`, `aadhaar_no`, `pan_no`, `address`, `city`, `state`, `pincode`, `status` |
| `orders` | Customer purchases | `id`, `user_id`, `order_number`, `total_amount`, `currency`, `status`, `shipping_address`, `payment_method` |
| `order_items` | Line items for orders | `id`, `order_id`, `product_name`, `sku`, `quantity`, `unit_price`, `total_price` |
| `payments` | Transaction records | `id`, `order_id`, `user_id`, `transaction_id`, `payment_gateway`, `amount`, `currency`, `status`, `upi_id`, `card_last_four` |
| `customer_reviews` | Product feedback | `id`, `user_id`, `product_name`, `rating`, `review_text` |
| `consent_preferences`| Granular DPDP consents | `id`, `user_id`, `purpose_id`, `is_granted`, `notice_version`, `updated_at` |
| `products` | Luxury artisan catalog | `id`, `name`, `sku`, `category`, `price`, `rating`, `image`, `stock`, `description` |
| `audit_logs` | Tamper-evident security trail | `id`, `action`, `user_id`, `ip_address`, `user_agent`, `details`, `created_at` |

---

## 🛡️ 6. DPDP Act 2025 Compliance Features

### 1. Granular DPDP Notice (v2.1)
- **Essential Processing**: Order delivery, GST invoicing, warranty redressal (Mandatory).
- **Personalized Recommendations**: SMS/Email marketing (Optional Opt-In).
- **Behavioral Analytics**: Anonymous telemetry for website optimization (Optional Opt-In).

### 2. Edge Agent Hot-Path Consent Enforcement
- Enterprise microservices query the local Zone Agent (`GET /consent/check?principalId=...&purpose=marketing`) in $< 1\text{ms}$.
- If consent is revoked in the Privacy Center, promotional campaign dispatches are instantly rejected with `403 Forbidden`.

### 3. DPDP Act §12 Right to Erasure
- Customers can exercise "Delete My Account" directly from the Privacy Center.
- Triggers local in-DB PII masking, revokes active processing consents, schedules a 30-day statutory recovery grace period, and generates a tamper-evident SHA-384 + HMAC cryptographic execution receipt.

---

## 🔌 7. Storefront REST API Summary

| Endpoint | Method | Description |
|---|---|---|
| `/api/auth/signup` | `POST` | Registers customer with DPDP granular consent notice |
| `/api/auth/login` | `POST` | Authenticates customer & returns session token |
| `/api/auth/me` | `GET` | Fetches authenticated customer profile & active consents |
| `/api/products` | `GET` | Lists artisanal product catalog |
| `/api/orders` | `POST` | Creates order, order items, and payment transaction |
| `/api/orders` | `GET` | Retrieves past orders for authenticated user |
| `/api/privacy/status` | `GET` | Fetches active consent states, notice version, and DSR status |
| `/api/privacy/consent/update` | `POST` | Grants/revokes specific consent & calls outbound SaaS webhook |
| `/api/privacy/dsr/erasure` | `POST` | Initiates DPDP §12 Right to Erasure / Account Deletion |
| `/api/privacy/dsr/reactivate` | `POST` | Restores account during 30-day grace period |
| `/api/marketing/dispatch-promo` | `POST` | Live DPDP test bench simulating promotional campaign gating |
