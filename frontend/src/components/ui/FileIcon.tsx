const COLORS: Record<string, { bg: string; fg: string }> = {
  pdf: { bg: '#E9D9D6', fg: '#7A2A26' },
  docx: { bg: '#DBE5F0', fg: '#1B2F4A' },
  xlsx: { bg: '#D9E4D7', fg: '#33503A' },
  zip: { bg: '#EDE5D3', fg: '#7A5B2E' },
};

/** Vignette « feuille » avec coin replié et extension. */
export function FileIcon({ type }: { type: string }) {
  const c = COLORS[type] ?? { bg: 'var(--surface-2)', fg: 'var(--muted)' };
  return (
    <div
      className="relative flex h-[38px] w-8 flex-shrink-0 items-end justify-center pb-1 font-mono text-[9px] font-semibold uppercase tracking-[0.05em]"
      style={{ background: c.bg, border: `1px solid ${c.fg}`, color: c.fg }}
    >
      <span
        className="absolute right-0 top-0 h-2 w-2"
        style={{ background: 'var(--surface)', borderLeft: `1px solid ${c.fg}`, borderBottom: `1px solid ${c.fg}` }}
      />
      {type.toUpperCase()}
    </div>
  );
}
