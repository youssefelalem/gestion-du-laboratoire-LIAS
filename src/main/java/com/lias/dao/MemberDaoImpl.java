package com.lias.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.lias.beans.Member;

public class MemberDaoImpl implements IMemberDao {

    private static final List<Member> DEMO_MEMBERS = new ArrayList<>();

    static {
        DEMO_MEMBERS.add(new Member("yea", "Youssef", "El Alem", "directeur@lias.ma", "permanent", "directeur", "IA", "Professeur de l'Enseignement Supérieur",
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80", "Faculté des Sciences Ben M'Sik — Casablanca", "LIAS (Membre fondateur)",
            "Directeur du laboratoire LIAS. Spécialiste de l'intelligence artificielle, des modèles génératifs et de la gouvernance des systèmes de données massives.", "Intelligence Artificielle, Deep Learning, Gouvernance R&D"));
        DEMO_MEMBERS.add(new Member("sb", "Sara", "Benjelloun", "permanent@lias.ma", "permanent", "chef-equipe", "Big Data", "Professeur Habilité",
            "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80", "Faculté des Sciences Ben M'Sik", "LIAS",
            "Enseignante-chercheuse habilitée, responsable de l'équipe Big Data & Cloud. Travaux axés sur le streaming distribué et le machine learning scalable.", "Big Data Streams, Apache Spark, Cloud Computing"));
        DEMO_MEMBERS.add(new Member("as", "Amine", "Alami", "doctorant@lias.ma", "doctorant", "membre", "NLP", "Doctorant",
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80", "Faculté des Sciences Ben M'Sik", "LIAS (Équipe NLP)",
            "Doctorant en 3ème année au LIAS travaillant sur le traitement automatique des langues pour les dialectes nord-africains (Darija).", "NLP, Dialectologie Maghrébine, LLM Fine-Tuning"));
        DEMO_MEMBERS.add(new Member("kz", "Karim", "Zouhair", "karim.zouhair@lias.ma", "permanent", "chef-equipe", "Sécurité", "Maître de Conférences",
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80", "École Nationale Supérieure d'Électricité et de Mécanique (ENSEM)", "LIAS",
            "Responsable de l'axe Cybersécurité et Architectures Cloud Zero-Trust. Auteur de nombreuses contributions en sécurité logicielle.", "Cybersécurité, Zero-Trust, Cryptographie Appliquée"));
        DEMO_MEMBERS.add(new Member("fb", "Fatima", "Berrada", "fatima.berrada@lias.ma", "associe", "membre", "IA", "Chercheur Associé",
            "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&auto=format&fit=crop&q=80", "Université Chouaib Doukkali — El Jadida", "Laboratoire de Recherche en Informatique (LaRI)",
            "Chercheuse associée collaborant avec le LIAS dans le cadre du projet d'apprentissage fédéré pour les systèmes médicaux.", "Santé Numérique, Federated Learning, Bioinformatique"));
        DEMO_MEMBERS.add(new Member("om", "Omar", "Mansouri", "omar.mansouri@lias.ma", "retraite", "aucun", "Big Data", "Professeur Émérite",
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&auto=format&fit=crop&q=80", "Faculté des Sciences Ben M'Sik", "LIAS",
            "Ancien directeur fondateur du LIAS (2016-2020), Professeur Émérite. Compte gelé à titre de mémoire académique institutionnelle.", "Bases de Données Réparties, Algorithmique Avancée"));
        DEMO_MEMBERS.add(new Member("kh", "Khalid", "Hassani", "ancien@lias.ma", "ancien", "aucun", "NLP", "Ancien Chercheur Post-Doc",
            "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&auto=format&fit=crop&q=80", "Université Hassan II", "LIAS",
            "Ancien chercheur post-doctoral au LIAS (2018-2022). Actuellement chercheur R&D dans l'industrie. Compte désactivé avec historique scientifique conservé selon CDC §8.2.", "Traitement Automatique des Langues, Réseaux de Neurones"));
    }

    private Member extractMember(ResultSet rs) throws SQLException {
        Member m = new Member(
            rs.getString("id"),
            rs.getString("firstName"),
            rs.getString("lastName"),
            rs.getString("email"),
            rs.getString("status"),
            rs.getString("role"),
            rs.getString("team"),
            rs.getString("grade")
        );
        try {
            m.setPhoto(rs.getString("photo"));
            m.setEtablissementOrigine(rs.getString("etablissement_origine"));
            m.setLaboratoireOrigine(rs.getString("laboratoire_origine"));
            m.setBiographie(rs.getString("biographie"));
            m.setCentresInteret(rs.getString("centres_interet"));
            m.setDateNaissance(rs.getString("date_naissance"));
            m.setDateEmbauche(rs.getString("date_embauche"));
            m.setDateAffiliation(rs.getString("date_affiliation"));
        } catch (SQLException ignored) {
            // En cas d'ancienne version de la table
        }
        return m;
    }

