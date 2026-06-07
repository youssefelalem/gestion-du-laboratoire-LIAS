import { useState } from 'react';
import { MEETINGS } from '@/data';
import { useSession } from '@/context/SessionContext';
import { Badge, Button, Card, Chip, FileIcon, SectionHead } from '@/components/ui';
import { fmtFR } from '@/lib/format';
import type { Meeting } from '@/types';

type Filter = 'toutes' | 'à venir' | 'passées';

export default function PV() {
  const { roleId } = useSession();
  const [selectedId, setSelectedId] = useState(MEETINGS[0].id);
  const [filter, setFilter] = useState<Filter>('toutes');

  const filtered = MEETINGS.filter(
    (m) =>
      filter === 'toutes' ||
      (filter === 'à venir' && m.status === 'à venir') ||
      (filter === 'passées' && m.status === 'passée'),
  );
  const sel = MEETINGS.find((m) => m.id === selectedId);

  const FILTERS: { id: Filter; label: string }[] = [
    { id: 'toutes', label: 'Toutes' },
    { id: 'à venir', label: 'À venir' },
    { id: 'passées', label: 'Passées' },
  ];

  return (
    <div>
      <SectionHead
        eyebrow={`${MEETINGS.filter((m) => m.status === 'à venir').length} réunions à venir · ${MEETINGS.filter((m) => m.pv).length} PV archivés`}
        title="Procès-verbaux & réunions"
        subtitle="Ordre du jour, comptes-rendus signés, et archivage des décisions du laboratoire."
        right={roleId !== 'visiteur' ? <Button variant="primary">+ Programmer une réunion</Button> : undefined}
      />

      <div className="grid grid-cols-[380px_1fr] gap-5">
        <div>
          <div className="mb-3 flex gap-1.5">
            {FILTERS.map((t) => (
              <Chip key={t.id} active={filter === t.id} onClick={() => setFilter(t.id)}>
                {t.label}
              </Chip>
            ))}
          </div>

          <Card padded={false}>
            {filtered.map((m, i) => {
              const active = m.id === selectedId;
              const d = new Date(m.date);
              return (
                <button
                  key={m.id}
                  onClick={() => setSelectedId(m.id)}
                  className={`grid w-full grid-cols-[56px_1fr_auto] items-center gap-3.5 border-l-2 px-[18px] py-4 text-left ${
                    active ? 'border-l-navy bg-surface-2' : 'border-l-transparent'
                  } ${i === 0 ? '' : 'border-t border-t-line'}`}
                >
                  <div className="border-r border-line pr-3.5 text-center">
                    <div className="font-mono text-[10px] uppercase tracking-[0.12em] text-muted">
                      {d.toLocaleDateString('fr-FR', { month: 'short' })}
                    </div>
                    <div className="font-serif text-2xl font-medium leading-none text-ink">{d.getDate()}</div>
                    <div className="mt-0.5 font-mono text-[10px] text-muted">{d.getFullYear()}</div>
                  </div>
                  <div className="min-w-0">
                    <div className="overflow-hidden text-ellipsis whitespace-nowrap font-serif text-[15px] font-medium text-ink">
                      {m.title}
                    </div>
                    <div className="mt-0.5 font-sans text-[11.5px] text-muted">
                      {m.time} · {m.duration} · {m.lieu.split('·')[0].trim()}
                    </div>
                    <div className="mt-0.5 font-mono text-[10.5px] uppercase tracking-[0.1em] text-muted">
                      présidée · {m.chair}
                    </div>
                  </div>
                  <div>
                    {m.status === 'à venir' ? (
                      <Badge tone="gold">à venir</Badge>
                    ) : m.pv?.validated ? (
                      <Badge tone="sage">PV signé</Badge>
                    ) : (
                      <Badge tone="muted">PV en attente</Badge>
                    )}
                  </div>
                </button>
              );
            })}
          </Card>
        </div>

        <div>{sel && <MeetingDetail m={sel} role={roleId} />}</div>
      </div>
    </div>
  );
}

