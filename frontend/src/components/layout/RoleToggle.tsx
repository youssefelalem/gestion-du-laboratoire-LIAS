import { useEffect, useRef, useState } from 'react';
import { ChevronDown } from 'lucide-react';
import { ROLE_OPTIONS } from '@/data';
import { useSession } from '@/context/SessionContext';
import { Avatar, type AvatarTone } from '@/components/ui';
import { cn } from '@/lib/cn';

/**
 * Bascule de "vue" — le moment signature de la démo.
 * Permet de voir l'application telle qu'elle apparaît à chaque type
 * d'utilisateur (et donc de constater le RBAC en direct).
 */
export function RoleToggle() {
  const { roleId, setRoleId, role, currentMember } = useSession();
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const onClick = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', onClick);
    return () => document.removeEventListener('mousedown', onClick);
  }, [open]);

  const tone: AvatarTone =
    roleId === 'visiteur' ? 'muted' : roleId === 'permanent' || roleId === 'admin' ? 'sage' : 'navy';

  return (
    <div ref={ref} className="relative">
      <button
        onClick={() => setOpen(!open)}
        className="flex min-w-[200px] items-center gap-2.5 border border-line bg-surface py-[5px] pl-[5px] pr-2.5"
      >
        <Avatar initials={currentMember ? currentMember.initials : '··'} size={28} tone={tone} />
        <div className="flex-1 text-left">
          <div className="font-sans text-[12.5px] font-medium leading-tight text-ink">
            {currentMember ? `${currentMember.firstName} ${currentMember.lastName}` : 'Visiteur public'}
          </div>
          <div className="font-mono text-[10px] uppercase tracking-[0.08em] text-muted">
            VUE · {role.label}
          </div>
        </div>
        <ChevronDown size={12} className="text-muted" />
      </button>

      {open && (
        <div className="absolute right-0 top-[calc(100%+6px)] z-[60] w-[280px] border border-line bg-surface shadow-[0_18px_40px_rgba(20,18,14,0.15)]">
          <div className="border-b border-line px-3.5 pb-2 pt-3">
            <div className="font-mono text-[10px] uppercase tracking-[0.15em] text-muted">
              Changer de vue · démo
            </div>
            <div className="mt-1 font-serif text-xs italic text-muted">
              Voyez l'application telle qu'elle apparaît à chaque type d'utilisateur.
            </div>
          </div>
          {ROLE_OPTIONS.map((r) => (
            <button
              key={r.id}
              onClick={() => {
                setRoleId(r.id);
                setOpen(false);
              }}
              className={cn(
                'flex w-full items-center gap-2.5 border-t border-line px-3.5 py-2.5 text-left',
                roleId === r.id ? 'bg-surface-2' : 'bg-transparent hover:bg-surface-2',
              )}
            >
              <span
                className={cn('h-1.5 w-1.5 rounded-full', roleId === r.id ? 'bg-navy' : 'bg-line')}
              />
              <div className="flex-1">
                <div className={cn('font-sans text-[13px] text-ink', roleId === r.id && 'font-medium')}>
                  {r.label}
                </div>
                <div className="mt-0.5 font-mono text-[10.5px] text-muted">Accès : {r.access}</div>
              </div>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
