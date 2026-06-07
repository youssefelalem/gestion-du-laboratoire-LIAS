import type { Mandat } from '@/types';

// Mandats — gouvernance historique (mémoire institutionnelle).
export const MANDATS: Mandat[] = [
  {
    id: 'm1',
    label: 'Mandat 2014 — 2018',
    from: '2014-09-01',
    to: '2018-08-31',
    status: 'passé',
    directeur: { id: 'mc', name: 'Pr. Mehdi Chraibi' },
    vice: { id: '—', name: 'Pr. Mohamed Sefrioui' },
    chefs: [
      { team: 'IA', name: 'Pr. Yassine El Amrani' },
      { team: 'BD', name: 'Pr. Salma Bennani' },
      { team: 'SEC', name: 'Pr. Khalid Tazi' },
    ],
  },
  {
    id: 'm2',
    label: 'Mandat 2018 — 2021',
    from: '2018-09-01',
    to: '2021-08-31',
    status: 'passé',
    directeur: { id: '—', name: 'Pr. Mohamed Sefrioui' },
    vice: { id: 'yea', name: 'Pr. Yassine El Amrani' },
    chefs: [
      { team: 'IA', name: 'Pr. Yassine El Amrani' },
      { team: 'BD', name: 'Pr. Salma Bennani' },
      { team: 'NLP', name: 'Dr. Leila Joundi' },
    ],
  },
  {
    id: 'm3',
    label: 'Mandat 2021 — 2024',
    from: '2021-09-01',
    to: '2024-08-31',
    status: 'passé',
    directeur: { id: 'yea', name: 'Pr. Yassine El Amrani' },
    vice: { id: 'nb', name: 'Pr. Nadia Berrada' },
    chefs: [
      { team: 'IA', name: 'Pr. Mehdi Chraibi' },
      { team: 'BD', name: 'Pr. Nadia Berrada' },
      { team: 'NLP', name: 'Dr. Omar Lahlou' },
      { team: 'SEC', name: 'Dr. Fatima Zahra Idrissi' },
    ],
  },
  {
    id: 'm4',
    label: 'Mandat 2024 — 2027',
    from: '2024-09-01',
    to: '2027-08-31',
    status: 'en cours',
    directeur: { id: 'yea', name: 'Pr. Yassine El Amrani' },
    vice: { id: 'nb', name: 'Pr. Nadia Berrada' },
    chefs: [
      { team: 'IA', name: 'Pr. Khalid Tazi' },
      { team: 'BD', name: 'Pr. Salma Bennani' },
      { team: 'NLP', name: 'Dr. Omar Lahlou' },
      { team: 'SEC', name: 'Dr. Fatima Zahra Idrissi' },
    ],
  },
];
