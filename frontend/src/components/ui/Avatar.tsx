import type { MemberStatus } from '@/types';

export type AvatarTone = 'navy' | 'sand' | 'burgundy' | 'sage' | 'muted';

const PALETTE: Record<AvatarTone, { bg: string; fg: string; ring: string }> = {
  navy: { bg: 'var(--surface-2)', fg: 'var(--ink)', ring: 'var(--border)' },
  sand: { bg: '#E8DFC9', fg: '#5A4A1F', ring: '#D7C9A4' },
  burgundy: { bg: '#E9D9D6', fg: '#5A2A28', ring: '#D6BAB5' },
  sage: { bg: '#D9E4D7', fg: '#33503A', ring: '#BBCFB7' },
  muted: { bg: 'var(--border)', fg: 'var(--muted)', ring: 'var(--border)' },
};

const STATUS_DOT: Record<MemberStatus, string> = {
  permanent: '#2F6B43',
  associe: '#7A5B2E',
  doctorant: '#1B2F4A',
  retraite: '#9A9A8E',
  ancien: '#B5453E',
};

interface AvatarProps {
  initials: string;
  size?: number;
  tone?: AvatarTone;
  status?: MemberStatus;
}

export function Avatar({ initials, size = 36, tone = 'navy', status }: AvatarProps) {
  const c = PALETTE[tone];
  const dot = Math.max(8, size * 0.22);
  return (
    <div className="relative flex-shrink-0" style={{ width: size, height: size }}>
      <div
        className="flex items-center justify-center rounded-full font-serif font-semibold"
        style={{
          width: size,
          height: size,
          background: c.bg,
          color: c.fg,
          border: `1px solid ${c.ring}`,
          fontSize: size * 0.38,
          letterSpacing: '0.02em',
        }}
      >
        {initials}
      </div>
      {status && (
        <span
          className="absolute rounded-full"
          style={{
            right: -1,
            bottom: -1,
            width: dot,
            height: dot,
            background: STATUS_DOT[status],
            border: '2px solid var(--surface)',
          }}
        />
      )}
    </div>
  );
}
