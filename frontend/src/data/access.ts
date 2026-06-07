import type { ModuleAccess, RoleOption } from '@/types';

// Vues utilisateur sélectionnables (démo du RBAC).
export const ROLE_OPTIONS: RoleOption[] = [
  { id: 'directeur', label: 'Directeur', member: 'yea', short: 'YE', access: 'Complet' },
  { id: 'permanent', label: 'Membre permanent', member: 'sb', short: 'SB', access: 'Standard' },
  { id: 'doctorant', label: 'Doctorant', member: 'as', short: 'AS', access: 'Limité' },
  { id: 'admin', label: 'Administrateur', member: null, short: 'AD', access: 'Technique' },
  { id: 'visiteur', label: 'Visiteur', member: null, short: '··', access: 'Public' },
];

// Module -> quelles vues y ont accès (cœur du RBAC).
export const MODULE_ACCESS: ModuleAccess = {
  dashboard: ['directeur', 'permanent', 'doctorant', 'admin'],
  profils: ['directeur', 'permanent', 'doctorant', 'visiteur', 'admin'],
  mandats: ['directeur', 'permanent', 'doctorant', 'visiteur', 'admin'],
  adhesions: ['directeur'],
  rapport: ['directeur', 'permanent'],
  evenements: ['directeur', 'permanent', 'doctorant', 'visiteur', 'admin'],
  documents: ['directeur', 'permanent', 'doctorant', 'admin'],
  publications: ['directeur', 'permanent', 'doctorant', 'visiteur', 'admin'],
  communication: ['directeur', 'permanent', 'doctorant'],
  materiel: ['directeur', 'permanent', 'admin'],
  conventions: ['directeur', 'permanent', 'visiteur', 'admin'],
  pv: ['directeur', 'permanent', 'admin'],
  calendrier: ['directeur', 'permanent', 'doctorant', 'visiteur', 'admin'],
  notifications: ['directeur', 'permanent', 'doctorant', 'admin'],
  recherche: ['directeur', 'permanent', 'doctorant', 'visiteur', 'admin'],
  admin: ['admin', 'directeur'],
};
