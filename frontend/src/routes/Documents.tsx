import { Fragment, useMemo, useState } from 'react';
import { DOCUMENTS } from '@/data';
import { useSession } from '@/context/SessionContext';
import { Button, Card, FileIcon, IconBtn, SearchInput, SectionHead } from '@/components/ui';
import { fmtFR } from '@/lib/format';
import type { DocFile } from '@/types';

type FoundDoc = DocFile & { path: string };
type Selection = { root: string; sub: string; ed: string | null };

export default function Documents() {
  const { roleId } = useSession();
  const firstRoot = Object.keys(DOCUMENTS)[0];
  const firstSub = Object.keys(DOCUMENTS[firstRoot])[0];
  const firstSubNode = DOCUMENTS[firstRoot][firstSub];
  const firstEd = Array.isArray(firstSubNode) ? null : Object.keys(firstSubNode)[0];

  const [open, setOpen] = useState<Record<string, boolean>>({
    [firstRoot]: true,
    [`${firstRoot}/${firstSub}`]: true,
  });
  const [selected, setSelected] = useState<Selection>({ root: firstRoot, sub: firstSub, ed: firstEd });
  const [search, setSearch] = useState('');

  const toggle = (k: string) => setOpen((o) => ({ ...o, [k]: !o[k] }));

  const node: DocFile[] = useMemo(() => {
    const sub = DOCUMENTS[selected.root]?.[selected.sub];
    if (!sub) return [];
    if (Array.isArray(sub)) return sub;
    return (selected.ed && sub[selected.ed]) || [];
  }, [selected]);

  const allDocs = useMemo<FoundDoc[]>(() => {
    const out: FoundDoc[] = [];
    Object.entries(DOCUMENTS).forEach(([root, subs]) => {
      Object.entries(subs).forEach(([sub, content]) => {
        if (Array.isArray(content)) {
          content.forEach((d) => out.push({ ...d, path: `${root} / ${sub}` }));
        } else {
          Object.entries(content).forEach(([ed, files]) => {
            files.forEach((f) => out.push({ ...f, path: `${root} / ${sub} / ${ed}` }));
          });
        }
      });
    });
    return out;
  }, []);

  const q = search.trim().toLowerCase();
  const searchResults = q
    ? allDocs.filter((d) => d.name.toLowerCase().includes(q) || d.path.toLowerCase().includes(q))
    : null;

  const canEdit = roleId !== 'visiteur';

  return (
    <div>
      <SectionHead
        eyebrow={`${allDocs.length} documents archivés · 4 types · historisation complète`}
        title="Archive documentaire"
        subtitle="Mémoire institutionnelle du laboratoire : programmes, attestations, rapports, demandes de financement — tous organisés par évènement et par date."
        right={canEdit ? <Button variant="primary">⤒ Téléverser</Button> : undefined}
      />

      <div className="mb-3.5">
        <SearchInput value={search} onChange={setSearch} placeholder="Rechercher dans 412 documents…" className="w-full" />
      </div>

      <div className="grid grid-cols-[320px_1fr] gap-[18px]">
        {/* Tree */}
        <Card padded={false} className="self-start">
          <div className="border-b border-line px-4 py-3 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
            Arborescence
          </div>
          <div className="px-1.5 py-2">
            {Object.entries(DOCUMENTS).map(([root, subs]) => {
              const isOpen = open[root];
              return (
                <div key={root}>
                  <TreeRow onClick={() => toggle(root)} caret={isOpen ? '▾' : '▸'} icon="▦" label={root} bold />
                  {isOpen &&
                    Object.entries(subs).map(([sub, content]) => {
                      const subKey = `${root}/${sub}`;
                      const isFolder = !Array.isArray(content);
                      const isSubOpen = open[subKey];
                      const isSubSelected =
                        selected.root === root && selected.sub === sub && Array.isArray(content);
                      return (
                        <div key={sub}>
                          <TreeRow
                            indent={1}
                            onClick={() => (isFolder ? toggle(subKey) : setSelected({ root, sub, ed: null }))}
                            caret={isFolder ? (isSubOpen ? '▾' : '▸') : ''}
                            icon="▤"
                            label={sub}
                            count={isFolder ? Object.keys(content).length : content.length}
                            selected={isSubSelected}
                          />
                          {isFolder &&
                            isSubOpen &&
                            Object.entries(content).map(([ed, files]) => (
                              <TreeRow
                                key={ed}
                                indent={2}
                                onClick={() => setSelected({ root, sub, ed })}
                                icon="◦"
                                label={ed}
                                count={files.length}
                                selected={selected.root === root && selected.sub === sub && selected.ed === ed}
                              />
                            ))}
                        </div>
                      );
                    })}
                </div>
              );
            })}
          </div>
        </Card>

        {/* Files or search */}
        <div>
          {searchResults ? (
            <SearchResults docs={searchResults} q={search} />
          ) : (
            <FilesList
              path={[selected.root, selected.sub, selected.ed].filter(Boolean) as string[]}
              files={node}
              canEdit={canEdit}
            />
          )}
        </div>
      </div>
    </div>
  );
}

