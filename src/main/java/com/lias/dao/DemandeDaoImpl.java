package com.lias.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.lias.beans.DemandeAdhesion;
import com.lias.beans.Materiel;

public class DemandeDaoImpl implements IDemandeDao {

    private static final List<DemandeAdhesion> DEMO_ADHESIONS = new ArrayList<>();
    private static final List<Materiel> DEMO_MATERIELS = new ArrayList<>();

    static {
        // Demandes d'adhésion initiales
        DEMO_ADHESIONS.add(new DemandeAdhesion(1L, "Tazi", "Hassan", "hassan.tazi@gmail.com", "Doctorant", "Faculté des Sciences Ben M'Sik", "Recherche sur l'apprentissage par renforcement appliqué à la robotique.", "2026-02-15", "EN_ATTENTE"));
        DEMO_ADHESIONS.add(new DemandeAdhesion(2L, "Idrissi", "Nadia", "nadia.idrissi@ucd.ac.ma", "Associé", "Université Chouaib Doukkali", "Collaboration thématique avec l'équipe Big Data sur la télédétection.", "2026-01-20", "ACCEPTEE"));
        DEMO_ADHESIONS.add(new DemandeAdhesion(3L, "Chraibi", "Mehdi", "mehdi.chraibi@outlook.com", "Doctorant", "Faculté des Sciences Aïn Chock", "Sujet non aligné avec les axes du LIAS.", "2026-01-10", "REFUSEE"));

        // Demandes et attributions de matériel (Distribution équitable CDC §14)
        DEMO_MATERIELS.add(new Materiel(1L, "Station de calcul GPU NVIDIA RTX 4090", "Calcul", "Amine Alami (Doctorant)", "2026-01-05", "ACCORDE", "2026-01-15", "Attribué pour l'entraînement des modèles NLP."));
        DEMO_MATERIELS.add(new Materiel(2L, "PC Portable Dell Precision 16\"", "Informatique", "Prof. Sara Benjelloun", "2025-11-10", "LIVRE", "2025-11-20", "Renouvellement d'équipement pour chef d'équipe Big Data."));
        DEMO_MATERIELS.add(new Materiel(3L, "Serveur de stockage NAS 24 To", "Réseau", "Prof. Karim Zouhair", "2026-02-01", "EN_ATTENTE", null, "En attente de validation budgétaire annuelle."));
    }

    @Override
    public List<DemandeAdhesion> findAllAdhesions() {
        List<DemandeAdhesion> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "SELECT * FROM demandes_adhesion ORDER BY id DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new DemandeAdhesion(
                        rs.getLong("id"),
                        rs.getString("nom"),
                        rs.getString("prenom"),
                        rs.getString("email"),
                        rs.getString("statutVise"),
                        rs.getString("etablissement"),
                        rs.getString("motivation"),
                        rs.getString("dateSoumission"),
                        rs.getString("decision")
                    ));
                }
                if (!list.isEmpty()) return list;
            } catch (SQLException e) {
                System.err.println("[DemandeDaoImpl] Erreur findAllAdhesions: " + e.getMessage());
            }
        }
        return new ArrayList<>(DEMO_ADHESIONS);
    }

    @Override
    public boolean saveAdhesion(DemandeAdhesion adhesion) {
        adhesion.setId((long) (DEMO_ADHESIONS.size() + 1));
        DEMO_ADHESIONS.add(0, adhesion);
        return true;
    }

    @Override
    public boolean updateDecisionAdhesion(Long id, String decision) {
        for (DemandeAdhesion a : DEMO_ADHESIONS) {
            if (a.getId().equals(id)) {
                a.setDecision(decision);
                return true;
            }
        }
        return false;
    }

    @Override
    public List<Materiel> findAllMateriels() {
        return new ArrayList<>(DEMO_MATERIELS);
    }

    @Override
    public boolean saveMateriel(Materiel mat) {
        mat.setId((long) (DEMO_MATERIELS.size() + 1));
        DEMO_MATERIELS.add(0, mat);
        return true;
    }

    @Override
    public boolean updateStatutMateriel(Long id, String statut, String dateAttribution) {
        for (Materiel m : DEMO_MATERIELS) {
            if (m.getId().equals(id)) {
                m.setStatut(statut);
                if (dateAttribution != null) m.setDateAttribution(dateAttribution);
                return true;
            }
        }
        return false;
    }
}
