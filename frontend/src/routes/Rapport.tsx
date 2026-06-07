import { useState, type ReactNode } from 'react';
import { useSession } from '@/context/SessionContext';
import { Button, Card, SectionHead } from '@/components/ui';

type Phase = 'preview' | 'generating' | 'ready';

export default function Rapport() {
  const { roleId } = useSession();
  const [phase, setPhase] = useState<Phase>('preview');
  const [progress, setProgress] = useState(0);
  const [year, setYear] = useState('2025-2026');

  function regenerate() {
    setPhase('generating');
    setProgress(0);
    const steps = [12, 28, 42, 58, 71, 84, 96, 100];
    let i = 0;
    const tick = () => {
      if (i >= steps.length) {
        setPhase('ready');
        return;
      }
      setProgress(steps[i++]);
      window.setTimeout(tick, 280);
    };
    tick();
  }

  return (
    <div>
      <SectionHead
        eyebrow="Document obligatoire · condition d'attribution du budget annuel"
        title={`Rapport d'activité ${year}`}
        subtitle="Génération automatique à partir des évènements, publications, mandats et conventions enregistrés dans le système."
        right={
          <>
            <select
              value={year}
              onChange={(e) => setYear(e.target.value)}
              className="border border-line bg-surface px-3 py-[7px] font-mono text-[12.5px] text-ink"
            >
              <option>2025-2026</option>
              <option>2024-2025</option>
              <option>2023-2024</option>
            </select>
            {roleId === 'directeur' && (
              <Button variant="primary" onClick={regenerate} disabled={phase === 'generating'}>
                {phase === 'generating' ? 'Génération…' : '↻ Régénérer'}
              </Button>
            )}
          </>
        }
      />

      {phase === 'generating' && (
        <Card className="mb-[18px]">
          <div className="mb-2.5 flex items-baseline justify-between">
            <div className="font-serif text-base">Compilation des données du laboratoire…</div>
            <div className="font-mono text-xs text-muted">{progress} %</div>
          </div>
          <div className="relative h-1 bg-surface-2">
            <div
              className="absolute inset-0 bg-navy transition-[width] duration-[250ms]"
              style={{ width: `${progress}%` }}
            />
          </div>
          <div className="mt-2.5 font-mono text-[11.5px] text-muted">
            {progress < 30 && '→ Agrégation des évènements scientifiques (24)'}
            {progress >= 30 && progress < 60 && '→ Indexation des publications par équipe (52)'}
            {progress >= 60 && progress < 85 && '→ Compilation des conventions actives (7)'}
            {progress >= 85 && '→ Mise en page et signature numérique'}
          </div>
        </Card>
      )}

      <div className="grid grid-cols-[1fr_280px] gap-6">
        {/* DOCUMENT PREVIEW */}
        <div className="min-h-[1200px] border border-line bg-surface px-14 py-12 shadow-[0_4px_18px_rgba(20,18,14,0.06)]">
          <div className="mb-8 border-b-2 border-ink pb-6">
            <div className="font-mono text-[11px] uppercase tracking-[0.18em] text-muted">
              Faculté des Sciences Ben M'Sik — Casablanca
            </div>
            <h1 className="m-0 mb-1.5 mt-3.5 font-serif text-[44px] font-medium leading-[1.1] tracking-[-0.015em]">
              Rapport d'activité {year}
            </h1>
            <div className="font-serif text-lg italic text-muted">
              Laboratoire d'Informatique et Applications Scientifiques (LIAS)
            </div>
            <div className="mt-[18px] flex items-end justify-between font-mono text-[11px] text-muted">
              <div>Édition générée le 26 mai 2026 · 18:42</div>
              <div>LIAS-RAP-2025-2026 · v.4</div>
            </div>
          </div>

          <Section num="01" title="Synthèse de l'exercice">
            <p className="m-0 mb-3 font-serif text-base leading-[1.7] text-ink">
              Au cours de l'exercice {year}, le laboratoire a maintenu une activité scientifique
              soutenue avec <strong>52 publications</strong> (revues et conférences confondues) et{' '}
              <strong>24 évènements organisés ou co-organisés</strong>. Les 4 équipes thématiques
              restent stables ; le mandat 2024–2027 est en cours de déroulement normal sous la
              direction du Pr. Yassine El Amrani.
            </p>
            <p className="m-0 mb-4 font-serif text-base leading-[1.7] text-ink">
              Trois conventions ont été renouvelées (Casa Transports, INRIA, Université Mohammed V)
              et une nouvelle convention signée avec le CNRS-LIPN. Le laboratoire compte désormais 33
              membres actifs, dont 11 doctorants — soit +18 % par rapport à l'exercice précédent.
            </p>

            <div className="grid grid-cols-4 border border-line">
              <ReportKPI v="52" label="Publications" sub="+15 % vs n-1" />
              <ReportKPI v="24" label="Évènements" sub="dont 9 organisés ici" />
              <ReportKPI v="7" label="Conventions" sub="toutes actives" />
              <ReportKPI v="33" label="Membres" sub="+18 % vs n-1" last />
            </div>
          </Section>

          <Section num="02" title="Production scientifique par équipe">
            <ProductionChart />

            <table className="mt-[18px] w-full border-collapse font-sans text-[13px]">
              <thead>
                <tr className="border-b border-ink">
                  <Th>Équipe</Th>
                  <Th align="right">Revues</Th>
                  <Th align="right">Conf.</Th>
                  <Th align="right">Total</Th>
                  <Th align="right">Évèn.</Th>
                </tr>
              </thead>
              <tbody>
                <Tr team="IA & Apprentissage" rev="7" conf="6" total="13" ev="8" />
                <Tr team="Big Data & Fouille" rev="5" conf="8" total="13" ev="6" />
                <Tr team="NLP" rev="3" conf="5" total="8" ev="4" />
                <Tr team="Sécurité & SD" rev="4" conf="3" total="7" ev="3" />
                <tr className="border-t-2 border-ink font-mono">
                  <Th>Total</Th>
                  <Th align="right">19</Th>
                  <Th align="right">22</Th>
                  <Th align="right">41</Th>
                  <Th align="right">21</Th>
                </tr>
              </tbody>
            </table>

            <div className="mt-3.5 font-serif text-[13.5px] italic text-muted">
              Figure 1 — Répartition des publications {year} par équipe (source : module Publications,
              validé le 24/05/2026).
            </div>
          </Section>

          <Section num="03" title="Évènements marquants">
            {[
              {
                date: '2025-10-22',
                t: 'CASA-DATA 2025',
                body: 'Workshop co-organisé avec Casa Transports, 180 participants. Actes en cours de publication aux éditions Springer.',
              },
              {
                date: '2025-11-04',
                t: 'Séminaire LLM & arabe dialectal',
                body: "Conférencier invité : Pr. Karim Bouzoubaa (EMI). Premier séminaire d'une série annuelle.",
              },
              {
                date: '2025-12-12',
                t: 'Atelier diffusion à NeurIPS',
                body: 'Présentation du travail de la doctorante Aya Saidi (Équipe IA), retenu parmi 80 soumissions internationales.',
              },
              {
                date: '2026-03-12',
                t: 'Journée Doctorants LIAS',
                body: '11 communications, 3 prix décernés, présence du doyen de la Faculté.',
              },
            ].map((e, i) => (
              <div
                key={i}
                className={`grid grid-cols-[120px_1fr] gap-[18px] py-3.5 ${i === 0 ? '' : 'border-t border-line'}`}
              >
                <div className="font-mono text-xs text-muted">
                  {new Date(e.date).toLocaleDateString('fr-FR', {
                    day: '2-digit',
                    month: 'long',
                    year: 'numeric',
                  })}
                </div>
                <div>
                  <div className="font-serif text-base font-medium text-ink">{e.t}</div>
                  <div className="mt-1 font-serif text-[14.5px] leading-[1.55] text-ink">{e.body}</div>
                </div>
              </div>
            ))}
          </Section>

          <Section num="04" title="Gouvernance et mandat actif">
            <p className="m-0 mb-3 font-serif text-[15.5px] leading-[1.65] text-ink">
              Le présent rapport est établi sous le mandat 2024–2027 dirigé par le Pr. Yassine El
              Amrani, assisté du Pr. Nadia Berrada (vice-direction). Les quatre chefs d'équipe pour
              cet exercice sont :
            </p>
            <ul className="m-0 mb-3 list-disc pl-[22px] font-serif text-[15.5px] leading-[1.7] text-ink">
              <li>Pr. Khalid Tazi — IA & Apprentissage automatique</li>
              <li>Pr. Salma Bennani — Big Data & Fouille de données</li>
              <li>Dr. Omar Lahlou — Traitement du langage naturel</li>
              <li>Dr. Fatima Zahra Idrissi — Sécurité & Systèmes distribués</li>
            </ul>
          </Section>

          <div className="mt-12 flex items-end justify-between border-t border-line pt-6">
            <div>
              <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
                Validé par
              </div>
              <div className="mt-1 font-serif text-base">Pr. Yassine El Amrani</div>
              <div className="font-sans text-xs text-muted">Directeur du LIAS — mandat 2024–2027</div>
            </div>
            <div className="text-right">
              <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
                Signature numérique
              </div>
              <div className="mt-1 font-mono text-[11px] text-ink">SHA-256 · 4f9c…be21</div>
            </div>
          </div>
        </div>

        {/* SIDE — status + sources + actions */}
        <div className="flex flex-col gap-3.5">
          <Card>
            <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">Statut</div>
            <div className="mt-1.5 flex items-center gap-2">
              <span
                className="h-2 w-2 rounded-full"
                style={{ background: phase === 'ready' ? '#33503A' : '#7A5B2E' }}
              />
              <div className="font-serif text-base">
                {phase === 'ready' ? 'Prêt à signer' : 'Brouillon — 78 %'}
              </div>
            </div>
            <div className="mt-2 font-sans text-xs leading-[1.5] text-muted">
              Le rapport est régénéré automatiquement à chaque ajout d'évènement, publication ou
              convention. Vous pouvez forcer la régénération à tout moment.
            </div>
          </Card>

          <Card>
            <div className="mb-1.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
              Sources de données
            </div>
            <SourceRow k="Évènements" v="24" ok />
            <SourceRow k="Publications" v="52" warn note="10 en attente de validation" />
            <SourceRow k="Conventions" v="7" ok />
            <SourceRow k="Mandat" v="OK" ok />
            <SourceRow k="Conventions financières" v="3" ok />
            <SourceRow k="Approbation finale" v={roleId === 'directeur' ? 'à faire' : 'directeur'} warn />
          </Card>

          <Card>
            <div className="mb-1.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
              Actions
            </div>
            <div className="flex flex-col gap-2">
              <Button variant="ghost" size="md">
                ⤓ PDF · A4 (12 pages)
              </Button>
              <Button variant="ghost" size="md">
                ⤓ DOCX · modifiable
              </Button>
              <Button variant="ghost" size="md">
                ↗ Soumettre au doyen
              </Button>
            </div>
          </Card>

          <div className="border-l-2 border-line px-3.5 py-3 font-serif text-[12.5px] italic text-muted">
            Rappel : sans rapport validé avant le 30 septembre, le budget de l'exercice n'est pas
            attribué.
          </div>
        </div>
      </div>
    </div>
  );
}

