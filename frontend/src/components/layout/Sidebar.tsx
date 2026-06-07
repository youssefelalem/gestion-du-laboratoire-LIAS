import { useLocation } from 'react-router-dom';
import { NAV_SECTIONS } from '@/config/navigation';
import { MODULE_ACCESS } from '@/data';
import { useSession } from '@/context/SessionContext';
import { cn } from '@/lib/cn';
import { NavItem } from './NavItem';

export function Sidebar() {
  const { roleId } = useSession();
  const { pathname } = useLocation();

  return (
    <aside className="flex flex-col border-r border-line px-4 py-[22px]">
      {NAV_SECTIONS.map((section, idx) => (
        <div key={section.label} className={cn('flex flex-col gap-1', idx > 0 && 'mt-[18px]')}>
          <div className="px-3 pb-1.5 pt-2.5 font-mono text-[10px] uppercase tracking-[0.18em] text-muted">
            {section.label}
          </div>
          {section.items.map((item) => (
            <NavItem
              key={item.id}
              item={item}
              active={pathname === item.path}
              allowed={MODULE_ACCESS[item.id].includes(roleId)}
            />
          ))}
        </div>
      ))}

      <div className="mt-auto flex flex-col gap-1.5 pt-[18px]">
        <span className="px-3 font-sans text-[11.5px] text-muted">↗ Site public</span>
        <span className="px-3 font-sans text-[11.5px] text-muted">↗ Déconnexion</span>
        <div className="px-3 pt-2 font-mono text-[10px] uppercase tracking-[0.1em] text-muted">
          v 0.1.0 · projet JEE
        </div>
      </div>
    </aside>
  );
}
