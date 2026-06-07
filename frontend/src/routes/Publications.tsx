import { useMemo, useState } from 'react';
import { PUBLICATIONS, TEAMS } from '@/data';
import { useSession } from '@/context/SessionContext';
import {
  Badge,
  Button,
  Card,
  Empty,
  FileIcon,
  FormField,
  SectionHead,
  fieldClass,
} from '@/components/ui';
import type { Publication } from '@/types';

const TEAM_LABELS: Record<string, string> = { ia: 'IA', bd: 'BD', nlp: 'NLP', sec: 'SEC' };

export default function Publications() {
  const { roleId } = useSession();
  const [tab, setTab] = useState<'list' | 'add'>('list');
  const [filterAuthor, setFilterAuthor] = useState('tous');
  const [filterYear, setFilterYear] = useState('toutes');
  const [filterTeam, setFilterTeam] = useState('toutes');
  const [filterType, setFilterType] = useState('tous');
  const [search, setSearch] = useState('');
  const [sortBy, setSortBy] = useState('year-desc');

  const years = [...new Set(PUBLICATIONS.map((p) => p.year))].sort((a, b) => b - a);
  const authors = [...new Set(PUBLICATIONS.flatMap((p) => p.authors))].sort();

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    let out = PUBLICATIONS.filter((p) => {
      const matchQ = !q || `${p.title} ${p.authors.join(' ')} ${p.venue}`.toLowerCase().includes(q);
      const matchA = filterAuthor === 'tous' || p.authors.includes(filterAuthor);
      const matchY = filterYear === 'toutes' || String(p.year) === filterYear;
      const matchT = filterTeam === 'toutes' || p.team === filterTeam;
      const matchType = filterType === 'tous' || p.type === filterType;
      return matchQ && matchA && matchY && matchT && matchType;
    });
    out = [...out];
    if (sortBy === 'year-desc') out.sort((a, b) => b.year - a.year);
    if (sortBy === 'year-asc') out.sort((a, b) => a.year - b.year);
    if (sortBy === 'title') out.sort((a, b) => a.title.localeCompare(b.title));
    if (sortBy === 'venue') out.sort((a, b) => a.venue.localeCompare(b.venue));
    return out;
  }, [search, filterAuthor, filterYear, filterTeam, filterType, sortBy]);

  return (
    <div>
      <SectionHead
        eyebrow={`${PUBLICATIONS.length} publications enregistrées · revues, conférences, ouvrages`}
        title="Publications scientifiques"
        subtitle="Catalogue des productions du laboratoire. Tout membre peut ajouter ses publications ; le directeur valide pour intégration au rapport annuel."
        right={
          roleId !== 'visiteur' ? (
            <Button variant="primary" onClick={() => setTab(tab === 'add' ? 'list' : 'add')}>
              {tab === 'add' ? '← Liste' : '+ Ajouter une publication'}
            </Button>
          ) : undefined
        }
      />

      {tab === 'list' && (
        <>
          <Card className="mb-3.5">
            <div className="grid grid-cols-[1.4fr_1fr_1fr_1fr_1fr] items-end gap-2.5">
              <FormField label="Recherche">
                <input
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  placeholder="Titre, auteur, revue…"
                  className={fieldClass}
                />
              </FormField>
              <FormField label="Auteur">
                <select value={filterAuthor} onChange={(e) => setFilterAuthor(e.target.value)} className={fieldClass}>
                  <option value="tous">Tous</option>
                  {authors.map((a) => (
                    <option key={a}>{a}</option>
                  ))}
                </select>
              </FormField>
              <FormField label="Année">
                <select value={filterYear} onChange={(e) => setFilterYear(e.target.value)} className={fieldClass}>
                  <option value="toutes">Toutes</option>
                  {years.map((y) => (
                    <option key={y}>{y}</option>
                  ))}
                </select>
              </FormField>
              <FormField label="Équipe">
                <select value={filterTeam} onChange={(e) => setFilterTeam(e.target.value)} className={fieldClass}>
                  <option value="toutes">Toutes</option>
                  {TEAMS.map((t) => (
                    <option key={t.id} value={t.id}>
                      {t.short}
                    </option>
                  ))}
                </select>
              </FormField>
              <FormField label="Type">
                <select value={filterType} onChange={(e) => setFilterType(e.target.value)} className={fieldClass}>
                  <option value="tous">Tous</option>
                  <option>Revue</option>
                  <option>Conf.</option>
                </select>
              </FormField>
            </div>

            <div className="mt-2.5 flex items-center justify-between border-t border-line pt-2.5">
              <div className="font-mono text-[11.5px] text-muted">
                {filtered.length} publication·s · {filtered.filter((p) => p.type === 'Revue').length} revues
                · {filtered.filter((p) => p.type === 'Conf.').length} conférences
              </div>
              <div className="flex items-center gap-2">
                <span className="font-mono text-[11px] uppercase tracking-[0.1em] text-muted">Trier par</span>
                <select
                  value={sortBy}
                  onChange={(e) => setSortBy(e.target.value)}
                  className={`${fieldClass} w-auto`}
                >
                  <option value="year-desc">Année (récent → ancien)</option>
                  <option value="year-asc">Année (ancien → récent)</option>
                  <option value="title">Titre</option>
                  <option value="venue">Revue / conférence</option>
                </select>
              </div>
            </div>
          </Card>

          <PublicationsByYear publications={filtered} />
        </>
      )}

      {tab === 'add' && <PublicationForm onCancel={() => setTab('list')} />}
    </div>
  );
}

