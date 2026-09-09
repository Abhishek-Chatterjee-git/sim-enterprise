/**
 * External DPDP Compliance SaaS Client
 * Complete Isolation: Outbound HTTPS public webhook client with zero internal DB coupling.
 */

export interface SaasConsentRevocationPayload {
  dataSubjectIdentifier: string; // Customer Email or Phone
  purpose?: string;
  reason?: string;
  organizationId?: string;
  organizationSlug?: string;
}

export interface SaasConsentGrantPayload {
  dataSubjectIdentifier: string;
  purpose?: string;
  purposes?: string[];
  noticeId?: string;
  organizationId?: string;
  organizationSlug?: string;
}

export interface SaasDsrRequestPayload {
  requesterReference: string; // Customer Email or Phone
  requestType: 'ERASURE' | 'ACCESS' | 'CORRECTION' | 'PORTABILITY';
  description?: string;
  organizationId?: string;
  organizationSlug?: string;
}

export class ComplianceSaasClient {
  private controlPlaneUrl: string;
  private defaultOrgSlug: string;
  private defaultOrgId?: string;

  constructor(controlPlaneUrl: string, defaultOrgSlug = 'artisan-luxe-enterprise', defaultOrgId?: string) {
    this.controlPlaneUrl = controlPlaneUrl.replace(/\/$/, '');
    this.defaultOrgSlug = defaultOrgSlug;
    this.defaultOrgId = defaultOrgId;
  }

