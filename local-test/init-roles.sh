#!/bin/sh
set -eu
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
  --set=app_password="$APP_DB_PASSWORD" \
  --set=discovery_password="$DISCOVERY_DB_PASSWORD" \
  --set=erasure_password="$ERASURE_DB_PASSWORD" <<'SQL'
CREATE ROLE ecom_app LOGIN PASSWORD :'app_password';
CREATE ROLE ecom_discovery LOGIN PASSWORD :'discovery_password';
CREATE ROLE ecom_erasure LOGIN PASSWORD :'erasure_password';
ALTER SCHEMA public OWNER TO ecom_app;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO ecom_discovery, ecom_erasure;
ALTER DEFAULT PRIVILEGES FOR ROLE ecom_app IN SCHEMA public GRANT SELECT ON TABLES TO ecom_discovery;
ALTER DEFAULT PRIVILEGES FOR ROLE ecom_app IN SCHEMA public GRANT SELECT, UPDATE, DELETE ON TABLES TO ecom_erasure;
SQL
