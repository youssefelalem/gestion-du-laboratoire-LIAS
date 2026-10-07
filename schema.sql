-- =========================================================================
-- Schéma de base de données MySQL — Laboratoire LIAS
-- Projet JEE — Faculté des Sciences Ben M'Sik Casablanca
-- Normalisation 3NF / BCNF & Historisation Temporelle
-- =========================================================================

CREATE DATABASE IF NOT EXISTS `lias_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `lias_db`;

-- Désactiver les vérifications de clés étrangères pour le nettoyage
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `conventions`;
DROP TABLE IF EXISTS `reunions_pv`;
DROP TABLE IF EXISTS `materiels`;
DROP TABLE IF EXISTS `demandes_adhesion`;
DROP TABLE IF EXISTS `evenements`;
DROP TABLE IF EXISTS `publications`;
DROP TABLE IF EXISTS `mandats`;
DROP TABLE IF EXISTS `affiliation_periods`;
DROP TABLE IF EXISTS `members`;
DROP TABLE IF EXISTS `laboratoire_info`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------------------------------------
-- 0. Table d'Information Institutionnelle du Laboratoire (CDC §4.1)
-- -------------------------------------------------------------------------
CREATE TABLE `laboratoire_info` (
    `id` INT PRIMARY KEY DEFAULT 1,
    `code` VARCHAR(50) NOT NULL DEFAULT 'LIAS',
    `nom_complet` VARCHAR(255) NOT NULL DEFAULT 'Laboratoire d\'Informatique et Applications Scientifiques',
    `date_creation` DATE NOT NULL, -- Date de création officielle du laboratoire (CDC §4.1)
    `etablissement` VARCHAR(150) NOT NULL DEFAULT 'Faculté des Sciences Ben M\'Sik',
    `universite` VARCHAR(150) NOT NULL DEFAULT 'Université Hassan II de Casablanca'
) ENGINE=InnoDB;

INSERT INTO `laboratoire_info` (`id`, `code`, `nom_complet`, `date_creation`, `etablissement`, `universite`) VALUES
(1, 'LIAS', 'Laboratoire d\'Informatique et Applications Scientifiques', '2016-09-01', 'Faculté des Sciences Ben M\'Sik', 'Université Hassan II de Casablanca');

-- -------------------------------------------------------------------------
-- 1. Table des Utilisateurs du système (Authentification & RBAC)
-- -------------------------------------------------------------------------
CREATE TABLE `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `nom` VARCHAR(100) NOT NULL,
    `prenom` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `role` VARCHAR(50) NOT NULL DEFAULT 'visiteur',
    `actif` BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

INSERT INTO `users` (`id`, `nom`, `prenom`, `email`, `password`, `role`, `actif`) VALUES
(1, 'El Alem', 'Youssef', 'directeur@lias.ma', 'admin123', 'directeur', 1),
(2, 'Benjelloun', 'Sara', 'permanent@lias.ma', 'pass123', 'permanent', 1),
(3, 'Alami', 'Amine', 'doctorant@lias.ma', 'doc123', 'doctorant', 1),
(4, 'Admin', 'Système', 'admin@lias.ma', 'admin123', 'admin', 1),
(5, 'Zouhair', 'Karim', 'karim.zouhair@lias.ma', 'pass123', 'permanent', 1),
(6, 'Berrada', 'Fatima', 'associe@lias.ma', 'pass123', 'associe', 1),
(7, 'Mansouri', 'Omar', 'retraite@lias.ma', 'pass123', 'retraite', 0);

