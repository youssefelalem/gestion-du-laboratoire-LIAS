import type { ReactNode } from 'react';

interface IconBtnProps {
  children: ReactNode;
  title?: string;
  onClick?: () => void;
}

export function IconBtn({ children, title, onClick }: IconBtnProps) {
  return (
    <button
      title={title}
      onClick={onClick}
      className="flex h-7 w-7 items-center justify-center border border-line bg-transparent font-mono text-[13px] text-ink hover:bg-surface-2"
    >
      {children}
    </button>
  );
}
