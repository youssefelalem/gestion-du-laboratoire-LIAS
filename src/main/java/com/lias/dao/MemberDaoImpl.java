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
        DEMO_MEMBERS.add(new Member("yea", "Youssef", "El Alem", "directeur@lias.ma", "permanent", "directeur", "IA", "Professeur de l'Enseignement Supérieur"));
        DEMO_MEMBERS.add(new Member("sb", "Sara", "Benjelloun", "permanent@lias.ma", "permanent", "chef-equipe", "Big Data", "Professeur Habilité"));
        DEMO_MEMBERS.add(new Member("as", "Amine", "Alami", "doctorant@lias.ma", "doctorant", "membre", "NLP", "Doctorant"));
        DEMO_MEMBERS.add(new Member("kz", "Karim", "Zouhair", "karim.zouhair@lias.ma", "permanent", "chef-equipe", "Sécurité", "Maître de Conférences"));
        DEMO_MEMBERS.add(new Member("fb", "Fatima", "Berrada", "fatima.berrada@lias.ma", "associe", "membre", "IA", "Chercheur Associé"));
        DEMO_MEMBERS.add(new Member("om", "Omar", "Mansouri", "omar.mansouri@lias.ma", "retraite", "aucun", "Big Data", "Professeur Émérite"));
    }

    @Override
    public List<Member> findAll() {
        List<Member> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "SELECT * FROM members ORDER BY lastName ASC";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Member(
                        rs.getString("id"),
                        rs.getString("firstName"),
                        rs.getString("lastName"),
                        rs.getString("email"),
                        rs.getString("status"),
                        rs.getString("role"),
                        rs.getString("team"),
                        rs.getString("grade")
                    ));
                }
                if (!list.isEmpty()) return list;
            } catch (SQLException e) {
                System.err.println("[MemberDaoImpl] Erreur findAll: " + e.getMessage());
            }
        }
        return new ArrayList<>(DEMO_MEMBERS);
    }

    @Override
    public Member findById(String id) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "SELECT * FROM members WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return new Member(
                            rs.getString("id"),
                            rs.getString("firstName"),
                            rs.getString("lastName"),
                            rs.getString("email"),
                            rs.getString("status"),
                            rs.getString("role"),
                            rs.getString("team"),
                            rs.getString("grade")
                        );
                    }
                }
            } catch (SQLException e) {
                System.err.println("[MemberDaoImpl] Erreur findById: " + e.getMessage());
            }
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
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "INSERT INTO members (id, firstName, lastName, email, status, role, team, grade) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, member.getId());
                ps.setString(2, member.getFirstName());
                ps.setString(3, member.getLastName());
                ps.setString(4, member.getEmail());
                ps.setString(5, member.getStatus());
                ps.setString(6, member.getRole());
                ps.setString(7, member.getTeam());
                ps.setString(8, member.getGrade());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("[MemberDaoImpl] Erreur save: " + e.getMessage());
            }
        }
        DEMO_MEMBERS.add(member);
        return true;
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
