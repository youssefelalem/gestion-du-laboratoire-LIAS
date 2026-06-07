import { useNavigate } from 'react-router-dom';
import type { NavItemDef } from '@/config/navigation';
import { cn } from '@/lib/cn';

interface NavItemProps {
  item: NavItemDef;
  active: boolean;
  allowed: boolean;
}

export function NavItem({ item, active, allowed }: NavItemProps) {
  const navigate = useNavigate();
  return (
    <button
      onClick={() => allowed && navigate(item.path)}
      disabled={!allowed}
      title={allowed ? item.label : `${item.label} — accès non autorisé pour cette vue`}
      className={cn(
        'flex w-full items-center gap-3 border-l-2 px-3 py-[9px] text-left font-sans text-[13.5px] tracking-[0.005em]',
        active
          ? 'border-navy bg-surface font-medium text-ink'
          : 'border-transparent text-ink',
        allowed ? 'cursor-pointer hover:bg-surface-2' : 'cursor-not-allowed text-muted opacity-55',
      )}
    >
      <span
        className={cn(
          'inline-block w-3.5 text-center font-mono text-sm',
          active ? 'text-navy' : 'text-muted',
        )}
      >
        {item.icon}
      </span>
      <span className="flex-1">{item.label}</span>
      {!allowed && <span className="font-mono text-[10px]">🔒</span>}
    </button>
  );
}
