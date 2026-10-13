#!/usr/bin/env bash
# Replace only the storefront image using the server's existing configuration.
set -euo pipefail
if [[ $# != 4 ]]; then
  echo 'Usage: deploy-storefront.sh DEPLOY_DIRECTORY IMAGE_ARCHIVE COMMIT_SHA ARCHIVE_SHA256' >&2
  exit 2
fi
deployment=$1
archive=$2
revision=$3
digest=$4
[[ "$revision" =~ ^[0-9a-f]{40}$ && "$digest" =~ ^[0-9a-f]{64}$ ]] || exit 2
cd "$deployment"
test -f compose.yml
test -f .env
test -f agent-bootstrap.env
# Serialize manual and automated updates on this host as well as in Actions.
exec 9>.storefront-deploy.lock
flock -n 9 || { echo 'Another storefront deployment is running' >&2; exit 1; }
printf '%s  %s\n' "$digest" "$archive" | sha256sum -c -
docker compose config --quiet
container=$(docker compose ps -q storefront)
test -n "$container" || { echo 'Start the initial storefront deployment first' >&2; exit 1; }
old_image=$(docker inspect --format '{{.Image}}' "$container")
test -n "$old_image"
docker tag "$old_image" dfortress-demo-storefront:rollback

override=compose.override.yml
marker='# Managed by deploy-storefront.sh'
backup=$(mktemp)
had_override=false
if [[ -f "$override" ]]; then
  IFS= read -r first_line < "$override"
  [[ "$first_line" == "$marker" ]] || { echo 'Existing compose.override.yml is not managed by this deployer' >&2; rm -f "$backup"; exit 1; }
  cp "$override" "$backup"
  had_override=true
fi
switched=false
cleanup() { rm -f "$backup"; }
trap cleanup EXIT
write_override() {
  printf '%s\nservices:\n  storefront:\n    image: %s\n' "$marker" "$1" > "$override.tmp"
  mv "$override.tmp" "$override"
}
rollback() {
  trap - ERR INT TERM
  echo 'Storefront deployment failed; restoring the previous image' >&2
  if [[ "$had_override" == true ]]; then
    cp "$backup" "$override"
  else
    write_override dfortress-demo-storefront:rollback
  fi
  if ! docker compose up -d --no-deps --no-build --pull never --wait --wait-timeout 180 storefront; then
    echo 'Rollback could not become healthy; inspect the storefront logs' >&2
  fi
  exit 1
}
on_failure() {
  if [[ "$switched" == true ]]; then rollback; else exit 1; fi
}
trap on_failure ERR INT TERM
docker load -i "$archive"
docker image inspect "dfortress-demo-storefront:$revision" >/dev/null
switched=true
write_override "dfortress-demo-storefront:$revision"
docker compose config --quiet
docker compose up -d --no-deps --no-build --pull never --wait --wait-timeout 180 storefront
curl --fail --silent --show-error --retry 5 --retry-delay 2 --max-time 10 http://127.0.0.1:3300/api/health
printf '\nDeployed storefront revision %s\n' "$revision"
# PostgreSQL, agent, proxy, private env files and existing source stay in place.