function PublicationsByYear({ publications }: { publications: Publication[] }) {
  const grouped = publications.reduce<Record<number, Publication[]>>((acc, p) => {
    (acc[p.year] = acc[p.year] ?? []).push(p);
    return acc;
  }, {});
  const years = Object.keys(grouped)
    .map(Number)
    .sort((a, b) => b - a);

  if (publications.length === 0) {
    return (
      <Card>
        <Empty title="Aucune publication ne correspond." sub="Modifiez les filtres." />
      </Card>
    );
  }

  return (
    <div>
      {years.map((year) => (
        <div key={year} className="mb-8">
          <div className="mb-3 flex items-baseline gap-3.5 border-b border-line pb-2">
            <h2 className="m-0 font-serif text-[34px] font-medium tracking-[-0.01em] [font-variant-numeric:tabular-nums]">
              {year}
            </h2>
            <span className="font-mono text-[11px] uppercase tracking-[0.1em] text-muted">
              {grouped[year].length} publication·s
            </span>
          </div>
          {grouped[year].map((p) => (
            <PublicationRow key={p.id} pub={p} />
          ))}
        </div>
      ))}
    </div>
  );
}

function PublicationRow({ pub }: { pub: Publication }) {
  return (
    <div className="grid grid-cols-[80px_1fr_120px] items-start gap-[18px] border-b border-line py-4">
      <div>
        <Badge tone={pub.type === 'Revue' ? 'navy' : 'gold'}>{pub.type}</Badge>
        <div className="mt-2 font-mono text-[10.5px] uppercase tracking-[0.1em] text-muted">
          [{TEAM_LABELS[pub.team] ?? '—'}]
        </div>
      </div>
      <div>
        <div className="font-serif text-[17px] font-medium leading-[1.3] text-ink">{pub.title}</div>
        <div className="mt-1.5 font-sans text-[13px] text-ink">{pub.authors.join(', ')}</div>
        <div className="mt-1 font-serif text-[13px] italic text-muted">
          {pub.venue}, {pub.year}
        </div>
      </div>
      <div className="flex flex-col items-end gap-1.5">
        <Button variant="ghost" size="sm">
          ⤓ PDF
        </Button>
        <Button variant="bare" size="sm" className="text-[11px] text-muted">
          BibTeX
        </Button>
      </div>
    </div>
  );
}