-- -------------------------------------------------------------------------
-- 2. Table des Membres du laboratoire (Profils académiques)
-- -------------------------------------------------------------------------
CREATE TABLE `members` (
    `id` VARCHAR(50) PRIMARY KEY,
    `firstName` VARCHAR(100) NOT NULL,
    `lastName` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `status` VARCHAR(50) NOT NULL, -- Statut d'appartenance: permanent, associe, doctorant, retraite, ancien
    `role` VARCHAR(50) NOT NULL,   -- Rôle de gouvernance courant: directeur, vice-directeur, chef-equipe, membre, aucun
    `team` VARCHAR(50),            -- Équipe de recherche: IA, Big Data, NLP, Sécurité
    `grade` VARCHAR(100),          -- Grade académique: Professeur de l'Enseignement Supérieur, Professeur Habilité, Maître de Conférences, Doctorant, Professeur Émérite, Chercheur Associé
    `photo` VARCHAR(255) DEFAULT NULL,
    `etablissement_origine` VARCHAR(150) DEFAULT 'Faculté des Sciences Ben M\'Sik',
    `laboratoire_origine` VARCHAR(150) DEFAULT 'LIAS',
    `date_naissance` DATE NULL,       -- Date de naissance confidentielle (CDC §4.2)
    `date_embauche` DATE NULL,        -- Date d'embauche universitaire (CDC §4.2)
    `date_affiliation` DATE NULL,     -- Date d'affiliation au laboratoire LIAS (Clé métier CDC §4.2)
    `biographie` TEXT DEFAULT NULL,
    `centres_interet` VARCHAR(255) DEFAULT 'Intelligence Artificielle, Big Data'
) ENGINE=InnoDB;

