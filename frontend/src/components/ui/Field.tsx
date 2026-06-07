import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';

/** Classe partagée pour inputs / selects / textarea (style du prototype). */
export const fieldClass =
  'w-full rounded-[2px] border border-line bg-surface px-3 py-[9px] font-sans text-[13.5px] text-ink outline-none';

interface FormFieldProps {
  label: string;
  full?: boolean;
  children: ReactNode;
}

/** Libellé mono + champ. `full` => occupe toute la largeur d'une grille 2 colonnes. */
export function FormField({ label, full, children }: FormFieldProps) {
  return (
    <label className={cn('block', full && 'col-span-2')}>
      <div className="mb-1.5 font-mono text-[10.5px] uppercase tracking-[0.12em] text-muted">
        {label}
      </div>
      {children}
    </label>
  );
}
