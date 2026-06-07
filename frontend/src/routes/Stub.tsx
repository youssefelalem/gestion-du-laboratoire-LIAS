import { SectionHead } from '@/components/ui';
import { navItemFor } from '@/config/navigation';
import type { ModuleId } from '@/types';

/** Résumé fonctionnel (cahier des charges) affiché par les écrans encore en stub. */
const STUB_INFO: Partial<Record<ModuleId, string>> = {
  adhesions:
    'Soumission en ligne, dossier complet (CV, motivation), décision du directeur en mandat : acceptée → création de compte, refusée → notification.',
  rapport:
    "Génération annuelle automatique à partir des évènements, publications et activités — condition d'obtention du budget annuel.",
  evenements:
    'Conférences, séminaires et workshops : création, organisation, archivage par édition, affectation des organisateurs.',
  calendrier: 'Visualisation des évènements scientifiques et navigation temporelle.',
  publications:
    'Ajout par membres et doctorants, consultation globale, classement par auteur, année et équipe.',
  documents:
    'Archive structurée par évènement et par date (programmes, financements, attestations, rapports) : upload, téléchargement, recherche, historisation.',
  communication: 'Discussions internes entre membres, par équipe et liées aux évènements.',
  materiel:
    'Suivi des arrivages, distribution équitable (qui a reçu quoi), et gestion des besoins validés par la direction.',
  conventions:
    'Gestion des partenaires, création de conventions, archivage documentaire et suivi des activités associées.',
  pv: 'Procès-verbaux : création des réunions, ordre du jour, upload et archivage des PV.',
  recherche: 'Recherche globale transverse : membres, documents, évènements et publications.',
  notifications: 'Évènements, validations de demandes et ajouts de documents.',
  admin: 'Gestion technique : comptes utilisateurs, paramétrage et maintenance du système.',
};

export function Stub({ module }: { module: ModuleId }) {
  const info = navItemFor(module);
  return (
    <div>
      <SectionHead eyebrow="Module · à venir" title={info?.label ?? module} subtitle={STUB_INFO[module]} />
      <div className="flex flex-col items-center justify-center gap-3 border border-dashed border-line bg-surface px-6 py-20 text-center">
        <div className="font-mono text-3xl text-muted">{info?.icon}</div>
        <div className="font-serif text-lg text-ink">Écran en cours de construction</div>
        <div className="max-w-md font-sans text-[13px] text-muted">
          Ce module fait partie du périmètre fonctionnel et sera porté lors de la prochaine
          itération, en réutilisant le design-system déjà en place.
        </div>
      </div>
    </div>
  );
}
