#!/bin/sh
set -eu
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
  --set=app_password="$APP_DB_PASSWORD" --set=agent_password="$AGENT_DB_PASSWORD" <<'SQL'
CREATE ROLE ecom_app LOGIN PASSWORD :'app_password';
CREATE ROLE demo_zone_agent LOGIN PASSWORD :'agent_password';
ALTER SCHEMA public OWNER TO ecom_app;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO demo_zone_agent;
ALTER DEFAULT PRIVILEGES FOR ROLE ecom_app IN SCHEMA public GRANT SELECT ON TABLES TO demo_zone_agent;
SQL