function Section({ num, title, children }: { num: string; title: string; children: ReactNode }) {
  return (
    <section className="mb-[42px]">
      <div className="mb-3.5 flex items-baseline gap-3.5">
        <span className="font-mono text-xs tracking-[0.05em] text-muted">§ {num}</span>
        <h2 className="m-0 font-serif text-2xl font-medium tracking-[-0.005em]">{title}</h2>
      </div>
      {children}
    </section>
  );
}

function ReportKPI({ v, label, sub, last }: { v: string; label: string; sub: string; last?: boolean }) {
  return (
    <div className={`px-[18px] py-3.5 ${last ? '' : 'border-r border-line'}`}>
      <div className="font-serif text-[38px] font-medium leading-none [font-variant-numeric:tabular-nums]">
        {v}
      </div>
      <div className="mt-1.5 font-mono text-[10.5px] uppercase tracking-[0.12em] text-muted">
        {label}
      </div>
      <div className="mt-0.5 font-sans text-[11.5px] text-muted">{sub}</div>
    </div>
  );
}

function Th({ children, align }: { children: ReactNode; align?: 'left' | 'right' }) {
  return (
    <th
      className={`px-2.5 py-2 font-mono text-[11px] font-medium uppercase tracking-[0.1em] text-muted ${
        align === 'right' ? 'text-right' : 'text-left'
      }`}
    >
      {children}
    </th>
  );
}

