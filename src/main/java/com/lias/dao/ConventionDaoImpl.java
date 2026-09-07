package com.lias.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.lias.beans.Convention;

public class ConventionDaoImpl implements IConventionDao {

    @Override
    public List<Convention> findAll() {
        List<Convention> list = new ArrayList<>();
        String sql = "SELECT * FROM conventions ORDER BY date_signature DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapConvention(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Convention findById(Long id) {
        String sql = "SELECT * FROM conventions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapConvention(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean save(Convention convention) {
        String sql = "INSERT INTO conventions (mandat_id, organisme_partenaire, type_partenaire, objet, date_signature, date_echeance, statut, budget_alloue) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (convention.getMandatId() != null) {
                ps.setLong(1, convention.getMandatId());
            } else {
                ps.setNull(1, java.sql.Types.BIGINT);
            }
            ps.setString(2, convention.getOrganismePartenaire());
            ps.setString(3, convention.getTypePartenaire());
            ps.setString(4, convention.getObjet());
            ps.setDate(5, convention.getDateSignature() != null ? Date.valueOf(convention.getDateSignature()) : null);
            ps.setDate(6, convention.getDateEcheance() != null ? Date.valueOf(convention.getDateEcheance()) : null);
            ps.setString(7, convention.getStatut());
            ps.setBigDecimal(8, convention.getBudgetAlloue());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Convention mapConvention(ResultSet rs) throws SQLException {
        Convention c = new Convention();
        c.setId(rs.getLong("id"));
        long mId = rs.getLong("mandat_id");
        if (!rs.wasNull()) c.setMandatId(mId);

        c.setOrganismePartenaire(rs.getString("organisme_partenaire"));
        c.setTypePartenaire(rs.getString("type_partenaire"));
        c.setObjet(rs.getString("objet"));

        Date dSig = rs.getDate("date_signature");
        if (dSig != null) c.setDateSignature(dSig.toLocalDate());

        Date dEch = rs.getDate("date_echeance");
        if (dEch != null) c.setDateEcheance(dEch.toLocalDate());

        c.setStatut(rs.getString("statut"));
        c.setBudgetAlloue(rs.getBigDecimal("budget_alloue"));
        return c;
    }
}
