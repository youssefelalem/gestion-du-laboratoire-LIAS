import { useState } from 'react';
import { MANDATS } from '@/data';
import { useSession } from '@/context/SessionContext';
import { Badge, Card, SectionHead } from '@/components/ui';
import { daysBetween, fmtFR } from '@/lib/format';

const FROM_YEAR = 2014;
const TO_YEAR = 2027;
const TOTAL_YEARS = TO_YEAR - FROM_YEAR;
const TODAY = new Date('2026-05-26');
const TODAY_PCT = ((TODAY.getFullYear() + TODAY.getMonth() / 12 - FROM_YEAR) / TOTAL_YEARS) * 100;

const GOV_EVENTS: { date: string; label: string; lane: number }[] = [
  { date: '2014-09-01', label: 'Création gouvernance formelle', lane: 0 },
  { date: '2018-09-01', label: 'Alternance — Sefrioui', lane: 0 },
  { date: '2021-09-01', label: 'El Amrani · 1ᵉʳ mandat', lane: 0 },
  { date: '2023-07-01', label: 'Retraite Pr. Chraibi', lane: 1 },
  { date: '2024-09-01', label: 'El Amrani · 2ᵉ mandat', lane: 0 },
];

export default function Mandats() {
  const { roleId } = useSession();
  const [selected, setSelected] = useState<string>(
    MANDATS.find((m) => m.status === 'en cours')!.id,
  );
  const cur = MANDATS.find((m) => m.id === selected)!;

  return (
    <div>
      <SectionHead
        eyebrow="Gouvernance · mémoire institutionnelle"
        title="Frise des mandats"
        subtitle="Chaque mandat est définitivement archivé. Aucun changement de rôle ne supprime de données — tout est traçable."
      />

      {/* Timeline */}
      <Card className="px-8 pb-8 pt-7">
        <div className="mb-[18px] flex items-baseline justify-between">
          <div>
            <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
              Continuum 2014 — 2027
            </div>
            <h3 className="m-0 mt-0.5 font-serif text-xl font-medium">
              23 années de direction archivées
            </h3>
          </div>
          <div className="flex items-center gap-3.5 font-sans text-xs text-muted">
            <LegendDot color="var(--navy)" label="Mandat passé" />
            <LegendDot color="#7A5B2E" label="Mandat en cours" />
            <LegendDot color="#B5453E" label="Aujourd'hui" line />
          </div>
        </div>

        {/* Year ruler */}
        <div className="relative mb-1.5 h-6">
          {Array.from({ length: TOTAL_YEARS + 1 }, (_, i) => {
            const year = FROM_YEAR + i;
            const left = (i / TOTAL_YEARS) * 100;
            if (Math.abs(left - TODAY_PCT) < (1.2 / TOTAL_YEARS) * 100) return null;
            return (
              <div
                key={year}
                className="absolute top-0 -translate-x-1/2 font-mono text-[10.5px] text-muted"
                style={{ left: `${left}%` }}
              >
                {year}
              </div>
            );
          })}
        </div>

        {/* Bars track */}
        <div className="relative h-[220px] py-1.5">
          {/* grid lines */}
          {Array.from({ length: TOTAL_YEARS + 1 }, (_, i) => (
            <div
              key={i}
              className="absolute bottom-0 top-0 w-px bg-line"
              style={{ left: `${(i / TOTAL_YEARS) * 100}%` }}
            />
          ))}

          {/* "today" marker */}
          <div
            className="absolute -bottom-2 -top-[30px] z-[2] w-0.5 bg-[#B5453E]"
            style={{ left: `${TODAY_PCT}%` }}
          >
            <div className="absolute -top-4 left-1/2 -translate-x-1/2 whitespace-nowrap border border-[#B5453E] bg-surface px-1.5 py-px font-mono text-[10px] font-semibold tracking-[0.05em] text-[#B5453E]">
              26 MAI 2026
            </div>
          </div>

          {/* mandate bars */}
          {MANDATS.map((m, idx) => {
            const startYear = new Date(m.from).getFullYear() + new Date(m.from).getMonth() / 12;
            const endYear = new Date(m.to).getFullYear() + new Date(m.to).getMonth() / 12;
            const left = ((startYear - FROM_YEAR) / TOTAL_YEARS) * 100;
            const width = ((endYear - startYear) / TOTAL_YEARS) * 100;
            const isActive = m.status === 'en cours';
            const isSelected = m.id === selected;
            const top = 24 + idx * 42;
            return (
              <button
                key={m.id}
                onClick={() => setSelected(m.id)}
                className="absolute flex h-8 items-center justify-between gap-2 px-3 text-left text-cream transition-all"
                style={{
                  left: `${left}%`,
                  width: `${width}%`,
                  top,
                  background: isActive ? '#7A5B2E' : 'var(--navy)',
                  border: `1px solid ${isActive ? '#7A5B2E' : 'var(--navy)'}`,
                  outline: isSelected ? '2px solid #B08838' : 'none',
                  outlineOffset: '2px',
                  opacity: isSelected ? 1 : 0.85,
                }}
              >
                <span className="overflow-hidden text-ellipsis whitespace-nowrap font-serif text-[13.5px] tracking-[-0.005em]">
                  {m.directeur.name.replace('Pr. ', '')}
                </span>
                <span className="whitespace-nowrap font-mono text-[10.5px] opacity-85">
                  {new Date(m.from).getFullYear()}–{new Date(m.to).getFullYear()}
                </span>
              </button>
            );
          })}
        </div>

        {/* Governance events */}
        <div className="relative mt-[18px] border-t border-line pt-3.5">
          <div className="mb-2 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Événements de gouvernance
          </div>
          <div className="relative h-24">
            {GOV_EVENTS.map((ev, i) => {
              const y = new Date(ev.date).getFullYear() + new Date(ev.date).getMonth() / 12;
              const left = ((y - FROM_YEAR) / TOTAL_YEARS) * 100;
              return (
                <div
                  key={i}
                  className="absolute w-[140px] -translate-x-1"
                  style={{ left: `${left}%`, top: ev.lane * 44 }}
                >
                  <div className="w-px bg-muted" style={{ height: ev.lane === 0 ? 8 : 40 }} />
                  <div className="mt-1 pr-2 font-sans text-[10.5px] leading-[1.3] text-ink">
                    {ev.label}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </Card>

      {/* Mandate detail */}
      <div className="mt-6 grid grid-cols-2 gap-5">
        <Card>
          <div className="mb-3 flex items-start justify-between">
            <div>
              <Badge tone={cur.status === 'en cours' ? 'gold' : 'navy'}>{cur.status}</Badge>
              <h2 className="m-0 mb-1 mt-2 font-serif text-2xl font-medium tracking-[-0.01em]">
                {cur.label}
              </h2>
              <div className="font-mono text-xs text-muted">
                {fmtFR(cur.from)} → {fmtFR(cur.to)} ·{' '}
                {Math.round((daysBetween(cur.from, cur.to) / 365.25) * 10) / 10} années
              </div>
            </div>
          </div>

          <div className="mt-4">
            <GovRow label="Direction" name={cur.directeur.name} role="Directeur" major />
            <GovRow label="Vice-direction" name={cur.vice.name} role="Vice-directeur·rice" major />
          </div>

          <div className="mt-2">
            <div className="border-t border-line pb-1 pt-3.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
              Chefs d'équipe
            </div>
            {cur.chefs.map((c, i) => (
              <GovRow key={i} label={c.team} name={c.name} role={`Chef d'équipe — ${c.team}`} />
            ))}
          </div>
        </Card>

        {/* Rules */}
        <Card>
          <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Règles de gouvernance
          </div>
          <h3 className="m-0 mb-3.5 mt-0.5 font-serif text-lg font-medium">
            Ce que ce mandat garantit
          </h3>

          <RuleRow
            num="01"
            title="Aucune perte de donnée"
            body="Tous les rôles précédents sont conservés. Pr. El Amrani apparaît dans 3 mandats avec 3 fonctions différentes."
          />
          <RuleRow
            num="02"
            title="Séparation statut / rôle"
            body="Le statut (permanent, associé) est indépendant du rôle (directeur, chef d'équipe). Un permanent peut être chef d'équipe puis redevenir simple membre."
          />
          <RuleRow
            num="03"
            title="Historisation automatique"
            body="Chaque changement génère une entrée datée. La frise au-dessus reconstruit toute la mémoire du laboratoire."
          />
          <RuleRow
            num="04"
            title="Validation par le directeur en mandat"
            body="Seul le directeur du mandat actif peut valider les adhésions et les demandes de matériel."
          />

          {roleId === 'directeur' && (
            <div className="mt-[18px] border border-dashed border-line bg-surface-2 p-3.5">
              <div className="mb-1 font-mono text-[10.5px] uppercase tracking-[0.12em] text-muted">
                Prochaine échéance
              </div>
              <div className="font-serif text-[15px] text-ink">
                Préparer le rapport de fin de mandat pour août 2027 — 15 mois restants.
              </div>
            </div>
          )}
        </Card>
      </div>
    </div>
  );
}

function LegendDot({ color, label, line }: { color: string; label: string; line?: boolean }) {
  return (
    <span className="inline-flex items-center gap-1.5">
      {line ? (
        <span className="h-3.5 w-0.5" style={{ background: color }} />
      ) : (
        <span className="h-2.5 w-2.5 rounded-[2px]" style={{ background: color }} />
      )}
      {label}
    </span>
  );
}

function GovRow({
  label,
  name,
  role,
  major,
}: {
  label: string;
  name: string;
  role?: string;
  major?: boolean;
}) {
  return (
    <div className="grid grid-cols-[120px_1fr] items-center gap-3.5 border-t border-line py-2.5">
      <div className="font-mono text-[11px] uppercase tracking-[0.1em] text-muted">{label}</div>
      <div>
        <div className={`font-serif text-ink ${major ? 'text-base' : 'text-[14.5px]'}`}>{name}</div>
        {role && <div className="mt-px font-sans text-[11.5px] text-muted">{role}</div>}
      </div>
    </div>
  );
}

function RuleRow({ num, title, body }: { num: string; title: string; body: string }) {
  return (
    <div className="grid grid-cols-[36px_1fr] gap-2.5 border-t border-line py-3">
      <div className="font-mono text-[11px] tracking-[0.05em] text-muted">{num}</div>
      <div>
        <div className="font-serif text-[15px] font-medium text-ink">{title}</div>
        <div className="mt-0.5 font-sans text-[12.5px] leading-[1.5] text-muted">{body}</div>
      </div>
    </div>
  );
}
