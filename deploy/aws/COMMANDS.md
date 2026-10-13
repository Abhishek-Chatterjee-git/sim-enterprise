# D-fortress AWS demo — SSH-to-deployment command runbook

Start at step 1 and run each section individually. This is not a single executable script.
Replace <...> placeholders. LOCAL means your computer; EC2 means the SSH session.
The main sequence ends with a public HTTPS storefront and verified enrolled agent. Maintenance and preparation details are in the appendices.
This assumes a separate Ubuntu demo instance, deployment permissions, and the prepared source pushed to your chosen Git branch. No AWS Console access is required for the server commands.
The instance administrator and DNS owner handle external networking/DNS prerequisites described in Appendix A.

## 1. LOCAL — SSH into EC2

On Linux, macOS, or WSL:

```bash
chmod 400 "<path-to-demo-key.pem>"
ssh -i "<path-to-demo-key.pem>" ubuntu@<EC2_PUBLIC_IP>
```

If you use PuTTY, use its configured key/session instead. Never put the private key in the repository or chat.

## 2. EC2 — inspect the server and permissions

First run these read-only checks:

```bash
whoami
cat /etc/os-release
uname -m
free -h
df -h /
sudo -l
command -v docker || true
command -v git || true
```

Continue with the apt commands only if this is Ubuntu and you have the needed sudo permissions.
If the server is Amazon Linux or another distribution, use its supported installation procedure instead.
If Docker is already installed, inspect its existing workloads before changing it:

```bash
sudo docker ps
sudo docker compose version
sudo ss -lntp
```

If sudo is unavailable, check whether your account already has Docker access with `docker info`.
If neither route is permitted, ask the instance administrator to install Docker/Compose and provide the necessary deployment access.
The following fresh-server commands assume an Ubuntu login named ubuntu. If your account is different, adapt the ownership and SSH username.

## 3. EC2 — install Docker and supporting tools

These commands follow Docker's official Ubuntu apt-repository installation:
https://docs.docker.com/engine/install/ubuntu/

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl git python3 nano dnsutils
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add the repository:

```bash
. /etc/os-release
DEMO_UBUNTU_SUITE="${UBUNTU_CODENAME:-$VERSION_CODENAME}"
DEMO_ARCH="$(dpkg --print-architecture)"
sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${DEMO_UBUNTU_SUITE}
Components: stable
Architectures: ${DEMO_ARCH}
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo docker version
sudo docker compose version
```

This runbook uses sudo for Docker, so no Docker-group logout/login is needed.
If this is not a fresh instance and Docker already exists, inspect it before replacing packages.

## 4. EC2 — clone the deployment repository

If the latest source has not been pushed, use a source bundle instead of cloning. From the local simulator repository, generate it:

```bash
python3 deploy/aws/package-source.py ../SIM_ENTERPRISE_AWS_DEPLOYMENT.tar.gz
scp -i "<path-to-demo-key.pem>" ../SIM_ENTERPRISE_AWS_DEPLOYMENT.tar.gz ubuntu@<EC2_PUBLIC_IP>:/tmp/
```

Then in the EC2 SSH session, extract into an empty deployment directory:

```bash
sudo install -d -m 0755 -o ubuntu -g ubuntu /opt/d-fortress-demo
test ! -e /opt/d-fortress-demo/sim-enterprise
tar -tzf /tmp/SIM_ENTERPRISE_AWS_DEPLOYMENT.tar.gz
tar -xzf /tmp/SIM_ENTERPRISE_AWS_DEPLOYMENT.tar.gz -C /opt/d-fortress-demo
cd /opt/d-fortress-demo/sim-enterprise/deploy/aws
```

Stop if the test command reports that the destination already exists; do not extract over a populated deployment. Check the uploaded archive's SHA-256 against the local bundle before extraction. The bundle deliberately excludes environment files, local customer data and enrolled agent identity. Skip the Git-clone commands below when using this option. A bundle deployment has no Git metadata, so use new bundles for subsequent updates and skip Git-only checks below.

