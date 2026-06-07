import type { MemberStatus } from '@/types';
import { Badge, type BadgeTone } from './Badge';

const MAP: Record<MemberStatus, { label: string; tone: BadgeTone }> = {
  permanent: { label: 'Permanent', tone: 'sage' },
  associe: { label: 'Associé', tone: 'gold' },
  doctorant: { label: 'Doctorant', tone: 'navy' },
  retraite: { label: 'Retraité', tone: 'muted' },
  ancien: { label: 'Ancien', tone: 'burgundy' },
};

export function StatusBadge({ status }: { status: MemberStatus }) {
  const m = MAP[status];
  return <Badge tone={m.tone}>{m.label}</Badge>;
}