function Td({
  children,
  align,
  mono,
}: {
  children: ReactNode;
  align?: 'left' | 'right';
  mono?: boolean;
}) {
  return (
    <td
      className={`p-2.5 text-ink [font-variant-numeric:tabular-nums] ${
        mono ? 'font-mono text-[13px]' : 'font-serif text-[14.5px]'
      } ${align === 'right' ? 'text-right' : 'text-left'}`}
    >
      {children}
    </td>
  );
}

function Tr({
  team,
  rev,
  conf,
  total,
  ev,
}: {
  team: string;
  rev: string;
  conf: string;
  total: string;
  ev: string;
}) {
  return (
    <tr className="border-t border-line">
      <Td>{team}</Td>
      <Td align="right" mono>
        {rev}
      </Td>
      <Td align="right" mono>
        {conf}
      </Td>
      <Td align="right" mono>
        {total}
      </Td>
      <Td align="right" mono>
        {ev}
      </Td>
    </tr>
  );
}

function ProductionChart() {
  const data = [
    { team: 'IA & Apprentissage', rev: 7, conf: 6 },
    { team: 'Big Data & Fouille', rev: 5, conf: 8 },
    { team: 'NLP', rev: 3, conf: 5 },
    { team: 'Sécurité & SD', rev: 4, conf: 3 },
  ];
  const max = Math.max(...data.map((d) => d.rev + d.conf));
  return (
    <div className="flex flex-col gap-2.5">
      {data.map((d) => {
        const total = d.rev + d.conf;
        const wTotal = (total / max) * 100;
        const wRev = (d.rev / total) * wTotal;
        return (
          <div key={d.team} className="grid grid-cols-[180px_1fr_56px] items-center gap-3.5">
            <div className="font-serif text-sm">{d.team}</div>
            <div className="relative h-[18px] border border-line bg-surface-2">
              <div className="absolute bottom-0 left-0 top-0 bg-navy" style={{ width: `${wRev}%` }} />
              <div
                className="absolute bottom-0 top-0 bg-[#B08838]"
                style={{ left: `${wRev}%`, width: `${wTotal - wRev}%` }}
              />
            </div>
            <div className="text-right font-mono text-xs">{total}</div>
          </div>
        );
      })}
      <div className="mt-1 flex gap-3.5 font-sans text-[11.5px] text-muted">
        <span className="inline-flex items-center gap-1.5">
          <span className="h-2.5 w-2.5 bg-navy" />
          Revues
        </span>
        <span className="inline-flex items-center gap-1.5">
          <span className="h-2.5 w-2.5 bg-[#B08838]" />
          Conférences
        </span>
      </div>
    </div>
  );
}

function SourceRow({
  k,
  v,
  ok,
  warn,
  note,
}: {
  k: string;
  v: string;
  ok?: boolean;
  warn?: boolean;
  note?: string;
}) {
  const c = ok ? '#33503A' : warn ? '#7A5B2E' : 'var(--muted)';
  return (
    <div className="border-t border-line py-2 font-sans text-[12.5px]">
      <div className="flex items-center justify-between">
        <span className="text-ink">{k}</span>
        <span className="font-mono" style={{ color: c }}>
          {v}
        </span>
      </div>
      {note && <div className="mt-0.5 text-[11px] text-muted">{note}</div>}
    </div>
  );
}