```bash
sudo install -d -m 0755 -o ubuntu -g ubuntu /opt/d-fortress-demo
git clone --branch <PUSHED_BRANCH> https://github.com/Abhishek-Chatterjee-git/sim-enterprise.git /opt/d-fortress-demo/sim-enterprise
cd /opt/d-fortress-demo/sim-enterprise
git log -1 --oneline
test -f deploy/aws/compose.yml
test -f deploy/render/start-agent.mjs
cd deploy/aws
```

For a private repository, authenticate with your approved GitHub method. Do not embed a token in the clone URL.
If the folder already exists, inspect its status and update it instead of cloning over it:

```bash
cd /opt/d-fortress-demo/sim-enterprise
git status --short
git pull --ff-only
cd deploy/aws
```

## 5. EC2 — generate private environment files

```bash
python3 prepare-env.py
chmod 600 .env agent-bootstrap.env
nano .env
```

Set these existing fields in the editor:

```dotenv
COMPLIANCE_API_KEY_ID=<organization-key-ID>
COMPLIANCE_API_KEY_SECRET=<organization-key-secret>
COMPLIANCE_NOTICE_ID=
DEMO_HOSTNAME=
```

Leave the generated database passwords, session secret, and local agent token unchanged.
Leave the notice ID blank unless you have its real portal UUID. Leave the hostname blank until DNS is ready.
Do not source .env as a shell script or paste secrets into terminal command arguments.
The API key must belong to artison-sons and have consent:write, consent:read, and dsr:write for these tests.

Check file permissions and ignored status without printing secrets:

```bash
stat -c '%a %n' .env agent-bootstrap.env
git check-ignore .env agent-bootstrap.env
sudo docker compose config --quiet
```

Do not run plain `docker compose config` in shared logs: its expanded output includes credentials.

## 6. EC2 — build before generating short-lived agent tokens

```bash
sudo docker compose build storefront agent
sudo docker compose up -d --wait --wait-timeout 180 postgres storefront
sudo docker compose ps
curl -fsS http://127.0.0.1:3300/api/health
```

The database and small seed fixture are initialized automatically. This does not migrate your local customer database.
If startup fails:

```bash
sudo docker compose logs --tail=100 postgres storefront
```

Grant the agent UPDATE on users for the approved masking demo:

```bash
sudo docker compose exec -T postgres psql -U ecom_owner -d ecommerce_demo -c 'GRANT UPDATE ON public.users TO demo_zone_agent'
sudo docker compose exec -T postgres psql -U ecom_owner -d ecommerce_demo -c "SELECT has_table_privilege('demo_zone_agent','public.users','SELECT') AS can_discover, has_table_privilege('demo_zone_agent','public.users','UPDATE') AS can_mask, has_table_privilege('demo_zone_agent','public.users','DELETE') AS can_purge;"
```

Expected: can_discover=true, can_mask=true, can_purge=false.
The agent has no erasure UPDATE grants on other tables. Do not use a hard-purge plan with these permissions.

## 7. LOCAL — optionally inspect the storefront before getting a domain

Open another local terminal and keep this SSH tunnel running:

```bash
ssh -i "<path-to-demo-key.pem>" -N -L 3300:127.0.0.1:3300 ubuntu@<EC2_PUBLIC_IP>
```

Open http://localhost:3300 and http://localhost:3300/privacy in your browser.
If local port 3300 is already used, use `-L 3301:127.0.0.1:3300` and browse port 3301.
This is temporary administrator access; the audience will use HTTPS after step 11.

## 8. PORTAL + EC2 — install and enroll the zone agent

Only NOW generate fresh Node.js installation commands for artison-sons in D-fortress.
Use the Node installer with install.sh and verify-release.mjs, not the standalone-binary variant.

On EC2:

```bash
cd /opt/d-fortress-demo/sim-enterprise/deploy/aws
nano agent-bootstrap.env
```

Replace its contents with these fields, copying the matching values from the generated portal commands:

