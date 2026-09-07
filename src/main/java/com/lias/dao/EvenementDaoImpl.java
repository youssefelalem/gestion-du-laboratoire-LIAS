package com.lias.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.lias.beans.Evenement;

public class EvenementDaoImpl implements IEvenementDao {

    private static final List<Evenement> DEMO_EVTS = new ArrayList<>();

    static {
        DEMO_EVTS.add(new Evenement(1L, "Journée Scientifique LIAS 2026 : Enjeux de l'IA Générative", "Conférence", "2026-04-15", "Amphithéâtre Al-Kindi, FSBM", "Rencontre annuelle rassemblant les 4 équipes de recherche et nos partenaires industriels.", "Prof. Youssef El Alem", "À venir"));
        DEMO_EVTS.add(new Evenement(2L, "Workshop : Traitement Distribué avec Apache Spark & BigLake", "Workshop", "2026-03-20", "Salle Réseau 4B", "Atelier pratique pour les doctorants et chercheurs de l'équipe Big Data.", "Prof. Sara Benjelloun", "À venir"));
        DEMO_EVTS.add(new Evenement(3L, "Séminaire : LLMs et Dialectologie Maghrébine", "Séminaire", "2026-02-10", "Salle des Thèses", "Présentation des avancées sur le corpus dialectal marocain.", "Amine Alami", "Passé"));
        DEMO_EVTS.add(new Evenement(4L, "Table Ronde : Cybersécurité des Systèmes d'Information Critiques", "Conférence", "2025-11-25", "Faculté Ben M'Sik", "Discussion interdisciplinaire avec des experts de l'ANRT et du secteur bancaire.", "Prof. Karim Zouhair", "Passé"));
    }

    @Override
    public List<Evenement> findAll() {
        List<Evenement> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "SELECT * FROM evenements ORDER BY date DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Evenement(
                        rs.getLong("id"),
                        rs.getString("titre"),
                        rs.getString("type"),
                        rs.getString("date"),
                        rs.getString("lieu"),
                        rs.getString("description"),
                        rs.getString("organisateur"),
                        rs.getString("statut")
                    ));
                }
                if (!list.isEmpty()) return list;
            } catch (SQLException e) {
                System.err.println("[EvenementDaoImpl] Erreur findAll: " + e.getMessage());
            }
        }
        return new ArrayList<>(DEMO_EVTS);
    }

    @Override
    public boolean save(Evenement evt) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "INSERT INTO evenements (titre, type, date, lieu, description, organisateur, statut) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, evt.getTitre());
                ps.setString(2, evt.getType());
                ps.setString(3, evt.getDate());
                ps.setString(4, evt.getLieu());
                ps.setString(5, evt.getDescription());
                ps.setString(6, evt.getOrganisateur());
                ps.setString(7, evt.getStatut());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("[EvenementDaoImpl] Erreur save: " + e.getMessage());
            }
        }
        evt.setId((long) (DEMO_EVTS.size() + 1));
        DEMO_EVTS.add(0, evt);
        return true;
    }
}
