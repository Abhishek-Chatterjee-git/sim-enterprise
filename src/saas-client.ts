import { createHash, createHmac, randomUUID } from 'node:crypto';

export interface SaasConsentRevocationPayload {
  dataSubjectIdentifier: string;
  purpose?: string;
  reason?: string;
  organizationId?: string;
  organizationSlug?: string;
}
export interface SaasConsentGrantPayload extends SaasConsentRevocationPayload {
  purposes?: string[];
  noticeId?: string;
}
export interface SaasDsrRequestPayload {
  requesterReference: string;
  requestType: 'ERASURE' | 'ACCESS' | 'CORRECTION' | 'PORTABILITY';
  description?: string;
  organizationId?: string;
  organizationSlug?: string;
}
export interface SaasResult {
  success: boolean;
  data?: any;
  error?: string;
}

/** Current public API integration; secrets stay on the storefront server. */
export class ComplianceSaasClient {
  constructor(private controlPlaneUrl: string,
    private defaultOrgSlug = 'artisan-luxe-enterprise',
    private defaultOrgId?: string,
    private keyId = process.env.COMPLIANCE_API_KEY_ID,
    private secret = process.env.COMPLIANCE_API_KEY_SECRET,
    private noticeId = process.env.COMPLIANCE_NOTICE_ID) {
    this.controlPlaneUrl = controlPlaneUrl.replace(/\/$/, '');
  }

  private async post(path: string, payload: object, signed = true): Promise<SaasResult> {
    if (signed && (!this.keyId || !this.secret)) {
      return { success: false, error: 'Portal API credentials are not configured; the portal operation was not performed.' };
    }
    const url = new URL(this.controlPlaneUrl + path);
    if (url.protocol !== 'https:' && !['127.0.0.1','localhost','[::1]'].includes(url.hostname)) {
      return { success: false, error: 'The compliance endpoint must use HTTPS.' };
    }
    // Make repeated identical requests produce distinct signed request targets.
    url.searchParams.set('requestId', randomUUID());
    const body = JSON.stringify(payload);
    const headers: Record<string,string> = { 'Content-Type': 'application/json' };
    if (signed) {
      const timestamp = Math.floor(Date.now()/1000).toString();
      const digest = createHash('sha256').update(body).digest('hex');
      const canonical = `${timestamp}\nPOST\n${url.pathname}${url.search}\n${digest}`;
      headers['X-DPDPOS-Key-Id'] = this.keyId!;
      headers['X-DPDPOS-Timestamp'] = timestamp;
      headers['X-DPDPOS-Signature'] = createHmac('sha256',this.secret!).update(canonical).digest('hex');
    }
    try {
      const response = await fetch(url, { method:'POST', headers, body,
        redirect:'error', signal:AbortSignal.timeout(15000) });
      const envelope = await response.json() as any;
      if (!response.ok || envelope.success === false) {
        return { success:false, error: typeof envelope.error === 'string' ? envelope.error
          : envelope.error?.message || envelope.message || `Portal request failed (HTTP ${response.status}).` };
      }
      return { success:true, data:envelope.data ?? envelope };
    } catch {
      return { success:false, error:'The portal request could not be confirmed. Check connectivity and certificate trust before retrying.' };
    }
  }

  private organization(payload: {organizationId?:string; organizationSlug?:string}) {
    const id = payload.organizationId || this.defaultOrgId;
    if (id) return { organizationId:id };
    // The verified key selects its own organization. Console codes need not
    // match the public API's name-based slug selector.
    return this.keyId ? {} : { organizationSlug:payload.organizationSlug || this.defaultOrgSlug };
  }

  notifyConsentGrant(payload: SaasConsentGrantPayload): Promise<SaasResult> {
    const noticeId = payload.noticeId || this.noticeId;
    return this.post('/api/v1/public/consent/grant', {
      ...this.organization(payload), dataSubjectIdentifier:payload.dataSubjectIdentifier,
      purposes:payload.purposes || [payload.purpose || 'essential'],
      ...(noticeId ? {noticeId} : {}),
    });
  }
  notifyConsentRevocation(payload: SaasConsentRevocationPayload): Promise<SaasResult> {
    return this.post('/api/v1/public/consent/revoke', {
      ...this.organization(payload), dataSubjectIdentifier:payload.dataSubjectIdentifier,
      ...(payload.purpose ? {purpose:payload.purpose} : {}), reason:payload.reason,
    });
  }
  submitDsrErasure(payload: SaasDsrRequestPayload): Promise<SaasResult> {
    return this.post('/api/v1/public/dsr/start', {
      ...this.organization(payload), requesterEmail:payload.requesterReference,
      requestType:payload.requestType,
    });
  }
  verifyDsr(verificationId: string, code: string): Promise<SaasResult> {
    return this.post('/api/v1/public/dsr/verify', {verificationId,code}, false);
  }
  lookupConsent(dataSubjectIdentifier: string): Promise<SaasResult> {
    return this.post('/api/v1/public/consent/lookup', {dataSubjectIdentifier});
  }
  withdrawDsr(token: string, requesterEmail: string): Promise<SaasResult> {
    return this.post('/api/v1/public/dsr/withdraw', {token, requesterEmail});
  }
}
