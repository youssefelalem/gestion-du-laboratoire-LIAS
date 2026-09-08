package com.lias.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import com.lias.beans.NotificationLabo;

/**
 * Implémentation JDBC / In-Memory du DAO Notifications (CDC §19).
 */
public class NotificationDaoImpl implements INotificationDao {

    private static final List<NotificationLabo> MEMORY_NOTIFS = new CopyOnWriteArrayList<>();

    static {
        initDefaultNotifications();
    }

    public NotificationDaoImpl() {
        initTable();
    }

    private void initTable() {
        String createTableSql = "CREATE TABLE IF NOT EXISTS notifications_labo (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "kind VARCHAR(50) NOT NULL, " +
                "when_text VARCHAR(100) NOT NULL, " +
                "is_read BOOLEAN NOT NULL DEFAULT FALSE, " +
                "who VARCHAR(150) NOT NULL, " +
                "body TEXT NOT NULL, " +
                "action_label VARCHAR(50), " +
                "target_url VARCHAR(255)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(createTableSql);

            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM notifications_labo");
            if (rs.next() && rs.getInt(1) == 0) {
                seedInitialData(conn);
            }
        } catch (Exception e) {
            System.err.println("NotificationDaoImpl: Table notice: " + e.getMessage());
        }
    }

    private static void initDefaultNotifications() {
        MEMORY_NOTIFS.clear();
        int id = 1;
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "adhesion", "il y a 12 min", false, "Imane Benkirane", "a soumis une demande d'adhésion (Membre permanent - Équipe IA).", "Examiner →", "/adhesions"));
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "publication", "il y a 1 h", false, "A. Saidi", "a ajouté une publication : « Diffusion priors for medical image inpainting » (MICCAI 2026).", "Valider →", "/publications"));
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "event", "il y a 3 h", false, "S. Bennani", "a créé l'événement « CASA-DATA 2026 — 8e édition » pour le 22 octobre.", "Voir →", "/evenements"));
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "document", "aujourd'hui", true, "O. Lahlou", "a téléversé 2 documents dans Séminaires NLP / 2025-2026.", "Ouvrir →", "/documents"));
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "meeting", "hier", true, "Système", "Rappel : Conseil de laboratoire le 2 juin 2026, 14:00.", "Calendrier →", "/calendrier"));
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "materiel", "hier", true, "F. Z. Idrissi", "a reçu sa station de calcul GPU (RTX 4090). Distribution validée.", "Historique →", "/materiel"));
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "rapport", "il y a 2 jours", true, "Système", "Le rapport annuel 2025-2026 est à 78 % de complétude. Échéance : 30 septembre.", "Rapport →", "/rapport"));
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "adhesion", "il y a 4 jours", true, "Karim Ouazzani", "demande d'adhésion acceptée — compte créé, identifiants envoyés.", "Profil →", "/profils"));
        MEMORY_NOTIFS.add(new NotificationLabo(id++, "convention", "il y a 1 sem.", true, "Y. El Amrani", "a signé la convention CNRS-LIPN (2026-2029).", "Convention →", "/conventions"));
    }

    private void seedInitialData(Connection conn) {
        String insertSql = "INSERT INTO notifications_labo (kind, when_text, is_read, who, body, action_label, target_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (NotificationLabo n : MEMORY_NOTIFS) {
                ps.setString(1, n.getKind());
                ps.setString(2, n.getWhenText());
                ps.setBoolean(3, n.isRead());
                ps.setString(4, n.getWho());
                ps.setString(5, n.getBody());
                ps.setString(6, n.getActionLabel());
                ps.setString(7, n.getTargetUrl());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            System.err.println("NotificationDaoImpl seed notice: " + e.getMessage());
        }
    }

    @Override
    public List<NotificationLabo> findAll() {
        List<NotificationLabo> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications_labo ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            return new ArrayList<>(MEMORY_NOTIFS);
        }
        return list.isEmpty() ? new ArrayList<>(MEMORY_NOTIFS) : list;
    }

    @Override
    public List<NotificationLabo> findByKind(String kind) {
        if (kind == null || "toutes".equalsIgnoreCase(kind)) return findAll();
        List<NotificationLabo> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications_labo WHERE kind = ? ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kind);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            for (NotificationLabo n : MEMORY_NOTIFS) {
                if (kind.equalsIgnoreCase(n.getKind())) list.add(n);
            }
        }
        return list;
    }

    @Override
    public List<NotificationLabo> findUnread() {
        List<NotificationLabo> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications_labo WHERE is_read = FALSE ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            for (NotificationLabo n : MEMORY_NOTIFS) {
                if (!n.isRead()) list.add(n);
            }
        }
        return list;
    }

    @Override
    public boolean markAsRead(int id) {
        String sql = "UPDATE notifications_labo SET is_read = TRUE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception ignored) {}

        for (NotificationLabo n : MEMORY_NOTIFS) {
            if (n.getId() != null && n.getId() == id) {
                n.setRead(true);
                break;
            }
        }
        return true;
    }

    @Override
    public boolean markAllAsRead() {
        String sql = "UPDATE notifications_labo SET is_read = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception ignored) {}

        for (NotificationLabo n : MEMORY_NOTIFS) {
            n.setRead(true);
        }
        return true;
    }

    @Override
    public boolean save(NotificationLabo notif) {
        if (notif == null) return false;
        String sql = "INSERT INTO notifications_labo (kind, when_text, is_read, who, body, action_label, target_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, notif.getKind());
            ps.setString(2, notif.getWhenText());
            ps.setBoolean(3, notif.isRead());
            ps.setString(4, notif.getWho());
            ps.setString(5, notif.getBody());
            ps.setString(6, notif.getActionLabel());
            ps.setString(7, notif.getTargetUrl());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) notif.setId(rs.getInt(1));
                }
                MEMORY_NOTIFS.add(0, notif);
                return true;
            }
        } catch (Exception ignored) {}

        notif.setId(MEMORY_NOTIFS.size() + 1);
        MEMORY_NOTIFS.add(0, notif);
        return true;
    }

    private NotificationLabo mapRow(ResultSet rs) throws Exception {
        return new NotificationLabo(
                rs.getInt("id"),
                rs.getString("kind"),
                rs.getString("when_text"),
                rs.getBoolean("is_read"),
                rs.getString("who"),
                rs.getString("body"),
                rs.getString("action_label"),
                rs.getString("target_url")
        );
    }
}
