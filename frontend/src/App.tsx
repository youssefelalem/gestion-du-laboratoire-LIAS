import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import type { ComponentType, ReactNode } from 'react';
import { SessionProvider, useSession } from '@/context/SessionContext';
import { AppShell } from '@/components/layout/AppShell';
import { ALL_NAV_ITEMS } from '@/config/navigation';
import { MODULE_ACCESS } from '@/data';
import type { ModuleId } from '@/types';
import Dashboard from '@/routes/Dashboard';
import Profils from '@/routes/Profils';
import Mandats from '@/routes/Mandats';
import Adhesions from '@/routes/Adhesions';
import Rapport from '@/routes/Rapport';
import Evenements from '@/routes/Evenements';
import Calendrier from '@/routes/Calendrier';
import Publications from '@/routes/Publications';
import Documents from '@/routes/Documents';
import Communication from '@/routes/Communication';
import Materiel from '@/routes/Materiel';
import Conventions from '@/routes/Conventions';
import PV from '@/routes/PV';
import Recherche from '@/routes/Recherche';
import Notifications from '@/routes/Notifications';
import Admin from '@/routes/Admin';
import { Stub } from '@/routes/Stub';

/** Écrans déjà portés en entier ; le reste retombe sur <Stub/>. */
const FULL_SCREENS: Partial<Record<ModuleId, ComponentType>> = {
  dashboard: Dashboard,
  profils: Profils,
  mandats: Mandats,
  adhesions: Adhesions,
  rapport: Rapport,
  evenements: Evenements,
  calendrier: Calendrier,
  publications: Publications,
  documents: Documents,
  communication: Communication,
  materiel: Materiel,
  conventions: Conventions,
  pv: PV,
  recherche: Recherche,
  notifications: Notifications,
  admin: Admin,
};

/** Garde RBAC : redirige vers une vue accessible si le module est interdit. */
function RequireAccess({ module, children }: { module: ModuleId; children: ReactNode }) {
  const { roleId } = useSession();
  if (!MODULE_ACCESS[module].includes(roleId)) {
    return <Navigate to="/profils" replace />;
  }
  return <>{children}</>;
}

export default function App() {
  return (
    <SessionProvider>
      <BrowserRouter>
        <Routes>
          <Route element={<AppShell />}>
            {ALL_NAV_ITEMS.map((item) => {
              const Screen = FULL_SCREENS[item.id];
              const element = Screen ? <Screen /> : <Stub module={item.id} />;
              return (
                <Route
                  key={item.id}
                  path={item.path}
                  element={<RequireAccess module={item.id}>{element}</RequireAccess>}
                />
              );
            })}
            <Route path="*" element={<Navigate to="/" replace />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </SessionProvider>
  );
}