INSERT INTO `members` (`id`, `firstName`, `lastName`, `email`, `status`, `role`, `team`, `grade`, `photo`, `etablissement_origine`, `laboratoire_origine`, `date_naissance`, `date_embauche`, `date_affiliation`, `biographie`, `centres_interet`) VALUES
('yea', 'Youssef', 'El Alem', 'directeur@lias.ma', 'permanent', 'directeur', 'IA', 'Professeur de l''Enseignement Supérieur', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80', 'Faculté des Sciences Ben M''Sik — Casablanca', 'LIAS (Membre fondateur)', '1978-04-15', '2006-09-01', '2016-09-01', 'Directeur du laboratoire LIAS. Spécialiste de l''intelligence artificielle, des modèles génératifs et de la gouvernance des systèmes de données massives.', 'Intelligence Artificielle, Deep Learning, Gouvernance R&D'),
('sb', 'Sara', 'Benjelloun', 'permanent@lias.ma', 'permanent', 'chef-equipe', 'Big Data', 'Professeur Habilité', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80', 'Faculté des Sciences Ben M''Sik', 'LIAS', '1984-11-20', '2012-09-01', '2018-10-01', 'Enseignante-chercheuse habilitée, responsable de l''équipe Big Data & Cloud. Travaux axés sur le streaming distribué et le machine learning scalable.', 'Big Data Streams, Apache Spark, Cloud Computing'),
('as', 'Amine', 'Alami', 'doctorant@lias.ma', 'doctorant', 'membre', 'NLP', 'Doctorant', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80', 'Faculté des Sciences Ben M''Sik', 'LIAS (Équipe NLP)', '1998-06-10', '2023-11-01', '2023-11-01', 'Doctorant en 3ème année au LIAS travaillant sur le traitement automatique des langues pour les dialectes nord-africains (Darija).', 'NLP, Dialectologie Maghrébine, LLM Fine-Tuning'),
('kz', 'Karim', 'Zouhair', 'karim.zouhair@lias.ma', 'permanent', 'chef-equipe', 'Sécurité', 'Maître de Conférences', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80', 'École Nationale Supérieure d''Électricité et de Mécanique (ENSEM)', 'LIAS', '1981-02-28', '2010-09-01', '2019-01-15', 'Responsable de l''axe Cybersécurité et Architectures Cloud Zero-Trust. Auteur de nombreuses contributions en sécurité logicielle.', 'Cybersécurité, Zero-Trust, Cryptographie Appliquée'),
('fb', 'Fatima', 'Berrada', 'fatima.berrada@lias.ma', 'associe', 'membre', 'IA', 'Chercheur Associé', 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&auto=format&fit=crop&q=80', 'Université Chouaib Doukkali — El Jadida', 'Laboratoire de Recherche en Informatique (LaRI)', '1986-08-14', '2014-09-01', '2021-03-01', 'Chercheuse associée collaborant avec le LIAS dans le cadre du projet d''apprentissage fédéré pour les systèmes médicaux.', 'Santé Numérique, Federated Learning, Bioinformatique'),
('om', 'Omar', 'Mansouri', 'omar.mansouri@lias.ma', 'retraite', 'aucun', 'Big Data', 'Professeur Émérite', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&auto=format&fit=crop&q=80', 'Faculté des Sciences Ben M''Sik', 'LIAS', '1956-03-12', '1984-09-01', '2016-09-01', 'Ancien directeur fondateur du LIAS (2016-2020), Professeur Émérite. Compte gelé à titre de mémoire académique institutionnelle.', 'Bases de Données Réparties, Algorithmique Avancée');

-- -------------------------------------------------------------------------
-- 3. Table des Périodes d'Affiliation (Historisation temporelle des membres)
-- -------------------------------------------------------------------------
CREATE TABLE `affiliation_periods` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `member_id` VARCHAR(50) NOT NULL,
    `date_debut` DATE NOT NULL,
    `date_fin` DATE NULL,
    `role_historique` VARCHAR(50) NOT NULL,
    FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO `affiliation_periods` (`id`, `member_id`, `date_debut`, `date_fin`, `role_historique`) VALUES
(1, 'yea', '2016-09-01', '2020-08-31', 'chef-equipe'),
(2, 'yea', '2020-09-01', NULL, 'directeur'),
(3, 'sb', '2018-10-01', '2022-09-30', 'membre'),
(4, 'sb', '2022-10-01', NULL, 'chef-equipe'),
(5, 'as', '2023-11-01', NULL, 'doctorant'),
(6, 'kz', '2019-01-15', NULL, 'chef-equipe'),
(7, 'om', '2004-09-01', '2023-08-31', 'directeur');

-- -------------------------------------------------------------------------
-- 4. Table des Mandats de Direction et Gouvernance
-- -------------------------------------------------------------------------
CREATE TABLE `mandats` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `titre` VARCHAR(150) NOT NULL,
    `directeur_id` VARCHAR(50) NOT NULL,
    `vice_directeur_id` VARCHAR(50) NULL,
    `date_debut` DATE NOT NULL,
    `date_fin` DATE NULL,
    `actif` BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (`directeur_id`) REFERENCES `members`(`id`)
) ENGINE=InnoDB;

INSERT INTO `mandats` (`id`, `titre`, `directeur_id`, `vice_directeur_id`, `date_debut`, `date_fin`, `actif`) VALUES
(1, 'Mandat Fondateur 2016-2020 : Consolidation des Équipes', 'om', 'yea', '2016-09-01', '2020-08-31', 0),
(2, 'Mandat Quinquennal 2020-2024 : Rayonnement IA & Big Data', 'yea', 'sb', '2020-09-01', '2024-08-31', 0),
(3, 'Mandat Actuel 2024-2028 : Intelligence Artificielle Générative & Cybersécurité', 'yea', 'sb', '2024-09-01', NULL, 1);

-- -------------------------------------------------------------------------
-- 5. Table des Publications Scientifiques
-- -------------------------------------------------------------------------
CREATE TABLE `publications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `titre` VARCHAR(255) NOT NULL,
    `auteurs` VARCHAR(255) NOT NULL,
    `annee` INT NOT NULL,
    `revue` VARCHAR(150) NOT NULL,
    `doi` VARCHAR(100),
    `equipe` VARCHAR(50),
    `type` VARCHAR(50)
) ENGINE=InnoDB;

INSERT INTO `publications` (`id`, `titre`, `auteurs`, `annee`, `revue`, `doi`, `equipe`, `type`) VALUES
(1, 'Deep Learning for Arabic Sentiment Analysis in North African Dialects', 'Amine Alami, Youssef El Alem', 2025, 'IEEE Transactions on Affective Computing', '10.1109/TAFFC.2025.01', 'NLP', 'Article'),
(2, 'Scalable Real-Time Anomaly Detection in Big Data Streams', 'Sara Benjelloun, Karim Zouhair', 2024, 'ACM Computing Surveys', '10.1145/3604921', 'Big Data', 'Article'),
(3, 'Zero-Trust Architecture for Cloud-Native Scientific Repositories', 'Karim Zouhair', 2025, 'International Conference on Information Security (ICIS)', '10.1007/978-3-030-99', 'Sécurité', 'Conférence'),
(4, 'Federated Learning over Distributed Healthcare Records', 'Youssef El Alem, Fatima Berrada', 2024, 'Journal of Medical Systems', '10.1007/s10916-024', 'IA', 'Article'),
(5, 'Efficient Indexing of Multilingual Scholarly Publications', 'Amine Alami, Sara Benjelloun', 2023, 'Information Sciences', '10.1016/j.ins.2023', 'Big Data', 'Article');

-- -------------------------------------------------------------------------
-- 6. Table des Évènements Scientifiques
-- -------------------------------------------------------------------------
CREATE TABLE `evenements` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `titre` VARCHAR(255) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `date` VARCHAR(50) NOT NULL,
    `lieu` VARCHAR(150),
    `description` TEXT,
    `organisateur` VARCHAR(100),
    `statut` VARCHAR(50)
) ENGINE=InnoDB;

INSERT INTO `evenements` (`id`, `titre`, `type`, `date`, `lieu`, `description`, `organisateur`, `statut`) VALUES
(1, 'Journée Scientifique LIAS 2026 : Enjeux de l''IA Générative', 'Conférence', '2026-04-15', 'Amphithéâtre Al-Kindi, FSBM', 'Rencontre annuelle rassemblant les 4 équipes de recherche.', 'Prof. Youssef El Alem', 'À venir'),
(2, 'Workshop : Traitement Distribué avec Apache Spark', 'Workshop', '2026-03-20', 'Salle Réseau 4B', 'Atelier pratique pour les doctorants et chercheurs de l''équipe Big Data.', 'Prof. Sara Benjelloun', 'À venir'),
(3, 'Séminaire : LLMs et Dialectologie Maghrébine', 'Séminaire', '2026-02-10', 'Salle des Thèses', 'Présentation des avancées sur le corpus dialectal marocain.', 'Amine Alami', 'Passé');

-- -------------------------------------------------------------------------
-- 7. Table des Demandes d'Adhésion
-- -------------------------------------------------------------------------
CREATE TABLE `demandes_adhesion` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `nom` VARCHAR(100) NOT NULL,
    `prenom` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `statutVise` VARCHAR(50),
    `etablissement` VARCHAR(150),
    `motivation` TEXT,
    `dateSoumission` VARCHAR(50),
    `decision` VARCHAR(50) DEFAULT 'EN_ATTENTE'
) ENGINE=InnoDB;

INSERT INTO `demandes_adhesion` (`id`, `nom`, `prenom`, `email`, `statutVise`, `etablissement`, `motivation`, `dateSoumission`, `decision`) VALUES
(1, 'Tazi', 'Hassan', 'hassan.tazi@gmail.com', 'Doctorant', 'Faculté des Sciences Ben M''Sik', 'Recherche sur l''apprentissage par renforcement.', '2026-02-15', 'EN_ATTENTE'),
(2, 'Idrissi', 'Nadia', 'nadia.idrissi@ucd.ac.ma', 'Associé', 'Université Chouaib Doukkali', 'Collaboration avec l''équipe Big Data.', '2026-01-20', 'ACCEPTEE');

-- -------------------------------------------------------------------------
-- 8. Table du Matériel et Équipements
-- -------------------------------------------------------------------------
CREATE TABLE `materiels` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `designation` VARCHAR(255) NOT NULL,
    `categorie` VARCHAR(100) NOT NULL,
    `demandeur` VARCHAR(150) NOT NULL,
    `dateDemande` VARCHAR(50) NOT NULL,
    `statut` VARCHAR(50) NOT NULL DEFAULT 'EN_ATTENTE',
    `dateAttribution` VARCHAR(50),
    `commentaire` TEXT
) ENGINE=InnoDB;

INSERT INTO `materiels` (`id`, `designation`, `categorie`, `demandeur`, `dateDemande`, `statut`, `dateAttribution`, `commentaire`) VALUES
(1, 'Station de calcul GPU NVIDIA RTX 4090', 'Calcul', 'Amine Alami (Doctorant)', '2026-01-05', 'ACCORDE', '2026-01-15', 'Attribué pour l''entraînement des modèles NLP.'),
(2, 'PC Portable Dell Precision 16"', 'Informatique', 'Prof. Sara Benjelloun', '2025-11-10', 'LIVRE', '2025-11-20', 'Renouvellement pour chef d''équipe Big Data.');

-- -------------------------------------------------------------------------
-- 9. Table des Procès-Verbaux de Réunions (Archivage institutionnel)
-- -------------------------------------------------------------------------
CREATE TABLE `reunions_pv` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `titre` VARCHAR(255) NOT NULL,
    `date_reunion` DATE NOT NULL,
    `ordre_du_jour` TEXT,
    `chemin_fichier_pv` VARCHAR(255) NOT NULL,
    `directeur_signataire` VARCHAR(100)
) ENGINE=InnoDB;

INSERT INTO `reunions_pv` (`id`, `titre`, `date_reunion`, `ordre_du_jour`, `chemin_fichier_pv`, `directeur_signataire`) VALUES
(1, 'Assemblée Générale Annuelle 2025', '2025-09-15', '1. Bilan d''activité 2024-2025. 2. Budget équipement. 3. Accueil des nouveaux doctorants.', 'archives/pv_ag_2025.pdf', 'Prof. Youssef El Alem'),
(2, 'Conseil de Laboratoire : Validation des Thèses & Soutenances', '2025-12-20', '1. Autorisation de soutenance de 3 doctorants. 2. Calendrier scientifique 2026.', 'archives/pv_conseil_dec2025.pdf', 'Prof. Youssef El Alem'),
(3, 'Conseil Extraordinaire : Arbitrage Matériel GPU', '2026-01-10', 'Répartition équitable de la dotation calcul haute performance.', 'archives/pv_gpu_jan2026.pdf', 'Prof. Youssef El Alem');

-- -------------------------------------------------------------------------
-- 10. Table des Conventions et Partenariats de Recherche
-- -------------------------------------------------------------------------
CREATE TABLE `conventions` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `mandat_id` BIGINT NULL,
    `organisme_partenaire` VARCHAR(150) NOT NULL,
    `type_partenaire` VARCHAR(50) NOT NULL DEFAULT 'Industrie',
    `objet` TEXT NOT NULL,
    `date_signature` DATE NOT NULL,
    `date_echeance` DATE NULL,
    `statut` VARCHAR(50) NOT NULL DEFAULT 'Active',
    `budget_alloue` DECIMAL(12,2) DEFAULT 0.00,
    FOREIGN KEY (`mandat_id`) REFERENCES `mandats`(`id`)
) ENGINE=InnoDB;

INSERT INTO `conventions` (`id`, `mandat_id`, `organisme_partenaire`, `type_partenaire`, `objet`, `date_signature`, `date_echeance`, `statut`, `budget_alloue`) VALUES
(1, 3, 'Centre National pour la Recherche Scientifique et Technique (CNRST)', 'Académique', 'Programme d''appui à la recherche en Intelligence Artificielle et Traitement du Langage Naturel (NLP).', '2024-10-01', '2027-09-30', 'Active', 250000.00),
(2, 3, 'OCP Group / UM6P', 'Industrie', 'Optimisation prédictive par Machine Learning des flux logistiques industriels.', '2025-01-15', '2028-01-14', 'Active', 400000.00),
(3, 2, 'Université Chouaib Doukkali (El Jadida)', 'Académique', 'Cotutelle de thèses en Big Data Analytics et réseaux de capteurs.', '2022-09-01', '2025-08-31', 'Échue', 80000.00);
