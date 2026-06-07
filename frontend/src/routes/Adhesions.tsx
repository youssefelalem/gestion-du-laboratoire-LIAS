import { useState } from 'react';
import { ADHESIONS_INIT, TEAMS } from '@/data';
import { Avatar, Badge, Button, Card, Chip, Empty, Meta, Modal, SectionHead } from '@/components/ui';
import { fmtFR } from '@/lib/format';
import type { Adhesion, AdhesionStatus } from '@/types';

type Filter = AdhesionStatus | 'tous';

export default function Adhesions() {
  const [requests, setRequests] = useState<Adhesion[]>(ADHESIONS_INIT);
  const [openId, setOpenId] = useState<string | null>(null);
  const [decisionModal, setDecisionModal] = useState<{ id: string; action: AdhesionStatus } | null>(
    null,
  );
  const [reason, setReason] = useState('');
  const [filter, setFilter] = useState<Filter>('en attente');
  const [toast, setToast] = useState<string | null>(null);

  const open = openId ? (requests.find((r) => r.id === openId) ?? null) : null;
  const filtered = requests.filter((r) => filter === 'tous' || r.status === filter);
  const counts = {
    'en attente': requests.filter((r) => r.status === 'en attente').length,
    acceptée: requests.filter((r) => r.status === 'acceptée').length,
    refusée: requests.filter((r) => r.status === 'refusée').length,
  };

  function decide(id: string, action: AdhesionStatus) {
    setRequests((prev) =>
      prev.map((r) =>
        r.id === id
          ? { ...r, status: action, reason, decidedAt: '2026-05-26', decidedBy: 'Pr. Yassine El Amrani' }
          : r,
      ),
    );
    setDecisionModal(null);
    setReason('');
    setOpenId(null);
    setToast(
      `Demande ${action === 'acceptée' ? 'acceptée — compte créé' : 'refusée — notification envoyée'}.`,
    );
    window.setTimeout(() => setToast(null), 3500);
  }

  const FILTERS: { id: Filter; label: string }[] = [
    { id: 'en attente', label: `En attente (${counts['en attente']})` },
    { id: 'acceptée', label: `Acceptées (${counts.acceptée})` },
    { id: 'refusée', label: `Refusées (${counts.refusée})` },
    { id: 'tous', label: 'Tous' },
  ];

  return (
    <div>
      <SectionHead
        eyebrow={`${counts['en attente']} demandes en attente · décisions exclusivement directionnelles`}
        title="Demandes d'adhésion"
        subtitle="Chaque décision est tracée, datée et signée. L'acceptation crée le compte ; le refus déclenche une notification motivée."
      />

      <div className="mb-3.5 flex gap-2">
        {FILTERS.map((t) => (
          <Chip key={t.id} active={filter === t.id} onClick={() => setFilter(t.id)}>
            {t.label}
          </Chip>
        ))}
      </div>

      <div className="grid grid-cols-2 gap-3.5">
        {filtered.map((r) => (
          <RequestCard key={r.id} req={r} onOpen={() => setOpenId(r.id)} />
        ))}
        {filtered.length === 0 && (
          <Card className="col-span-2">
            <Empty title="Aucune demande dans cet état." />
          </Card>
        )}
      </div>

      {/* Detail modal */}
      <Modal open={!!open} onClose={() => setOpenId(null)} width={760}>
        {open && (
          <div>
            <div className="border-b border-line px-7 pb-[18px] pt-[22px]">
              <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
                Demande #{open.id.toUpperCase()} · soumise le {fmtFR(open.submitted)}
              </div>
              <div className="mt-2 flex items-center gap-3.5">
                <Avatar initials={open.initials} size={56} tone="sand" />
                <div className="flex-1">
                  <h2 className="m-0 font-serif text-2xl font-medium">{open.name}</h2>
                  <div className="mt-0.5 font-sans text-[13px] text-muted">
                    {open.grade} · {open.inst}
                  </div>
                </div>
                <Badge
                  tone={
                    open.status === 'en attente' ? 'gold' : open.status === 'acceptée' ? 'sage' : 'burgundy'
                  }
                >
                  {open.status}
                </Badge>
              </div>
            </div>

            <div className="px-7 py-[18px]">
              <div className="mb-[18px] grid grid-cols-2 gap-3.5">
                <Meta k="Type d'adhésion" v={open.type} />
                <Meta k="Équipe ciblée" v={TEAMS.find((t) => t.id === open.target_team)?.name ?? '—'} />
                <Meta k="Publications" v={`${open.publications} · h-index ${open.hIndex}`} mono />
                <Meta k="CV joint" v={open.cv} mono />
              </div>

              <div className="mb-1.5 font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
                Lettre de motivation
              </div>
              <div className="border-l-[3px] border-navy bg-surface-2 px-4 py-3.5 font-serif text-[15px] italic leading-[1.6] text-ink">
                « {open.motivation} »
              </div>

              {open.status !== 'en attente' && (
                <div className="mt-[18px] border border-line bg-surface-2 p-3.5">
                  <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
                    Décision archivée
                  </div>
                  <div className="mt-1 font-serif text-sm">
                    {open.status === 'acceptée' ? 'Acceptée' : 'Refusée'} le {fmtFR(open.decidedAt)} par{' '}
                    {open.decidedBy}
                  </div>
                  {open.reason && (
                    <div className="mt-1.5 font-sans text-[12.5px] italic text-muted">« {open.reason} »</div>
                  )}
                </div>
              )}
            </div>

            {open.status === 'en attente' && (
              <div className="flex justify-end gap-2 border-t border-line px-7 pb-[22px] pt-3.5">
                <Button variant="ghost" onClick={() => setOpenId(null)}>
                  Fermer
                </Button>
                <Button
                  variant="danger"
                  onClick={() => setDecisionModal({ id: open.id, action: 'refusée' })}
                >
                  Refuser
                </Button>
                <Button
                  variant="accept"
                  onClick={() => setDecisionModal({ id: open.id, action: 'acceptée' })}
                >
                  Accepter et créer le compte
                </Button>
              </div>
            )}
          </div>
        )}
      </Modal>

      {/* Decision confirmation modal */}
      <Modal open={!!decisionModal} onClose={() => setDecisionModal(null)} width={460}>
        {decisionModal && (
          <div className="px-7 py-6">
            <div className="font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
              Confirmation
            </div>
            <h3 className="m-0 mb-3 mt-1 font-serif text-xl font-medium">
              {decisionModal.action === 'acceptée' ? "Accepter l'adhésion" : "Refuser l'adhésion"}
            </h3>
            <p className="m-0 mb-3.5 font-sans text-[13px] leading-[1.55] text-muted">
              {decisionModal.action === 'acceptée'
                ? "Un compte sera créé. Le membre recevra ses identifiants par email et apparaîtra dans l'annuaire du laboratoire."
                : 'Une notification motivée sera envoyée au candidat. La décision sera archivée définitivement.'}
            </p>
            <label className="mb-1.5 block font-mono text-[10.5px] uppercase tracking-[0.15em] text-muted">
              {decisionModal.action === 'acceptée' ? 'Note interne (optionnelle)' : 'Motif du refus'}
            </label>
            <textarea
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              rows={3}
              placeholder={
                decisionModal.action === 'acceptée'
                  ? "Affecter à l'équipe IA — encadrement Pr. Tazi…"
                  : 'Profil hors thématiques actuelles du laboratoire…'
              }
              className="w-full resize-y rounded-[2px] border border-line bg-surface-2 p-2.5 font-sans text-[13px] text-ink outline-none"
            />
            <div className="mt-4 flex justify-end gap-2">
              <Button variant="ghost" onClick={() => setDecisionModal(null)}>
                Annuler
              </Button>
              <Button
                variant={decisionModal.action === 'acceptée' ? 'accept' : 'danger'}
                onClick={() => decide(decisionModal.id, decisionModal.action)}
              >
                Confirmer
              </Button>
            </div>
          </div>
        )}
      </Modal>

      {/* Toast */}
      {toast && (
        <div className="fixed bottom-6 left-1/2 z-[1100] -translate-x-1/2 bg-ink px-[18px] py-3 font-sans text-[13px] text-cream shadow-[0_12px_32px_rgba(20,18,14,0.25)]">
          {toast}
        </div>
      )}
    </div>
  );
}