```dotenv
INSTALLER_URL=<full-install.sh-download-URL>
INSTALLER_SHA256=<install.sh-SHA256>
VERIFIER_URL=<full-verify-release.mjs-download-URL>
VERIFIER_SHA256=<verify-release.mjs-SHA256>
RELEASE_MANIFEST_TOKEN=<value-following---manifest-token>
RELEASE_TARBALL_TOKEN=<value-following---tarball-token>
AGENT_ENROLLMENT_TOKEN=<fresh-enrollment-token>
```

Use literal ENV_NAME=value lines, not export statements or the whole shell snippet.
Save and start promptly inside the ten-minute download window:

```bash
chmod 600 agent-bootstrap.env
sudo docker compose up -d agent
sudo docker compose logs --tail=100 agent
```

Follow logs if necessary; Ctrl+C exits the log viewer without stopping the agent:

```bash
sudo docker compose logs -f --tail=50 agent
```

If tokens expired or were consumed by another installation, regenerate the commands and update the file.
After changing the bootstrap file, recreate the container so it receives the new environment:

```bash
sudo docker compose up -d --force-recreate agent
```

Do not execute the published shell snippet separately on the host: that would consume the single-use links before the container uses them.

## 9. EC2 + PORTAL — check readiness and discovery

On EC2:

```bash
sudo docker compose exec -T agent /var/lib/d-fortress/installed/bin/dpdp agent status
sudo docker compose exec -T storefront node --input-type=module -e '
const response = await fetch("http://agent:5000/scan/trigger", {
  method: "POST",
  headers: { Authorization: "Bearer " + process.env.AGENT_LOCAL_API_TOKEN }
});
console.log("HTTP", response.status);
console.log(await response.text());
if (!response.ok) process.exitCode = 1;
'
```

In the portal, confirm AWS-Ecommerce-Demo is ACTIVE, heartbeat is current, and discovery belongs to the NEW AWS database.
Record the new agent UUID and target ID. Do not select the former local agent/target in the demo plan.
A running container alone is not proof that enrollment succeeded.

This demo still uses verified HTTPS plus enrolled credentials, with AGENT_MTLS=off.
Certificate issuance and local consent-cache enforcement are separate outstanding checks.

## 10. EC2 — remove temporary installation secrets after successful enrollment

Only after ACTIVE status and successful discovery:

```bash
printf '%s\n' '# Installed and enrolled; bootstrap secrets removed.' > agent-bootstrap.env
chmod 600 agent-bootstrap.env
sudo docker compose up -d --force-recreate agent
sudo docker compose exec -T agent /var/lib/d-fortress/installed/bin/dpdp agent status
```

The installed release, credentials, keys, and task journal remain on the persistent Docker volume.
Confirm the portal shows the SAME enrolled agent after this restart.

## 11. DNS administrator + EC2 — publish the HTTPS demo

Choose a hostname you control, such as shop.digitalfortress.in.
Ask the DNS administrator to create an A record pointing to the EC2 public IPv4 address; you do not need AWS Console access for this. If the address changes, the record must be updated.
Do not add an AAAA record unless IPv6 is configured. If using a DNS proxy, use DNS-only initially for diagnosis.

On EC2, edit only the hostname field:

```bash
nano .env
```

Set:

```dotenv
DEMO_HOSTNAME=<your-real-hostname>
```

Use the bare hostname: no https:// and no path.
Check DNS; its returned address must match the demo instance:

```bash
read -r -p "Demo hostname: " DEMO_HOSTNAME
dig +short A "$DEMO_HOSTNAME"
sudo ss -lntp
sudo docker compose --profile public up -d proxy
sudo docker compose logs --tail=100 proxy
curl -fsS "https://$DEMO_HOSTNAME/api/health"
```

Caddy obtains and renews the certificate. Ports 80/443 must be reachable.
If another process owns 80/443, resolve that conflict before starting the proxy.
Open https://<hostname> and https://<hostname>/privacy from another device.

