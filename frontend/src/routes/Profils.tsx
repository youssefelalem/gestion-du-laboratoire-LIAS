import { useMemo, useState } from 'react';
import { MEMBERS, PUBLICATIONS, TEAMS } from '@/data';
import { useSession } from '@/context/SessionContext';
import {
  Avatar,
  type AvatarTone,
  Badge,
  Button,
  Card,
  Chip,
  Empty,
  Meta,
  SearchInput,
  SectionHead,
  StatusBadge,
} from '@/components/ui';
import { daysBetween, fmtFR, fmtMonthYearFR } from '@/lib/format';
import type { AffiliationPeriod, Member, MemberStatus } from '@/types';

const TODAY = '2026-05-26';

function avatarToneFor(status: MemberStatus): AvatarTone {
  if (status === 'retraite') return 'muted';
  if (status === 'ancien') return 'burgundy';
  if (status === 'associe') return 'sand';
  return 'navy';
}

const STATUS_FILTERS: { id: MemberStatus | 'tous'; label: string }[] = [
  { id: 'tous', label: 'Tous' },
  { id: 'permanent', label: 'Permanents' },
  { id: 'associe', label: 'Associés' },
  { id: 'doctorant', label: 'Doctorants' },
  { id: 'retraite', label: 'Retraités' },
  { id: 'ancien', label: 'Anciens' },
];

export default function Profils() {
  const { roleId, currentMember } = useSession();
  const [search, setSearch] = useState('');
  const [filterStatus, setFilterStatus] = useState<MemberStatus | 'tous'>('tous');
  const [filterTeam, setFilterTeam] = useState<string>('toutes');
  const [selectedId, setSelectedId] = useState<string>(currentMember?.id ?? MEMBERS[0].id);
  const [editing, setEditing] = useState(false);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    return MEMBERS.filter((m) => {
      const matchQ =
        !q ||
        `${m.firstName} ${m.lastName} ${m.interests.join(' ')}`.toLowerCase().includes(q);
      const matchS = filterStatus === 'tous' || m.status === filterStatus;
      const matchT = filterTeam === 'toutes' || m.team === filterTeam;
      return matchQ && matchS && matchT;
    });
  }, [search, filterStatus, filterTeam]);

  const selected = MEMBERS.find((m) => m.id === selectedId) ?? MEMBERS[0];
  const canEdit = roleId === 'directeur' || currentMember?.id === selected.id;

  return (
    <div>
      <SectionHead
        eyebrow={`${MEMBERS.length} profils · 4 équipes · historique complet conservé`}
        title="Profils & membres"
        subtitle="Chaque profil capitalise l'historique d'affiliation, les rôles successifs et les publications. Aucune donnée n'est supprimée."
        right={
          roleId === 'directeur' ? (
            <Button variant="primary" size="md">
              + Ajouter un membre
            </Button>
          ) : undefined
        }
      />

      <div className="grid grid-cols-[320px_1fr] gap-5">
        {/* LEFT — list + filters */}
        <div>
          <SearchInput value={search} onChange={setSearch} placeholder="Nom, intérêt, équipe…" />

          <div className="mt-2.5 flex flex-wrap gap-1.5">
            {STATUS_FILTERS.map((s) => (
              <Chip key={s.id} active={filterStatus === s.id} onClick={() => setFilterStatus(s.id)}>
                {s.label}
              </Chip>
            ))}
          </div>

          <select
            value={filterTeam}
            onChange={(e) => setFilterTeam(e.target.value)}
            className="mt-2.5 w-full rounded-[2px] border border-line bg-surface px-2.5 py-[7px] font-sans text-[13px] text-ink"
          >
            <option value="toutes">Toutes les équipes</option>
            {TEAMS.map((t) => (
              <option key={t.id} value={t.id}>
                {t.name}
              </option>
            ))}
          </select>

          <div className="mt-3.5 max-h-[62vh] overflow-auto border border-line bg-surface">
            {filtered.length === 0 && (
              <Empty title="Aucun profil ne correspond." sub="Ajustez les filtres." />
            )}
            {filtered.map((m) => (
              <button
                key={m.id}
                onClick={() => setSelectedId(m.id)}
                className={`flex w-full items-center gap-3 border-t border-l-2 border-line px-3.5 py-3 text-left ${
                  selectedId === m.id ? 'border-l-navy bg-surface-2' : 'border-l-transparent'
                }`}
              >
                <Avatar initials={m.initials} status={m.status} size={36} tone={avatarToneFor(m.status)} />
                <div className="min-w-0 flex-1">
                  <div className="font-serif text-[13.5px] font-medium text-ink">
                    {m.firstName} {m.lastName}
                  </div>
                  <div className="mt-0.5 overflow-hidden text-ellipsis whitespace-nowrap text-[11.5px] text-muted">
                    {m.team_label}
                  </div>
                </div>
                <StatusBadge status={m.status} />
              </button>
            ))}
          </div>
        </div>

        {/* RIGHT — detail */}
        <ProfileDetail member={selected} canEdit={canEdit} editing={editing} setEditing={setEditing} />
      </div>
    </div>
  );
}