function TreeRow({
  indent = 0,
  onClick,
  caret,
  icon,
  label,
  count,
  bold,
  selected,
}: {
  indent?: number;
  onClick: () => void;
  caret?: string;
  icon: string;
  label: string;
  count?: number;
  bold?: boolean;
  selected?: boolean;
}) {
  return (
    <button
      onClick={onClick}
      style={{ paddingLeft: 10 + indent * 16 }}
      className={`flex w-full items-center gap-1.5 border-l-2 py-1.5 pr-2.5 text-left font-sans text-[13px] text-ink hover:bg-surface-2 ${
        selected ? 'border-l-navy bg-surface-2' : 'border-l-transparent'
      } ${bold ? 'font-medium' : 'font-normal'}`}
    >
      <span className="w-2.5 font-mono text-[9px] text-muted">{caret}</span>
      <span className={`font-mono text-xs ${bold ? 'text-navy' : 'text-muted'}`}>{icon}</span>
      <span className="flex-1 overflow-hidden text-ellipsis whitespace-nowrap">{label}</span>
      {count !== undefined && <span className="font-mono text-[10.5px] text-muted">{count}</span>}
    </button>
  );
}

function FilesList({ path, files, canEdit }: { path: string[]; files: DocFile[]; canEdit: boolean }) {
  return (
    <div>
      <div className="mb-3.5 flex items-center gap-2 font-sans text-[13px]">
        {path.map((p, i) => (
          <Fragment key={i}>
            <span
              className={
                i === path.length - 1 ? 'font-serif text-base text-ink' : 'font-sans text-[13px] text-muted'
              }
            >
              {p}
            </span>
            {i < path.length - 1 && <span className="text-muted">/</span>}
          </Fragment>
        ))}
        <span className="ml-auto font-mono text-[11.5px] text-muted">{files.length} fichiers</span>
      </div>

      <Card padded={false}>
        {canEdit && (
          <div className="m-3.5 flex items-center justify-between gap-3.5 border border-dashed border-line bg-surface-2 p-[18px]">
            <div className="flex items-center gap-3">
              <div className="font-mono text-2xl text-muted">⤒</div>
              <div>
                <div className="font-serif text-[15px] text-ink">Glissez-déposez des fichiers ici</div>
                <div className="mt-0.5 font-sans text-xs text-muted">
                  PDF, DOCX, XLSX, ZIP · 50 MB max par fichier · historisation automatique
                </div>
              </div>
            </div>
            <Button variant="ghost" size="md">
              Parcourir
            </Button>
          </div>
        )}

        <table className="w-full border-collapse font-sans">
          <thead>
            <tr className="bg-surface-2">
              {['Nom', 'Taille', 'Date', 'Ajouté par', ''].map((h, i) => (
                <th
                  key={i}
                  className="px-3.5 py-2 text-left font-mono text-[11px] font-medium uppercase tracking-[0.1em] text-muted"
                >
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {files.map((f, i) => (
              <tr key={i} className="border-t border-line">
                <td className="px-3.5 py-3">
                  <div className="flex items-center gap-3">
                    <FileIcon type={f.type} />
                    <span className="font-serif text-[14.5px] text-ink">{f.name}</span>
                  </div>
                </td>
                <td className="px-2.5 py-3 font-mono text-[11.5px] text-muted">{f.size}</td>
                <td className="px-2.5 py-3 font-mono text-[11.5px] text-muted">{fmtFR(f.date)}</td>
                <td className="px-2.5 py-3 font-sans text-[12.5px]">{f.by}</td>
                <td className="px-2.5 py-3 text-right">
                  <div className="flex justify-end gap-1">
                    <IconBtn title="Télécharger">⤓</IconBtn>
                    <IconBtn title="Aperçu">◉</IconBtn>
                    {canEdit && <IconBtn title="Historique">⟲</IconBtn>}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
    </div>
  );
}

function SearchResults({ docs, q }: { docs: FoundDoc[]; q: string }) {
  return (
    <div>
      <div className="mb-3.5 font-serif text-base text-ink">
        <strong className="font-medium">{docs.length}</strong> résultat·s pour <em>« {q} »</em>
      </div>
      <Card padded={false}>
        {docs.map((d, i) => (
          <div
            key={i}
            className={`grid grid-cols-[auto_1fr_auto] items-center gap-3.5 px-[18px] py-3.5 ${
              i === 0 ? '' : 'border-t border-line'
            }`}
          >
            <FileIcon type={d.type} />
            <div>
              <div className="font-serif text-[14.5px] text-ink">{d.name}</div>
              <div className="mt-0.5 font-mono text-[11px] text-muted">
                {d.path} · {d.size} · {fmtFR(d.date)}
              </div>
            </div>
            <Button variant="ghost" size="sm" icon="⤓">
              Télécharger
            </Button>
          </div>
        ))}
      </Card>
    </div>
  );
}
