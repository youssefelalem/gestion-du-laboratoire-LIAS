import type { EventFull } from '@/types';

// Évènements enrichis (organisateurs, éditions, statut) — agenda, archives, calendrier.
export const EVENTS_FULL: EventFull[] = [
  { id: 'e1', type: 'Conférence', title: 'NeurIPS 2025 — Atelier diffusion', date: '2025-12-12', lieu: 'Vancouver, Canada', role: 'Présentation', team: 'ia', edition: null, organizers: ['Y. El Amrani', 'K. Tazi'], status: 'passé' },
  { id: 'e2', type: 'Séminaire', title: 'LLM & arabe dialectal', date: '2025-11-04', lieu: "Ben M'Sik · Amphi A", role: 'Organisation', team: 'nlp', edition: '2025', organizers: ['O. Lahlou'], status: 'passé' },
  { id: 'e3', type: 'Workshop', title: 'CASA-DATA 2025', date: '2025-10-22', lieu: 'Casablanca · CRIIT', role: 'Co-organisation', team: 'bd', edition: '7e édition', organizers: ['S. Bennani', 'N. Berrada'], status: 'passé' },
  { id: 'e4', type: 'Séminaire', title: "Sécurité IoT — état de l'art", date: '2026-01-18', lieu: "Ben M'Sik · Salle 12", role: 'Organisation', team: 'sec', edition: null, organizers: ['F. Z. Idrissi'], status: 'passé' },
  { id: 'e5', type: 'Conférence', title: 'ICML 2026 — Soumission', date: '2026-02-01', lieu: '—', role: 'Soumission', team: 'ia', edition: null, organizers: ['Y. El Amrani'], status: 'passé' },
  { id: 'e6', type: 'Workshop', title: 'Journée Doctorants LIAS', date: '2026-03-12', lieu: "Ben M'Sik · Amphi A", role: 'Organisation', team: null, edition: '4e édition', organizers: ['N. Berrada', 'K. Tazi'], status: 'passé' },
  { id: 'e7', type: 'Séminaire', title: 'Graph Neural Networks', date: '2026-04-22', lieu: "Ben M'Sik · Salle 8", role: 'Invité externe', team: 'bd', edition: null, organizers: ['S. Bennani'], status: 'passé' },
  { id: 'e8', type: 'Conférence', title: 'IJCAI 2026', date: '2026-08-04', lieu: 'Montréal, Canada', role: 'Présentation', team: 'ia', edition: null, organizers: ['Y. El Amrani', 'A. Saidi'], status: 'à venir' },
  { id: 'e9', type: 'Workshop', title: 'CASA-DATA 2026', date: '2026-10-22', lieu: 'Casablanca · CRIIT', role: 'Co-organisation', team: 'bd', edition: '8e édition', organizers: ['S. Bennani', 'Y. Boussadi'], status: 'à venir' },
  { id: 'e10', type: 'Séminaire', title: 'Federated Learning sur Edge', date: '2026-06-14', lieu: "Ben M'Sik · Salle 12", role: 'Organisation', team: 'sec', edition: null, organizers: ['F. Z. Idrissi'], status: 'à venir' },
  { id: 'e11', type: 'Conférence', title: 'ACL 2026', date: '2026-07-10', lieu: 'Vienne, Autriche', role: 'Présentation', team: 'nlp', edition: null, organizers: ['O. Lahlou'], status: 'à venir' },
];
