import type { ScientificEvent } from '@/types';

// Évènements 2025–2026 (dashboard + rapport).
export const EVENEMENTS: ScientificEvent[] = [
  { id: 'e1', type: 'Conférence', title: 'NeurIPS — Atelier diffusion', date: '2025-12-12', lieu: 'Vancouver', role: 'Présentation', team: 'ia' },
  { id: 'e2', type: 'Séminaire', title: 'LLM & arabe dialectal', date: '2025-11-04', lieu: "Ben M'Sik", role: 'Organisation', team: 'nlp' },
  { id: 'e3', type: 'Workshop', title: 'CASA-DATA 2025', date: '2025-10-22', lieu: 'Casablanca', role: 'Co-organisation', team: 'bd' },
  { id: 'e4', type: 'Séminaire', title: "Sécurité IoT — état de l'art", date: '2026-01-18', lieu: "Ben M'Sik", role: 'Organisation', team: 'sec' },
  { id: 'e5', type: 'Conférence', title: 'ICML 2026 — Soumission', date: '2026-02-01', lieu: '—', role: 'Soumission', team: 'ia' },
  { id: 'e6', type: 'Workshop', title: 'Journée Doctorants LIAS', date: '2026-03-12', lieu: "Ben M'Sik", role: 'Organisation', team: '—' },
  { id: 'e7', type: 'Séminaire', title: 'Graph Neural Networks', date: '2026-04-22', lieu: "Ben M'Sik", role: 'Invité externe', team: 'bd' },
  { id: 'e8', type: 'Conférence', title: 'IJCAI 2026', date: '2026-08-04', lieu: 'Montréal', role: 'Présentation', team: 'ia' },
];