function RequestCard({ req, onOpen }: { req: Adhesion; onOpen: () => void }) {
  const team = TEAMS.find((t) => t.id === req.target_team);
  return (
    <Card padded={false}>
      <div className="flex items-start gap-3.5 px-5 py-[18px]">
        <Avatar initials={req.initials} size={44} tone="sand" />
        <div className="min-w-0 flex-1">
          <div className="flex items-baseline justify-between gap-2.5">
            <div className="font-serif text-lg font-medium text-ink">{req.name}</div>
            <span className="font-mono text-[11px] text-muted">{fmtFR(req.submitted)}</span>
          </div>
          <div className="mt-0.5 font-sans text-[12.5px] text-muted">{req.grade}</div>
          <div className="mt-2.5 flex flex-wrap gap-1.5">
            <Badge tone="navy">{req.type}</Badge>
            <Badge tone="neutral">→ {team?.short ?? '—'}</Badge>
            <Badge tone="muted">
              {req.publications} pubs · h{req.hIndex}
            </Badge>
            {req.status !== 'en attente' && (
              <Badge tone={req.status === 'acceptée' ? 'sage' : 'burgundy'}>{req.status}</Badge>
            )}
          </div>
        </div>
      </div>
      <div className="border-t border-line px-5 py-2.5 font-serif text-[13.5px] italic text-muted">
        « {req.motivation.slice(0, 120)}
        {req.motivation.length > 120 ? '…' : ''} »
      </div>
      <div className="flex items-center justify-between border-t border-line px-5 py-2.5">
        <div className="font-mono text-[11px] text-muted">{req.inst}</div>
        <Button variant="ghost" size="sm" onClick={onOpen}>
          Examiner →
        </Button>
      </div>
    </Card>
  );
}
