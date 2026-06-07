export function Wordmark() {
  return (
    <div className="flex items-center gap-2.5">
      <div className="flex h-[34px] w-[34px] items-center justify-center bg-navy font-serif text-lg font-semibold tracking-[-0.02em] text-cream">
        L
      </div>
      <div className="font-serif text-xl font-medium leading-none tracking-[-0.01em]">
        LIAS
        <span className="ml-1.5 font-mono text-[10px] tracking-[0.1em] text-muted">· EST. 2003</span>
      </div>
    </div>
  );
}
