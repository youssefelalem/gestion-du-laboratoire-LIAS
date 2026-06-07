import type { Partner } from '@/types';

export const PARTNERS: Partner[] = [
  { id: 'p1', short: 'CT', name: 'Casa Transports', type: 'Industrie', country: 'Maroc', since: '2024-03-15', until: '2027-03-14', status: 'active', activities: ['CASA-DATA 2025', 'Thèse Y. Boussadi', 'Open dataset trafic'], lead: 'S. Bennani', funding: '480 000 MAD' },
  { id: 'p2', short: 'IN', name: 'INRIA Paris', type: 'Recherche', country: 'France', since: '2025-01-20', until: '2028-01-19', status: 'active', activities: ['Échange doctorant', 'Co-publication ACM CSUR'], lead: 'N. Berrada', funding: '€ 120 000' },
  { id: 'p3', short: 'UM', name: 'Université Mohammed V', type: 'Académique', country: 'Maroc', since: '2022-09-01', until: '2027-08-31', status: 'active', activities: ['ANR-CASA-CRYPTO', 'Encadrement conjoint'], lead: 'F. Z. Idrissi', funding: '230 000 MAD' },
  { id: 'p4', short: 'LP', name: 'CNRS-LIPN', type: 'Recherche', country: 'France', since: '2026-02-10', until: '2029-02-09', status: 'active', activities: ['Graph mining', 'Workshop bilatéral 2026'], lead: 'N. Berrada', funding: '€ 90 000' },
  { id: 'p5', short: 'EN', name: 'ENSIAS Rabat', type: 'Académique', country: 'Maroc', since: '2021-09-01', until: '2026-08-31', status: 'à renouveler', activities: ['Échange enseignants'], lead: 'Y. El Amrani', funding: '—' },
  { id: 'p6', short: 'OC', name: 'OCP Innovation Fund', type: 'Industrie', country: 'Maroc', since: '2023-06-01', until: '2025-12-31', status: 'terminée', activities: ['Projet IA Mining'], lead: 'K. Tazi', funding: '320 000 MAD' },
];
