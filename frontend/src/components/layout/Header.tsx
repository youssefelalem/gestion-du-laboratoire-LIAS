import { useNavigate } from 'react-router-dom';
import { Bell, Search } from 'lucide-react';
import { Wordmark } from './Wordmark';
import { RoleToggle } from './RoleToggle';

export function Header() {
  const navigate = useNavigate();

  return (
    <header className="sticky top-0 z-50 flex h-16 items-center justify-between border-b border-line bg-bg px-7">
      <div className="flex items-center gap-3.5">
        <Wordmark />
        <div className="h-6 w-px bg-line" />
        <div className="flex flex-col">
          <div className="font-serif text-sm leading-[1.1] text-ink">
            Faculté des Sciences Ben M'Sik
          </div>
          <div className="font-mono text-[10px] uppercase tracking-[0.1em] text-muted">
            Casablanca · Université Hassan II
          </div>
        </div>
      </div>

      <div className="mx-8 max-w-[420px] flex-1">
        <button
          onClick={() => navigate('/recherche')}
          className="flex h-9 w-full items-center gap-2 rounded-[2px] border border-line bg-surface px-3 text-left font-sans text-[13px] text-muted"
        >
          <Search size={14} strokeWidth={1.8} className="flex-shrink-0" />
          <span className="flex-1 overflow-hidden text-ellipsis whitespace-nowrap">
            Recherche globale…
          </span>
          <span className="flex-shrink-0 rounded-[2px] border border-line px-1.5 py-px font-mono text-[10px]">
            ⌘K
          </span>
        </button>
      </div>

      <div className="flex items-center gap-3.5">
        <button
          onClick={() => navigate('/notifications')}
          className="relative flex h-9 w-9 items-center justify-center border border-line"
          title="Notifications"
        >
          <Bell size={16} strokeWidth={1.6} className="text-ink" />
          <span className="absolute -right-1 -top-1 flex h-3.5 w-3.5 items-center justify-center rounded-full bg-[#B5453E] font-mono text-[9px] text-cream">
            3
          </span>
        </button>
        <RoleToggle />
      </div>
    </header>
  );
}
