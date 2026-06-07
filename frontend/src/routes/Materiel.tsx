import { useState } from 'react';
import { MATERIEL_ITEMS, MATERIEL_REQUESTS } from '@/data';
import { useSession } from '@/context/SessionContext';
import { Badge, type BadgeTone, Button, Card, KPI, SectionHead } from '@/components/ui';
import { fmtFR } from '@/lib/format';
import type { HolderStatus, MaterialItem, MaterialRequest } from '@/types';

const DOT_COLOR: Record<HolderStatus, string> = {
  livré: '#33503A',
  'en attente': '#C97A2B',
  'en stock': '#1B2F4A',
};
function statusTone(s: HolderStatus): BadgeTone {
  return s === 'livré' ? 'sage' : s === 'en attente' ? 'gold' : 'navy';
}

export default function Materiel() {
  const { roleId } = useSession();
  const [tab, setTab] = useState<'inventaire' | 'demandes' | 'equite'>('inventaire');

  const totalItems = MATERIEL_ITEMS.reduce((s, i) => s + i.qty, 0);
  const distributed = MATERIEL_ITEMS.reduce((s, i) => s + i.distributed, 0);
  const pending = MATERIEL_REQUESTS.filter((r) => r.status === 'en attente').length;

  const TABS: { id: typeof tab; label: string }[] = [
    { id: 'inventaire', label: 'Inventaire & distribution' },
    { id: 'demandes', label: `Demandes (${MATERIEL_REQUESTS.length})` },
    { id: 'equite', label: 'Équité de distribution' },
  ];

  return (
    <div>
      <SectionHead
        eyebrow={`${totalItems} unités au catalogue · ${distributed} distribuées · ${pending} demandes en attente`}
        title="Gestion du matériel"
        subtitle="Suivi des arrivages, distribution équitable et historique complet — qui a reçu quoi, et qui n'a pas encore reçu."
        right={roleId !== 'visiteur' ? <Button variant="primary">+ Demande de matériel</Button> : undefined}
      />

      <div className="mb-6 grid grid-cols-4 gap-3">
        <KPI label="Unités en stock" value={totalItems - distributed} sub="prêtes à distribuer" accent="#33503A" />
        <KPI
          label="Unités distribuées"
          value={distributed}
          sub={`sur ${totalItems} (${Math.round((distributed / totalItems) * 100)} %)`}
        />
        <KPI label="Demandes en attente" value={pending} sub="à arbitrer par la direction" accent="#7A5B2E" />
        <KPI label="Arrivages récents" value={MATERIEL_ITEMS.length} sub="3 derniers mois" />
      </div>

      <div className="mb-5 flex border-b border-line">
        {TABS.map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={`-mb-px border-b-2 px-[18px] py-2.5 font-serif text-[15px] ${
              tab === t.id ? 'border-navy text-ink' : 'border-transparent italic text-muted'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab === 'inventaire' && <InventoryView items={MATERIEL_ITEMS} />}
      {tab === 'demandes' && <RequestsView requests={MATERIEL_REQUESTS} role={roleId} />}
      {tab === 'equite' && <FairnessView items={MATERIEL_ITEMS} />}
    </div>
  );
}

function InventoryView({ items }: { items: MaterialItem[] }) {
  return (
    <div className="flex flex-col gap-4">
      {items.map((item) => {
        const pct = (item.distributed / item.qty) * 100;
        return (
          <Card key={item.id} padded={false}>
            <div className="grid grid-cols-[1fr_200px] items-center gap-6 px-[22px] py-[18px]">
              <div>
                <Badge tone="muted">{item.category}</Badge>
                <h3 className="m-0 my-1 font-serif text-lg font-medium">{item.name}</h3>
                <div className="font-mono text-[11.5px] text-muted">Arrivage du {fmtFR(item.arrived)}</div>
              </div>
              <div>
                <div className="mb-1.5 flex justify-between font-mono text-[11px] text-muted">
                  <span>distribué</span>
                  <span>
                    {item.distributed} / {item.qty}
                  </span>
                </div>
                <div className="relative h-1.5 border border-line bg-surface-2">
                  <div
                    className="absolute inset-0"
                    style={{ width: `${pct}%`, background: pct === 100 ? '#33503A' : 'var(--navy)' }}
                  />
                </div>
              </div>
            </div>

            <div className="border-t border-line bg-surface-2">
              {item.holders.map((h, i) => (
                <div
                  key={i}
                  className={`grid grid-cols-[24px_1fr_auto_auto] items-center gap-3.5 px-[22px] py-2.5 ${
                    i === 0 ? '' : 'border-t border-line'
                  }`}
                >
                  <span
                    className="inline-block h-2.5 w-2.5 rounded-full"
                    style={{ background: DOT_COLOR[h.status] }}
                  />
                  <div className="font-sans text-[13px] text-ink">
                    {h.who}{' '}
                    {h.n && <span className="font-mono text-[11px] text-muted">× {h.n}</span>}
                  </div>
                  <div className="font-mono text-[11px] text-muted">
                    {h.date === '—' ? '—' : fmtFR(h.date)}
                  </div>
                  <Badge tone={statusTone(h.status)}>{h.status}</Badge>
                </div>
              ))}
            </div>
          </Card>
        );
      })}
    </div>
  );
}

function RequestsView({ requests, role }: { requests: MaterialRequest[]; role: string }) {
  return (
    <div className="grid grid-cols-2 gap-3.5">
      {requests.map((r) => (
        <Card key={r.id} padded={false}>
          <div className="px-5 py-4">
            <div className="mb-1.5 flex items-baseline justify-between">
              <Badge tone={r.status === 'en attente' ? 'gold' : r.status === 'acceptée' ? 'sage' : 'burgundy'}>
                {r.status}
              </Badge>
              <span className="font-mono text-[11px] text-muted">{fmtFR(r.submitted)}</span>
            </div>
            <h4 className="m-0 my-1 font-serif text-[17px] font-medium">{r.what}</h4>
            <div className="font-sans text-[12.5px] text-muted">
              Demandé par <strong className="font-medium text-ink">{r.who}</strong>
            </div>
          </div>
          <div className="border-t border-line bg-surface-2 px-5 py-3 font-serif text-[13px] italic leading-[1.45] text-ink">
            « {r.motif} »
          </div>
          {r.status === 'refusée' && r.reason && (
            <div className="border-t border-line px-5 py-2.5 font-sans text-xs text-[#7A2A26]">
              Motif du refus : {r.reason}
            </div>
          )}
          {r.status === 'en attente' && role === 'directeur' && (
            <div className="flex justify-end gap-2 border-t border-line px-5 py-3">
              <Button variant="danger" size="sm">
                Refuser
              </Button>
              <Button variant="accept" size="sm">
                Accepter
              </Button>
            </div>
          )}
        </Card>
      ))}
    </div>
  );
}

function FairnessView({ items }: { items: MaterialItem[] }) {
  const dist: Record<string, number> = { IA: 0, BD: 0, NLP: 0, SEC: 0, Doctorants: 0, Associés: 0 };
  items.forEach((it) => {
    it.holders.forEach((h) => {
      if (h.status !== 'livré') return;
      const n = h.n ?? 1;
      if (h.who.includes('IA')) dist.IA += n;
      else if (h.who.includes('BD')) dist.BD += n;
      else if (h.who.includes('NLP')) dist.NLP += n;
      else if (h.who.includes('SEC')) dist.SEC += n;
      else if (h.who.includes('Doc')) dist.Doctorants += n;
      else if (h.who.includes('associé')) dist.Associés += n;
    });
  });
  const max = Math.max(...Object.values(dist));

  return (
    <div className="grid grid-cols-2 gap-5">
      <Card>
        <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
          Répartition par groupe
        </div>
        <h3 className="m-0 mb-[18px] mt-1 font-serif text-xl font-medium">Cumul des unités reçues</h3>
        {Object.entries(dist).map(([k, v]) => (
          <div key={k} className="mb-3">
            <div className="mb-1 flex justify-between font-sans text-[13px]">
              <span className="text-ink">{k}</span>
              <span className="font-mono text-muted">{v} unité·s</span>
            </div>
            <div className="relative h-3.5 border border-line bg-surface-2">
              <div className="absolute inset-0 bg-navy" style={{ width: max ? `${(v / max) * 100}%` : '0%' }} />
            </div>
          </div>
        ))}
      </Card>

      <Card>
        <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
          Membres en attente
        </div>
        <h3 className="m-0 mb-3.5 mt-1 font-serif text-xl font-medium">Qui n'a pas encore reçu</h3>
        {items.flatMap((it) =>
          it.holders
            .filter((h) => h.status === 'en attente')
            .map((h) => (
              <div
                key={`${it.id}-${h.who}`}
                className="flex items-center justify-between border-t border-line py-3"
              >
                <div>
                  <div className="font-serif text-[14.5px] text-ink">{h.who}</div>
                  <div className="font-sans text-xs text-muted">
                    en attente de <em>{it.name}</em>
                  </div>
                </div>
                <Badge tone="gold">en attente</Badge>
              </div>
            )),
        )}
        <div className="mt-[18px] border-l-2 border-[#C97A2B] bg-surface-2 px-3.5 py-3 font-serif text-[13px] italic leading-[1.5] text-ink">
          Une notification automatique est envoyée chaque semaine au directeur tant que des
          distributions restent en attente.
        </div>
      </Card>
    </div>
  );
}
