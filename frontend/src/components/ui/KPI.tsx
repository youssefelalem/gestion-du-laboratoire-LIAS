import type { ReactNode } from 'react';

interface KPIProps {
  label: string;
  value: ReactNode;
  sub?: ReactNode;
  /** Couleur du liseré supérieur (ex. 'var(--navy)'). */
  accent?: string;
  children?: ReactNode;
}

export function KPI({ label, value, sub, accent, children }: KPIProps) {
  return (
    <div
      className="flex flex-col gap-1.5 border border-line bg-surface px-5 pb-4 pt-[18px]"
      style={accent ? { borderTop: `2px solid ${accent}` } : undefined}
    >
      <div className="font-sans text-[11px] font-medium uppercase tracking-[0.10em] text-muted">
        {label}
      </div>
      <div className="font-serif text-4xl font-medium leading-none text-ink [font-variant-numeric:tabular-nums]">
        {value}
      </div>
      {sub && <div className="font-sans text-xs text-muted">{sub}</div>}
      {children}
    </div>
  );
}
