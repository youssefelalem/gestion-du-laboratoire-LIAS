import { useState } from 'react';
import { Badge, type BadgeTone, Button, Card, Empty, SectionHead } from '@/components/ui';

interface Notif {
  id: number;
  kind: keyof typeof KIND_META;
  when: string;
  read: boolean;
  who: string;
  body: string;
  action: string;
}

const KIND_META = {
  adhesion: { label: 'Adhésion', icon: '+', tone: 'gold' as BadgeTone },
  publication: { label: 'Publication', icon: '¶', tone: 'navy' as BadgeTone },
  event: { label: 'Évènement', icon: '◇', tone: 'sage' as BadgeTone },
  document: { label: 'Document', icon: '▤', tone: 'neutral' as BadgeTone },
  meeting: { label: 'Réunion', icon: '≡', tone: 'navy' as BadgeTone },
  materiel: { label: 'Matériel', icon: '▭', tone: 'neutral' as BadgeTone },
  rapport: { label: 'Rapport', icon: '§', tone: 'gold' as BadgeTone },
  convention: { label: 'Convention', icon: '⌘', tone: 'sage' as BadgeTone },
};

const NOTIFICATIONS: Notif[] = [
  { id: 1, kind: 'adhesion', when: 'il y a 12 min', read: false, who: 'Imane Benkirane', body: "a soumis une demande d'adhésion (Membre permanent — Équipe IA).", action: 'Examiner →' },
  { id: 2, kind: 'publication', when: 'il y a 1 h', read: false, who: 'A. Saidi', body: 'a ajouté une publication : « Diffusion priors for medical image inpainting » (MICCAI 2026).', action: 'Valider →' },
  { id: 3, kind: 'event', when: 'il y a 3 h', read: false, who: 'S. Bennani', body: "a créé l'évènement « CASA-DATA 2026 — 8e édition » pour le 22 octobre.", action: 'Voir →' },
  { id: 4, kind: 'document', when: "aujourd'hui", read: true, who: 'O. Lahlou', body: 'a téléversé 2 documents dans Séminaires NLP / 2025-2026.', action: 'Ouvrir →' },
  { id: 5, kind: 'meeting', when: 'hier', read: true, who: 'Système', body: 'Rappel : Conseil de laboratoire le 2 juin 2026, 14:00.', action: 'Calendrier →' },
  { id: 6, kind: 'materiel', when: 'hier', read: true, who: 'F. Z. Idrissi', body: 'a reçu sa station de calcul GPU (RTX 4090). Distribution validée.', action: 'Historique →' },
  { id: 7, kind: 'rapport', when: 'il y a 2 jours', read: true, who: 'Système', body: 'Le rapport annuel 2025–2026 est à 78 % de complétude. Échéance : 30 septembre.', action: 'Rapport →' },
  { id: 8, kind: 'adhesion', when: 'il y a 4 jours', read: true, who: 'Karim Ouazzani', body: "demande d'adhésion acceptée — compte créé, identifiants envoyés.", action: 'Profil →' },
  { id: 9, kind: 'convention', when: 'il y a 1 sem.', read: true, who: 'Y. El Amrani', body: 'a signé la convention CNRS-LIPN (2026–2029).', action: 'Convention →' },
];

export default function Notifications() {
  const [filter, setFilter] = useState('toutes');
  const [list, setList] = useState(NOTIFICATIONS);

  const unread = list.filter((n) => !n.read).length;
  const filtered = list.filter(
    (n) => filter === 'toutes' || (filter === 'non lues' && !n.read) || n.kind === filter,
  );

  const FILTERS = [
    { id: 'toutes', label: 'Toutes', count: list.length },
    { id: 'non lues', label: 'Non lues', count: unread },
    { id: 'adhesion', label: 'Adhésions', count: list.filter((n) => n.kind === 'adhesion').length },
    { id: 'publication', label: 'Publications', count: list.filter((n) => n.kind === 'publication').length },
    { id: 'event', label: 'Évènements', count: list.filter((n) => n.kind === 'event').length },
    { id: 'document', label: 'Documents', count: list.filter((n) => n.kind === 'document').length },
    { id: 'meeting', label: 'Réunions', count: list.filter((n) => n.kind === 'meeting').length },
    { id: 'rapport', label: 'Rapports', count: list.filter((n) => n.kind === 'rapport').length },
  ];

  return (
    <div>
      <SectionHead
        eyebrow={`${unread} non lues · ${list.length} au total`}
        title="Notifications"
        subtitle="Toutes les actions importantes du laboratoire — validations, soumissions, ajouts de documents — sont tracées ici."
        right={
          unread > 0 ? (
            <Button variant="ghost" onClick={() => setList(list.map((n) => ({ ...n, read: true })))}>
              Tout marquer comme lu
            </Button>
          ) : undefined
        }
      />

      <div className="grid grid-cols-[200px_1fr] gap-6">
        <div>
          <div className="px-3 pb-2 pt-1 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Filtres
          </div>
          {FILTERS.map((f) => (
            <button
              key={f.id}
              onClick={() => setFilter(f.id)}
              className={`flex w-full items-center justify-between border-l-2 px-3 py-2 text-left font-sans text-[13px] text-ink ${
                filter === f.id ? 'border-l-navy bg-surface font-medium' : 'border-l-transparent font-normal'
              }`}
            >
              <span>{f.label}</span>
              <span className="font-mono text-[10.5px] text-muted">{f.count}</span>
            </button>
          ))}
        </div>

        <Card padded={false}>
          {filtered.map((n, i) => {
            const meta = KIND_META[n.kind];
            return (
              <div
                key={n.id}
                className={`relative grid grid-cols-[36px_1fr_auto] gap-3.5 px-[22px] py-[18px] ${
                  i === 0 ? '' : 'border-t border-line'
                } ${n.read ? '' : 'bg-[rgba(176,136,56,0.04)]'}`}
              >
                {!n.read && (
                  <span className="absolute left-1.5 top-1/2 h-1.5 w-1.5 -translate-y-1/2 rounded-full bg-[#B5453E]" />
                )}
                <div className="flex h-9 w-9 items-center justify-center border border-line bg-surface-2 font-mono text-base text-navy">
                  {meta.icon}
                </div>
                <div>
                  <div className="mb-0.5 flex items-baseline gap-2">
                    <Badge tone={meta.tone}>{meta.label}</Badge>
                    <span className="font-mono text-[10.5px] text-muted">{n.when}</span>
                  </div>
                  <div className="font-serif text-[14.5px] leading-[1.5] text-ink">
                    <strong className="font-medium">{n.who}</strong> {n.body}
                  </div>
                </div>
                <Button variant="ghost" size="sm">
                  {n.action}
                </Button>
              </div>
            );
          })}
          {filtered.length === 0 && <Empty title="Aucune notification dans ce filtre." />}
        </Card>
      </div>
    </div>
  );
}
