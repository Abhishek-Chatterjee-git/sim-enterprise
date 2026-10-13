# Storefront updates through GitHub Actions

The workflow `.github/workflows/storefront-deploy.yml` tests pull requests and deploys pushes to main. A manual run from main is also supported. GitHub builds the Docker image and transfers it over SSH. The server replaces only storefront, waits for its container health check and checks localhost:3300/api/health. A failed update attempts to restore the previous image. The single storefront container briefly stops during replacement; this is not a zero-downtime deployment.

The existing server deployment directory, Compose configuration, .env, database volume, agent installation/state, and Caddy stay on the server. The deployment does not git-pull or copy local source over that directory. Existing edits such as sslmode=disable remain in place. Runtime schema initialization still runs at application startup; an image rollback does not undo database schema/data changes. Review such changes before merging.

## One-time setup

Create a separate SSH key on your own computer, not in this repository:

```bash
ssh-keygen -t ed25519 -C github-storefront-deploy -f ~/.ssh/dfortress-storefront-cd -N ''
cat ~/.ssh/dfortress-storefront-cd.pub
```

In the server's existing root session, add ONLY that public key:

```bash
install -d -m 700 /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
nano /root/.ssh/authorized_keys
```

Add one line beginning `restrict ` followed by the public key. `restrict` disables forwarding and interactive PTYs while still permitting the commands/file transfer used here. Save without replacing existing keys. This key can execute commands as root: anyone able to modify the deploying main branch/workflow can control the demo host. Limit repository write access accordingly. A separate deploy user with reviewed privileges can be configured later.

From your computer, verify login before configuring Actions:

```bash
ssh -i ~/.ssh/dfortress-storefront-cd -o IdentitiesOnly=yes root@105.225.221.108 'docker compose version'
```

Read the server's public host key through the already trusted server session:

```bash
printf '105.225.221.108 '
cat /etc/ssh/ssh_host_ed25519_key.pub
```

The complete resulting line is the known-host entry. For a nonstandard port, the hostname prefix must be `[105.225.221.108]:PORT`. Keep strict host-key verification enabled in the workflow.

In GitHub → sim-enterprise → Settings → Secrets and variables → Actions, add repository secrets:

| Secret | Value |
| --- | --- |
| DEPLOY_SSH_KEY | Full contents of the private file `~/.ssh/dfortress-storefront-cd`, including BEGIN/END lines. Paste directly in GitHub, never into chat or Git. |
| DEPLOY_KNOWN_HOSTS | Full public host-key line from the trusted server session above. |

Add repository variables:

| Variable | Value for this demo |
| --- | --- |
| DEPLOY_HOST | 105.225.221.108 |
| DEPLOY_USER | root |
| DEPLOY_PORT | 22 |
| DEPLOY_PATH | /root/sim-enterprise/deploy/aws |

Docker/Compose, bash, curl, gzip, sha256sum and flock must be available on the x86_64 server. The original storefront must already be running. GitHub-hosted runners must be able to reach its SSH port; successful SSH from your own computer does not prove runner reachability. Keep the existing firewall policy and arrange an approved route if SSH is source-restricted. The workflow never uses the server login password or D-fortress API secrets.

## First run and everyday updates

Push/merge these workflow files to main after configuring the secrets. Open GitHub Actions → Storefront CI and deploy. You can select Run workflow on main for the first deployment. Afterward, merge a storefront change into main and watch its run. Verify https://test.digitalfortress.in and /privacy afterward; the automated health check tests the local app, not public DNS/CDN routing. Browser caching may require a refresh after a frontend update.

The server creates `compose.override.yml` with the pinned image tag. Compose automatically reads it with compose.yml, so normal service restarts preserve the deployed image. Do not run `docker compose build storefront` afterward: the host checkout is intentionally not updated by this workflow. Use CI to build/update it. An existing unmanaged compose.override.yml causes the deployer to stop rather than overwrite it.

For a manual rollback after a successful release, on the server:

```bash
cd /root/sim-enterprise/deploy/aws
printf '%s\n' '# Managed by deploy-storefront.sh' 'services:' '  storefront:' '    image: dfortress-demo-storefront:rollback' > compose.override.yml
docker compose up -d --no-deps --no-build --pull never --wait --wait-timeout 180 storefront
curl -fsS http://127.0.0.1:3300/api/health
```

The rollback tag is the image running before the latest deployment. Coordinate manual rollback with Actions; do not update the same service concurrently. Revert the corresponding commit on main before the next normal deployment to keep source and runtime aligned. Images accumulate on the server; inspect disk usage and remove older unused images deliberately while preserving the current and rollback images. No automatic volume or image pruning is performed.
