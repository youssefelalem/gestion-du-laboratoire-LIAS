import { useState } from 'react';
import { EVENTS_FULL } from '@/data';
import { Button, Card, SectionHead } from '@/components/ui';
import type { EventFull, EventType } from '@/types';

const TYPE_COLORS: Record<EventType, string> = {
  Conférence: 'var(--navy)',
  Séminaire: '#B08838',
  Workshop: '#33503A',
};

export default function Calendrier() {
  const [view, setView] = useState<'mois' | 'annee'>('mois');
  const [cursor, setCursor] = useState(new Date('2026-06-01'));

  function shift(delta: number) {
    const n = new Date(cursor);
    if (view === 'mois') n.setMonth(n.getMonth() + delta);
    else n.setFullYear(n.getFullYear() + delta);
    setCursor(n);
  }

  const monthLabel = cursor.toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' });

  return (
    <div>
      <SectionHead
        eyebrow="Visualisation des évènements · navigation temporelle"
        title="Calendrier"
        subtitle="Vue mensuelle ou annuelle de toutes les activités scientifiques du laboratoire."
        right={
          <>
            <Button variant="ghost" size="md" onClick={() => setCursor(new Date('2026-05-26'))}>
              Aujourd'hui
            </Button>
            <div className="flex border border-line">
              <Button
                variant={view === 'mois' ? 'primary' : 'ghost'}
                size="md"
                onClick={() => setView('mois')}
                className="rounded-none border-none"
              >
                Mois
              </Button>
              <Button
                variant={view === 'annee' ? 'primary' : 'ghost'}
                size="md"
                onClick={() => setView('annee')}
                className="rounded-none border-none"
              >
                Année
              </Button>
            </div>
          </>
        }
      />

      <div className="mb-3.5 flex items-baseline justify-between">
        <div className="flex items-baseline gap-3.5">
          <button onClick={() => shift(-1)} className={navBtnClass}>
            ‹
          </button>
          <h2 className="m-0 font-serif text-[32px] font-medium capitalize tracking-[-0.01em]">
            {view === 'mois' ? monthLabel : cursor.getFullYear()}
          </h2>
          <button onClick={() => shift(1)} className={navBtnClass}>
            ›
          </button>
        </div>
        <div className="flex items-center gap-3.5 font-sans text-xs text-muted">
          <LegendSwatch color="var(--navy)" label="Conférence" />
          <LegendSwatch color="#B08838" label="Séminaire" />
          <LegendSwatch color="#33503A" label="Workshop" />
        </div>
      </div>

      {view === 'mois' ? (
        <MonthGrid cursor={cursor} events={EVENTS_FULL} />
      ) : (
        <YearGrid year={cursor.getFullYear()} events={EVENTS_FULL} />
      )}
    </div>
  );
}

const navBtnClass =
  'flex h-9 w-9 items-center justify-center border border-line bg-surface font-serif text-[22px] text-ink';

function LegendSwatch({ color, label }: { color: string; label: string }) {
  return (
    <span className="inline-flex items-center gap-1.5">
      <span className="h-2.5 w-2.5" style={{ background: color }} />
      {label}
    </span>
  );
}

function MonthGrid({ cursor, events }: { cursor: Date; events: EventFull[] }) {
  const y = cursor.getFullYear();
  const m = cursor.getMonth();
  const startDay = (new Date(y, m, 1).getDay() + 6) % 7; // Monday = 0
  const daysInMonth = new Date(y, m + 1, 0).getDate();
  const today = new Date('2026-05-26');

  const cells: (number | null)[] = [];
  for (let i = 0; i < startDay; i++) cells.push(null);
  for (let d = 1; d <= daysInMonth; d++) cells.push(d);
  while (cells.length % 7 !== 0) cells.push(null);

  const dayHeaders = ['LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM', 'DIM'];

  return (
    <Card padded={false}>
      <div className="grid grid-cols-7">
        {dayHeaders.map((d) => (
          <div
            key={d}
            className="border-b border-line bg-surface-2 px-3.5 py-2.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted"
          >
            {d}
          </div>
        ))}
        {cells.map((d, i) => {
          const isToday =
            !!d && y === today.getFullYear() && m === today.getMonth() && d === today.getDate();
          const dayEvents = d
            ? events.filter((e) => {
                const ed = new Date(e.date);
                return ed.getFullYear() === y && ed.getMonth() === m && ed.getDate() === d;
              })
            : [];
          return (
            <div
              key={i}
              className={`min-h-[118px] border-b border-line px-2.5 py-2 ${
                (i + 1) % 7 !== 0 ? 'border-r' : ''
              }`}
              style={{
                background: !d ? 'var(--surface-2)' : isToday ? 'rgba(176,136,56,0.08)' : 'var(--surface)',
              }}
            >
              {d && (
                <>
                  <div
                    className="mb-1.5 inline-flex h-6 w-6 items-center justify-center font-serif text-[15px]"
                    style={{
                      color: isToday ? 'var(--cream)' : 'var(--ink)',
                      background: isToday ? '#B5453E' : 'transparent',
                      fontWeight: isToday ? 600 : 400,
                    }}
                  >
                    {d}
                  </div>
                  {dayEvents.slice(0, 3).map((e) => (
                    <div
                      key={e.id}
                      className="mb-[3px] overflow-hidden text-ellipsis whitespace-nowrap px-1.5 py-[3px] font-sans text-[10.5px] leading-[1.25] text-cream"
                      style={{ background: TYPE_COLORS[e.type] }}
                    >
                      {e.title}
                    </div>
                  ))}
                  {dayEvents.length > 3 && (
                    <div className="font-mono text-[9.5px] text-muted">+{dayEvents.length - 3}</div>
                  )}
                </>
              )}
            </div>
          );
        })}
      </div>
    </Card>
  );
}

function YearGrid({ year, events }: { year: number; events: EventFull[] }) {
  const months = Array.from({ length: 12 }, (_, m) => new Date(year, m, 1));
  return (
    <div className="grid grid-cols-4 gap-3.5">
      {months.map((d) => {
        const m = d.getMonth();
        const monthEvents = events.filter((e) => {
          const ed = new Date(e.date);
          return ed.getFullYear() === year && ed.getMonth() === m;
        });
        return (
          <Card key={m} padded={false}>
            <div className="flex items-baseline justify-between border-b border-line bg-surface-2 px-3.5 py-2.5">
              <span className="font-serif text-lg font-medium capitalize">
                {d.toLocaleDateString('fr-FR', { month: 'long' })}
              </span>
              <span className="font-mono text-[11px] text-muted">{monthEvents.length}</span>
            </div>
            <div className="min-h-[130px] p-3">
              {monthEvents.length === 0 && (
                <div className="font-serif text-[13px] italic text-muted">—</div>
              )}
              {monthEvents.map((e) => (
                <div key={e.id} className="flex items-baseline gap-2 py-1">
                  <span
                    className="h-1.5 w-1.5 flex-shrink-0 rounded-full"
                    style={{ background: TYPE_COLORS[e.type] }}
                  />
                  <span className="font-mono text-[10.5px] text-muted">
                    {String(new Date(e.date).getDate()).padStart(2, '0')}
                  </span>
                  <span className="overflow-hidden text-ellipsis whitespace-nowrap font-sans text-xs text-ink">
                    {e.title}
                  </span>
                </div>
              ))}
            </div>
          </Card>
        );
      })}
    </div>
  );
}
