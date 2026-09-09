import { createHmac, pbkdf2Sync, randomBytes } from 'node:crypto';

/**
 * Enterprise Auth & Password Cryptography
 * Uses standard Node.js crypto (PBKDF2 with SHA-512)
 */

export function hashPassword(password: string): string {
  const salt = randomBytes(16).toString('hex');
  const hash = pbkdf2Sync(password, salt, 10000, 64, 'sha512').toString('hex');
  return `${salt}:${hash}`;
}

export function verifyPassword(password: string, storedHash: string): boolean {
  if (!storedHash || !storedHash.includes(':')) return false;
  const [salt, originalHash] = storedHash.split(':');
  const hash = pbkdf2Sync(password, salt, 10000, 64, 'sha512').toString('hex');
  return hash === originalHash;
}

export interface SessionPayload {
  userId: string;
  email: string;
  fullName: string;
  role?: string;
  exp: number;
}

export function createSessionToken(payload: Omit<SessionPayload, 'exp'>, secret: string, expiresInHours = 24): string {
  const exp = Date.now() + expiresInHours * 3600 * 1000;
  const fullPayload: SessionPayload = { ...payload, exp };
  const encodedData = Buffer.from(JSON.stringify(fullPayload)).toString('base64url');
  const signature = createHmac('sha256', secret).update(encodedData).digest('base64url');
  return `${encodedData}.${signature}`;
}

export function verifySessionToken(token: string, secret: string): SessionPayload | null {
  if (!token || !token.includes('.')) return null;
  const [encodedData, signature] = token.split('.');
  
  const expectedSignature = createHmac('sha256', secret).update(encodedData).digest('base64url');
  if (signature !== expectedSignature) return null;

  try {
    const payload: SessionPayload = JSON.parse(Buffer.from(encodedData, 'base64url').toString('utf8'));
    if (Date.now() > payload.exp) {
      return null; // Expired
    }
    return payload;
  } catch {
    return null;
  }
}
