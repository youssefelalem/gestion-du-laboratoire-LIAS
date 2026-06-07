// ============================================================
// LIAS — domain types
// Vocabulaire métier du laboratoire (cahier des charges JEE).
// ============================================================

/** Statut d'un membre (orthogonal au rôle de gouvernance). */
export type MemberStatus = 'permanent' | 'associe' | 'doctorant' | 'retraite' | 'ancien';

/** Rôle de gouvernance (responsabilité), indépendant du statut. */
export type GovRole = 'directeur' | 'vice-directeur' | 'chef-equipe' | 'membre' | 'aucun';

/** « Vue » utilisateur courante (pour le RBAC et le sélecteur de rôle). */
export type ViewRole = 'directeur' | 'permanent' | 'doctorant' | 'admin' | 'visiteur';

export type TeamId = 'ia' | 'bd' | 'nlp' | 'sec';

export interface Team {
  id: TeamId;
  name: string;
  short: string;
  members: number;
}

/** Une période d'affiliation historisée (clé du "tout est conservé"). */
export interface AffiliationPeriod {
  from: string; // ISO date
  to: string | null; // null => en cours
  role: string;
}

export interface Member {
  id: string;
  firstName: string;
  lastName: string;
  initials: string;
  status: MemberStatus;
  role: GovRole;
  team: TeamId;
  team_label: string;
  grade: string;
  email: string;
  inst: string;
  origLab: string;
  hired: string; // date d'embauche
  affiliated: string; // date d'affiliation au LIAS (clé métier)
  birth: string; // confidentielle
  interests: string[];
  bio: string;
  pubs: number;
  hIndex: number;
  history: AffiliationPeriod[];
}

export interface GovPerson {
  id: string;
  name: string;
}
export interface TeamLead {
  team: string;
  name: string;
}

export type MandatStatus = 'passé' | 'en cours';

export interface Mandat {
  id: string;
  label: string;
  from: string;
  to: string;
  status: MandatStatus;
  directeur: GovPerson;
  vice: GovPerson;
  chefs: TeamLead[];
}

export type AdhesionStatus = 'en attente' | 'acceptée' | 'refusée';

export interface Adhesion {
  id: string;
  name: string;
  initials: string;
  submitted: string;
  status: AdhesionStatus;
  type: string;
  target_team: TeamId;
  inst: string;
  origLab?: string;
  grade: string;
  motivation: string;
  publications: number;
  hIndex: number;
  cv: string;
  // Décision (renseignés une fois traitée)
  reason?: string;
  decidedAt?: string;
  decidedBy?: string;
}

export type EventType = 'Conférence' | 'Séminaire' | 'Workshop';

export interface ScientificEvent {
  id: string;
  type: EventType;
  title: string;
  date: string;
  lieu: string;
  role: string;
  team: TeamId | '—';
}

/** Évènement enrichi (agenda/archives/calendrier) : édition, organisateurs, statut. */
export interface EventFull {
  id: string;
  type: EventType;
  title: string;
  date: string;
  lieu: string;
  role: string;
  team: TeamId | null;
  edition: string | null;
  organizers: string[];
  status: 'passé' | 'à venir';
}

export type PublicationType = 'Revue' | 'Conf.';

export interface Publication {
  id: string;
  title: string;
  authors: string[];
  venue: string;
  year: number;
  team: TeamId;
  type: PublicationType;
}

// --- Archive documentaire (arbre imbriqué) -----------------------
export interface DocFile {
  name: string;
  size: string;
  date: string;
  type: string;
  by: string;
}
/** Un sous-dossier = soit une liste de fichiers, soit un map édition → fichiers. */
export type DocSubNode = DocFile[] | Record<string, DocFile[]>;
export type DocRoot = Record<string, DocSubNode>;
export type DocumentsTree = Record<string, DocRoot>;

// --- Communication interne ---------------------------------------
export interface Channel {
  id: string;
  kind: 'général' | 'direction' | 'équipe' | 'groupe' | 'évènement';
  name: string;
  members: number;
  unread: number;
}
export interface ChatMessageData {
  id: number;
  who: string;
  role: string;
  time: string;
  body: string;
  attach?: string;
  self?: boolean;
}

// --- Matériel -----------------------------------------------------
export type HolderStatus = 'livré' | 'en attente' | 'en stock';
export interface MaterialHolder {
  who: string;
  date: string;
  status: HolderStatus;
  n?: number;
}
export interface MaterialItem {
  id: string;
  name: string;
  category: string;
  arrived: string;
  qty: number;
  distributed: number;
  holders: MaterialHolder[];
}
export interface MaterialRequest {
  id: string;
  who: string;
  what: string;
  submitted: string;
  status: 'en attente' | 'acceptée' | 'refusée';
  motif: string;
  reason?: string;
}

// --- Conventions & partenaires -----------------------------------
export interface Partner {
  id: string;
  short: string;
  name: string;
  type: 'Industrie' | 'Recherche' | 'Académique';
  country: string;
  since: string;
  until: string;
  status: 'active' | 'à renouveler' | 'terminée';
  activities: string[];
  lead: string;
  funding: string;
}

// --- Procès-verbaux ----------------------------------------------
export interface MeetingPV {
  file: string;
  size: string;
  validated: boolean;
  signedBy: string | null;
}
export interface Meeting {
  id: string;
  title: string;
  date: string;
  time: string;
  duration: string;
  lieu: string;
  status: 'à venir' | 'passée';
  chair: string;
  attendees: string[];
  agenda: string[];
  pv: MeetingPV | null;
}

export interface RoleOption {
  id: ViewRole;
  label: string;
  member: string | null;
  short: string;
  access: string;
}

/** Identifiant de module = clé de route + clé du RBAC. */
export type ModuleId =
  | 'dashboard'
  | 'profils'
  | 'mandats'
  | 'adhesions'
  | 'rapport'
  | 'evenements'
  | 'calendrier'
  | 'publications'
  | 'documents'
  | 'communication'
  | 'materiel'
  | 'conventions'
  | 'pv'
  | 'recherche'
  | 'notifications'
  | 'admin';

export type ModuleAccess = Record<ModuleId, ViewRole[]>;
