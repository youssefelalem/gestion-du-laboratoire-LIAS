import type { MaterialItem, MaterialRequest } from '@/types';

export const MATERIEL_ITEMS: MaterialItem[] = [
  {
    id: 'm1',
    name: 'Station de calcul GPU (RTX 4090)',
    category: 'Calcul',
    arrived: '2026-02-10',
    qty: 4,
    distributed: 3,
    holders: [
      { who: 'K. Tazi (IA)', date: '2026-02-12', status: 'livré' },
      { who: 'S. Bennani (BD)', date: '2026-02-15', status: 'livré' },
      { who: 'O. Lahlou (NLP)', date: '2026-03-01', status: 'livré' },
      { who: 'F. Z. Idrissi (SEC)', date: '—', status: 'en attente' },
    ],
  },
  {
    id: 'm2',
    name: "MacBook Pro 16'' M3",
    category: 'Portable',
    arrived: '2026-03-04',
    qty: 3,
    distributed: 2,
    holders: [
      { who: 'A. Saidi (Doc.)', date: '2026-03-06', status: 'livré' },
      { who: 'Y. Boussadi (Doc.)', date: '2026-03-06', status: 'livré' },
      { who: 'Nouveau doctorant — à affecter', date: '—', status: 'en attente' },
    ],
  },
  {
    id: 'm3',
    name: 'Capteurs IoT (kit complet)',
    category: 'IoT',
    arrived: '2026-04-20',
    qty: 12,
    distributed: 8,
    holders: [
      { who: 'F. Z. Idrissi (SEC)', date: '2026-04-22', status: 'livré', n: 6 },
      { who: 'R. Hamdani (associé)', date: '2026-04-25', status: 'livré', n: 2 },
      { who: 'Réserve laboratoire', date: '—', status: 'en stock', n: 4 },
    ],
  },
  {
    id: 'm4',
    name: 'Licence MATLAB R2026a (10 postes)',
    category: 'Logiciel',
    arrived: '2026-05-02',
    qty: 10,
    distributed: 10,
    holders: [
      { who: 'Équipe IA', date: '2026-05-04', status: 'livré', n: 4 },
      { who: 'Équipe BD', date: '2026-05-04', status: 'livré', n: 3 },
      { who: 'Équipe SEC', date: '2026-05-04', status: 'livré', n: 2 },
      { who: 'Doctorants', date: '2026-05-05', status: 'livré', n: 1 },
    ],
  },
  {
    id: 'm5',
    name: "Écran 4K 32''",
    category: 'Bureau',
    arrived: '2026-05-15',
    qty: 6,
    distributed: 0,
    holders: [{ who: 'À répartir', date: '—', status: 'en stock', n: 6 }],
  },
];

export const MATERIEL_REQUESTS: MaterialRequest[] = [
  { id: 'r1', who: 'O. Lahlou', what: 'Serveur GPU pour fine-tuning LLM', submitted: '2026-05-20', status: 'en attente', motif: 'Modèles 7B sur arabe dialectal.' },
  { id: 'r2', who: 'Y. Boussadi', what: 'Licence Apache Flink Enterprise', submitted: '2026-05-22', status: 'en attente', motif: 'Streaming analytics — thèse.' },
  { id: 'r3', who: 'F. Z. Idrissi', what: 'Carte FPGA Xilinx Alveo', submitted: '2026-05-10', status: 'acceptée', motif: 'Crypto post-quantique embarquée.' },
  { id: 'r4', who: 'A. Saidi', what: 'Abonnement Adobe Creative Cloud', submitted: '2026-04-28', status: 'refusée', motif: 'Présentations doctorales.', reason: 'Hors budget cette année — utiliser Inkscape/GIMP.' },
];
