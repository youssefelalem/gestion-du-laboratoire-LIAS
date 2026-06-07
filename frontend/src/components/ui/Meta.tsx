import type { ReactNode } from 'react';

interface MetaProps {
  k: string;
  v: ReactNode;
  muted?: boolean;
  mono?: boolean;
}

/** Paire libellé / valeur — utilisée dans les fiches (profils, adhésions…). */
export function Meta({ k, v, muted, mono }: MetaProps) {
  return (
    <div>
      <div className="font-mono text-[10.5px] uppercase tracking-[0.12em] text-muted">{k}</div>
      <div
        className={`mt-0.5 ${mono ? 'font-mono text-[13px]' : 'font-sans text-sm'} ${
          muted ? 'italic text-muted' : 'text-ink'
        }`}
      >
        {v}
      </div>
    </div>
  );
}
