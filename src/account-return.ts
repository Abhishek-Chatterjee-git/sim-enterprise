/** Six calendar months, clamping month-end dates rather than overflowing. */
export function returnDeadline(requestedAt: number): number {
  const date = new Date(requestedAt);
  const day = date.getUTCDate();
  date.setUTCDate(1);
  date.setUTCMonth(date.getUTCMonth() + 6);
  const lastDay = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + 1, 0)).getUTCDate();
  date.setUTCDate(Math.min(day, lastDay));
  return date.getTime();
}

export const RETURN_NOTICE_VERSION = '2.1';
