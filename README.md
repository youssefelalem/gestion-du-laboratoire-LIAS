# Application Web de gestion du laboratoire LIAS

> Projet JEE — Master Data Science & Big Data (2025–2026)
> Laboratoire d'Informatique et Applications Scientifiques (**LIAS**)
> Faculté des Sciences Ben M'Sik — Université Hassan II, Casablanca

Plateforme de **mémoire institutionnelle** du laboratoire : gestion du cycle de
vie des membres, gouvernance (mandats), évènements scientifiques, publications,
archivage documentaire, et production du rapport d'activité annuel.

---

## 🧱 Structure du dépôt (monorepo)

```
gestion-du-laboratoire-LIAS/
├── backend/      → Application JEE / Servlets (Tomcat 10.1, Java 21)
├── frontend/     → SPA React + TypeScript + Vite + TailwindCSS
├── docs/         → System design & modèle de données
│   ├── system-design.md
│   └── data-model.md
└── README.md
```

- **`backend/`** contient le projet Eclipse JEE. Après un `git clone`, importez ce
  **sous-dossier** dans Eclipse (*File → Import → Existing Projects → sélectionner `backend/`*).
- **`frontend/`** est une application autonome consommant (à terme) l'API REST du backend.
  Pour l'instant elle fonctionne avec des **données mock** (voir `frontend/src/data/`).

---

## 🚀 Lancer le frontend

```bash
cd frontend
npm install
npm run dev      # http://localhost:5173
```

Autres scripts : `npm run build` (typecheck + bundle de production), `npm run preview`, `npm run lint`.

### Démo du RBAC
Le sélecteur de **vue** (en haut à droite) permet de basculer entre
*Directeur · Permanent · Doctorant · Administrateur · Visiteur* et de constater en
direct le contrôle d'accès : les modules non autorisés apparaissent **verrouillés (🔒)**.

---

## 🎨 Stack & design

| Couche | Technologies |
|---|---|
| Frontend | React 18, TypeScript 5, Vite 5, TailwindCSS 3, React Router 6 |
| Design | Style éditorial/académique — serif **Spectral**, sans **DM Sans**, mono **JetBrains Mono** ; palette papier (crème/marine/or) ; thèmes d'accent *marine / bordeaux / forêt* |
| Backend | Java 21, Jakarta Servlets, Tomcat 10.1 (API REST + JPA à venir) |

Tokens de design centralisés dans `frontend/src/styles/theme.css` et exposés à Tailwind
via `frontend/tailwind.config.ts`.

---

## 📦 État d'avancement

**Livré :**
- ✅ Structure monorepo + design-system Tailwind fidèle au prototype
- ✅ Shell applicatif (header, sidebar, routing, RBAC, bascule de rôle)
- ✅ **Les 16 écrans** portés en React + TypeScript : tableau de bord, profils (+ historique
  d'affiliation), mandats (frise de gouvernance), demandes d'adhésion, rapport annuel,
  évènements, calendrier, publications, archive documentaire, communication interne,
  matériel, conventions, procès-verbaux, recherche globale, notifications, administration.

**Prochaine étape :** brancher le frontend sur l'API REST du backend JEE — remplacer le
barrel `@/data` par un client API (`src/lib/api.ts`) renvoyant les mêmes types, sans toucher
aux écrans. Voir [`docs/system-design.md`](docs/system-design.md) §8.

---

## 📚 Documentation

- [System design](docs/system-design.md) — architecture, carte des modules, matrice RBAC, surface REST.
- [Modèle de données](docs/data-model.md) — entités, relations et historisation.