function ProfileDetail({
  member,
  canEdit,
  editing,
  setEditing,
}: {
  member: Member;
  canEdit: boolean;
  editing: boolean;
  setEditing: (v: boolean) => void;
}) {
  const roleLabel =
    member.role === 'directeur'
      ? 'Directeur'
      : member.role === 'vice-directeur'
        ? 'Vice-direction'
        : member.role === 'chef-equipe'
          ? "Chef d'équipe"
          : member.role;

  return (
    <div className="grid grid-cols-[1fr_320px] gap-[18px]">
      <Card>
        {/* Header */}
        <div className="mb-[18px] flex items-start gap-[18px]">
          <Avatar initials={member.initials} size={84} status={member.status} tone={avatarToneFor(member.status)} />
          <div className="flex-1">
            <div className="mb-1 flex items-center gap-2">
              <StatusBadge status={member.status} />
              {member.role !== 'aucun' && member.role !== 'membre' && (
                <Badge tone="navy">{roleLabel}</Badge>
              )}
            </div>
            <h2 className="m-0 mb-1 mt-0.5 font-serif text-[30px] font-medium tracking-[-0.01em]">
              {member.firstName} {member.lastName}
            </h2>
            <div className="font-sans text-[13.5px] text-muted">
              {member.grade} · {member.team_label}
            </div>
            <div className="mt-1.5 font-mono text-xs text-muted">{member.email}</div>
          </div>
          {canEdit && (
            <Button variant="ghost" size="sm" onClick={() => setEditing(!editing)}>
              {editing ? 'Annuler' : '✎ Modifier'}
            </Button>
          )}
        </div>

        {/* Bio */}
        <div className="border-y border-line py-3.5 font-serif text-[15.5px] italic leading-[1.55] text-ink">
          « {member.bio} »
        </div>

        {/* Meta grid */}
        <div className="mt-[18px] grid grid-cols-2 gap-x-6 gap-y-3.5">
          <Meta k="Établissement" v={member.inst} />
          <Meta k="Laboratoire d'origine" v={member.origLab} />
          <Meta k="Date d'embauche" v={fmtFR(member.hired)} />
          <Meta k="Affiliation au LIAS" v={fmtFR(member.affiliated)} mono />
          <Meta k="Date de naissance" v="confidentielle" muted />
          <Meta
            k="Ancienneté au labo"
            v={`${Math.floor(daysBetween(member.affiliated, TODAY) / 365)} ans`}
            mono
          />
        </div>

        {/* Centres d'intérêt */}
        <div className="mt-[22px]">
          <div className="mb-2 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Centres d'intérêt
          </div>
          <div className="flex flex-wrap gap-1.5">
            {member.interests.map((i) => (
              <Badge key={i} tone="neutral">
                {i}
              </Badge>
            ))}
          </div>
        </div>

        <PublicationsList member={member} />
      </Card>

      {/* RIGHT — indicators + timeline */}
      <div className="flex flex-col gap-[18px]">
        <Card>
          <div className="mb-1 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Indicateurs
          </div>
          <div className="mt-1.5 grid grid-cols-2 gap-3">
            <Stat label="Publications" value={member.pubs} />
            <Stat label="h-index" value={member.hIndex} />
          </div>
        </Card>

        <AffiliationTimeline history={member.history} />
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

function AffiliationTimeline({ history }: { history: AffiliationPeriod[] }) {
  return (
    <Card>
      <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
        Historique des affiliations
      </div>
      <h3 className="m-0 mb-4 mt-1 font-serif text-lg font-medium">Cycle de vie au laboratoire</h3>
      <div className="relative pl-[18px]">
        <div className="absolute bottom-1.5 left-[5px] top-1.5 w-px bg-line" />
        {history.map((h, i) => {
          const isCurrent = h.to === null;
          return (
            <div key={i} className="relative pb-4 pl-2">
              <div
                className="absolute -left-[18px] top-1 h-[11px] w-[11px] rounded-full border-2"
                style={{
                  background: isCurrent ? 'var(--navy)' : 'var(--surface)',
                  borderColor: isCurrent ? 'var(--navy)' : 'var(--muted)',
                }}
              />
              <div className="font-mono text-[11px] text-muted">
                {fmtMonthYearFR(h.from)} — {fmtMonthYearFR(h.to)}
              </div>
              <div
                className={`mt-px font-serif text-[14.5px] text-ink ${isCurrent ? 'font-medium' : 'font-normal'}`}
              >
                {h.role}
              </div>
            </div>
          );
        })}
      </div>
    </Card>
  );
}

function PublicationsList({ member }: { member: Member }) {
  const lastName = member.lastName.split(' ').pop() ?? '';
  const firstInit = member.firstName[0];
  const mine = PUBLICATIONS.filter((p) =>
    p.authors.some((a) => a.includes(lastName) || a.includes(`${firstInit}. ${lastName}`)),
  ).slice(0, 4);

  if (mine.length === 0) return null;

  return (
    <div className="mt-[22px]">
      <div className="mb-2 flex items-baseline justify-between">
        <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
          Publications récentes
        </div>
        <span className="font-sans text-xs text-navy">Voir tout →</span>
      </div>
      {mine.map((p) => (
        <div key={p.id} className="border-t border-line py-2.5">
          <div className="font-serif text-[14.5px] leading-[1.35] text-ink">{p.title}</div>
          <div className="mt-1 flex items-center gap-2 font-sans text-[11.5px] text-muted">
            <span>{p.authors.join(', ')}</span>
            <span>·</span>
            <span className="font-mono">
              {p.venue}, {p.year}
            </span>
            <Badge tone="muted">{p.type}</Badge>
          </div>
        </div>
      ))}
    </div>
  );
}