    @Override
    public List<Member> findAll() {
        List<Member> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "SELECT * FROM members ORDER BY lastName ASC";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(extractMember(rs));
                    }
                    if (!list.isEmpty()) return list;
                } catch (SQLException e) {
                    System.err.println("[MemberDaoImpl] Erreur findAll: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[MemberDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }
        return new ArrayList<>(DEMO_MEMBERS);
    }

    @Override
    public Member findById(String id) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "SELECT * FROM members WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return extractMember(rs);
                        }
                    }
                } catch (SQLException e) {
                    System.err.println("[MemberDaoImpl] Erreur findById: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[MemberDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }
        for (Member m : DEMO_MEMBERS) {
            if (m.getId().equalsIgnoreCase(id)) return m;
        }
        return null;
    }

    @Override
    public List<Member> findByTeam(String team) {
        List<Member> filtered = new ArrayList<>();
        for (Member m : findAll()) {
            if (m.getTeam() != null && m.getTeam().equalsIgnoreCase(team)) {
                filtered.add(m);
            }
        }
        return filtered;
    }

    @Override
    public List<Member> findByStatus(String status) {
        List<Member> filtered = new ArrayList<>();
        for (Member m : findAll()) {
            if (m.getStatus() != null && m.getStatus().equalsIgnoreCase(status)) {
                filtered.add(m);
            }
        }
        return filtered;
    }

    @Override
    public boolean save(Member member) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "INSERT INTO members (id, firstName, lastName, email, status, role, team, grade, photo, etablissement_origine, laboratoire_origine, biographie, centres_interet) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, member.getId());
                    ps.setString(2, member.getFirstName());
                    ps.setString(3, member.getLastName());
                    ps.setString(4, member.getEmail());
                    ps.setString(5, member.getStatus());
                    ps.setString(6, member.getRole());
                    ps.setString(7, member.getTeam());
                    ps.setString(8, member.getGrade());
                    ps.setString(9, member.getPhoto());
                    ps.setString(10, member.getEtablissementOrigine());
                    ps.setString(11, member.getLaboratoireOrigine());
                    ps.setString(12, member.getBiographie());
                    ps.setString(13, member.getCentresInteret());
                    return ps.executeUpdate() > 0;
                } catch (SQLException e) {
                    System.err.println("[MemberDaoImpl] Erreur save: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[MemberDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }
        DEMO_MEMBERS.add(member);
        return true;
    }

    @Override
    public boolean update(Member member) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "UPDATE members SET firstName = ?, lastName = ?, email = ?, status = ?, role = ?, team = ?, grade = ?, photo = ?, etablissement_origine = ?, laboratoire_origine = ?, biographie = ?, centres_interet = ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, member.getFirstName());
                    ps.setString(2, member.getLastName());
                    ps.setString(3, member.getEmail());
                    ps.setString(4, member.getStatus());
                    ps.setString(5, member.getRole());
                    ps.setString(6, member.getTeam());
                    ps.setString(7, member.getGrade());
                    ps.setString(8, member.getPhoto());
                    ps.setString(9, member.getEtablissementOrigine());
                    ps.setString(10, member.getLaboratoireOrigine());
                    ps.setString(11, member.getBiographie());
                    ps.setString(12, member.getCentresInteret());
                    ps.setString(13, member.getId());
                    return ps.executeUpdate() > 0;
                } catch (SQLException e) {
                    System.err.println("[MemberDaoImpl] Erreur update: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.err.println("[MemberDaoImpl] Erreur fermeture connexion : " + e.getMessage());
        }
        for (Member m : DEMO_MEMBERS) {
            if (m.getId().equalsIgnoreCase(member.getId())) {
                m.setFirstName(member.getFirstName());
                m.setLastName(member.getLastName());
                m.setEmail(member.getEmail());
                m.setStatus(member.getStatus());
                m.setRole(member.getRole());
                m.setTeam(member.getTeam());
                m.setGrade(member.getGrade());
                m.setPhoto(member.getPhoto());
                m.setEtablissementOrigine(member.getEtablissementOrigine());
                m.setLaboratoireOrigine(member.getLaboratoireOrigine());
                m.setBiographie(member.getBiographie());
                m.setCentresInteret(member.getCentresInteret());
                return true;
            }
        }
        return false;
    }

    @Override
    public List<com.lias.beans.AffiliationPeriod> getAffiliationPeriods(String memberId) {
        List<com.lias.beans.AffiliationPeriod> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM affiliation_periods WHERE member_id = ? ORDER BY date_debut ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.lias.beans.AffiliationPeriod ap = new com.lias.beans.AffiliationPeriod();
                    ap.setId(rs.getLong("id"));
                    ap.setMemberId(rs.getString("member_id"));
                    java.sql.Date dDeb = rs.getDate("date_debut");
                    if (dDeb != null) ap.setDateDebut(dDeb.toLocalDate());
                    java.sql.Date dFin = rs.getDate("date_fin");
                    if (dFin != null) ap.setDateFin(dFin.toLocalDate());
                    ap.setRoleHistorique(rs.getString("role_historique"));
                    list.add(ap);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean addAffiliationPeriod(com.lias.beans.AffiliationPeriod period) {
        String sql = "INSERT INTO affiliation_periods (member_id, date_debut, date_fin, role_historique) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, period.getMemberId());
            ps.setDate(2, period.getDateDebut() != null ? java.sql.Date.valueOf(period.getDateDebut()) : null);
            ps.setDate(3, period.getDateFin() != null ? java.sql.Date.valueOf(period.getDateFin()) : null);
            ps.setString(4, period.getRoleHistorique());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
