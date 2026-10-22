package com.lias.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.lias.beans.Publication;

public class PublicationDaoImpl implements IPublicationDao {

    private static final List<Publication> DEMO_PUBS = new ArrayList<>();

    static {
        DEMO_PUBS.add(new Publication(1L, "Deep Learning for Arabic Sentiment Analysis in North African Dialects", "Amine Alami, Youssef El Alem", 2025, "IEEE Transactions on Affective Computing", "10.1109/TAFFC.2025.01", "NLP", "Article"));
        DEMO_PUBS.add(new Publication(2L, "Scalable Real-Time Anomaly Detection in Big Data Streams", "Sara Benjelloun, Karim Zouhair", 2024, "ACM Computing Surveys", "10.1145/3604921", "Big Data", "Article"));
        DEMO_PUBS.add(new Publication(3L, "Zero-Trust Architecture for Cloud-Native Scientific Repositories", "Karim Zouhair", 2025, "International Conference on Information Security (ICIS)", "10.1007/978-3-030-99", "Sécurité", "Conférence"));
        DEMO_PUBS.add(new Publication(4L, "Federated Learning over Distributed Healthcare Records", "Youssef El Alem, Fatima Berrada", 2024, "Journal of Medical Systems", "10.1007/s10916-024", "IA", "Article"));
        DEMO_PUBS.add(new Publication(5L, "Efficient Indexing of Multilingual Scholarly Publications", "Amine Alami, Sara Benjelloun", 2023, "Information Sciences", "10.1016/j.ins.2023", "Big Data", "Article"));
    }

    @Override
    public List<Publication> findAll() {
        List<Publication> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "SELECT * FROM publications ORDER BY annee DESC, id DESC";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(new Publication(
                            rs.getLong("id"),
                            rs.getString("titre"),
                            rs.getString("auteurs"),
                            rs.getInt("annee"),
                            rs.getString("revue"),
                            rs.getString("doi"),
                            rs.getString("equipe"),
                            rs.getString("type")
                        ));
                    }
                    if (!list.isEmpty()) return list;
                } catch (SQLException e) {
                    System.err.println("[PublicationDaoImpl] Erreur findAll: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[PublicationDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }
        return new ArrayList<>(DEMO_PUBS);
    }

    @Override
    public List<Publication> findByYear(int year) {
        List<Publication> filtered = new ArrayList<>();
        for (Publication p : findAll()) {
            if (p.getAnnee() == year) filtered.add(p);
        }
        return filtered;
    }

    @Override
    public List<Publication> findByTeam(String team) {
        List<Publication> filtered = new ArrayList<>();
        for (Publication p : findAll()) {
            if (p.getEquipe() != null && p.getEquipe().equalsIgnoreCase(team)) {
                filtered.add(p);
            }
        }
        return filtered;
    }

    @Override
    public List<Publication> findByAuthor(String author) {
        List<Publication> filtered = new ArrayList<>();
        for (Publication p : findAll()) {
            if (p.getAuteurs() != null && p.getAuteurs().toLowerCase().contains(author.toLowerCase())) {
                filtered.add(p);
            }
        }
        return filtered;
    }

    @Override
    public boolean save(Publication pub) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "INSERT INTO publications (titre, auteurs, annee, revue, doi, equipe, type) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, pub.getTitre());
                    ps.setString(2, pub.getAuteurs());
                    ps.setInt(3, pub.getAnnee());
                    ps.setString(4, pub.getRevue());
                    ps.setString(5, pub.getDoi());
                    ps.setString(6, pub.getEquipe());
                    ps.setString(7, pub.getType());
                    return ps.executeUpdate() > 0;
                } catch (SQLException e) {
                    System.err.println("[PublicationDaoImpl] Erreur save: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[PublicationDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }
        pub.setId((long) (DEMO_PUBS.size() + 1));
        DEMO_PUBS.add(0, pub);
        return true;
    }
}
