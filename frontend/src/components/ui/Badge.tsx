import type { ReactNode } from 'react';
import { cn } from '@/lib/cn';

export type BadgeTone = 'neutral' | 'navy' | 'gold' | 'burgundy' | 'sage' | 'muted';

const TONES: Record<BadgeTone, string> = {
  neutral: 'bg-surface-2 text-ink border-line',
  navy: 'bg-[rgba(27,47,74,0.06)] text-[#1B2F4A] border-[rgba(27,47,74,0.18)]',
  gold: 'bg-[rgba(176,136,56,0.10)] text-[#7A5B2E] border-[rgba(176,136,56,0.32)]',
  burgundy: 'bg-[rgba(132,42,38,0.07)] text-[#7A2A26] border-[rgba(132,42,38,0.28)]',
  sage: 'bg-[rgba(70,108,80,0.08)] text-[#33503A] border-[rgba(70,108,80,0.28)]',
  muted: 'bg-transparent text-muted border-line',
};

interface BadgeProps {
  children: ReactNode;
  tone?: BadgeTone;
  variant?: 'soft' | 'outline';
  className?: string;
}

export function Badge({ children, tone = 'neutral', variant = 'soft', className }: BadgeProps) {
  return (
    <span
      className={cn(
        'inline-flex items-center gap-1.5 whitespace-nowrap rounded-full border px-2 py-0.5 font-sans text-[11.5px] font-medium tracking-[0.02em]',
        TONES[tone],
        variant === 'outline' && 'bg-transparent',
        className,
      )}
    >
      {children}
    </span>
  );
}
