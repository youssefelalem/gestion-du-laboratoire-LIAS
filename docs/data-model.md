# Modèle de données — LIAS

> Compagnon de [`system-design.md`](system-design.md). Décrit les entités, leurs
> relations, et surtout le **design temporel** (historisation) qui est au cœur du
> cahier des charges.

---

## 1. Diagramme entités-relations

```mermaid
erDiagram
  MEMBER ||--o{ AFFILIATION_PERIOD : "historise"
  MEMBER }o--|| TEAM : "affecté à"
  MEMBER ||--o{ ROLE_ASSIGNMENT : "occupe"
  MANDAT ||--o{ ROLE_ASSIGNMENT : "cadre"
  MANDAT }o--|| MEMBER : "directeur"
  ADHESION ..|| MEMBER : "crée si acceptée"
  EVENT ||--o{ DOCUMENT : "archive"
  EVENT }o--o{ MEMBER : "organisateurs"
  PUBLICATION }o--o{ MEMBER : "auteurs"
  PUBLICATION }o--|| TEAM : "rattachée"
  CONVENTION }o--|| PARTNER : "lie"
  MEETING ||--o| PV : "produit"
  MATERIAL ||--o{ MATERIAL_ALLOC : "distribué via"
  MATERIAL_ALLOC }o--|| MEMBER : "détenteur"
  MATERIAL_REQUEST }o--|| MEMBER : "demandeur"
  NOTIFICATION }o--|| MEMBER : "destinataire"
  USER_ACCOUNT |o--|| MEMBER : "authentifie"
```

---

## 2. Entités principales

### MEMBER
Profil complet et modifiable. Champs : `id`, `firstName`, `lastName`, `photo`,
`email`, `status` (statut), `role` (rôle de gouvernance courant), `team`, `grade`,
`inst` (établissement d'origine), `origLab` (laboratoire d'origine), `bio`,
`interests[]`, `hired` (date d'embauche), `affiliated` (**date d'affiliation = clé
métier**), `birth` (confidentielle), `pubs`, `hIndex`.

> Le statut et le rôle stockés sur MEMBER sont l'**état courant** ; l'historique
> complet vit dans `AFFILIATION_PERIOD` et `ROLE_ASSIGNMENT`.

### AFFILIATION_PERIOD  *(temporelle)*
Une période d'appartenance. Champs : `memberId`, `from`, `to` (nullable → en cours),
`role` (libellé de la période). Un membre **peut quitter et revenir** : chaque
passage est une nouvelle ligne. C'est ce qui rend possible la reconstruction du
*cycle de vie* affiché dans l'écran **Profils**.

### TEAM
Axe thématique. Champs : `id`, `name`, `short`, `members` (effectif). 4 équipes :
IA, Big Data, NLP, Sécurité.

### MANDAT  *(temporelle)*
Période de gouvernance. Champs : `id`, `label`, `from`, `to`, `status`
(`passé` / `en cours`), `directeur`, `vice`, `chefs[]` (par équipe).
**Historique complet conservé** → frise de l'écran **Mandats**.

### ROLE_ASSIGNMENT  *(temporelle)*
Affectation d'un rôle de gouvernance à un membre, dans le cadre (optionnel) d'un
mandat. Champs : `memberId`, `mandatId?`, `role`, `from`, `to`. Permet à un membre
d'apparaître dans plusieurs mandats avec des fonctions différentes, sans écrasement.

### ADHESION
Demande d'entrée. Champs : `id`, `name`, `submitted`, `status`
(`en attente` / `acceptée` / `refusée`), `type`, `target_team`, `inst`, `grade`,
`motivation`, `cv`, `publications`, `hIndex`. **Acceptée → crée un MEMBER + compte** ;
refusée → notification. Validée uniquement par le **directeur en mandat**.

### EVENT & DOCUMENT
`EVENT` : `type` (Conférence/Séminaire/Workshop), `title`, `date`, `lieu`, `edition`,
`organizers[]`, `status`. `DOCUMENT` : archivé **par évènement et par date** ;
`name`, `size`, `type`, `by`, catégories (financement, programme, attestation,
rapport, administratif). Upload / téléchargement / recherche / historisation.

### PUBLICATION
`title`, `authors[]`, `venue`, `year`, `team`, `type` (Revue/Conf.). Classable par
auteur, année, équipe. Ajoutable par membres **et** doctorants.

### PARTNER & CONVENTION
`PARTNER` : `name`, `type` (Industrie/Recherche/Académique), `country`, `lead`.
`CONVENTION` : `since`, `until`, `status`, `funding`, `activities[]`.

### MEETING & PV
`MEETING` : `title`, `date`, `chair`, `attendees[]`, `agenda[]` (ordre du jour).
`PV` : `file`, `validated`, `signedBy`. Création de réunion → upload du PV → archivage.

### MATERIAL, MATERIAL_ALLOC & MATERIAL_REQUEST
`MATERIAL` : `name`, `category`, `arrived`, `qty`. `MATERIAL_ALLOC` : `holder`,
`date`, `status` (livré/en attente/en stock), `n` → suit **qui a reçu quoi / qui n'a
pas reçu** (distribution équitable). `MATERIAL_REQUEST` : `who`, `what`, `status`,
validée par la direction.

### NOTIFICATION
`recipient`, `type` (évènement / validation de demande / ajout de document), `date`,
`read`.

### USER_ACCOUNT
Authentification, liée 0..1 à un MEMBER. États : actif / **gelé** (retraité) /
**désactivé** (ancien, réactivable). Administré par l'`admin` système.

---

## 3. Design de l'historisation

Le cœur du système est **temporel**. Trois tables suivent le motif *période* :

| Table | Période | Sémantique |
|---|---|---|
| `AFFILIATION_PERIOD` | `(from, to)` | présence du membre au labo (départs/retours) |
| `ROLE_ASSIGNMENT` | `(from, to)` | fonctions de gouvernance successives |
| `MANDAT` | `(from, to)` | périodes de direction |

Règle : `to = NULL` ⇒ **période en cours**. On **n'efface jamais** : on **clôture**
(on renseigne `to`) puis on **ouvre** une nouvelle ligne. Toute la mémoire du labo
se reconstruit en lisant ces tables.

### Statut ⇄ Rôle (séparation stricte)

```
STATUT  (appartenance) : permanent · associe · doctorant · retraite · ancien
RÔLE    (responsabilité): directeur · vice-directeur · chef-equipe · membre · aucun
```

Les deux dimensions sont **indépendantes** et historisées séparément. Exemple réel
(jeu de données) : *Pr. El Amrani* est `permanent` (statut constant) mais a été
*membre* → *chef d'équipe* → *vice-directeur* → *directeur* (rôles successifs).

### Cycle de vie d'un compte

```
adhésion acceptée → MEMBER actif → (départ) ancien · désactivé   ↺ réactivable
                                 → (retraite) retraité · gelé     (historique conservé)
```

---

## 4. Clés & contraintes métier

- **Clé métier d'affiliation** : `affiliated` (date d'affiliation au LIAS) distingue
  l'ancienneté *au labo* de la date d'embauche *administrative*.
- **Confidentialité** : `birth` n'est jamais exposée publiquement (vue *visiteur*).
- **Intégrité temporelle** : pour un même membre, les `AFFILIATION_PERIOD` ne se
  chevauchent pas ; au plus une ligne avec `to = NULL` par dimension.
- **Autorité** : une décision d'adhésion ou de matériel référence le `MANDAT` actif
  et son directeur (traçabilité de *qui* a validé).
