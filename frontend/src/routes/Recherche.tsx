import { Fragment, type ReactNode, useMemo, useState } from 'react';
import { Search } from 'lucide-react';
import { DOCUMENTS, EVENTS_FULL, MEMBERS, PARTNERS, PUBLICATIONS } from '@/data';
import { Avatar, Badge, Button, Card, Empty, FileIcon, SectionHead, StatusBadge } from '@/components/ui';
import { fmtFR } from '@/lib/format';
import type { DocFile } from '@/types';

type FoundDoc = DocFile & { path: string };

export default function Recherche() {
  const [query, setQuery] = useState('Aya');
  const [category, setCategory] = useState('tout');

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return { members: [], pubs: [], events: [], docs: [] as FoundDoc[], partners: [], total: 0 };

    const members = MEMBERS.filter((m) =>
      `${m.firstName} ${m.lastName} ${m.interests.join(' ')} ${m.team_label} ${m.bio}`
        .toLowerCase()
        .includes(q),
    );
    const pubs = PUBLICATIONS.filter((p) =>
      `${p.title} ${p.authors.join(' ')} ${p.venue}`.toLowerCase().includes(q),
    );
    const events = EVENTS_FULL.filter((e) =>
      `${e.title} ${e.lieu} ${e.organizers.join(' ')}`.toLowerCase().includes(q),
    );
    const partners = PARTNERS.filter((p) =>
      `${p.name} ${p.type} ${p.activities.join(' ')}`.toLowerCase().includes(q),
    );
    const docs: FoundDoc[] = [];
    Object.entries(DOCUMENTS).forEach(([root, subs]) => {
      Object.entries(subs).forEach(([sub, content]) => {
        const flat = Array.isArray(content) ? content : Object.values(content).flat();
        flat.forEach((d) => {
          if (d.name.toLowerCase().includes(q)) docs.push({ ...d, path: `${root} / ${sub}` });
        });
      });
    });

    return {
      members,
      pubs,
      events,
      docs,
      partners,
      total: members.length + pubs.length + events.length + docs.length + partners.length,
    };
  }, [query]);

  const cats = [
    { id: 'tout', label: 'Tout', count: results.total },
    { id: 'membres', label: 'Membres', count: results.members.length },
    { id: 'pubs', label: 'Publications', count: results.pubs.length },
    { id: 'events', label: 'Évènements', count: results.events.length },
    { id: 'docs', label: 'Documents', count: results.docs.length },
    { id: 'partners', label: 'Partenaires', count: results.partners.length },
  ];

  const showCat = (id: string) => category === 'tout' || category === id;

  return (
    <div>
      <SectionHead
        eyebrow="Index global · 412 documents · 11 membres · 12 publications · 7 partenaires"
        title="Recherche dans le laboratoire"
        subtitle="Une requête, tous les corpus : profils, publications, évènements, documents archivés et conventions."
      />

      <div className="mb-[18px] flex items-center gap-3.5 border border-line bg-surface px-[22px] py-[18px]">
        <Search size={22} strokeWidth={1.6} className="text-muted" />
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          autoFocus
          placeholder="Tapez un mot-clé : nom, sujet, titre, organisation…"
          className="flex-1 border-none bg-transparent font-serif text-[22px] text-ink outline-none"
        />
        <span className="font-mono text-xs text-muted">{results.total} résultat·s</span>
      </div>

      <div className="mb-6 flex border-b border-line">
        {cats.map((c) => (
          <button
            key={c.id}
            onClick={() => setCategory(c.id)}
            className={`-mb-px inline-flex items-center gap-1.5 border-b-2 px-4 py-2.5 font-sans text-[13.5px] ${
              category === c.id ? 'border-navy font-medium text-ink' : 'border-transparent text-muted'
            }`}
          >
            {c.label}
            <span
              className={`rounded-full px-1.5 py-px font-mono text-[10.5px] ${
                category === c.id ? 'bg-navy text-cream' : 'bg-surface-2 text-muted'
              }`}
            >
              {c.count}
            </span>
          </button>
        ))}
      </div>

      {results.total === 0 && (
        <Empty title={`Aucun résultat pour « ${query} »`} sub="Essayez un autre mot-clé." />
      )}

      {showCat('membres') && results.members.length > 0 && (
        <ResultGroup label="Membres" count={results.members.length}>
          {results.members.map((m) => (
            <Card key={m.id} padded={false} className="mb-2.5">
              <div className="flex items-center gap-3.5 px-[18px] py-3.5">
                <Avatar initials={m.initials} size={44} status={m.status} />
                <div className="flex-1">
                  <Highlight text={`${m.firstName} ${m.lastName}`} q={query} className="font-serif text-base font-medium text-ink" />
                  <div className="mt-0.5 font-sans text-[12.5px] text-muted">
                    {m.grade} · {m.team_label}
                  </div>
                </div>
                <StatusBadge status={m.status} />
              </div>
            </Card>
          ))}
        </ResultGroup>
      )}

      {showCat('pubs') && results.pubs.length > 0 && (
        <ResultGroup label="Publications" count={results.pubs.length}>
          {results.pubs.map((p) => (
            <Card key={p.id} padded={false} className="mb-2.5">
              <div className="px-[18px] py-3.5">
                <Badge tone={p.type === 'Revue' ? 'navy' : 'gold'}>{p.type}</Badge>
                <Highlight text={p.title} q={query} className="mt-1.5 font-serif text-[15.5px] font-medium text-ink" />
                <div className="mt-1 font-sans text-[12.5px] text-muted">
                  {p.authors.join(', ')} · <em>{p.venue}</em>, {p.year}
                </div>
              </div>
            </Card>
          ))}
        </ResultGroup>
      )}

      {showCat('events') && results.events.length > 0 && (
        <ResultGroup label="Évènements" count={results.events.length}>
          {results.events.map((e) => (
            <Card key={e.id} padded={false} className="mb-2.5">
              <div className="flex items-center gap-3.5 px-[18px] py-3.5">
                <div className="min-w-[90px] font-mono text-xs text-muted">{fmtFR(e.date)}</div>
                <div className="flex-1">
                  <Badge tone="navy">{e.type}</Badge>
                  <Highlight text={e.title} q={query} className="mt-1 font-serif text-[15px] font-medium text-ink" />
                  <div className="mt-0.5 font-sans text-xs text-muted">{e.lieu}</div>
                </div>
              </div>
            </Card>
          ))}
        </ResultGroup>
      )}

      {showCat('docs') && results.docs.length > 0 && (
        <ResultGroup label="Documents" count={results.docs.length}>
          {results.docs.map((d, i) => (
            <Card key={i} padded={false} className="mb-2.5">
              <div className="flex items-center gap-3.5 px-[18px] py-3.5">
                <FileIcon type={d.type} />
                <div className="flex-1">
                  <Highlight text={d.name} q={query} className="font-serif text-[14.5px] text-ink" />
                  <div className="mt-0.5 font-mono text-[11px] text-muted">
                    {d.path} · {d.size}
                  </div>
                </div>
                <Button variant="ghost" size="sm">
                  ⤓
                </Button>
              </div>
            </Card>
          ))}
        </ResultGroup>
      )}

      {showCat('partners') && results.partners.length > 0 && (
        <ResultGroup label="Partenaires" count={results.partners.length}>
          {results.partners.map((p) => (
            <Card key={p.id} padded={false} className="mb-2.5">
              <div className="flex items-center gap-3.5 px-[18px] py-3.5">
                <div className="flex h-[42px] w-[42px] items-center justify-center border border-line bg-surface-2 font-serif text-lg font-semibold text-navy">
                  {p.short}
                </div>
                <div className="flex-1">
                  <Highlight text={p.name} q={query} className="font-serif text-base font-medium text-ink" />
                  <div className="mt-0.5 font-sans text-xs text-muted">
                    {p.type} · {p.country}
                  </div>
                </div>
                <Badge tone={p.status === 'active' ? 'sage' : 'muted'}>{p.status}</Badge>
              </div>
            </Card>
          ))}
        </ResultGroup>
      )}
    </div>
  );
}

function ResultGroup({ label, count, children }: { label: string; count: number; children: ReactNode }) {
  return (
    <div className="mb-7">
      <div className="mb-2.5 flex items-baseline gap-2.5">
        <h3 className="m-0 font-serif text-xl font-medium tracking-[-0.005em]">{label}</h3>
        <span className="font-mono text-[11px] uppercase tracking-[0.1em] text-muted">
          {count} résultat·s
        </span>
      </div>
      {children}
    </div>
  );
}

function Highlight({ text, q, className }: { text: string; q: string; className?: string }) {
  if (!q.trim()) return <div className={className}>{text}</div>;
  const parts = text.split(new RegExp(`(${q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi'));
  return (
    <div className={className}>
      {parts.map((p, i) =>
        p.toLowerCase() === q.toLowerCase() ? (
          <mark key={i} className="bg-[rgba(176,136,56,0.32)] px-0.5 text-ink">
            {p}
          </mark>
        ) : (
          <Fragment key={i}>{p}</Fragment>
        ),
      )}
    </div>
  );
}
