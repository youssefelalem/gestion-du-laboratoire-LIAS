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
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "INSERT INTO demandes_adhesion (nom, prenom, email, statutVise, etablissement, motivation, dateSoumission, decision) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, adhesion.getNom());
                ps.setString(2, adhesion.getPrenom());
                ps.setString(3, adhesion.getEmail());
                ps.setString(4, adhesion.getStatutVise());
                ps.setString(5, adhesion.getEtablissement());
                ps.setString(6, adhesion.getMotivation());
                ps.setString(7, adhesion.getDateSoumission());
                ps.setString(8, adhesion.getDecision() != null ? adhesion.getDecision() : "EN_ATTENTE");
                if (ps.executeUpdate() > 0) return true;
            } catch (SQLException e) {
                System.err.println("[DemandeDaoImpl] Erreur saveAdhesion: " + e.getMessage());
            }
        }
        adhesion.setId((long) (DEMO_ADHESIONS.size() + 1));
        DEMO_ADHESIONS.add(0, adhesion);
        return true;
    }

    @Override
    public boolean updateDecisionAdhesion(Long id, String decision) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "UPDATE demandes_adhesion SET decision = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, decision);
                ps.setLong(2, id);
                if (ps.executeUpdate() > 0) {
                    // Si acceptée, créer automatiquement le membre et la période d'affiliation si possible
                    if ("ACCEPTEE".equalsIgnoreCase(decision)) {
                        creerMembreApresAdhesion(conn, id);
                    }
                    return true;
                }
            } catch (SQLException e) {
                System.err.println("[DemandeDaoImpl] Erreur updateDecisionAdhesion: " + e.getMessage());
            }
        }
        for (DemandeAdhesion a : DEMO_ADHESIONS) {
            if (a.getId().equals(id)) {
                a.setDecision(decision);
                return true;
            }
        }
        return false;
    }

    private void creerMembreApresAdhesion(Connection conn, Long adhesionId) {
        String sqlSelect = "SELECT * FROM demandes_adhesion WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setLong(1, adhesionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String prenom = rs.getString("prenom");
                    String nom = rs.getString("nom");
                    String email = rs.getString("email");
                    String statutVise = rs.getString("statutVise");

                    String memberId = (prenom.substring(0, 1) + nom).toLowerCase().replaceAll("[^a-z0-9]", "");
                    if (memberId.length() > 50) memberId = memberId.substring(0, 50);

                    // 1. Inserer dans members
                    String sqlMember = "INSERT IGNORE INTO members (id, firstName, lastName, email, status, role, team, grade) " +
                                       "VALUES (?, ?, ?, ?, ?, 'membre', 'IA', ?)";
                    try (PreparedStatement psM = conn.prepareStatement(sqlMember)) {
                        psM.setString(1, memberId);
                        psM.setString(2, prenom);
                        psM.setString(3, nom);
                        psM.setString(4, email);
                        psM.setString(5, statutVise.toLowerCase());
                        psM.setString(6, statutVise);
                        psM.executeUpdate();
                    }

                    // 2. Inserer dans affiliation_periods
                    String sqlAff = "INSERT INTO affiliation_periods (member_id, date_debut, date_fin, role_historique) " +
                                    "VALUES (?, CURDATE(), NULL, ?)";
                    try (PreparedStatement psA = conn.prepareStatement(sqlAff)) {
                        psA.setString(1, memberId);
                        psA.setString(2, statutVise.toLowerCase());
                        psA.executeUpdate();
                    }

                    // 3. Inserer dans users
                    String sqlUser = "INSERT IGNORE INTO users (nom, prenom, email, password, role, actif) " +
                                     "VALUES (?, ?, ?, 'pass123', ?, 1)";
                    try (PreparedStatement psU = conn.prepareStatement(sqlUser)) {
                        psU.setString(1, nom);
                        psU.setString(2, prenom);
                        psU.setString(3, email);
                        psU.setString(4, statutVise.equalsIgnoreCase("Doctorant") ? "doctorant" : "permanent");
                        psU.executeUpdate();
                    }

                    // 4. Trace du service de notification par email (CDC §4 & §19)
                    System.out.println("================================================================================");
                    System.out.println("[SERVICE NOTIFICATION - EMAIL AUTOMATIQUE]");
                    System.out.println("Destinataire : " + email + " (" + prenom + " " + nom + ")");
                    System.out.println("Objet        : Décision d'adhésion au Laboratoire LIAS - Compte Activé");
                    System.out.println("Message      : Félicitations, votre candidature a été validée par la direction.");
                    System.out.println("Identifiants : Identifiant: " + email + " | Mot de passe initial: pass123");
                    System.out.println("================================================================================");
                }
            }
        } catch (SQLException e) {
            System.err.println("[DemandeDaoImpl] Info: creation membre: " + e.getMessage());
        }
    }

    @Override
    public List<Materiel> findAllMateriels() {
        List<Materiel> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "SELECT * FROM materiels ORDER BY id DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Materiel(
                        rs.getLong("id"),
                        rs.getString("designation"),
                        rs.getString("categorie"),
                        rs.getString("demandeur"),
                        rs.getString("dateDemande"),
                        rs.getString("statut"),
                        rs.getString("dateAttribution"),
                        rs.getString("commentaire")
                    ));
                }
                if (!list.isEmpty()) return list;
            } catch (SQLException e) {
                System.err.println("[DemandeDaoImpl] Erreur findAllMateriels: " + e.getMessage());
            }
        }
        return new ArrayList<>(DEMO_MATERIELS);
    }

    @Override
    public boolean saveMateriel(Materiel mat) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "INSERT INTO materiels (designation, categorie, demandeur, dateDemande, statut, dateAttribution, commentaire) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, mat.getDesignation());
                ps.setString(2, mat.getCategorie());
                ps.setString(3, mat.getDemandeur());
                ps.setString(4, mat.getDateDemande());
                ps.setString(5, mat.getStatut() != null ? mat.getStatut() : "EN_ATTENTE");
                ps.setString(6, mat.getDateAttribution());
                ps.setString(7, mat.getCommentaire());
                if (ps.executeUpdate() > 0) return true;
            } catch (SQLException e) {
                System.err.println("[DemandeDaoImpl] Erreur saveMateriel: " + e.getMessage());
            }
        }
        mat.setId((long) (DEMO_MATERIELS.size() + 1));
        DEMO_MATERIELS.add(0, mat);
        return true;
    }

    @Override
    public boolean updateStatutMateriel(Long id, String statut, String dateAttribution) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "UPDATE materiels SET statut = ?, dateAttribution = COALESCE(?, dateAttribution) WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, statut);
                ps.setString(2, dateAttribution);
                ps.setLong(3, id);
                if (ps.executeUpdate() > 0) return true;
            } catch (SQLException e) {
                System.err.println("[DemandeDaoImpl] Erreur updateStatutMateriel: " + e.getMessage());
            }
        }
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