function MeetingDetail({ m, role }: { m: Meeting; role: string }) {
  return (
    <Card>
      <div className="mb-3 flex items-start justify-between">
        <div>
          <Badge tone={m.status === 'à venir' ? 'gold' : 'navy'}>{m.status}</Badge>
          <h2 className="m-0 mb-1 mt-2 font-serif text-[28px] font-medium tracking-[-0.01em]">{m.title}</h2>
          <div className="font-mono text-xs text-muted">
            {fmtFR(m.date)} · {m.time} · {m.duration} · {m.lieu}
          </div>
        </div>
        {m.status === 'à venir' && role !== 'visiteur' && (
          <Button variant="ghost" size="sm">
            ↗ Ajouter au calendrier
          </Button>
        )}
      </div>

      <div className="grid grid-cols-[140px_1fr] items-start gap-3.5 border-t border-line py-3.5">
        <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">Présidence</div>
        <div className="font-serif text-[15px] text-ink">{m.chair}</div>
      </div>
      <div className="grid grid-cols-[140px_1fr] items-start gap-3.5 border-t border-line py-3.5">
        <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">Participants</div>
        <div className="flex flex-wrap gap-1.5">
          {m.attendees.map((a, i) => (
            <Badge key={i} tone="navy">
              {a}
            </Badge>
          ))}
        </div>
      </div>

      <div className="mt-1.5 border-t border-line pb-1.5 pt-[18px]">
        <div className="mb-2.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
          Ordre du jour
        </div>
        <ol className="m-0 list-none p-0">
          {m.agenda.map((a, i) => (
            <li
              key={i}
              className={`grid grid-cols-[34px_1fr] items-baseline gap-3 py-2.5 ${
                i === 0 ? '' : 'border-t border-line'
              }`}
            >
              <span className="font-mono text-xs tracking-[0.05em] text-muted">
                {String(i + 1).padStart(2, '0')}
              </span>
              <span className="font-serif text-[15px] leading-[1.45] text-ink">{a}</span>
            </li>
          ))}
        </ol>
      </div>

      <div className="mt-[22px] border border-line bg-surface-2 p-[18px]">
        <div className="mb-2.5 flex items-baseline justify-between">
          <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">Procès-verbal</div>
          {m.pv?.validated && (
            <span className="font-mono text-[10.5px] uppercase tracking-[0.1em] text-[#33503A]">
              ✓ signé par {m.pv.signedBy}
            </span>
          )}
        </div>

        {m.pv ? (
          <div className="flex items-center gap-3.5 border border-line bg-surface px-4 py-3.5">
            <FileIcon type="pdf" />
            <div className="flex-1">
              <div className="font-serif text-[15px] text-ink">{m.pv.file}</div>
              <div className="mt-0.5 font-mono text-[11px] text-muted">
                PDF · {m.pv.size} {m.pv.validated ? '· archivé définitivement' : '· en attente de signature'}
              </div>
            </div>
            <Button variant="ghost" size="sm">
              ⤓ Télécharger
            </Button>
            {!m.pv.validated && role === 'directeur' && (
              <Button variant="primary" size="sm">
                Signer & archiver
              </Button>
            )}
          </div>
        ) : (
          <div className="border border-dashed border-line bg-surface px-6 py-6 text-center">
            <div className="font-serif text-[15px] italic text-muted">
              Aucun PV n'est encore disponible pour cette réunion.
            </div>
            {role !== 'visiteur' && (
              <Button variant="ghost" size="md" className="mt-3">
                ⤒ Téléverser le PV
              </Button>
            )}
          </div>
        )}
      </div>

      {m.pv?.validated && (
        <div className="mt-[18px]">
          <div className="mb-2 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Décisions traçables
          </div>
          <ul className="m-0 list-none p-0">
            {[
              "Validation du rapport intermédiaire — voté à l'unanimité",
              'Distribution du matériel reçu — déléguée à F. Z. Idrissi',
              'Convention CNRS-LIPN — signée le 10/02/2026',
            ].map((d, i) => (
              <li key={i} className="border-t border-line py-2 font-serif text-sm text-ink">
                → {d}
              </li>
            ))}
          </ul>
        </div>
      )}
    </Card>
  );
}
