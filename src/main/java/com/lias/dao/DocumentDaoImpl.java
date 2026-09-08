package com.lias.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicInteger;

import com.lias.beans.DocumentLabo;

/**
 * Implémentation JDBC du DAO Archive Documentaire (CDC §10).
 * Organisation par arborescence d'évènements, dates, et types.
 */
public class DocumentDaoImpl implements IDocumentDao {

    private static final List<DocumentLabo> FALLBACK_DOCS = new CopyOnWriteArrayList<>();
    private static final AtomicInteger ID_GEN = new AtomicInteger(100);

    static {
        initDefaultDocs();
    }

    public DocumentDaoImpl() {
        initTable();
    }

    private void initTable() {
        String createTableSql = "CREATE TABLE IF NOT EXISTS documents_labo (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "dossier VARCHAR(100) NOT NULL, " +
                "sous_dossier VARCHAR(100) NOT NULL, " +
                "edition_rubrique VARCHAR(100), " +
                "nom_fichier VARCHAR(255) NOT NULL, " +
                "taille VARCHAR(50) NOT NULL, " +
                "date_fichier VARCHAR(50) NOT NULL, " +
                "type VARCHAR(20) NOT NULL, " +
                "auteur VARCHAR(150) NOT NULL, " +
                "description TEXT" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(createTableSql);

            // Vérifier si la table est vide pour la pré-remplir
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM documents_labo");
            if (rs.next() && rs.getInt(1) == 0) {
                seedInitialData(conn);
            }
        } catch (Exception e) {
            System.err.println("DocumentDaoImpl: Table creation/seeding notice: " + e.getMessage());
        }
    }

    private static void initDefaultDocs() {
        FALLBACK_DOCS.clear();
        int id = 1;
        // Événements > CASA-DATA > 2025 — 7e édition
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2025 — 7e édition", "Programme_CASA-DATA_2025.pdf", "412 KB", "2025-09-01", "pdf", "S. Bennani", "Programme complet des conférences plénières et sessions parallèles"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2025 — 7e édition", "Demande_financement_2025.pdf", "218 KB", "2025-06-12", "pdf", "N. Berrada", "Dossier de subvention CNRST et Université"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2025 — 7e édition", "Attestations_participants.pdf", "1.2 MB", "2025-10-25", "pdf", "Système", "Attestations officielles d'émargement"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2025 — 7e édition", "Rapport_CASA-DATA_2025.docx", "178 KB", "2025-11-08", "docx", "S. Bennani", "Rapport scientifique et financier de synthèse"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2025 — 7e édition", "Actes_compiles.pdf", "6.4 MB", "2025-12-15", "pdf", "S. Bennani", "Volume complet des actes avec ISBN"));

        // Événements > CASA-DATA > 2024 — 6e édition
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2024 — 6e édition", "Programme_CASA-DATA_2024.pdf", "380 KB", "2024-09-04", "pdf", "S. Bennani", "Programme de l'édition 2024"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2024 — 6e édition", "Rapport_2024.docx", "165 KB", "2024-11-12", "docx", "N. Berrada", "Bilan de clôture CASA-DATA 2024"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2024 — 6e édition", "Photos_evenement.zip", "24 MB", "2024-10-25", "zip", "Système", "Archive photographique de l'école d'automne"));

        // Événements > CASA-DATA > 2023 — 5e édition
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2023 — 5e édition", "Programme_2023.pdf", "362 KB", "2023-09-02", "pdf", "M. Chraibi", "Planning des interventions"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "CASA-DATA", "2023 — 5e édition", "Rapport_2023.docx", "148 KB", "2023-11-15", "docx", "M. Chraibi", "Rapport technique final"));

        // Événements > Journée Doctorants > 2026 — 4e édition
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "Journée Doctorants", "2026 — 4e édition", "Programme_JD_2026.pdf", "205 KB", "2026-02-20", "pdf", "K. Tazi", "Planning des présentations orales et posters"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "Journée Doctorants", "2026 — 4e édition", "Liste_communications.xlsx", "42 KB", "2026-03-08", "xlsx", "K. Tazi", "Tableau récapitulatif des résumés acceptés"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "Journée Doctorants", "2026 — 4e édition", "Rapport_JD_2026.docx", "120 KB", "2026-03-20", "docx", "N. Berrada", "Rapport du comité d'évaluation"));

        // Événements > Journée Doctorants > 2025 — 3e édition
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "Journée Doctorants", "2025 — 3e édition", "Programme_JD_2025.pdf", "198 KB", "2025-02-22", "pdf", "K. Tazi", "Planning des ateliers"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "Journée Doctorants", "2025 — 3e édition", "Rapport_JD_2025.docx", "115 KB", "2025-03-20", "docx", "K. Tazi", "Synthèse des travaux doctoraux"));

        // Événements > Séminaires NLP > 2025-2026
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "Séminaires NLP", "2025-2026", "LLM_Darija_slides.pdf", "4.8 MB", "2025-11-04", "pdf", "O. Lahlou", "Présentation : Modèles de fondation pour le dialecte marocain"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Évènements", "Séminaires NLP", "2025-2026", "Invitation_Bouzoubaa.pdf", "88 KB", "2025-10-20", "pdf", "O. Lahlou", "Lettre d'invitation officielle conférencier invité"));

        // Administratif > Conventions
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Administratif", "Conventions", null, "Convention_Casa_Transports_2024.pdf", "540 KB", "2024-03-15", "pdf", "Y. El Amrani", "Accord cadre de partenariat R&D mobilité urbaine"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Administratif", "Conventions", null, "Convention_INRIA_2025.pdf", "612 KB", "2025-01-20", "pdf", "Y. El Amrani", "Projet bilatéral INRIA Sophia Antipolis"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Administratif", "Conventions", null, "Convention_CNRS_LIPN_2026.pdf", "498 KB", "2026-02-10", "pdf", "Y. El Amrani", "Accord de co-tutelle et mobilité internationale"));

        // Administratif > Rapports annuels
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Administratif", "Rapports annuels", null, "Rapport_LIAS_2024-2025.pdf", "3.2 MB", "2025-09-28", "pdf", "Y. El Amrani", "Rapport d'activité scientifique annuel validé par le Conseil"));
        FALLBACK_DOCS.add(new DocumentLabo(id++, "Administratif", "Rapports annuels", null, "Rapport_LIAS_2023-2024.pdf", "2.9 MB", "2024-09-25", "pdf", "M. Sefrioui", "Rapport quadriennal mi-parcours"));
    }

    private void seedInitialData(Connection conn) {
        String insertSql = "INSERT INTO documents_labo (dossier, sous_dossier, edition_rubrique, nom_fichier, taille, date_fichier, type, auteur, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (DocumentLabo doc : FALLBACK_DOCS) {
                ps.setString(1, doc.getDossier());
                ps.setString(2, doc.getSousDossier());
                ps.setString(3, doc.getEditionRubrique());
                ps.setString(4, doc.getNomFichier());
                ps.setString(5, doc.getTaille());
                ps.setString(6, doc.getDateFichier());
                ps.setString(7, doc.getType());
                ps.setString(8, doc.getAuteur());
                ps.setString(9, doc.getDescription());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            System.err.println("DocumentDaoImpl: Seeding notice: " + e.getMessage());
        }
    }

    @Override
    public List<DocumentLabo> findAll() {
        List<DocumentLabo> list = new ArrayList<>();
        String sql = "SELECT * FROM documents_labo ORDER BY date_fichier DESC, id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            // Utiliser fallback
            return new ArrayList<>(FALLBACK_DOCS);
        }
        return list.isEmpty() ? new ArrayList<>(FALLBACK_DOCS) : list;
    }

    @Override
    public List<DocumentLabo> findByDossier(String dossier, String sousDossier, String editionRubrique) {
        List<DocumentLabo> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM documents_labo WHERE dossier = ?");
        if (sousDossier != null && !sousDossier.trim().isEmpty()) {
            sql.append(" AND sous_dossier = ?");
        }
        if (editionRubrique != null && !editionRubrique.trim().isEmpty()) {
            sql.append(" AND edition_rubrique = ?");
        }
        sql.append(" ORDER BY nom_fichier ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setString(idx++, dossier);
            if (sousDossier != null && !sousDossier.trim().isEmpty()) {
                ps.setString(idx++, sousDossier);
            }
            if (editionRubrique != null && !editionRubrique.trim().isEmpty()) {
                ps.setString(idx++, editionRubrique);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            for (DocumentLabo doc : FALLBACK_DOCS) {
                boolean match = doc.getDossier().equalsIgnoreCase(dossier);
                if (match && sousDossier != null && !sousDossier.trim().isEmpty()) {
                    match = sousDossier.equalsIgnoreCase(doc.getSousDossier());
                }
                if (match && editionRubrique != null && !editionRubrique.trim().isEmpty()) {
                    match = editionRubrique.equalsIgnoreCase(doc.getEditionRubrique());
                }
                if (match) list.add(doc);
            }
        }
        return list;
    }

    @Override
    public List<DocumentLabo> search(String query) {
        if (query == null || query.trim().isEmpty()) {
            return findAll();
        }
        List<DocumentLabo> list = new ArrayList<>();
        String q = "%" + query.trim().toLowerCase() + "%";
        String sql = "SELECT * FROM documents_labo WHERE LOWER(nom_fichier) LIKE ? OR LOWER(dossier) LIKE ? OR LOWER(sous_dossier) LIKE ? OR LOWER(description) LIKE ? OR LOWER(auteur) LIKE ? ORDER BY date_fichier DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, q);
            ps.setString(2, q);
            ps.setString(3, q);
            ps.setString(4, q);
            ps.setString(5, q);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            String lower = query.trim().toLowerCase();
            for (DocumentLabo d : FALLBACK_DOCS) {
                if (d.getNomFichier().toLowerCase().contains(lower) ||
                    d.getCheminComplet().toLowerCase().contains(lower) ||
                    (d.getDescription() != null && d.getDescription().toLowerCase().contains(lower)) ||
                    d.getAuteur().toLowerCase().contains(lower)) {
                    list.add(d);
                }
            }
        }
        return list;
    }

    @Override
    public DocumentLabo findById(int id) {
        String sql = "SELECT * FROM documents_labo WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            for (DocumentLabo d : FALLBACK_DOCS) {
                if (d.getId() != null && d.getId() == id) return d;
            }
        }
        return null;
    }

    @Override
    public boolean save(DocumentLabo doc) {
        if (doc == null) return false;
        String sql = "INSERT INTO documents_labo (dossier, sous_dossier, edition_rubrique, nom_fichier, taille, date_fichier, type, auteur, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, doc.getDossier());
            ps.setString(2, doc.getSousDossier());
            ps.setString(3, doc.getEditionRubrique());
            ps.setString(4, doc.getNomFichier());
            ps.setString(5, doc.getTaille() != null ? doc.getTaille() : "150 KB");
            ps.setString(6, doc.getDateFichier());
            ps.setString(7, doc.getType() != null ? doc.getType() : "pdf");
            ps.setString(8, doc.getAuteur());
            ps.setString(9, doc.getDescription());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) doc.setId(rs.getInt(1));
                }
                FALLBACK_DOCS.add(0, doc);
                return true;
            }
        } catch (Exception e) {
            System.err.println("DocumentDaoImpl: save error: " + e.getMessage());
            doc.setId(ID_GEN.incrementAndGet());
            FALLBACK_DOCS.add(0, doc);
            return true;
        }
        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM documents_labo WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            FALLBACK_DOCS.removeIf(d -> d.getId() != null && d.getId() == id);
            return rows > 0;
        } catch (Exception e) {
            return FALLBACK_DOCS.removeIf(d -> d.getId() != null && d.getId() == id);
        }
    }

    private DocumentLabo mapRow(ResultSet rs) throws Exception {
        return new DocumentLabo(
                rs.getInt("id"),
                rs.getString("dossier"),
                rs.getString("sous_dossier"),
                rs.getString("edition_rubrique"),
                rs.getString("nom_fichier"),
                rs.getString("taille"),
                rs.getString("date_fichier"),
                rs.getString("type"),
                rs.getString("auteur"),
                rs.getString("description")
        );
    }
}
