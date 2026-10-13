# Simulator only: Vercel + Supabase + managed zone agent

The main D-fortress platform stays on its existing AWS deployment. This configuration moves only the ecommerce demo. No existing local/customer database is automatically uploaded.

## 1. Create a dedicated Supabase project

Create a new demo project, choose a region near the app/agent, and save its database password privately. Use the Connect dialog to get a direct or session-pooler PostgreSQL connection string. A session-pooler URL supports IPv4 hosts. The initial demo uses session mode for both Vercel and the persistent agent; Vercel uses a small local pool of two connections per function instance. Monitor total connections if traffic grows.

Use a PostgreSQL connection string, not the Supabase HTTPS project URL or anon/service-role API key. Keep sim_enterprise out of the Data API's exposed schemas. The frontend does not need a Supabase SDK or project key: its own authenticated backend handles database access.

## 2. Prepare schema locally, once

Commit/push the prepared source before importing the repository on Vercel. Locally, use Node 22 and a private environment file outside Git, containing:

```dotenv
DATABASE_URL=<Supabase admin PostgreSQL connection string>
DATABASE_SCHEMA=sim_enterprise
DATABASE_SSL=true
SIM_APP_DB_PASSWORD=<separate random URL-safe password, 32+ characters>
SIM_AGENT_DB_PASSWORD=<another random URL-safe password, 32+ characters>
```

Use the Supabase connection string exactly as shown for its mode. Percent-encode special characters in passwords. If certificate trust requires the project's CA, add DATABASE_SSL_CA with the PEM certificate (literal backslash-n line breaks are accepted). Do not disable certificate verification to work around a trust error.

An empty template is provided. From the simulator root, copy it and edit privately:

```sh
cp deploy/supabase/setup.env.example deploy/supabase/setup.env
chmod 600 deploy/supabase/setup.env
```

Do not overwrite an existing setup.env. Fill DATABASE_URL and the two role passwords in an editor. setup.env is ignored by Git. On Windows, use the equivalent private file permissions if chmod is unavailable.

Run from the simulator root:

```sh
npm ci
npm run build
node --env-file=deploy/supabase/setup.env deploy/supabase/migrate.mjs
node --env-file=deploy/supabase/setup.env deploy/supabase/prepare-roles.mjs
```

This creates/initializes sim_enterprise and the small seed fixture, revokes browser API roles' access, creates sim_app for application CRUD and sim_agent for discovery plus UPDATE on users. Neither runtime role gets schema creation or role administration. Agent DELETE is not granted. These scripts require project administrator credentials and must not run as Vercel build hooks. Rerunning role preparation changes their passwords to the values supplied; coordinate environment changes if rotating them. New tables introduced by later migrations need new reviewed grants.

The original customer authentication remains in place; this is not a Supabase Auth migration. New customer consent still goes through the existing D-fortress API integration. Seed fixture preferences are not automatically registered as live portal consent.

## 3. Deploy the app on Vercel

Import https://github.com/Abhishek-Chatterjee-git/sim-enterprise, select the pushed branch, and use the repo root. Choose framework Other and Node.js 22.x. vercel.json configures npm ci, npm run build, static public files, /privacy, and the serverless API adapter. There is no persistent npm start process.

Set these server-side environment variables:

```dotenv
NODE_ENV=production
DB_TYPE=POSTGRES
DATABASE_URL=<Supabase SESSION-pooler URL for sim_app>
DATABASE_SCHEMA=sim_enterprise
DATABASE_SSL=true
DATABASE_POOL_MAX=2
SESSION_SECRET=<persistent random value of at least 32 characters>
CONTROL_PLANE_URL=https://d-fortress.digitalfortress.in
ORGANIZATION_SLUG=artison-sons
COMPLIANCE_API_KEY_ID=<organization key ID>
COMPLIANCE_API_KEY_SECRET=<organization key secret>
AGENT_LOCAL_SYNC_ENABLED=false
```

For session pooling, custom role usernames normally take the form sim_app.<project-reference>; use the correct host/port/project reference from your Connect dialog. Use sim_app's password, not the admin password. Add DATABASE_SSL_CA if needed for verified TLS. COMPLIANCE_NOTICE_ID is optional and must be a real notice UUID if supplied.

Never use a public/browser environment prefix for these credentials. Keep preview deployments pointed at disposable demo data or limit their access; do not connect them to production data.

After deployment, open the Vercel HTTPS URL, /privacy, and /api/health. Verify that /api/products returns the seeded catalog. Deletion challenge bindings remain in PostgreSQL across separate invocations and cold starts. Runtime requests do not migrate or seed the database.

## 4. Run the agent as a separate managed worker

Vercel/Supabase functions do not host this continuous agent. Optional Render setup: create a Blueprint from this repo and select deploy/supabase/render-agent.yaml, NOT the root render.yaml (which also creates a Render database/storefront). Review worker and persistent-disk charges before creating it.

Set worker DATABASE_URL to Supabase's SESSION-pooler connection string for sim_agent.<project-reference>, using its dedicated password. DB_SCHEMA=sim_enterprise is essential: otherwise the scanner looks at public. The worker config persists its identity/journal and limits execution to five rows. Use a new enrollment rather than copying a live local/AWS agent identity.

Once the image is built and waiting for install environment, generate fresh Node.js install commands for artison-sons. Add INSTALLER_URL, INSTALLER_SHA256, VERIFIER_URL, VERIFIER_SHA256, RELEASE_MANIFEST_TOKEN, RELEASE_TARBALL_TOKEN, and AGENT_ENROLLMENT_TOKEN to the worker environment. Restart promptly within the download window. See ../render/README.md for the bootstrap field mapping only; its Render database setup does not apply here.

The agent verifies database TLS by default. Avoid sslmode=require or other SSL query parameters that override the driver's verification settings. If your release needs the Supabase CA, create a Render Secret File named supabase-ca.pem containing that public certificate and set DB_SSL_CA_FILE=/etc/secrets/supabase-ca.pem on the worker. The release must support non-public PostgreSQL schemas and verified database TLS. Verify actual discovery of sim_enterprise before proceeding; do not infer compatibility solely from container uptime.

After ACTIVE status and successful discovery, remove bootstrap secrets. Keep the disk, installed release, and one worker instance. AGENT_MTLS=off is the existing demo limitation; requiring platform client certificates waits for verified certificate issuance/renewal. ML-DSA-65 evidence signing is configured on the main D-fortress backend, not Supabase or Vercel.

## 5. Test the full path

Create a fresh customer using an inbox you control, grant and withdraw consent, request deletion, verify the emailed code, and approve a users.email soft-mask plan against the NEW Supabase agent/target. The connector schema is sim_enterprise; table discovery and erasure must resolve that schema. Verify the database changes and signed receipt. Related orders/payments are not erased by a users-only plan. Local cache enforcement is disabled and is not demonstrated by this architecture.

Live cloud deployment/connection tests require your project and configured worker. The checked-in code alone does not create cloud services or migrate existing personal data.

References: https://vercel.com/docs/functions/runtimes/node-js, https://supabase.com/docs/guides/database/connecting-to-postgres, and https://supabase.com/docs/guides/platform/ssl-enforcement.
