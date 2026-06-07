import { useState } from 'react';
import { MEMBERS } from '@/data';
import {
  Avatar,
  Badge,
  Button,
  Card,
  FormField,
  IconBtn,
  KPI,
  SearchInput,
  SectionHead,
  StatusBadge,
  fieldClass,
} from '@/components/ui';
import type { Member } from '@/types';

const ROLE_LABEL: Record<string, string> = {
  directeur: 'Directeur',
  'vice-directeur': 'Vice-direction',
  'chef-equipe': "Chef d'équipe",
  membre: 'Membre',
  aucun: '—',
};

export default function Admin() {
  const [tab, setTab] = useState<'comptes' | 'parametres' | 'journal' | 'maintenance'>('comptes');

  const TABS: { id: typeof tab; label: string }[] = [
    { id: 'comptes', label: 'Comptes utilisateurs' },
    { id: 'parametres', label: 'Paramètres du laboratoire' },
    { id: 'journal', label: 'Journal des actions' },
    { id: 'maintenance', label: 'Maintenance' },
  ];

  return (
    <div>
      <SectionHead
        eyebrow="Maintenance · comptes utilisateurs · paramétrage technique"
        title="Administration système"
        subtitle="Gestion des comptes, paramétrage du laboratoire et journal des actions techniques. Réservé à l'administrateur et à la direction."
      />

      <div className="mb-[22px] grid grid-cols-4 gap-3">
        <KPI label="Comptes actifs" value="33" sub="3 rôles distincts" accent="#33503A" />
        <KPI label="Comptes gelés" value="2" sub="retraités" />
        <KPI label="Comptes désactivés" value="1" sub="anciens membres" />
        <KPI label="Stockage utilisé" value="2.4 GB" sub="sur 50 GB" accent="var(--navy)" />
      </div>

      <div className="mb-5 flex border-b border-line">
        {TABS.map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={`-mb-px border-b-2 px-[18px] py-2.5 font-serif text-[15px] ${
              tab === t.id ? 'border-navy text-ink' : 'border-transparent italic text-muted'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab === 'comptes' && <AccountsTab members={MEMBERS} />}
      {tab === 'parametres' && <SettingsTab />}
      {tab === 'journal' && <JournalTab />}
      {tab === 'maintenance' && <MaintenanceTab />}
    </div>
  );
}

function AccountsTab({ members }: { members: Member[] }) {
  const [q, setQ] = useState('');
  const filtered = members.filter(
    (m) =>
      !q.trim() ||
      `${m.firstName} ${m.lastName} ${m.email}`.toLowerCase().includes(q.trim().toLowerCase()),
  );

  return (
    <Card padded={false}>
      <div className="flex items-center justify-between border-b border-line px-[18px] py-3.5">
        <SearchInput value={q} onChange={setQ} placeholder="Filtrer les comptes…" className="w-[320px]" />
        <div className="flex gap-2">
          <Button variant="ghost" size="sm">
            ⤓ Exporter CSV
          </Button>
          <Button variant="primary" size="sm">
            + Créer un compte
          </Button>
        </div>
      </div>
      <table className="w-full border-collapse font-sans">
        <thead>
          <tr className="bg-surface-2">
            {['', 'Identité', 'Email', 'Statut', 'Rôle', 'Dernière connexion', 'Actions'].map((h, i) => (
              <th
                key={i}
                className="px-2.5 py-2 text-left font-mono text-[11px] font-medium uppercase tracking-[0.1em] text-muted"
              >
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {filtered.map((m) => (
            <tr key={m.id} className="border-t border-line">
              <td className="px-3.5 py-2.5">
                <Avatar initials={m.initials} size={32} status={m.status} />
              </td>
              <td className="px-2.5 py-2.5">
                <div className="font-serif text-sm text-ink">
                  {m.firstName} {m.lastName}
                </div>
                <div className="font-mono text-[10.5px] text-muted">#{m.id.toUpperCase()}</div>
              </td>
              <td className="px-2.5 py-2.5 font-mono text-[11.5px] text-muted">{m.email}</td>
              <td className="px-2.5 py-2.5">
                <StatusBadge status={m.status} />
              </td>
              <td className="px-2.5 py-2.5 font-sans text-[12.5px]">{ROLE_LABEL[m.role]}</td>
              <td className="px-2.5 py-2.5 font-mono text-[11.5px] text-muted">
                {m.status === 'retraite' || m.status === 'ancien'
                  ? '—'
                  : `${(m.id.charCodeAt(0) % 48) + 1}h`}
              </td>
              <td className="px-2.5 py-2.5">
                <div className="flex gap-1">
                  <IconBtn title="Réinitialiser le mot de passe">⟲</IconBtn>
                  <IconBtn title="Modifier">✎</IconBtn>
                  <IconBtn title="Geler / Désactiver">⊘</IconBtn>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </Card>
  );
}

function SettingsTab() {
  return (
    <div className="grid grid-cols-2 gap-[18px]">
      <Card>
        <h3 className="m-0 mb-3.5 font-serif text-lg font-medium">Identité du laboratoire</h3>
        <div className="flex flex-col gap-3.5">
          <FormField label="Nom du laboratoire">
            <input defaultValue="Laboratoire d'Informatique et Applications Scientifiques (LIAS)" className={fieldClass} />
          </FormField>
          <FormField label="Établissement">
            <input defaultValue="Faculté des Sciences Ben M'Sik — Casablanca" className={fieldClass} />
          </FormField>
          <FormField label="Date de création">
            <input type="date" defaultValue="2003-03-14" className={fieldClass} />
          </FormField>
          <FormField label="Domaine email institutionnel">
            <input defaultValue="@lias.ma" className={`${fieldClass} font-mono`} />
          </FormField>
        </div>
      </Card>

      <Card>
        <h3 className="m-0 mb-3.5 font-serif text-lg font-medium">Règles métier</h3>
        <SettingRow label="Validation des publications obligatoire" enabled />
        <SettingRow label="Notifications par email aux membres" enabled />
        <SettingRow label="Historisation automatique des changements" enabled locked />
        <SettingRow label="Génération automatique du rapport annuel" enabled />
        <SettingRow label="Auto-archivage après fin de mandat" />
        <SettingRow label="Mode maintenance" />
      </Card>

      <Card>
        <h3 className="m-0 mb-3.5 font-serif text-lg font-medium">Quotas</h3>
        <QuotaRow label="Stockage total" used="2.4 GB" total="50 GB" pct={4.8} />
        <QuotaRow label="Documents archivés" used="412" total="∞" pct={0} />
        <QuotaRow label="Comptes utilisateurs" used="36" total="100" pct={36} />
        <QuotaRow label="Conventions actives" used="4" total="∞" pct={0} />
      </Card>

      <Card>
        <h3 className="m-0 mb-3.5 font-serif text-lg font-medium">Sauvegardes</h3>
        <div className="mb-3 font-mono text-[11.5px] text-muted">
          Sauvegarde automatique chaque nuit · rétention 30 jours
        </div>
        {[
          { date: '26 mai 2026 · 03:00', size: '2.4 GB' },
          { date: '25 mai 2026 · 03:00', size: '2.4 GB' },
          { date: '24 mai 2026 · 03:00', size: '2.3 GB' },
          { date: '23 mai 2026 · 03:00', size: '2.3 GB' },
        ].map((b, i) => (
          <div key={i} className="grid grid-cols-[1fr_auto_auto] items-center gap-2.5 border-t border-line py-2">
            <span className="font-serif text-[13px]">{b.date}</span>
            <span className="font-mono text-[11px] text-muted">{b.size}</span>
            <Badge tone="sage">OK</Badge>
          </div>
        ))}
        <Button variant="ghost" size="md" className="mt-3.5 w-full">
          ↻ Lancer une sauvegarde manuelle
        </Button>
      </Card>
    </div>
  );
}

function SettingRow({ label, enabled, locked }: { label: string; enabled?: boolean; locked?: boolean }) {
  const [on, setOn] = useState(!!enabled);
  return (
    <div className="flex items-center justify-between border-t border-line py-3">
      <div>
        <div className="font-serif text-sm text-ink">{label}</div>
        {locked && (
          <div className="mt-0.5 font-mono text-[10.5px] text-muted">verrouillé par règle institutionnelle</div>
        )}
      </div>
      <button
        onClick={() => !locked && setOn(!on)}
        disabled={locked}
        className={`relative h-5 w-9 rounded-full transition-colors ${on ? 'bg-navy' : 'bg-line'} ${
          locked ? 'cursor-not-allowed opacity-60' : 'cursor-pointer'
        }`}
      >
        <span
          className="absolute top-0.5 h-4 w-4 rounded-full bg-cream transition-[left]"
          style={{ left: on ? 18 : 2 }}
        />
      </button>
    </div>
  );
}

function QuotaRow({ label, used, total, pct }: { label: string; used: string; total: string; pct: number }) {
  return (
    <div className="border-t border-line py-2.5">
      <div className="mb-1 flex justify-between">
        <span className="font-serif text-[13.5px]">{label}</span>
        <span className="font-mono text-[11.5px] text-muted">
          {used} / {total}
        </span>
      </div>
      <div className="relative h-1 border border-line bg-surface-2">
        <div
          className="absolute inset-0"
          style={{ width: `${Math.max(pct, 1)}%`, background: pct > 80 ? '#B5453E' : 'var(--navy)' }}
        />
      </div>
    </div>
  );
}

function JournalTab() {
  const entries = [
    { at: '26 mai 2026 · 14:22', who: 'Y. El Amrani', what: 'Validation rapport intermédiaire 2025-2026', ip: '192.168.1.42' },
    { at: '26 mai 2026 · 12:08', who: 'Système', what: 'Sauvegarde nocturne terminée — 2.4 GB', ip: '—' },
    { at: '26 mai 2026 · 10:55', who: 'N. Berrada', what: "Modification du profil (centres d'intérêt)", ip: '192.168.1.18' },
    { at: '26 mai 2026 · 09:31', who: 'K. Tazi', what: 'Téléversement : article ICML 2026.pdf', ip: '10.0.0.55' },
    { at: '25 mai 2026 · 16:48', who: 'admin', what: 'Création compte : ouazzani@lias.ma (acceptation adhésion)', ip: '192.168.1.1' },
    { at: '25 mai 2026 · 14:12', who: 'S. Bennani', what: 'Création évènement : CASA-DATA 2026', ip: '192.168.1.22' },
    { at: '24 mai 2026 · 11:30', who: 'admin', what: 'Mise à jour paramètres : domaine email', ip: '192.168.1.1' },
  ];
  return (
    <Card padded={false}>
      <div className="flex items-center justify-between border-b border-line px-[18px] py-3.5">
        <div className="font-mono text-[11.5px] text-muted">7 derniers évènements · rétention 90 jours</div>
        <Button variant="ghost" size="sm">
          ⤓ Télécharger le journal complet
        </Button>
      </div>
      <table className="w-full border-collapse font-sans">
        <thead>
          <tr className="bg-surface-2">
            {['Horodatage', 'Acteur', 'Action', 'Adresse IP'].map((h, i) => (
              <th
                key={i}
                className="px-2.5 py-2 text-left font-mono text-[11px] font-medium uppercase tracking-[0.1em] text-muted"
              >
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {entries.map((e, i) => (
            <tr key={i} className="border-t border-line">
              <td className="px-3.5 py-2.5 font-mono text-[11.5px] text-muted">{e.at}</td>
              <td className="px-2.5 py-2.5 font-serif text-[13.5px]">{e.who}</td>
              <td className="px-2.5 py-2.5 font-sans text-[13px]">{e.what}</td>
              <td className="px-2.5 py-2.5 font-mono text-[11px] text-muted">{e.ip}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </Card>
  );
}

function MaintenanceTab() {
  const services = [
    { name: 'Base de données PostgreSQL', val: '99.98 %' },
    { name: 'Stockage de fichiers (NFS)', val: '4.8 % utilisé' },
    { name: 'Service de mail (SMTP)', val: 'délai moyen 1.2 s' },
    { name: 'Indexation recherche', val: 'dernière 03:14' },
    { name: 'Génération de rapports', val: 'file 0' },
    { name: 'Antivirus uploads', val: 'signatures à jour' },
  ];
  return (
    <div className="grid grid-cols-2 gap-[18px]">
      <Card>
        <h3 className="m-0 mb-1 font-serif text-lg font-medium">Santé du système</h3>
        <div className="mb-4 font-sans text-xs text-muted">État des services techniques.</div>
        {services.map((s, i) => (
          <div key={i} className="grid grid-cols-[1fr_auto_auto] items-center gap-3 border-t border-line py-2.5">
            <span className="font-serif text-sm">{s.name}</span>
            <span className="font-mono text-[11px] text-muted">{s.val}</span>
            <Badge tone="sage">OK</Badge>
          </div>
        ))}
      </Card>

      <Card>
        <h3 className="m-0 mb-3.5 font-serif text-lg font-medium">Actions techniques</h3>
        <div className="flex flex-col gap-2.5">
          <Button variant="ghost" size="md" className="justify-start">
            ↻ Reconstruire l'index de recherche
          </Button>
          <Button variant="ghost" size="md" className="justify-start">
            ⌫ Vider le cache applicatif
          </Button>
          <Button variant="ghost" size="md" className="justify-start">
            ⤓ Exporter toutes les données (RGPD)
          </Button>
          <Button variant="ghost" size="md" className="justify-start">
            ⚙ Régénérer les rapports annuels
          </Button>
          <Button variant="danger" size="md" className="justify-start">
            ⚠ Activer le mode maintenance
          </Button>
        </div>
        <div className="mt-[18px] border-l-2 border-[#C97A2B] bg-surface-2 px-3.5 py-3 font-serif text-[12.5px] italic leading-[1.5] text-muted">
          Les actions techniques sont journalisées et notifiées au directeur en mandat. Aucune donnée
          n'est jamais supprimée — seules les opérations de maintenance technique sont permises.
        </div>
      </Card>
    </div>
  );
}
