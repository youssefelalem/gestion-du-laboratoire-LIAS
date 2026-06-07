import { useState } from 'react';
import { EVENTS_FULL } from '@/data';
import { useSession } from '@/context/SessionContext';
import {
  Badge,
  type BadgeTone,
  Button,
  Card,
  Chip,
  FormField,
  SearchInput,
  SectionHead,
  fieldClass,
} from '@/components/ui';
import { fmtFR } from '@/lib/format';
import type { EventFull, EventType } from '@/types';

const TYPE_TONE: Record<EventType, BadgeTone> = {
  Conférence: 'navy',
  Séminaire: 'gold',
  Workshop: 'sage',
};

export default function Evenements() {
  const { roleId } = useSession();
  const [tab, setTab] = useState<'agenda' | 'archives' | 'create'>('agenda');
  const [filterType, setFilterType] = useState<'tous' | EventType>('tous');
  const [search, setSearch] = useState('');

  const upcoming = EVENTS_FULL.filter((e) => e.status === 'à venir').sort((a, b) =>
    a.date.localeCompare(b.date),
  );
  const past = EVENTS_FULL.filter((e) => e.status === 'passé').sort((a, b) =>
    b.date.localeCompare(a.date),
  );

  const TABS: { id: typeof tab; label: string }[] = [
    { id: 'agenda', label: `Agenda (${upcoming.length})` },
    { id: 'archives', label: `Archives (${past.length})` },
    { id: 'create', label: 'Créer un évènement' },
  ];

  return (
    <div>
      <SectionHead
        eyebrow={`${upcoming.length} évènements à venir · ${past.length} archivés`}
        title="Évènements scientifiques"
        subtitle="Conférences, séminaires et workshops du laboratoire — agenda interactif et archive par édition."
        right={
          roleId === 'directeur' || roleId === 'permanent' ? (
            <Button variant="primary" onClick={() => setTab('create')}>
              + Nouvel évènement
            </Button>
          ) : undefined
        }
      />

      <div className="mb-6 flex border-b border-line">
        {TABS.map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={`-mb-px border-b-2 px-[18px] py-2.5 font-serif text-[15px] ${
              tab === t.id
                ? 'border-navy text-ink'
                : 'border-transparent italic text-muted'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab === 'agenda' && <AgendaTimeline events={upcoming} />}
      {tab === 'archives' && (
        <ArchivesView
          events={past}
          filterType={filterType}
          setFilterType={setFilterType}
          search={search}
          setSearch={setSearch}
        />
      )}
      {tab === 'create' && <EventCreateForm />}
    </div>
  );
}

function AgendaTimeline({ events }: { events: EventFull[] }) {
  const grouped = events.reduce<Record<string, EventFull[]>>((acc, e) => {
    const k = new Date(e.date).toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' });
    (acc[k] = acc[k] ?? []).push(e);
    return acc;
  }, {});

  return (
    <div className="grid grid-cols-[1fr_320px] gap-6">
      <Card padded={false}>
        {Object.entries(grouped).map(([month, evs], i) => (
          <div key={month}>
            <div
              className={`bg-surface-2 px-[22px] pb-2 pt-3 font-mono text-[11px] uppercase tracking-[0.15em] text-muted ${
                i === 0 ? '' : 'border-t border-line'
              }`}
            >
              {month}
            </div>
            {evs.map((e) => (
              <div
                key={e.id}
                className="grid grid-cols-[74px_1fr_auto] items-start gap-[18px] border-t border-line px-[22px] py-[18px]"
              >
                <div className="text-center">
                  <div className="font-serif text-[34px] font-medium leading-none text-ink">
                    {new Date(e.date).getDate()}
                  </div>
                  <div className="mt-1 font-mono text-[10px] uppercase tracking-[0.15em] text-muted">
                    {new Date(e.date).toLocaleDateString('fr-FR', { weekday: 'short' })}
                  </div>
                </div>
                <div>
                  <div className="mb-1 flex gap-1.5">
                    <Badge tone={TYPE_TONE[e.type]}>{e.type}</Badge>
                    {e.edition && <Badge tone="muted">{e.edition}</Badge>}
                  </div>
                  <div className="mb-1 font-serif text-lg font-medium text-ink">{e.title}</div>
                  <div className="font-sans text-[12.5px] text-muted">
                    {e.lieu} · {e.role}
                  </div>
                  <div className="mt-1.5 font-mono text-[11px] text-muted">
                    Organisé par · {e.organizers.join(', ')}
                  </div>
                </div>
                <Button variant="ghost" size="sm">
                  Voir
                </Button>
              </div>
            ))}
          </div>
        ))}
      </Card>

      <div className="flex flex-col gap-4">
        <Card>
          <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Vue d'ensemble
          </div>
          <h3 className="m-0 mb-3.5 mt-0.5 font-serif text-lg font-medium">Prochains 12 mois</h3>
          <div className="flex flex-col gap-2">
            <Stat label="Conférences" value={events.filter((e) => e.type === 'Conférence').length} />
            <Stat label="Séminaires" value={events.filter((e) => e.type === 'Séminaire').length} />
            <Stat label="Workshops" value={events.filter((e) => e.type === 'Workshop').length} />
          </div>
        </Card>

        <Card>
          <div className="mb-2 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Légende
          </div>
          <div className="flex flex-col gap-1.5 font-sans text-[12.5px]">
            <span>
              <Badge tone="navy">Conférence</Badge> — externe, soumission/présentation
            </span>
            <span>
              <Badge tone="gold">Séminaire</Badge> — invité ou interne
            </span>
            <span>
              <Badge tone="sage">Workshop</Badge> — organisé par le laboratoire
            </span>
          </div>
        </Card>
      </div>
    </div>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div className="border border-line bg-surface-2 px-3 py-2.5">
      <div className="font-mono text-[10px] uppercase tracking-[0.12em] text-muted">{label}</div>
      <div className="mt-0.5 font-serif text-2xl font-medium text-ink [font-variant-numeric:tabular-nums]">
        {value}
      </div>
    </div>
  );
}

function ArchivesView({
  events,
  filterType,
  setFilterType,
  search,
  setSearch,
}: {
  events: EventFull[];
  filterType: 'tous' | EventType;
  setFilterType: (v: 'tous' | EventType) => void;
  search: string;
  setSearch: (v: string) => void;
}) {
  const filtered = events.filter((e) => {
    const matchT = filterType === 'tous' || e.type === filterType;
    const q = search.trim().toLowerCase();
    const matchQ = !q || `${e.title}${e.lieu}${e.organizers.join(' ')}`.toLowerCase().includes(q);
    return matchT && matchQ;
  });
  const byEdition = filtered.filter((e) => e.edition);
  const others = filtered.filter((e) => !e.edition);

  const FILTERS: ('tous' | EventType)[] = ['tous', 'Conférence', 'Séminaire', 'Workshop'];

  return (
    <div>
      <div className="mb-[18px] flex items-center gap-2.5">
        <SearchInput value={search} onChange={setSearch} placeholder="Titre, lieu, organisateur…" className="w-[320px]" />
        {FILTERS.map((t) => (
          <Chip key={t} active={filterType === t} onClick={() => setFilterType(t)}>
            {t === 'tous' ? 'Tous types' : t}
          </Chip>
        ))}
        <div className="ml-auto font-mono text-[11.5px] text-muted">{filtered.length} résultat·s</div>
      </div>

      {byEdition.length > 0 && (
        <>
          <div className="mb-2.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Séries récurrentes — par édition
          </div>
          <div className="mb-6 grid grid-cols-[repeat(auto-fill,minmax(280px,1fr))] gap-3.5">
            {byEdition.map((e) => (
              <EditionCard key={e.id} ev={e} />
            ))}
          </div>
        </>
      )}

      <div className="mb-2.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
        Évènements ponctuels
      </div>
      <Card padded={false}>
        <table className="w-full border-collapse font-sans">
          <thead>
            <tr className="bg-surface-2">
              {['Date', 'Type', 'Titre', 'Lieu', 'Organisateurs', ''].map((h, i) => (
                <th
                  key={i}
                  className="px-2.5 py-2 text-left font-mono text-[11px] font-medium uppercase tracking-[0.1em] text-muted"
                >
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {others.map((e) => (
              <tr key={e.id} className="border-t border-line">
                <td className="px-2.5 py-3 font-mono text-[11.5px] text-muted">{fmtFR(e.date)}</td>
                <td className="px-2.5 py-3">
                  <Badge tone={TYPE_TONE[e.type]}>{e.type}</Badge>
                </td>
                <td className="px-2.5 py-3 font-serif text-[14.5px]">{e.title}</td>
                <td className="px-2.5 py-3 font-sans text-[12.5px] text-muted">{e.lieu}</td>
                <td className="px-2.5 py-3 font-sans text-[12.5px] text-ink">
                  {e.organizers.join(', ')}
                </td>
                <td className="px-2.5 py-3 text-right">
                  <Button variant="ghost" size="sm">
                    Archive
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
    </div>
  );
}

function EditionCard({ ev }: { ev: EventFull }) {
  return (
    <Card padded={false}>
      <div className="flex items-center justify-between bg-surface-2 px-[18px] py-3">
        <Badge tone="muted">{ev.edition}</Badge>
        <span className="font-mono text-[11px] text-muted">{fmtFR(ev.date)}</span>
      </div>
      <div className="p-[18px]">
        <div className="mb-1.5 flex gap-1.5">
          <Badge tone={TYPE_TONE[ev.type]}>{ev.type}</Badge>
        </div>
        <div className="font-serif text-lg font-medium leading-[1.2] text-ink">{ev.title}</div>
        <div className="mt-1 font-sans text-[12.5px] text-muted">{ev.lieu}</div>
        <div className="mt-2.5 border-t border-line pt-2.5 font-mono text-[11px] text-muted">
          {ev.organizers.join(' · ')}
        </div>
      </div>
    </Card>
  );
}

function EventCreateForm() {
  const [title, setTitle] = useState('');
  const [type, setType] = useState<EventType>('Séminaire');
  const [date, setDate] = useState('');
  const [lieu, setLieu] = useState("Ben M'Sik · Amphi A");
  const [team, setTeam] = useState('ia');
  const [edition, setEdition] = useState('');
  const [desc, setDesc] = useState('');

  return (
    <div className="grid grid-cols-[1fr_360px] gap-6">
      <Card>
        <h3 className="m-0 mb-1 font-serif text-xl font-medium">Nouvel évènement scientifique</h3>
        <div className="mb-5 font-sans text-[12.5px] text-muted">
          L'évènement sera ajouté à l'agenda et automatiquement intégré au rapport annuel.
        </div>

        <div className="grid grid-cols-2 gap-x-4 gap-y-[18px]">
          <FormField label="Titre" full>
            <input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Ex. : Workshop CASA-DATA 2027" className={fieldClass} />
          </FormField>
          <FormField label="Type">
            <select value={type} onChange={(e) => setType(e.target.value as EventType)} className={fieldClass}>
              <option>Conférence</option>
              <option>Séminaire</option>
              <option>Workshop</option>
            </select>
          </FormField>
          <FormField label="Date">
            <input type="date" value={date} onChange={(e) => setDate(e.target.value)} className={fieldClass} />
          </FormField>
          <FormField label="Lieu">
            <input value={lieu} onChange={(e) => setLieu(e.target.value)} className={fieldClass} />
          </FormField>
          <FormField label="Équipe porteuse">
            <select value={team} onChange={(e) => setTeam(e.target.value)} className={fieldClass}>
              <option value="ia">IA & Apprentissage</option>
              <option value="bd">Big Data & Fouille</option>
              <option value="nlp">NLP</option>
              <option value="sec">Sécurité & SD</option>
              <option value="">Inter-équipes</option>
            </select>
          </FormField>
          <FormField label="Édition (si série)" full>
            <input value={edition} onChange={(e) => setEdition(e.target.value)} placeholder="Ex. : 8e édition" className={fieldClass} />
          </FormField>
          <FormField label="Description" full>
            <textarea value={desc} onChange={(e) => setDesc(e.target.value)} rows={4} placeholder="Objectifs, public visé, partenaires…" className={`${fieldClass} resize-y`} />
          </FormField>
          <FormField label="Organisateurs" full>
            <div className="flex flex-wrap gap-1.5 border border-line bg-surface-2 p-2">
              <Badge tone="navy">Y. El Amrani ×</Badge>
              <Badge tone="navy">S. Bennani ×</Badge>
              <button className="cursor-pointer rounded-full border border-dashed border-line bg-transparent px-2 py-0.5 font-sans text-[11.5px] text-muted">
                + ajouter
              </button>
            </div>
          </FormField>
        </div>

        <div className="mt-6 flex justify-end gap-2">
          <Button variant="ghost">Annuler</Button>
          <Button variant="ghost">Enregistrer brouillon</Button>
          <Button variant="primary">Publier l'évènement</Button>
        </div>
      </Card>

      <div>
        <Card>
          <div className="mb-2 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Aperçu
          </div>
          <div className="border border-line bg-surface-2 p-[18px]">
            <Badge tone={TYPE_TONE[type]}>{type}</Badge>
            <div className="mt-2 font-serif text-lg font-medium text-ink">
              {title || "Titre de l'évènement"}
            </div>
            <div className="mt-1.5 font-mono text-[11.5px] text-muted">
              {date ? fmtFR(date) : '— date à définir —'}
            </div>
            <div className="mt-0.5 font-sans text-[12.5px] text-muted">{lieu}</div>
          </div>
          <div className="mt-3.5 border-l-2 border-line px-3.5 py-3 font-serif text-[12.5px] italic text-muted">
            Après publication, l'évènement déclenche : notification interne, ajout au calendrier,
            création d'un canal de discussion dédié, et entrée dans l'archive documentaire.
          </div>
        </Card>
      </div>
    </div>
  );
}
