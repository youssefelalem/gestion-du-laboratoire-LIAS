import type { ReactNode } from 'react';

interface SectionHeadProps {
  eyebrow?: ReactNode;
  title: ReactNode;
  subtitle?: ReactNode;
  right?: ReactNode;
}

export function SectionHead({ eyebrow, title, subtitle, right }: SectionHeadProps) {
  return (
    <div className="mb-[18px] flex items-end justify-between gap-6 border-b border-line pb-3.5">
      <div>
        {eyebrow && (
          <div className="mb-1.5 font-mono text-[10.5px] uppercase tracking-[0.18em] text-muted">
            {eyebrow}
          </div>
        )}
        <h1 className="m-0 font-serif text-[30px] font-medium leading-[1.15] tracking-[-0.01em] text-ink">
          {title}
        </h1>
        {subtitle && (
          <p className="mt-1.5 max-w-[640px] font-sans text-[13.5px] text-muted">{subtitle}</p>
        )}
      </div>
      {right && <div className="flex gap-2">{right}</div>}
    </div>
  );
}
