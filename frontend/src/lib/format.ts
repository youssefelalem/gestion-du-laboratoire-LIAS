// ============================================================
// LIAS — helpers de formatage (dates FR)
// ============================================================

/** "14 mars 2003" — ou "—" si vide. */
export function fmtFR(iso?: string | null): string {
  if (!iso) return '—';
  return new Date(iso).toLocaleDateString('fr-FR', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  });
}

/** "mars 2003" — ou "en cours" si null (période ouverte). */
export function fmtMonthYearFR(iso?: string | null): string {
  if (!iso) return 'en cours';
  return new Date(iso).toLocaleDateString('fr-FR', {
    month: 'short',
    year: 'numeric',
  });
}

export function yearOf(iso: string): number {
  return new Date(iso).getFullYear();
}

export function daysBetween(a: string, b: string): number {
  return Math.round((new Date(b).getTime() - new Date(a).getTime()) / (1000 * 60 * 60 * 24));
}
