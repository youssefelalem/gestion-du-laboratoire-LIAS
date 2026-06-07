import { Search } from 'lucide-react';
import { cn } from '@/lib/cn';

interface SearchInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
}

export function SearchInput({
  value,
  onChange,
  placeholder = 'Recherche…',
  className,
}: SearchInputProps) {
  return (
    <div
      className={cn(
        'flex items-center gap-2 rounded-[2px] border border-line bg-surface px-3 py-[7px]',
        className,
      )}
    >
      <Search size={14} strokeWidth={1.8} className="text-muted" />
      <input
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="flex-1 border-none bg-transparent font-sans text-[13px] text-ink outline-none placeholder:text-muted"
      />
    </div>
  );
}
