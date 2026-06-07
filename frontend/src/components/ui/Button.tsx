import type { ButtonHTMLAttributes, ReactNode } from 'react';
import { cn } from '@/lib/cn';

type Variant = 'primary' | 'ghost' | 'danger' | 'accept' | 'bare';
type Size = 'sm' | 'md' | 'lg';

const VARIANTS: Record<Variant, string> = {
  primary: 'bg-navy text-cream border-navy hover:opacity-90',
  ghost: 'bg-transparent text-ink border-line hover:bg-surface-2',
  danger: 'bg-transparent text-[#7A2A26] border-[#C7A09C] hover:bg-[#7A2A26] hover:text-cream',
  accept: 'bg-transparent text-[#33503A] border-[#A8C0A4] hover:bg-[#33503A] hover:text-cream',
  bare: 'bg-transparent text-ink border-transparent hover:bg-surface-2',
};

const SIZES: Record<Size, string> = {
  sm: 'px-2.5 py-1 text-xs',
  md: 'px-3.5 py-[7px] text-[13px]',
  lg: 'px-[18px] py-2.5 text-sm',
};

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  size?: Size;
  icon?: ReactNode;
}

export function Button({
  children,
  variant = 'ghost',
  size = 'md',
  icon,
  className,
  type = 'button',
  ...rest
}: ButtonProps) {
  return (
    <button
      type={type}
      className={cn(
        'inline-flex items-center justify-center gap-1.5 rounded-[2px] border font-sans font-medium tracking-[0.01em] transition-all duration-150 disabled:cursor-not-allowed disabled:opacity-40',
        VARIANTS[variant],
        SIZES[size],
        className,
      )}
      {...rest}
    >
      {icon}
      {children}
    </button>
  );
}