## 12. BROWSER + PORTAL — run the actual demonstration

Returning to a pending account within six months also requires the main platform's /api/v1/public/dsr/withdraw update to be deployed. On return the customer must enter their existing password, accept notice version 2.1 again, and choose optional consents. The platform must confirm withdrawal before the simulator restores access. Approved/dispatched erasure tasks block automatic restoration; completed masking cannot be undone. Deploying this simulator alone does not activate the new platform endpoint.

1. Create a fresh account using an inbox you can access.
2. Grant/withdraw a purpose in the storefront and confirm the portal record.
3. Request deletion from /privacy and enter the emailed verification code.
4. In D-fortress, review the request and propose a users.email soft-delete/mask plan for the NEW AWS target.
5. Keep the approved row cap at or below five and use the required approval workflow.
6. Confirm agent execution, actual masked fields, affected-row count, and receipt evidence.
7. A users-only plan does not erase related orders/payments. The email stays unless included in the plan.
8. ML-DSA-65 evidence depends on the LIVE platform signer being ACTIVE; configuring this EC2 agent does not enable it.

Optional SQL verification on EC2, using the disposable customer's email interactively:

```bash
read -r -p "Disposable customer email: " DEMO_TEST_EMAIL
sudo docker compose exec -T postgres psql -U ecom_owner -d ecommerce_demo --set=test_email="$DEMO_TEST_EMAIL" <<'SQL'
SELECT status,
       full_name LIKE '[ERASED:%' AS name_masked,
       phone LIKE '[ERASED:%' AS phone_masked,
       password_hash LIKE '[ERASED:%' AS password_masked
FROM users WHERE email = :'test_email';
SQL
unset DEMO_TEST_EMAIL
```

This check assumes the selected columns use the tested mask-marker format. Compare all columns selected in your actual plan.
Do not print full customer rows into shared logs.

## 13. Deployment completion checklist

Deployment is complete when all these checks pass:

- The storefront health endpoint returns success through its public HTTPS hostname.
- The storefront and /privacy open from another device without your SSH tunnel.
- The NEW AWS agent is ACTIVE in D-fortress and discovery shows this demo database.
- Consent grant/withdrawal reaches the intended organization.
- A verified and approved disposable-customer erasure executes against the NEW AWS target.
- Temporary bootstrap secrets have been removed, and the agent keeps its identity after restart.

If public ports or DNS are not available yet, the SSH-tunnel setup is usable for private testing but the public deployment is still pending.
Local consent-cache enforcement and platform ML-DSA-65 signing must be assessed separately; this runbook does not enable those automatically.

## Appendix A — instance administrator and DNS prerequisites

Ask whoever supplies the instance to confirm these prerequisites. These are administrator tasks, not AWS Console steps for you:

- A separate demo EC2 instance; approximately 2 vCPUs / 4 GB RAM and 30 GB storage is the starting proposal.
- SSH address, username, and your approved login method. Do not share the private key.
- sudo privileges, or Docker/Compose preinstalled with permission to use them. Do not bypass restricted privileges.
- A publicly reachable, preferably stable address for the web demonstration.
- Security-group inbound TCP 80/443 for the public site and TCP 22 restricted to your administrative source.
- PostgreSQL 5432, storefront 3300, and agent 5000 remain closed to the public.
- Outbound access needed for package/image downloads, DNS, HTTPS certificate issuance, and the D-fortress portal.
- Someone able to add the demo hostname's DNS A record when you choose the hostname.

SSH access alone does not grant AWS API permissions. Do not assume you can change security groups or addresses using AWS CLI. The instance owner can do those changes separately. Until public access/DNS is ready, step 7 provides an SSH tunnel for private setup testing; that tunnel is not the audience's public URL.

## Appendix B — LOCAL Git preparation before the server clone

The repository is https://github.com/Abhishek-Chatterjee-git/sim-enterprise.
The AWS files and the earlier application integration changes must be on the branch you clone.

In the local simulator repository:

```bash
git status --short
git diff --stat
git branch --show-current
```