function PublicationForm({ onCancel }: { onCancel: () => void }) {
  const [title, setTitle] = useState('');
  const [authors, setAuthors] = useState<string[]>(['Y. El Amrani']);
  const [authorInput, setAuthorInput] = useState('');
  const [year, setYear] = useState(2026);
  const [type, setType] = useState('Conf.');
  const [venue, setVenue] = useState('');
  const [team, setTeam] = useState('ia');
  const [doi, setDoi] = useState('');
  const [abstract, setAbstract] = useState('');

  return (
    <div className="grid grid-cols-[1fr_360px] gap-6">
      <Card>
        <h3 className="m-0 mb-1 font-serif text-[22px] font-medium">Nouvelle publication</h3>
        <div className="mb-6 font-sans text-[12.5px] text-muted">
          La publication sera ajoutée au catalogue après validation par le directeur ou un chef
          d'équipe.
        </div>

        <div className="grid grid-cols-2 gap-x-4 gap-y-[18px]">
          <FormField label="Titre" full>
            <input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Titre exact de l'article" className={fieldClass} />
          </FormField>

          <FormField label="Auteurs (ordre d'apparition)" full>
            <div className="flex flex-wrap gap-1.5 border border-line bg-surface-2 p-2">
              {authors.map((a, i) => (
                <span
                  key={i}
                  className="inline-flex items-center gap-1.5 rounded-full bg-navy px-2.5 py-1 font-sans text-[12.5px] text-cream"
                >
                  <span className="font-mono text-[10px] opacity-60">{i + 1}.</span>
                  {a}
                  <button
                    onClick={() => setAuthors(authors.filter((_, j) => j !== i))}
                    className="cursor-pointer border-none bg-transparent p-0 leading-none text-cream"
                  >
                    ×
                  </button>
                </span>
              ))}
              <input
                value={authorInput}
                onChange={(e) => setAuthorInput(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && authorInput.trim()) {
                    e.preventDefault();
                    setAuthors([...authors, authorInput.trim()]);
                    setAuthorInput('');
                  }
                }}
                placeholder="+ tapez un nom puis Entrée"
                className="min-w-[180px] flex-1 border-none bg-transparent px-2 py-1 font-sans text-[12.5px] outline-none"
              />
            </div>
          </FormField>

          <FormField label="Type">
            <select value={type} onChange={(e) => setType(e.target.value)} className={fieldClass}>
              <option>Revue</option>
              <option>Conf.</option>
              <option>Ouvrage</option>
              <option>Chapitre</option>
              <option>Thèse</option>
            </select>
          </FormField>

          <FormField label="Année">
            <input type="number" value={year} onChange={(e) => setYear(+e.target.value)} min="2000" max="2030" className={fieldClass} />
          </FormField>

          <FormField label="Revue / Conférence" full>
            <input value={venue} onChange={(e) => setVenue(e.target.value)} placeholder="Ex. : IEEE TNNLS · NeurIPS · ACM CSUR…" className={fieldClass} />
          </FormField>

          <FormField label="Équipe">
            <select value={team} onChange={(e) => setTeam(e.target.value)} className={fieldClass}>
              <option value="ia">IA & Apprentissage</option>
              <option value="bd">Big Data & Fouille</option>
              <option value="nlp">NLP</option>
              <option value="sec">Sécurité & SD</option>
            </select>
          </FormField>

          <FormField label="DOI">
            <input value={doi} onChange={(e) => setDoi(e.target.value)} placeholder="10.1109/…" className={`${fieldClass} font-mono text-[12.5px]`} />
          </FormField>

          <FormField label="Résumé (optionnel)" full>
            <textarea value={abstract} onChange={(e) => setAbstract(e.target.value)} rows={4} className={`${fieldClass} resize-y`} />
          </FormField>

          <FormField label="Fichier PDF" full>
            <div className="flex items-center gap-3 border border-dashed border-line bg-surface-2 p-3.5">
              <FileIcon type="pdf" />
              <div className="flex-1 font-sans text-[12.5px] text-muted">
                Aucun fichier sélectionné — 10 MB max
              </div>
              <Button variant="ghost" size="sm">
                Parcourir
              </Button>
            </div>
          </FormField>
        </div>

        <div className="mt-6 flex justify-end gap-2">
          <Button variant="ghost" onClick={onCancel}>
            Annuler
          </Button>
          <Button variant="primary">Soumettre pour validation</Button>
        </div>
      </Card>

      <div>
        <Card>
          <div className="mb-2.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Aperçu citation
          </div>
          <div className="border-l-[3px] border-navy bg-surface-2 p-4 font-serif text-[13.5px] leading-[1.5] text-ink">
            {authors.map((a) => a.split(' ').pop()).join(', ')}
            {authors.length > 0 && '. '}
            <em>{title || '[Titre]'}</em>. {venue || '[Revue]'}, {year}.
          </div>

          <div className="mb-2.5 mt-[18px] font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            BibTeX généré
          </div>
          <pre className="m-0 overflow-auto bg-ink p-3.5 font-mono text-[11px] leading-[1.5] text-cream">
            {`@${type === 'Revue' ? 'article' : 'inproceedings'}{lias${year},
  title = {${title || '...'}},
  author = {${authors.join(' and ')}},
  ${type === 'Revue' ? 'journal' : 'booktitle'} = {${venue || '...'}},
  year = {${year}},
}`}
          </pre>
        </Card>
      </div>
    </div>
  );
}