  /**
   * Notify External SaaS Compliance Platform when customer grants consent (e.g. during Signup / Settings)
   */
  async notifyConsentGrant(payload: SaasConsentGrantPayload): Promise<{ success: boolean; data?: any; error?: string }> {
    const url = `${this.controlPlaneUrl}/api/v1/public/consent/grant`;
    const body = {
      organizationSlug: payload.organizationSlug || this.defaultOrgSlug,
      organizationId: payload.organizationId || this.defaultOrgId,
      dataSubjectIdentifier: payload.dataSubjectIdentifier,
      purpose: payload.purpose || 'Personalized Recommendations & Order Fulfillment',
      purposes: payload.purposes || [payload.purpose || 'Personalized Recommendations & Order Fulfillment'],
      noticeId: payload.noticeId || 'DPDP-NOTICE-2025-V2.1',
    };

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Simulated-Enterprise-Storefront/1.0',
        },
        body: JSON.stringify(body),
        signal: AbortSignal.timeout(4000),
      });

      if (!response.ok) {
        // Try fallback legacy route if available
        const fallbackUrl = `${this.controlPlaneUrl}/api/consent/record`;
        const fbRes = await fetch(fallbackUrl, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            tenantId: this.defaultOrgSlug,
            principalId: payload.dataSubjectIdentifier,
            noticeVersion: '2.1',
            consentedPurposes: payload.purposes || [payload.purpose || 'essential'],
            channel: 'STOREFRONT_SIGNUP',
          }),
          signal: AbortSignal.timeout(3000),
        }).catch(() => null);

        if (fbRes && fbRes.ok) {
          const fbData = await fbRes.json();
          return { success: true, data: fbData };
        }

        const errText = await response.text().catch(() => 'Unknown error');
        console.warn(`[Compliance SaaS Client] Grant webhook returned ${response.status}: ${errText}`);
        return { success: false, error: errText };
      }

      const data = await response.json();
      console.log(`[Compliance SaaS Client] Consent grant recorded at SaaS for ${payload.dataSubjectIdentifier}`);
      return { success: true, data };
    } catch (err: any) {
      console.warn(`[Compliance SaaS Client] SaaS unreachable for consent grant: ${err.message}`);
      return { success: false, error: err.message };
    }
  }

  /**
   * Notify External SaaS Compliance Platform when customer revokes consent (e.g. unchecks marketing)
   */
  async notifyConsentRevocation(payload: SaasConsentRevocationPayload): Promise<{ success: boolean; data?: any; error?: string }> {
    const url = `${this.controlPlaneUrl}/api/v1/public/consent/revoke`;
    const body = {
      organizationSlug: payload.organizationSlug || this.defaultOrgSlug,
      organizationId: payload.organizationId || this.defaultOrgId,
      dataSubjectIdentifier: payload.dataSubjectIdentifier,
      purpose: payload.purpose || 'Personalized Recommendations & Marketing Communications',
      reason: payload.reason || 'Data Principal revoked consent via Self-Service Privacy Center',
    };

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Simulated-Enterprise-Storefront/1.0',
        },
        body: JSON.stringify(body),
        signal: AbortSignal.timeout(4000),
      });

      if (!response.ok) {
        // Fallback to legacy endpoint
        const fallbackUrl = `${this.controlPlaneUrl}/api/consent/record`;
        const fbRes = await fetch(fallbackUrl, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            tenantId: this.defaultOrgSlug,
            principalId: payload.dataSubjectIdentifier,
            noticeVersion: '2.1',
            consentedPurposes: ['essential'], // Removed marketing
            channel: 'PRIVACY_PORTAL',
          }),
          signal: AbortSignal.timeout(3000),
        }).catch(() => null);

        if (fbRes && fbRes.ok) {
          const fbData = await fbRes.json();
          return { success: true, data: fbData };
        }

        const errText = await response.text().catch(() => 'Unknown error');
        console.warn(`[Compliance SaaS Client] Revoke webhook returned ${response.status}: ${errText}`);
        return { success: false, error: errText };
      }

      const data = await response.json();
      console.log(`[Compliance SaaS Client] Consent revocation recorded at SaaS for ${payload.dataSubjectIdentifier}`);
      return { success: true, data };
    } catch (err: any) {
      console.warn(`[Compliance SaaS Client] SaaS unreachable for consent revocation: ${err.message}`);
      return { success: false, error: err.message };
    }
  }

  /**
   * Submit statutory DSR Erasure Request (DPDP Act §12 Right to Erasure / "Delete My Account")
   */
  async submitDsrErasure(payload: SaasDsrRequestPayload): Promise<{ success: boolean; data?: any; error?: string }> {
    const url = `${this.controlPlaneUrl}/api/v1/public/dsr`;
    const body = {
      organizationSlug: payload.organizationSlug || this.defaultOrgSlug,
      organizationId: payload.organizationId || this.defaultOrgId,
      requestType: payload.requestType,
      requesterReference: payload.requesterReference,
      description: payload.description || 'Data Principal requested account deletion under DPDP Act 2023 §12',
    };

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Simulated-Enterprise-Storefront/1.0',
        },
        body: JSON.stringify(body),
        signal: AbortSignal.timeout(4000),
      });

      if (!response.ok) {
        // Fallback to legacy DSR route
        const fallbackUrl = `${this.controlPlaneUrl}/api/dsr/request`;
        const fbRes = await fetch(fallbackUrl, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            tenantId: this.defaultOrgSlug,
            principalId: payload.requesterReference,
            requestType: 'ERASURE',
            requestedBy: 'CUSTOMER_PORTAL',
            gracePeriodDays: 30,
          }),
          signal: AbortSignal.timeout(3000),
        }).catch(() => null);

        if (fbRes && fbRes.ok) {
          const fbData = await fbRes.json();
          return { success: true, data: fbData };
        }

        const errText = await response.text().catch(() => 'Unknown error');
        console.warn(`[Compliance SaaS Client] Public DSR submission returned ${response.status}: ${errText}`);
        return { success: false, error: errText };
      }

      const data = await response.json();
      console.log(`[Compliance SaaS Client] DSR Erasure request ledgered at SaaS for ${payload.requesterReference}`);
      return { success: true, data };
    } catch (err: any) {
      console.warn(`[Compliance SaaS Client] SaaS unreachable for DSR submission: ${err.message}`);
      return { success: false, error: err.message };
    }
  }
}
