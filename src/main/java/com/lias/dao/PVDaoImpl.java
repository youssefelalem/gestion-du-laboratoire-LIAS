package com.lias.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.lias.beans.ReunionPV;

public class PVDaoImpl implements IPVDao {

    @Override
    public List<ReunionPV> findAll() {
        List<ReunionPV> list = new ArrayList<>();
        String sql = "SELECT * FROM reunions_pv ORDER BY date_reunion DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapPV(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ReunionPV findById(Long id) {
        String sql = "SELECT * FROM reunions_pv WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPV(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean save(ReunionPV pv) {
        String sql = "INSERT INTO reunions_pv (titre, date_reunion, ordre_du_jour, chemin_fichier_pv, directeur_signataire) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pv.getTitre());
            ps.setDate(2, pv.getDateReunion() != null ? Date.valueOf(pv.getDateReunion()) : null);
            ps.setString(3, pv.getOrdreDuJour());
            ps.setString(4, pv.getCheminFichierPV());
            ps.setString(5, pv.getDirecteurSignataire());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private ReunionPV mapPV(ResultSet rs) throws SQLException {
        ReunionPV pv = new ReunionPV();
        pv.setId(rs.getLong("id"));
        pv.setTitre(rs.getString("titre"));

        Date d = rs.getDate("date_reunion");
        if (d != null) pv.setDateReunion(d.toLocalDate());

        pv.setOrdreDuJour(rs.getString("ordre_du_jour"));
        pv.setCheminFichierPV(rs.getString("chemin_fichier_pv"));
        pv.setDirecteurSignataire(rs.getString("directeur_signataire"));
        return pv;
    }
}
