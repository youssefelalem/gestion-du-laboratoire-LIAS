import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';

interface ChipProps {
  children: ReactNode;
  active?: boolean;
  onClick?: () => void;
}

export function Chip({ children, active, onClick }: ChipProps) {
  return (
    <button
      onClick={onClick}
      className={cn(
        'rounded-full border px-2.5 py-1 font-sans text-[11.5px] font-medium tracking-[0.01em]',
        active
          ? 'border-navy bg-navy text-cream'
          : 'border-line bg-transparent text-ink hover:bg-surface-2',
      )}
    >
      {children}
    </button>
  );
}
