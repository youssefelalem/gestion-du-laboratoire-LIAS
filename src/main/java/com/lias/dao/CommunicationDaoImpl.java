package com.lias.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.lias.beans.MessageCommunication;

public class CommunicationDaoImpl implements ICommunicationDao {

    private static final List<MessageCommunication> SAMPLE_MESSAGES = Collections.synchronizedList(new ArrayList<>());

    static {
        SAMPLE_MESSAGES.add(new MessageCommunication(1L, "general", "Général & Direction", "Prof. Youssef El Amrani", "directeur@lias.ma", "Directeur", "Rappel : la campagne d'arbitrage des candidatures et le rapport annuel 2025-2026 doivent être validés avant la fin du mois. Merci à chaque responsable d'équipe de vérifier ses effectifs.", "Hier à 16:42"));
        SAMPLE_MESSAGES.add(new MessageCommunication(2L, "general", "Général & Direction", "Prof. Amine Alami", "amine.alami@lias.ma", "Responsable DSCC", "Reçu. J'ai consolidé les chiffres et les 5 publications scientifiques de notre équipe. Tout est à jour dans le système.", "Hier à 17:14"));
        SAMPLE_MESSAGES.add(new MessageCommunication(3L, "general", "Général & Direction", "Dr. Karim Bennani", "karim.bennani@lias.ma", "Enseignant-Chercheur", "Pour la réservation du matériel GPU, la demande est soumise pour l'entraînement des modèles NLP.", "Aujourd'hui à 09:15"));
        SAMPLE_MESSAGES.add(new MessageCommunication(4L, "general", "Général & Direction", "Salma El Fassi", "salma.elfassi@univ-h2c.ma", "Doctorante", "Merci à l'équipe pour les retours sur l'article IEEE. Le fichier final est disponible dans l'archive documentaire.", "Aujourd'hui à 11:48"));

        SAMPLE_MESSAGES.add(new MessageCommunication(5L, "team_dscc", "Équipe Data Science & Cloud (DSCC)", "Prof. Amine Alami", "amine.alami@lias.ma", "Chef d'équipe", "Point d'avancement ce jeudi à 14h en salle 12 pour préparer les démonstrations sur le cluster Hadoop / Spark.", "Hier à 14:00"));
        SAMPLE_MESSAGES.add(new MessageCommunication(6L, "team_dscc", "Équipe Data Science & Cloud (DSCC)", "Tariq Bennani", "tariq.bennani@univh2c.ma", "Doctorant", "Les métriques de performance sur les données distribuées sont compilées. Je prépare les graphiques.", "Aujourd'hui à 10:20"));

        SAMPLE_MESSAGES.add(new MessageCommunication(7L, "team_msi", "Équipe Modélisation & SI (MSI)", "Prof. Sara Benjelloun", "sara.benjelloun@lias.ma", "Chef d'équipe", "Réunion méthodologique sur les architectures micro-services et l'intégration continue.", "2026-06-02 11:00"));

        SAMPLE_MESSAGES.add(new MessageCommunication(8L, "events", "Manifestations & Événements", "Prof. Youssef El Amrani", "directeur@lias.ma", "Directeur", "L'ordre du jour et la logistique du Workshop National sur l'IA sont validés. Les inscriptions doctorants sont ouvertes.", "Aujourd'hui à 14:22"));
    }

    public CommunicationDaoImpl() {
        initDatabaseTable();
    }

    private void initDatabaseTable() {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "CREATE TABLE IF NOT EXISTS communications_internes (" +
                             "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                             "canal_id VARCHAR(50) NOT NULL, " +
                             "canal_nom VARCHAR(100) NOT NULL, " +
                             "auteur_nom VARCHAR(100) NOT NULL, " +
                             "auteur_email VARCHAR(100) NOT NULL, " +
                             "auteur_role VARCHAR(50) NOT NULL, " +
                             "message TEXT NOT NULL, " +
                             "date_envoi VARCHAR(50) NOT NULL" +
                             ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                try (Statement stmt = conn.createStatement()) {
                    stmt.execute(sql);
                } catch (SQLException e) {
                    System.err.println("[CommunicationDaoImpl] Info table init: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[CommunicationDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }
    }

    @Override
    public List<MessageCommunication> findByCanal(String canalId) {
        if (canalId == null || canalId.trim().isEmpty()) {
            canalId = "general";
        }
        List<MessageCommunication> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "SELECT * FROM communications_internes WHERE canal_id = ? ORDER BY id ASC";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, canalId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            list.add(new MessageCommunication(
                                rs.getLong("id"),
                                rs.getString("canal_id"),
                                rs.getString("canal_nom"),
                                rs.getString("auteur_nom"),
                                rs.getString("auteur_email"),
                                rs.getString("auteur_role"),
                                rs.getString("message"),
                                rs.getString("date_envoi")
                            ));
                        }
                    }
                    if (!list.isEmpty()) return list;
                } catch (SQLException e) {
                    System.err.println("[CommunicationDaoImpl] Erreur findByCanal: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[CommunicationDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }

        // Fallback en mémoire
        List<MessageCommunication> fallback = new ArrayList<>();
        for (MessageCommunication m : SAMPLE_MESSAGES) {
            if (m.getCanalId().equalsIgnoreCase(canalId)) {
                fallback.add(m);
            }
        }
        return fallback;
    }

    @Override
    public boolean save(MessageCommunication msg) {
        if (msg == null) return false;
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "INSERT INTO communications_internes (canal_id, canal_nom, auteur_nom, auteur_email, auteur_role, message, date_envoi) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, msg.getCanalId());
                    ps.setString(2, msg.getCanalNom() != null ? msg.getCanalNom() : msg.getCanalId());
                    ps.setString(3, msg.getAuteurNom());
                    ps.setString(4, msg.getAuteurEmail());
                    ps.setString(5, msg.getAuteurRole());
                    ps.setString(6, msg.getMessage());
                    ps.setString(7, msg.getDateEnvoi() != null ? msg.getDateEnvoi() : DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm").format(LocalDateTime.now()));
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        try (ResultSet gk = ps.getGeneratedKeys()) {
                            if (gk.next()) msg.setId(gk.getLong(1));
                        }
                        return true;
                    }
                } catch (SQLException e) {
                    System.err.println("[CommunicationDaoImpl] Erreur save: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[CommunicationDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }

        // Sauvegarde en mémoire
        if (msg.getId() == null) {
            msg.setId(System.currentTimeMillis());
        }
        if (msg.getDateEnvoi() == null) {
            msg.setDateEnvoi("À l'instant");
        }
        SAMPLE_MESSAGES.add(msg);
        return true;
    }
}
