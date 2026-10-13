# Separate EC2 demo deployment

Follow [COMMANDS.md](COMMANDS.md) for the complete command-by-command setup, agent enrollment, HTTPS, verification, and backup runbook.

For automatic storefront updates after deployment, follow [CICD.md](CICD.md). GitHub Actions builds the image and updates only the storefront; the existing server configuration and agent/database volumes remain in place.

For a manual update after pulling new source, run this from the simulator repository root:

```sh
bash deploy/aws/redeploy.sh
```

The script builds before stopping services, then restarts PostgreSQL, storefront, the already installed agent, and Caddy when DEMO_HOSTNAME is configured. It preserves private environment files and all named volumes, handles the managed CI image override, restores the agent users UPDATE grant, and checks storefront health and agent readiness. Use it after initial installation/enrollment, while no demo deletion task is being executed. The update briefly interrupts the demo. An error stops the script with diagnostics; it does not automatically roll back the entire stack or database changes. The agent's installed signed release stays pinned; no new installation tokens are required.

The current pending-account return flow requires the main D-fortress backend's signed /api/v1/public/dsr/withdraw endpoint. Deploy and verify that backend change before demonstrating return within six months. The simulator requires the existing password and fresh privacy acceptance, and refuses restoration if the portal cannot confirm withdrawal or erasure has already been dispatched. This does not restore masked passwords/data. Ordinary consent and erasure demonstrations do not require using the return flow.

This deployment runs ecommerce, demo PostgreSQL, and the enrolled zone agent on a separate EC2 instance. It does not use the D-fortress application database. Docker volumes preserve state across container restarts/redeployments; protect the underlying EBS storage and take backups. Terminating an instance may delete its attached storage depending on its settings.

## Prepare AWS

Create an x86_64 Ubuntu EC2 instance with enough memory for two Node processes, PostgreSQL, and image builds. A starting demo allocation is 2 vCPUs, 4 GB RAM, and 30 GB encrypted EBS; monitor it and resize if needed. This is a sizing proposal, not a capacity guarantee or pricing quote. Install Docker Engine and the Docker Compose plugin using the official Ubuntu instructions. Enable Docker at boot.

Use a stable public address for DNS. Allow HTTP/HTTPS inbound (80/443), and restrict SSH (22) to your administrative source. Do not expose PostgreSQL, storefront port 3300, or agent port 5000. Permit outbound HTTPS/DNS for the control plane, release installation, images, and certificate issuance.

Clone the simulator repository once the prepared source changes are pushed. Do not copy the local customer database or enrolled agent identity into this new deployment. Use a dedicated disposable demo organization/key if available; the default configured organization is artison-sons.

## Start without a domain

From the repository root:

```sh
cd deploy/aws
python3 prepare-env.py
```

Edit the generated private .env and set COMPLIANCE_API_KEY_ID and COMPLIANCE_API_KEY_SECRET. Purpose/notice configuration must match the portal; set COMPLIANCE_NOTICE_ID only when you have its real UUID. The generator creates URL-safe random database passwords and does not overwrite existing files. These files are ignored by Git; preserve them securely. Changing the env passwords after the database has initialized does not rotate PostgreSQL roles automatically.

```sh
docker compose build
docker compose up -d postgres storefront
docker compose ps
curl -fsS http://127.0.0.1:3300/api/health
```

Wait for storefront health. The demo schema and small seed fixture are created on first start. The larger local CSV dataset is not automatically imported. Grant only users masking access to the agent:

```sh
docker compose exec -T postgres psql -U ecom_owner -d ecommerce_demo -c 'GRANT UPDATE ON public.users TO demo_zone_agent'
```

The agent has SELECT privileges for discovery and UPDATE on users; it cannot hard-purge or modify other tables. Broader erasure needs an explicitly reviewed plan and grants.

Before DNS is ready, you can inspect the storefront through an SSH tunnel from your computer:

```sh
ssh -L 3300:127.0.0.1:3300 ubuntu@<EC2-address>
```

Then open http://localhost:3300 on that computer. This is setup access, not the public audience URL.

## Install the agent after building

Generate fresh Node.js install commands in the portal. Put the following values in agent-bootstrap.env using ENV_NAME=value lines; never paste the whole shell snippet:

```dotenv
INSTALLER_URL=<full install.sh download URL>
INSTALLER_SHA256=<install.sh SHA-256>
VERIFIER_URL=<full verify-release.mjs download URL>
VERIFIER_SHA256=<verify-release.mjs SHA-256>
RELEASE_MANIFEST_TOKEN=<manifest token>
RELEASE_TARBALL_TOKEN=<tarball token>
AGENT_ENROLLMENT_TOKEN=<fresh enrollment token>
```

Start within the ten-minute download window:

```sh
docker compose up -d agent
docker compose logs --tail=80 agent
```

The shared bootstrap image verifies the release, installs it on the agent_state volume, and runs the foreground agent. After the portal shows ACTIVE and discovery succeeds, remove bootstrap secrets and recreate the agent container with `docker compose up -d --force-recreate agent`. Its persistent credentials and installed release are reused.

Keep one agent instance. AGENT_DATA_DIR is /var/lib/d-fortress/data. Do not use DATA_DIR, remove its volume, or copy its identity to another active host. The install is pinned; image rebuilds do not upgrade the release on disk.

The setup keeps AGENT_MTLS=off, matching the previous successful HTTPS/bearer demo. Platform certificate issuance remains unverified. Change to required only once that path works. The agent's local API is authenticated and reachable only inside the Docker network. Local consent synchronization is deliberately disabled until cache hydration/recovery and actual processing enforcement are verified.

The agent database URL explicitly uses sslmode=disable because the bundled PostgreSQL container has no TLS listener and is reachable only inside the same Docker network. This does not disable HTTPS to the control plane. Do not reuse this setting for a remote or publicly reachable database; configure verified database TLS there.

## Publish HTTPS

Use a subdomain of a domain you control, for example shop.digitalfortress.in; there is no requirement to purchase a separate domain. Point its A record to the demo EC2 public address. Set DEMO_HOSTNAME in .env to the bare hostname (no https:// or path). Remove any AAAA record unless IPv6 routing is configured. Once DNS resolves and ports 80/443 are reachable:

```sh
docker compose --profile public up -d proxy
docker compose logs --tail=80 proxy
```

Caddy requests and renews the HTTPS certificate. Open https://<hostname> and /privacy. Do not enable the public profile with the localhost fallback. If another proxy already uses these ports, adapt the configuration instead of replacing that proxy.

## Demonstrate and maintain

Create a new customer using an inbox you can access. Verify consent records in the portal, start deletion, enter the emailed code, and approve a users.email soft-mask plan targeting this new AWS agent/database. Keep the approved row cap at or below five. Verify actual masking, receipt fields, and the persisted identity after a restart. A users-only plan does not erase related orders/payments, and ML-DSA-65 evidence depends on live backend signing configuration.

Back up PostgreSQL and the agent state privately. `docker compose down` preserves named volumes; do not use `down -v` on a populated demo. Store backups off the instance and protect credentials. This is a single-host demo, not a high-availability production deployment. RDS is an alternative if managed database operations are required later.

References: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/security-group-rules-reference.html and https://docs.docker.com/engine/install/ubuntu/.