Review the changes. Stage the deployment files and select the intended tracked application changes:

```bash
git add -- deploy/aws .gitignore README.md
git add -p
git diff --cached --stat
git diff --cached --check
```

Confirm the intended build/API/privacy changes are included and no private environment files or credentials are staged.
Some existing Windows line endings can cause whitespace diagnostics; review those rather than discarding unrelated work.
Commit and push your selected changes:

```bash
git commit -m "Prepare isolated AWS ecommerce and zone-agent demo"
git push
```

If those changes are already committed and pushed, skip the commit. Note the branch you pushed for step 4.

## Appendix C — operational commands after deployment

Run from the deployment directory:

```bash
cd /opt/d-fortress-demo/sim-enterprise/deploy/aws
sudo docker compose --profile public ps
sudo docker compose logs --tail=100 storefront agent proxy
sudo docker compose restart storefront
sudo docker compose restart agent
sudo docker compose exec -T agent /var/lib/d-fortress/installed/bin/dpdp agent status
```

Updating source, after reviewing/pushing a known good commit:

```bash
git status --short
git pull --ff-only
sudo docker compose build storefront agent
sudo docker compose --profile public up -d
```

Image rebuilds do NOT upgrade the agent package pinned on its persistent disk. Agent release upgrades require a deliberate verified upgrade.
Do not change generated database passwords in .env after initialization without rotating the corresponding PostgreSQL roles.

Stop the demo without deleting its data:

```bash
sudo docker compose --profile public down
```

Start it again:

```bash
sudo docker compose --profile public up -d
```

Do not use `down -v`: it deletes the demo database and agent identity volumes.

## Appendix D — private backups before updates

Run while the demo is idle; stopping storefront/agent below briefly interrupts it:

```bash
cd /opt/d-fortress-demo/sim-enterprise/deploy/aws
DEMO_BACKUP_DIR="/opt/d-fortress-backups/$(date -u +%Y%m%dT%H%M%SZ)"
sudo install -d -m 0700 "$DEMO_BACKUP_DIR"
sudo docker compose stop storefront agent
set -o pipefail
sudo docker compose exec -T postgres pg_dump -U ecom_owner -d ecommerce_demo -Fc | sudo tee "$DEMO_BACKUP_DIR/database.dump" >/dev/null
DEMO_AGENT_CONTAINER="$(sudo docker compose ps -aq agent)"
sudo docker run --rm --volumes-from "${DEMO_AGENT_CONTAINER}:ro" -v "$DEMO_BACKUP_DIR:/backup" postgres:16-alpine tar -czf /backup/agent-state.tar.gz -C /var/lib/d-fortress .
sudo cp .env "$DEMO_BACKUP_DIR/storefront.env"
sudo cp agent-bootstrap.env "$DEMO_BACKUP_DIR/agent-bootstrap.env"
sudo chmod 600 "$DEMO_BACKUP_DIR/"*
sudo docker compose up -d storefront agent
```

Confirm each backup command succeeded before proceeding. The SQL dump and agent archive contain private data/credentials.
Copy backups to protected off-instance storage through your approved mechanism. Local backups do not survive loss of the EC2 storage.
Do not restore an agent identity onto another host while its original instance is still active.

## Appendix E — troubleshooting

- Missing deploy/aws files after clone: push the prepared files or clone the correct branch.
- Agent waiting for environment: bootstrap fields are missing; add fresh ones and recreate it.
- Download HTTP 401: regenerate single-use installation links.
- Agent fails enrollment with a certificate error: retain the documented off mode for this demo until platform issuance is fixed.
- Masking permission denied: confirm step 6 ran and the plan targets users soft-masking.
- HTTPS certificate failure: inspect A/AAAA records, EC2 security-group rules, and proxy logs.
- Portal consent delivery failed: check the organization key scopes, secret, server clock, and outbound HTTPS.
- Agent not ACTIVE: inspect worker logs and portal status; do not treat container uptime as readiness.
