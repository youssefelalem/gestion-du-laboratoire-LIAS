import { useEffect, type ReactNode } from 'react';

interface ModalProps {
  open: boolean;
  onClose: () => void;
  children: ReactNode;
  width?: number;
}

export function Modal({ open, onClose, children, width = 560 }: ModalProps) {
  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div
      onClick={onClose}
      className="fixed inset-0 z-[1000] flex animate-fade items-center justify-center bg-[rgba(20,18,14,0.45)]"
    >
      <div
        onClick={(e) => e.stopPropagation()}
        className="max-h-[90vh] max-w-[92vw] animate-rise overflow-auto border border-line bg-surface shadow-[0_32px_60px_rgba(20,18,14,0.18)]"
        style={{ width }}
      >
        {children}
      </div>
    </div>
  );
}
