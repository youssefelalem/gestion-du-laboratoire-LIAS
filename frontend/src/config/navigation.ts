import type { ModuleId } from '@/types';

export interface NavItemDef {
  id: ModuleId;
  label: string;
  /** Glyphe mono — signature typographique du design. */
  icon: string;
  path: string;
}

export interface NavSectionDef {
  label: string;
  items: NavItemDef[];
}

export const NAV_SECTIONS: NavSectionDef[] = [
  {
    label: 'Principal',
    items: [
      { id: 'dashboard', label: 'Tableau de bord', icon: '⊟', path: '/' },
      { id: 'profils', label: 'Profils', icon: '⊙', path: '/profils' },
      { id: 'mandats', label: 'Mandats', icon: '⌗', path: '/mandats' },
      { id: 'adhesions', label: "Demandes d'adhésion", icon: '+', path: '/adhesions' },
      { id: 'rapport', label: 'Rapport annuel', icon: '§', path: '/rapport' },
    ],
  },
  {
    label: 'Modules secondaires',
    items: [
      { id: 'evenements', label: 'Évènements', icon: '◇', path: '/evenements' },
      { id: 'calendrier', label: 'Calendrier', icon: '▦', path: '/calendrier' },
      { id: 'publications', label: 'Publications', icon: '¶', path: '/publications' },
      { id: 'documents', label: 'Archive documentaire', icon: '▤', path: '/documents' },
      { id: 'communication', label: 'Communication', icon: '❝', path: '/communication' },
      { id: 'materiel', label: 'Matériel', icon: '▭', path: '/materiel' },
      { id: 'conventions', label: 'Conventions', icon: '⌘', path: '/conventions' },
      { id: 'pv', label: 'Procès-verbaux', icon: '≡', path: '/pv' },
    ],
  },
  {
    label: 'Outils',
    items: [
      { id: 'recherche', label: 'Recherche globale', icon: '⌕', path: '/recherche' },
      { id: 'notifications', label: 'Notifications', icon: '◉', path: '/notifications' },
      { id: 'admin', label: 'Administration', icon: '⚙', path: '/admin' },
    ],
  },
];

export const ALL_NAV_ITEMS: NavItemDef[] = NAV_SECTIONS.flatMap((s) => s.items);

/** Retrouve la définition de nav d'un module. */
export function navItemFor(id: ModuleId): NavItemDef | undefined {
  return ALL_NAV_ITEMS.find((i) => i.id === id);
}
