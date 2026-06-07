import { useNavigate } from 'react-router-dom';
import { ADHESIONS_INIT, EVENEMENTS, MANDATS } from '@/data';
import { useSession } from '@/context/SessionContext';
import { Avatar, Badge, Button, Card, KPI, SectionHead } from '@/components/ui';
import { fmtMonthYearFR, yearOf } from '@/lib/format';
import type { Mandat } from '@/types';

export default function Dashboard() {
  const navigate = useNavigate();
  const { roleId, currentMember } = useSession();

  const current = MANDATS.find((m) => m.status === 'en cours')!;
  const upcoming = EVENEMENTS.filter((e) => new Date(e.date) >= new Date('2026-05-01')).slice(0, 4);
  const pendingAdh = ADHESIONS_INIT.length;
  const isDir = roleId === 'directeur';

  const monthsRemaining = Math.max(
    0,
    Math.round(
      (new Date(current.to).getTime() - new Date('2026-05-26').getTime()) / (1000 * 60 * 60 * 24 * 30),
    ),
  );

  return (
    <div>
      <SectionHead
        eyebrow={`Lundi 26 mai 2026 · ${monthsRemaining} mois restants de mandat`}
        title={
          isDir
            ? `Bonjour ${currentMember?.firstName}.`
            : `Bonjour ${currentMember?.firstName ?? 'visiteur·euse'}.`
        }
        subtitle={
          isDir
            ? "Quatre demandes d'adhésion attendent votre décision. Le rapport annuel 2025–2026 est à 78 % de complétude."
            : 'Voici un aperçu des activités récentes du laboratoire et de votre équipe.'
        }
      />

      {/* KPIs */}
      <div className="mb-6 grid grid-cols-4 gap-3">
        <KPI label="Membres actifs" value="33" sub="dont 11 doctorants" accent="var(--navy)" />
        <KPI label="Publications 2026" value="12" sub="vs 18 en 2025 (YTD)" />
        <KPI label="Évènements à venir" value={upcoming.length} sub="6 prochains mois" />
        {isDir ? (
          <KPI label="Demandes en attente" value={pendingAdh} sub="à valider" accent="#7A5B2E" />
        ) : (
          <KPI
            label="Mes publications"
            value={currentMember?.pubs ?? '—'}
            sub={`h-index ${currentMember?.hIndex ?? '—'}`}
          />
        )}
      </div>

      {/* Main grid */}
      <div className="grid grid-cols-[1.6fr_1fr] gap-5">
        {/* LEFT — mandate snapshot + events */}
        <div className="flex flex-col gap-5">
          <Card>
            <div className="mb-3.5 flex items-start justify-between">
              <div>
                <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
                  Gouvernance · mandat en cours
                </div>
                <h3 className="m-0 mt-1 font-serif text-[22px] font-medium tracking-[-0.005em]">
                  {current.label}
                </h3>
              </div>
              <Button variant="ghost" size="sm" onClick={() => navigate('/mandats')}>
                Frise complète →
              </Button>
            </div>

            <MandateProgress mandate={current} today="2026-05-26" />

            <div className="mt-[18px] grid grid-cols-2 gap-2.5">
              <GovTile label="Directeur" name={current.directeur.name} />
              <GovTile label="Vice-directrice" name={current.vice.name} />
              {current.chefs.map((c, i) => (
                <GovTile key={i} label={`Chef d'équipe — ${c.team}`} name={c.name} />
              ))}
            </div>
          </Card>

          <Card padded={false}>
            <div className="flex items-center justify-between border-b border-line px-5 pb-3 pt-4">
              <div>
                <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
                  Agenda scientifique
                </div>
                <h3 className="m-0 mt-0.5 font-serif text-lg font-medium">Évènements à venir</h3>
              </div>
              <Badge tone="muted">6 mois</Badge>
            </div>
            <div>
              {upcoming.map((e) => (
                <div
                  key={e.id}
                  className="grid grid-cols-[90px_1fr_auto] items-center gap-4 border-t border-line px-5 py-3.5"
                >
                  <div className="font-mono text-xs text-ink">
                    <div className="font-semibold">
                      {new Date(e.date).toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' })}
                    </div>
                    <div className="text-[10.5px] text-muted">{yearOf(e.date)}</div>
                  </div>
                  <div>
                    <div className="font-serif text-[15px] text-ink">{e.title}</div>
                    <div className="mt-0.5 font-sans text-xs text-muted">
                      {e.type} · {e.lieu} · {e.role}
                    </div>
                  </div>
                  <Badge tone="navy">{e.type}</Badge>
                </div>
              ))}
            </div>
          </Card>
        </div>

        {/* RIGHT — context panel */}
        <div className="flex flex-col gap-5">
          <Card>
            <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
              Rapport annuel · obligatoire
            </div>
            <h3 className="m-0 mb-3.5 mt-1 font-serif text-xl font-medium">Exercice 2025 — 2026</h3>

            <RingProgress value={78} />

            <div className="mt-4 font-sans text-[12.5px]">
              <ReportLine label="Évènements collectés" done="24/24" ok />
              <ReportLine label="Publications validées" done="42/52" />
              <ReportLine label="Conventions actives" done="7/7" ok />
              <ReportLine label="Mandat / gouvernance" done="OK" ok />
              <ReportLine label="Approbation directeur" done="à faire" warn />
            </div>

            <Button
              variant="primary"
              size="md"
              className="mt-4 w-full"
              onClick={() => navigate('/rapport')}
            >
              Ouvrir le rapport →
            </Button>
          </Card>

          {isDir ? (
            <Card>
              <div className="mb-3 flex items-center justify-between">
                <div>
                  <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
                    À décider
                  </div>
                  <h3 className="m-0 mt-0.5 font-serif text-lg font-medium">Demandes d'adhésion</h3>
                </div>
                <Badge tone="gold">{pendingAdh} en attente</Badge>
              </div>
              {ADHESIONS_INIT.slice(0, 3).map((a) => (
                <div key={a.id} className="flex items-center gap-3 border-t border-line py-2.5">
                  <Avatar initials={a.initials} tone="sand" size={32} />
                  <div className="min-w-0 flex-1">
                    <div className="font-sans text-[13px] font-medium text-ink">{a.name}</div>
                    <div className="font-sans text-[11.5px] text-muted">
                      {a.type} · {a.inst}
                    </div>
                  </div>
                </div>
              ))}
              <Button
                variant="ghost"
                size="sm"
                className="mt-3 w-full"
                onClick={() => navigate('/adhesions')}
              >
                Traiter les demandes
              </Button>
            </Card>
          ) : (
            <Card>
              <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">Le LIAS</div>
              <h3 className="m-0 mb-3.5 mt-0.5 font-serif text-lg font-medium">
                Mémoire institutionnelle
              </h3>
              <FactRow k="Création" v="14 mars 2003" />
              <FactRow k="Membres permanents" v="22" />
              <FactRow k="Doctorant·e·s" v="11" />
              <FactRow k="Équipes" v="4 axes thématiques" />
              <FactRow k="Mandats archivés" v="3" />
              <FactRow k="Publications totales" v="412" />
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}

function GovTile({ label, name }: { label: string; name: string }) {
  return (
    <div className="border border-line bg-surface-2 px-3 py-2.5">
      <div className="font-mono text-[10px] uppercase tracking-[0.12em] text-muted">{label}</div>
      <div className="mt-0.5 font-serif text-[14.5px] text-ink">{name}</div>
    </div>
  );
}

function MandateProgress({ mandate, today }: { mandate: Mandat; today: string }) {
  const start = new Date(mandate.from).getTime();
  const end = new Date(mandate.to).getTime();
  const now = new Date(today).getTime();
  const pct = Math.max(0, Math.min(100, ((now - start) / (end - start)) * 100));
  return (
    <div className="mt-1.5">
      <div className="relative h-1.5 border border-line bg-surface-2">
        <div className="absolute inset-0 bg-navy" style={{ width: `${pct}%` }} />
      </div>
      <div className="mt-1.5 flex justify-between font-mono text-[10.5px] text-muted">
        <span>{fmtMonthYearFR(mandate.from)}</span>
        <span>{Math.round(pct)} % écoulé</span>
        <span>{fmtMonthYearFR(mandate.to)}</span>
      </div>
    </div>
  );
}

function RingProgress({ value }: { value: number }) {
  const r = 44;
  const c = 2 * Math.PI * r;
  const dash = (value / 100) * c;
  return (
    <div className="flex items-center gap-[18px]">
      <svg width="110" height="110" viewBox="0 0 110 110">
        <circle cx="55" cy="55" r={r} stroke="var(--border)" strokeWidth="6" fill="none" />
        <circle
          cx="55"
          cy="55"
          r={r}
          stroke="var(--navy)"
          strokeWidth="6"
          fill="none"
          strokeDasharray={`${dash} ${c - dash}`}
          strokeDashoffset={c * 0.25 * -1}
          transform="rotate(-90 55 55)"
          strokeLinecap="butt"
        />
        <text
          x="55"
          y="58"
          textAnchor="middle"
          fontFamily="var(--font-serif)"
          fontSize="26"
          fontWeight="500"
          fill="var(--ink)"
        >
          {value}
          <tspan fontSize="13" fill="var(--muted)">
            %
          </tspan>
        </text>
      </svg>
      <div className="flex-1 font-sans text-[12.5px] text-muted">
        Données agrégées depuis le 1<sup>er</sup> septembre 2025. Mise à jour automatique chaque nuit.
      </div>
    </div>
  );
}

function ReportLine({
  label,
  done,
  ok,
  warn,
}: {
  label: string;
  done: string;
  ok?: boolean;
  warn?: boolean;
}) {
  const color = ok ? '#33503A' : warn ? '#7A5B2E' : 'var(--muted)';
  return (
    <div className="flex items-center justify-between border-t border-line py-1.5">
      <span className="text-ink">{label}</span>
      <span className="font-mono text-[11.5px]" style={{ color }}>
        {done}
      </span>
    </div>
  );
}

function FactRow({ k, v }: { k: string; v: string }) {
  return (
    <div className="flex justify-between border-t border-line py-2 font-sans text-[13px]">
      <span className="text-muted">{k}</span>
      <span className="font-mono text-xs text-ink">{v}</span>
    </div>
  );
}
