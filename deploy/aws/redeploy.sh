#!/usr/bin/env bash
# Run after pulling source. Rebuild the demo without deleting persistent state.
set -euo pipefail
directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repository=$(cd "$directory/../.." && pwd)
cd "$directory"
for tool in docker python3 curl flock; do command -v "$tool" >/dev/null; done
test -f .env || { echo 'Missing deploy/aws/.env; complete initial setup first' >&2; exit 1; }
test -f agent-bootstrap.env || { echo 'Missing agent-bootstrap.env; preserve or create the enrolled-agent environment file' >&2; exit 1; }
docker info >/dev/null
docker compose version
exec 9>.storefront-deploy.lock
flock -n 9 || { echo 'Another deployment is running' >&2; exit 1; }
marker='# Managed by deploy-storefront.sh'
if [[ -f compose.override.yml ]]; then
  IFS= read -r first_line < compose.override.yml
  [[ "$first_line" == "$marker" ]] || { echo 'Unmanaged compose.override.yml found; review it before updating' >&2; exit 1; }
fi
docker compose --profile public config --quiet
hostname=$(docker compose --profile public config --format json | python3 -c 'import json,sys; print(json.load(sys.stdin)["services"]["proxy"]["environment"]["DEMO_HOSTNAME"])')
compose=(docker compose)
public=false
if [[ -n "$hostname" && "$hostname" != localhost ]]; then
  [[ "$hostname" =~ ^[a-zA-Z0-9][a-zA-Z0-9.-]*$ ]] || { echo 'DEMO_HOSTNAME must be a bare hostname' >&2; exit 1; }
  compose+=(--profile public)
  public=true
elif [[ -n "$(docker compose --profile public ps -q proxy)" ]]; then
  echo 'The proxy is running but DEMO_HOSTNAME is missing; fix .env before updating' >&2
  exit 1
fi

release="manual-$(date -u +%Y%m%dT%H%M%SZ)-$$"
image="dfortress-demo-storefront:$release"
echo 'Building new images while the existing demo keeps running...'
# Build the app directly so a previous CI image tag cannot be overwritten.
docker build -t "$image" "$repository"
docker compose -f compose.yml build agent
docker compose -f compose.yml run --rm --no-deps --entrypoint sh agent \
  -c 'test -x /var/lib/d-fortress/installed/bin/dpdp' || {
    echo 'No installed agent release found. Finish initial installation/enrollment before using this updater.' >&2
    exit 1
  }
old_container=$(docker compose ps -q storefront)
if [[ -n "$old_container" ]]; then
  old_image=$(docker inspect --format '{{.Image}}' "$old_container")
  docker tag "$old_image" dfortress-demo-storefront:rollback
fi

status_file=$(mktemp)
trap 'rm -f "$status_file"' EXIT
on_error() {
  echo 'Update did not finish. Database and agent volumes were retained. Inspect: docker compose --profile public ps' >&2
  echo 'Fix the reported error, then run this script again. Do not use down -v.' >&2
}
trap on_error ERR
echo 'Stopping the agent and app before restarting PostgreSQL...'
"${compose[@]}" stop agent storefront
if [[ "$public" == true ]]; then "${compose[@]}" stop proxy; fi
"${compose[@]}" up -d --no-deps --no-build --force-recreate --wait --wait-timeout 180 postgres
"${compose[@]}" exec -T postgres psql -v ON_ERROR_STOP=1 -U ecom_owner -d ecommerce_demo \
  -c 'GRANT UPDATE ON public.users TO demo_zone_agent'
printf '%s\nservices:\n  storefront:\n    image: %s\n' "$marker" "$image" > compose.override.yml.tmp
mv compose.override.yml.tmp compose.override.yml
"${compose[@]}" up -d --no-deps --no-build --pull never --force-recreate --wait --wait-timeout 180 storefront
curl --fail --silent --show-error --retry 5 --retry-delay 2 --max-time 10 http://127.0.0.1:3300/api/health
"${compose[@]}" up -d --no-deps --no-build --force-recreate agent
ready=false
echo 'Waiting for the existing enrolled agent to become ready...'
for attempt in {1..30}; do
  if "${compose[@]}" exec -T agent /var/lib/d-fortress/installed/bin/dpdp agent status > "$status_file" 2>&1; then
    ready=true
    break
  fi
  sleep 2
done
cat "$status_file"
[[ "$ready" == true ]] || { echo 'Agent is not ready yet; inspect docker compose logs --tail=80 agent' >&2; exit 1; }
if [[ "$public" == true ]]; then
  "${compose[@]}" up -d --no-deps --no-build --force-recreate --wait --wait-timeout 180 proxy
  echo "Storefront: https://$hostname"
fi
"${compose[@]}" ps
echo "Demo restarted with new storefront image $image"
echo 'Database, API credentials, agent enrollment and execution journal were preserved.'
echo 'Rebuilding the agent wrapper does not upgrade its installed signed release.'
