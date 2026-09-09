/**
 * Enterprise Application & Zone Agent Configuration Resolver
 * Treats Compliance Platform as an external SaaS provider (Zero hardcoded internal DB access)
 */

export interface EnterpriseConfig {
  nodeEnv: string;
  appMode: 'all' | 'storefront' | 'worker' | 'admin';
  
  // Web Service
  port: number;
  adminPort: number;
  sessionSecret: string;
  
  // Database Configuration
  dbConnectionString: string;
  dbType: 'POSTGRES' | 'SQLITE';
  
  // External SaaS Compliance Provider (DPDP Control Plane)
  controlPlaneUrl: string;
  organizationId?: string;
  organizationSlug: string;
  
  // In-VPC Zone Agent Configuration
  agentId: string;
  agentName: string;
  agentPort: number;
  agentSecret: string;
  heartbeatIntervalMs: number;
  ddlCheckIntervalMs: number;
}

export function loadEnterpriseConfig(): EnterpriseConfig {
  const rawConnStr = 
    process.env.DATABASE_URL || 
    process.env.DB_CONNECTION_STRING || 
    './data/enterprise_data.sqlite';

  let dbType: 'POSTGRES' | 'SQLITE' = 'SQLITE';
  if (
    rawConnStr.startsWith('postgres://') || 
    rawConnStr.startsWith('postgresql://') || 
    process.env.DB_TYPE?.toUpperCase() === 'POSTGRES'
  ) {
    dbType = 'POSTGRES';
  }

  const mode = (process.env.APP_MODE?.toLowerCase() || 'all') as EnterpriseConfig['appMode'];

  return {
    nodeEnv: process.env.NODE_ENV || 'development',
    appMode: mode,
    port: parseInt(process.env.PORT || process.env.ECOM_PORT || '3000', 10),
    adminPort: parseInt(process.env.ADMIN_PORT || '3001', 10),
    sessionSecret: process.env.SESSION_SECRET || 'enterprise-secure-jwt-session-secret-2026',
    dbConnectionString: rawConnStr,
    dbType,
    controlPlaneUrl: (process.env.CONTROL_PLANE_URL || process.env.COMPLIANCE_SAAS_URL || 'http://127.0.0.1:4000').replace(/\/$/, ''),
    organizationId: process.env.ORGANIZATION_ID,
    organizationSlug: process.env.ORGANIZATION_SLUG || 'artisan-luxe-enterprise',
    agentId: process.env.AGENT_ID || 'agent-vpc-mumbai-01',
    agentName: process.env.AGENT_NAME || 'AWS-Mumbai-Zone-Agent',
    agentPort: parseInt(process.env.AGENT_PORT || '5000', 10),
    agentSecret: process.env.AGENT_SECRET || 'dpdp-zone-agent-secret-key-2026',
    heartbeatIntervalMs: parseInt(process.env.HEARTBEAT_INTERVAL_MS || '5000', 10),
    ddlCheckIntervalMs: parseInt(process.env.DDL_CHECK_INTERVAL_MS || '15000', 10),
  };
}
