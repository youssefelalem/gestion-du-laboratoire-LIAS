import type { CSSProperties, ReactNode } from 'react';
import { cn } from '@/lib/cn';

interface CardProps {
  children: ReactNode;
  padded?: boolean;
  className?: string;
  style?: CSSProperties;
}

export function Card({ children, padded = true, className, style }: CardProps) {
  return (
    <div className={cn('border border-line bg-surface', padded && 'p-5', className)} style={style}>
      {children}
    </div>
  );
}
