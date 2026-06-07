import type { Channel, ChatMessageData } from '@/types';

export const CHANNELS: Channel[] = [
  { id: 'general', kind: 'général', name: 'Discussion générale', members: 33, unread: 2 },
  { id: 'directorate', kind: 'direction', name: 'Direction & vice-direction', members: 2, unread: 0 },
  { id: 'team_ia', kind: 'équipe', name: 'Équipe IA & Apprentissage', members: 11, unread: 5 },
  { id: 'team_bd', kind: 'équipe', name: 'Équipe Big Data & Fouille', members: 9, unread: 0 },
  { id: 'team_nlp', kind: 'équipe', name: 'Équipe NLP', members: 6, unread: 1 },
  { id: 'team_sec', kind: 'équipe', name: 'Équipe Sécurité & SD', members: 7, unread: 0 },
  { id: 'doctorants', kind: 'groupe', name: 'Doctorant·e·s', members: 11, unread: 0 },
  { id: 'ev_casadata', kind: 'évènement', name: 'CASA-DATA 2026 · orga', members: 5, unread: 3 },
  { id: 'ev_jd2026', kind: 'évènement', name: 'Journée Doctorants 2026', members: 8, unread: 0 },
];

export const MESSAGES_GENERAL: ChatMessageData[] = [
  { id: 1, who: 'Y. El Amrani', role: 'Directeur', time: 'hier · 16:42', body: "Rappel : le rapport annuel 2025–2026 doit être validé avant le 30 septembre. Merci aux chefs d'équipe de finaliser leurs contributions cette semaine." },
  { id: 2, who: 'N. Berrada', role: 'Vice-direction', time: 'hier · 17:14', body: "Reçu. J'ai consolidé les chiffres de l'équipe Big Data — il manque encore 3 publications côté IA à valider." },
  { id: 3, who: 'K. Tazi', role: 'Chef IA', time: 'hier · 18:02', body: "Je m'en occupe ce soir. J'aurai besoin du retour d'Aya Saidi sur l'article MICCAI." },
  { id: 4, who: 'O. Lahlou', role: 'NLP', time: "aujourd'hui · 09:15", body: "Petite question logistique : peut-on réserver l'amphi A pour le séminaire du 14 juin ?" },
  { id: 5, who: 'F. Z. Idrissi', role: 'Sécurité', time: "aujourd'hui · 10:30", body: "Amphi A est déjà réservé pour la journée d'accueil des nouveaux doctorants. Salle 12 est libre." },
  { id: 6, who: 'A. Saidi', role: 'Doctorante', time: "aujourd'hui · 11:48", body: 'Merci à tous pour les retours sur MICCAI ! Version révisée déposée dans l’archive documentaire (dossier IA / publications).' },
  { id: 7, who: 'Y. El Amrani', role: 'Directeur', time: "aujourd'hui · 14:22", body: 'Excellent travail. On en reparle au prochain conseil de laboratoire le 02/06.', attach: 'Ordre_du_jour_conseil_02-06-2026.pdf' },
];
