-- =========================================================================
-- Schéma de base de données MySQL — Laboratoire LIAS
-- Projet JEE — Faculté des Sciences Ben M'Sik Casablanca
-- =========================================================================

CREATE DATABASE IF NOT EXISTS `lias_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `lias_db`;

-- 1. Table des Utilisateurs du système (Authentification)
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `nom` VARCHAR(100) NOT NULL,
    `prenom` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `role` VARCHAR(50) NOT NULL DEFAULT 'visiteur',
    `actif` BOOLEAN NOT NULL DEFAULT TRUE
);

-- Insertion des utilisateurs de test
INSERT INTO `users` (`id`, `nom`, `prenom`, `email`, `password`, `role`, `actif`) VALUES
(1, 'El Alem', 'Youssef', 'directeur@lias.ma', 'admin123', 'directeur', 1),
(2, 'Benjelloun', 'Sara', 'permanent@lias.ma', 'pass123', 'permanent', 1),
(3, 'Alami', 'Amine', 'doctorant@lias.ma', 'doc123', 'doctorant', 1),
(4, 'Admin', 'Système', 'admin@lias.ma', 'admin123', 'admin', 1);

-- 2. Table des Membres du laboratoire (Profils académiques)
DROP TABLE IF EXISTS `members`;
CREATE TABLE `members` (
    `id` VARCHAR(50) PRIMARY KEY,
    `firstName` VARCHAR(100) NOT NULL,
    `lastName` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `status` VARCHAR(50) NOT NULL,
    `role` VARCHAR(50) NOT NULL,
    `team` VARCHAR(50),
    `grade` VARCHAR(100)
);

INSERT INTO `members` (`id`, `firstName`, `lastName`, `email`, `status`, `role`, `team`, `grade`) VALUES
('yea', 'Youssef', 'El Alem', 'directeur@lias.ma', 'permanent', 'directeur', 'IA', 'Professeur de l''Enseignement Supérieur'),
('sb', 'Sara', 'Benjelloun', 'permanent@lias.ma', 'permanent', 'chef-equipe', 'Big Data', 'Professeur Habilité'),
('as', 'Amine', 'Alami', 'doctorant@lias.ma', 'doctorant', 'membre', 'NLP', 'Doctorant'),
('kz', 'Karim', 'Zouhair', 'karim.zouhair@lias.ma', 'permanent', 'chef-equipe', 'Sécurité', 'Maître de Conférences'),
('fb', 'Fatima', 'Berrada', 'fatima.berrada@lias.ma', 'associe', 'membre', 'IA', 'Chercheur Associé'),
('om', 'Omar', 'Mansouri', 'omar.mansouri@lias.ma', 'retraite', 'aucun', 'Big Data', 'Professeur Émérite');

-- 3. Table des Publications Scientifiques
DROP TABLE IF EXISTS `publications`;
CREATE TABLE `publications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `titre` VARCHAR(255) NOT NULL,
    `auteurs` VARCHAR(255) NOT NULL,
    `annee` INT NOT NULL,
    `revue` VARCHAR(150) NOT NULL,
    `doi` VARCHAR(100),
    `equipe` VARCHAR(50),
    `type` VARCHAR(50)
);

INSERT INTO `publications` (`id`, `titre`, `auteurs`, `annee`, `revue`, `doi`, `equipe`, `type`) VALUES
(1, 'Deep Learning for Arabic Sentiment Analysis in North African Dialects', 'Amine Alami, Youssef El Alem', 2025, 'IEEE Transactions on Affective Computing', '10.1109/TAFFC.2025.01', 'NLP', 'Article'),
(2, 'Scalable Real-Time Anomaly Detection in Big Data Streams', 'Sara Benjelloun, Karim Zouhair', 2024, 'ACM Computing Surveys', '10.1145/3604921', 'Big Data', 'Article'),
(3, 'Zero-Trust Architecture for Cloud-Native Scientific Repositories', 'Karim Zouhair', 2025, 'International Conference on Information Security (ICIS)', '10.1007/978-3-030-99', 'Sécurité', 'Conférence'),
(4, 'Federated Learning over Distributed Healthcare Records', 'Youssef El Alem, Fatima Berrada', 2024, 'Journal of Medical Systems', '10.1007/s10916-024', 'IA', 'Article'),
(5, 'Efficient Indexing of Multilingual Scholarly Publications', 'Amine Alami, Sara Benjelloun', 2023, 'Information Sciences', '10.1016/j.ins.2023', 'Big Data', 'Article');

