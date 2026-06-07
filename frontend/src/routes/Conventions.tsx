import { useState } from 'react';
import { PARTNERS } from '@/data';
import { useSession } from '@/context/SessionContext';
import { Badge, Button, Card, Chip, IconBtn, KPI, SearchInput, SectionHead } from '@/components/ui';
import { fmtMonthYearFR } from '@/lib/format';
import type { Partner } from '@/types';

type Filter = 'actives' | 'renouveler' | 'terminees' | 'toutes';

const TYPE_PALETTE: Record<Partner['type'], { bg: string; fg: string }> = {
  Industrie: { bg: '#E9D9D6', fg: '#7A2A26' },
  Recherche: { bg: '#DBE5F0', fg: '#1B2F4A' },
  Académique: { bg: '#EDE5D3', fg: '#7A5B2E' },
};

export default function Conventions() {
  const { roleId } = useSession();
  const [filter, setFilter] = useState<Filter>('actives');
  const [search, setSearch] = useState('');

  const stats = {
    actives: PARTNERS.filter((p) => p.status === 'active').length,
    renouveler: PARTNERS.filter((p) => p.status === 'à renouveler').length,
    terminees: PARTNERS.filter((p) => p.status === 'terminée').length,
  };

  const filtered = PARTNERS.filter((p) => {
    const matchF =
      filter === 'toutes' ||
      (filter === 'actives' && p.status === 'active') ||
      (filter === 'renouveler' && p.status === 'à renouveler') ||
      (filter === 'terminees' && p.status === 'terminée');
    const q = search.trim().toLowerCase();
    const matchQ = !q || `${p.name}${p.type}${p.country}`.toLowerCase().includes(q);
    return matchF && matchQ;
  });

  const FILTERS: { id: Filter; label: string }[] = [
    { id: 'actives', label: `Actives (${stats.actives})` },
    { id: 'renouveler', label: `À renouveler (${stats.renouveler})` },
    { id: 'terminees', label: `Terminées (${stats.terminees})` },
    { id: 'toutes', label: 'Toutes' },
  ];

  return (
    <div>
      <SectionHead
        eyebrow={`${stats.actives} conventions actives · ${stats.renouveler} à renouveler · ${stats.terminees} terminées`}
        title="Conventions & collaborations"
        subtitle="Partenaires industriels, académiques et institutionnels du laboratoire. Chaque convention est archivée avec ses activités associées."
        right={roleId === 'directeur' ? <Button variant="primary">+ Nouvelle convention</Button> : undefined}
      />

      <div className="mb-[22px] grid grid-cols-3 gap-3">
        <KPI label="Financement total mobilisé" value="€ 210 K" sub="+ 1.03 M MAD" />
        <KPI label="Pays partenaires" value="2" sub="Maroc · France" />
        <KPI label="Activités liées" value="13" sub="thèses, workshops, projets" />
      </div>

      <div className="mb-[18px] flex items-center gap-2.5">
        <SearchInput value={search} onChange={setSearch} placeholder="Nom, pays, type…" className="w-[320px]" />
        {FILTERS.map((t) => (
          <Chip key={t.id} active={filter === t.id} onClick={() => setFilter(t.id)}>
            {t.label}
          </Chip>
        ))}
      </div>

      <div className="grid grid-cols-[repeat(auto-fill,minmax(360px,1fr))] gap-3.5">
        {filtered.map((p) => (
          <PartnerCard key={p.id} p={p} />
        ))}
      </div>
    </div>
  );
}

function PartnerCard({ p }: { p: Partner }) {
  const today = new Date('2026-05-26').getTime();
  const start = new Date(p.since).getTime();
  const end = new Date(p.until).getTime();
  const monthsLeft = Math.round((end - today) / (1000 * 60 * 60 * 24 * 30));
  const pct = Math.max(0, Math.min(100, ((today - start) / (end - start)) * 100));
  const tp = TYPE_PALETTE[p.type];

  return (
    <Card padded={false}>
      <div className="border-b border-line px-5 pb-3.5 pt-[18px]">
        <div className="flex items-start gap-3.5">
          <div
            className="flex h-[54px] w-[54px] items-center justify-center font-serif text-[22px] font-semibold tracking-[-0.02em]"
            style={{ background: tp.bg, color: tp.fg, border: `1px solid ${tp.fg}` }}
          >
            {p.short}
          </div>
          <div className="min-w-0 flex-1">
            <div className="mb-1 flex flex-wrap gap-1.5">
              <Badge tone={p.status === 'active' ? 'sage' : p.status === 'à renouveler' ? 'gold' : 'muted'}>
                {p.status}
              </Badge>
              <Badge tone="neutral">{p.type}</Badge>
            </div>
            <h3 className="m-0 my-1 font-serif text-lg font-medium leading-[1.2] tracking-[-0.005em]">
              {p.name}
            </h3>
            <div className="font-mono text-[11px] tracking-[0.08em] text-muted">
              {p.country.toUpperCase()}
            </div>
          </div>
        </div>
      </div>

      <div className="px-5 pb-3.5 pt-3">
        <div className="mb-1.5 flex justify-between font-mono text-[10.5px] text-muted">
          <span>{fmtMonthYearFR(p.since)}</span>
          <span>{p.status === 'active' ? (monthsLeft > 0 ? `${monthsLeft} mois restants` : 'expirée') : ''}</span>
          <span>{fmtMonthYearFR(p.until)}</span>
        </div>
        <div className="relative h-1 border border-line bg-surface-2">
          <div
            className="absolute inset-0"
            style={{ width: `${pct}%`, background: p.status === 'à renouveler' ? '#C97A2B' : 'var(--navy)' }}
          />
        </div>
      </div>

      <div className="border-t border-line px-5 py-3">
        <div className="mb-2 font-mono text-[10px] uppercase tracking-[0.15em] text-muted">
          Activités associées
        </div>
        <ul className="m-0 list-none p-0">
          {p.activities.map((a, i) => (
            <li key={i} className="flex gap-2 py-1 font-serif text-[13.5px] text-ink">
              <span className="font-mono text-[11px] text-muted">—</span>
              <span>{a}</span>
            </li>
          ))}
        </ul>
      </div>

      <div className="flex items-center justify-between border-t border-line bg-surface-2 px-5 py-2.5">
        <div className="font-mono text-[11px] text-muted">
          Réf. <strong className="text-ink">{p.lead}</strong> · {p.funding}
        </div>
        <div className="flex gap-1">
          <IconBtn title="Documents">▤</IconBtn>
          <IconBtn title="Détail">→</IconBtn>
        </div>
      </div>
    </Card>
  );
}
