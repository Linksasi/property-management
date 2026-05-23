package com.property.dao;

import com.property.entity.Resident;
import com.property.util.DBUtil;
import java.sql.*;

public class ResidentDAO {

    public Resident findByUserId(String userId) {
        String sql = "SELECT * FROM Resident WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Resident r) {
        if (r.getResidentId() == null || r.getResidentId().isEmpty()) {
            r.setResidentId(generateId());
        }
        String sql = "INSERT INTO Resident (resident_id, user_id, name, phone, id_card, check_in_date) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getResidentId());
            ps.setString(2, r.getUserId());
            ps.setString(3, r.getName());
            ps.setString(4, r.getPhone());
            ps.setString(5, r.getIdCard());
            ps.setString(6, r.getCheckInDate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public String generateId() {
        String sql = "SELECT CONCAT('R', RIGHT('0000'+CAST(ISNULL(MAX(CAST(SUBSTRING(resident_id,2,10) AS INT)),0)+1 AS VARCHAR),4)) FROM Resident";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getString(1) != null) return rs.getString(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return "R0001";
    }

    private Resident mapRow(ResultSet rs) throws SQLException {
        Resident r = new Resident();
        r.setResidentId(rs.getString("resident_id"));
        r.setUserId(rs.getString("user_id"));
        r.setName(rs.getString("name"));
        r.setPhone(rs.getString("phone"));
        r.setIdCard(rs.getString("id_card"));
        r.setCheckInDate(rs.getString("check_in_date"));
        return r;
    }
}