-- 4. Table des Évènements Scientifiques
DROP TABLE IF EXISTS `evenements`;
CREATE TABLE `evenements` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `titre` VARCHAR(255) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `date` VARCHAR(50) NOT NULL,
    `lieu` VARCHAR(150),
    `description` TEXT,
    `organisateur` VARCHAR(100),
    `statut` VARCHAR(50)
);

INSERT INTO `evenements` (`id`, `titre`, `type`, `date`, `lieu`, `description`, `organisateur`, `statut`) VALUES
(1, 'Journée Scientifique LIAS 2026 : Enjeux de l''IA Générative', 'Conférence', '2026-04-15', 'Amphithéâtre Al-Kindi, FSBM', 'Rencontre annuelle rassemblant les 4 équipes de recherche.', 'Prof. Youssef El Alem', 'À venir'),
(2, 'Workshop : Traitement Distribué avec Apache Spark', 'Workshop', '2026-03-20', 'Salle Réseau 4B', 'Atelier pratique pour les doctorants et chercheurs de l''équipe Big Data.', 'Prof. Sara Benjelloun', 'À venir'),
(3, 'Séminaire : LLMs et Dialectologie Maghrébine', 'Séminaire', '2026-02-10', 'Salle des Thèses', 'Présentation des avancées sur le corpus dialectal marocain.', 'Amine Alami', 'Passé');

-- 5. Table des Demandes d'Adhésion
DROP TABLE IF EXISTS `demandes_adhesion`;
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
);

INSERT INTO `demandes_adhesion` (`id`, `nom`, `prenom`, `email`, `statutVise`, `etablissement`, `motivation`, `dateSoumission`, `decision`) VALUES
(1, 'Tazi', 'Hassan', 'hassan.tazi@gmail.com', 'Doctorant', 'Faculté des Sciences Ben M''Sik', 'Recherche sur l''apprentissage par renforcement.', '2026-02-15', 'EN_ATTENTE'),
(2, 'Idrissi', 'Nadia', 'nadia.idrissi@ucd.ac.ma', 'Associé', 'Université Chouaib Doukkali', 'Collaboration avec l''équipe Big Data.', '2026-01-20', 'ACCEPTEE');

-- 6. Table du Matériel et Équipements
DROP TABLE IF EXISTS `materiels`;
CREATE TABLE `materiels` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `designation` VARCHAR(255) NOT NULL,
    `categorie` VARCHAR(100) NOT NULL,
    `demandeur` VARCHAR(150) NOT NULL,
    `dateDemande` VARCHAR(50) NOT NULL,
    `statut` VARCHAR(50) NOT NULL DEFAULT 'EN_ATTENTE',
    `dateAttribution` VARCHAR(50),
    `commentaire` TEXT
);

INSERT INTO `materiels` (`id`, `designation`, `categorie`, `demandeur`, `dateDemande`, `statut`, `dateAttribution`, `commentaire`) VALUES
(1, 'Station de calcul GPU NVIDIA RTX 4090', 'Calcul', 'Amine Alami (Doctorant)', '2026-01-05', 'ACCORDE', '2026-01-15', 'Attribué pour l''entraînement des modèles NLP.'),
(2, 'PC Portable Dell Precision 16"', 'Informatique', 'Prof. Sara Benjelloun', '2025-11-10', 'LIVRE', '2025-11-20', 'Renouvellement pour chef d''équipe Big Data.');
