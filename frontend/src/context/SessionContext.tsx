import { createContext, useContext, useMemo, useState, type ReactNode } from 'react';
import type { Member, RoleOption, ViewRole } from '@/types';
import { MEMBERS, ROLE_OPTIONS } from '@/data';

interface SessionValue {
  roleId: ViewRole;
  setRoleId: (id: ViewRole) => void;
  role: RoleOption;
  currentMember: Member | null;
}

const SessionContext = createContext<SessionValue | null>(null);

/**
 * Session courante = "vue" sélectionnée via le RoleToggle.
 * Pilote tout le RBAC de l'interface (cf. MODULE_ACCESS).
 */
export function SessionProvider({ children }: { children: ReactNode }) {
  const [roleId, setRoleId] = useState<ViewRole>('directeur');

  const value = useMemo<SessionValue>(() => {
    const role = ROLE_OPTIONS.find((r) => r.id === roleId)!;
    const currentMember = role.member
      ? (MEMBERS.find((m) => m.id === role.member) ?? null)
      : null;
    return { roleId, setRoleId, role, currentMember };
  }, [roleId]);

  return <SessionContext.Provider value={value}>{children}</SessionContext.Provider>;
}

// eslint-disable-next-line react-refresh/only-export-components
export function useSession(): SessionValue {
  const ctx = useContext(SessionContext);
  if (!ctx) throw new Error('useSession must be used within a SessionProvider');
  return ctx;
}
