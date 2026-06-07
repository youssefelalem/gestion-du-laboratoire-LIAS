interface EmptyProps {
  title: string;
  sub?: string;
}

export function Empty({ title, sub }: EmptyProps) {
  return (
    <div className="px-6 py-12 text-center text-muted">
      <div className="mb-1.5 font-serif text-lg">{title}</div>
      {sub && <div className="font-sans text-[13px]">{sub}</div>}
    </div>
  );
}
