import { useEffect, useRef, useState } from 'react';
import { CHANNELS, MESSAGES_GENERAL } from '@/data';
import { useSession } from '@/context/SessionContext';
import { Avatar, Badge, Button, Card, Empty, IconBtn, SearchInput } from '@/components/ui';
import { SectionHead } from '@/components/ui';
import type { ChatMessageData } from '@/types';

export default function Communication() {
  const { currentMember } = useSession();
  const [channelId, setChannelId] = useState('general');
  const [draft, setDraft] = useState('');
  const [messages, setMessages] = useState<ChatMessageData[]>(MESSAGES_GENERAL);
  const [chanQuery, setChanQuery] = useState('');
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages, channelId]);

  const channel = CHANNELS.find((c) => c.id === channelId);
  const q = chanQuery.trim().toLowerCase();
  const match = (kind: string) =>
    CHANNELS.filter((c) => c.kind === kind && (!q || c.name.toLowerCase().includes(q)));

  const groups: [string, ReturnType<typeof match>][] = [
    ['général', [...match('général'), ...match('direction'), ...match('groupe')]],
    ['équipes', match('équipe')],
    ['évènements', match('évènement')],
  ];

  function send() {
    if (!draft.trim()) return;
    setMessages([
      ...messages,
      {
        id: Date.now(),
        who: currentMember ? `${currentMember.firstName[0]}. ${currentMember.lastName}` : 'Vous',
        role: 'Vous',
        time: "à l'instant",
        body: draft.trim(),
        self: true,
      },
    ]);
    setDraft('');
  }

  return (
    <div>
      <SectionHead
        eyebrow="Espaces de discussion · canaux thématiques · liaison avec les évènements"
        title="Communication interne"
        subtitle="Discussions entre membres, par équipe, ou autour des évènements organisés. Tout est archivé et lié à la mémoire institutionnelle."
      />

      <Card padded={false} className="grid h-[70vh] grid-cols-[260px_1fr] overflow-hidden">
        {/* Channels */}
        <div className="overflow-auto border-r border-line bg-surface-2">
          <div className="px-3.5 pb-2 pt-3.5">
            <SearchInput value={chanQuery} onChange={setChanQuery} placeholder="Rechercher canal…" />
          </div>

          {groups.map(([label, list]) => (
            <div key={label}>
              <div className="px-4 pb-1.5 pt-3.5 font-mono text-[10px] uppercase tracking-[0.18em] text-muted">
                {label}
              </div>
              {list.map((c) => {
                const active = c.id === channelId;
                return (
                  <button
                    key={c.id}
                    onClick={() => setChannelId(c.id)}
                    className={`flex w-full items-center gap-2 border-l-2 px-4 py-2 text-left font-sans text-[13px] text-ink ${
                      active ? 'border-l-navy bg-surface font-medium' : 'border-l-transparent font-normal'
                    }`}
                  >
                    <span className={`font-mono text-sm ${active ? 'text-navy' : 'text-muted'}`}>#</span>
                    <span className="flex-1 overflow-hidden text-ellipsis whitespace-nowrap">{c.name}</span>
                    {c.unread > 0 && (
                      <span className="rounded-full bg-navy px-1.5 py-px font-mono text-[9.5px] font-semibold text-cream">
                        {c.unread}
                      </span>
                    )}
                  </button>
                );
              })}
            </div>
          ))}
        </div>

        {/* Chat pane */}
        <div className="flex min-w-0 flex-col">
          <div className="flex items-center justify-between border-b border-line px-[22px] py-3.5">
            <div>
              <div className="flex items-center gap-2">
                <span className="font-mono text-lg text-navy">#</span>
                <h3 className="m-0 font-serif text-lg font-medium">{channel?.name}</h3>
                <Badge tone="muted">{channel?.members} membres</Badge>
              </div>
              <div className="mt-0.5 font-sans text-xs text-muted">
                Canal {channel?.kind} · créé automatiquement par le système
              </div>
            </div>
            <div className="flex gap-2">
              <IconBtn title="Membres">⚇</IconBtn>
              <IconBtn title="Fichiers partagés">▦</IconBtn>
              <IconBtn title="Paramètres">⚙</IconBtn>
            </div>
          </div>

          <div ref={scrollRef} className="flex-1 overflow-auto bg-surface px-[22px] py-5">
            {channelId === 'general' ? (
              messages.map((m) => <ChatMessage key={m.id} m={m} />)
            ) : (
              <Empty
                title={`Aperçu du canal #${channel?.name}`}
                sub="Ouvrez la discussion générale pour voir les messages en exemple."
              />
            )}
          </div>

          <div className="border-t border-line bg-surface-2 px-[22px] py-3.5">
            <div className="flex items-end gap-2.5 border border-line bg-surface px-3 py-2.5">
              <textarea
                value={draft}
                onChange={(e) => setDraft(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    send();
                  }
                }}
                rows={1}
                placeholder={`Écrire dans #${channel?.name}…`}
                className="max-h-[120px] min-h-[22px] flex-1 resize-none border-none bg-transparent font-sans text-sm text-ink outline-none"
              />
              <button title="Joindre un fichier" className="border-none bg-transparent p-0 font-mono text-lg text-muted">
                ⌁
              </button>
              <Button variant="primary" size="sm" onClick={send} disabled={!draft.trim()}>
                Envoyer
              </Button>
            </div>
            <div className="mt-1.5 font-mono text-[10px] tracking-[0.05em] text-muted">
              ⏎ envoyer · ⇧⏎ retour à la ligne · les messages sont archivés et liés à la mémoire du
              laboratoire
            </div>
          </div>
        </div>
      </Card>
    </div>
  );
}

function ChatMessage({ m }: { m: ChatMessageData }) {
  const initials = (m.who.match(/[A-ZÉÈ]/g) ?? ['?', '?']).slice(0, 2).join('');
  return (
    <div className="mb-[18px] grid grid-cols-[40px_1fr] gap-3">
      <Avatar initials={initials} size={36} tone={m.self ? 'sage' : 'navy'} />
      <div>
        <div className="mb-0.5 flex items-baseline gap-2">
          <span className="font-serif text-[14.5px] font-medium text-ink">{m.who}</span>
          <span className="font-mono text-[10px] uppercase tracking-[0.05em] text-muted">{m.role}</span>
          <span className="font-mono text-[10.5px] text-muted">· {m.time}</span>
        </div>
        <div className="font-sans text-[13.5px] leading-[1.5] text-ink">{m.body}</div>
        {m.attach && (
          <div className="mt-2 inline-flex items-center gap-2 border border-line bg-surface-2 px-3 py-2">
            <span className="font-mono text-[9px] font-semibold uppercase text-[#7A2A26]">pdf</span>
            <div>
              <div className="font-serif text-[13px] text-ink">{m.attach}</div>
              <div className="mt-px font-mono text-[10.5px] text-muted">PDF · 240 KB</div>
            </div>
            <Button variant="ghost" size="sm" className="ml-3">
              ⤓
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
