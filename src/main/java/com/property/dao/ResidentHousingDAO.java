package com.property.dao;

import com.property.entity.ResidentHousing;
import com.property.util.DBUtil;
import java.sql.*;

public class ResidentHousingDAO {

    public boolean insert(ResidentHousing rh) {
        String sql = "INSERT INTO ResidentHousing (resident_id, housing_id, start_date, is_owner) VALUES (?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rh.getResidentId());
            ps.setString(2, rh.getHousingId());
            ps.setString(3, rh.getStartDate());
            ps.setBoolean(4, rh.isOwner());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public ResidentHousing findByResidentId(String residentId) {
        String sql = "SELECT * FROM ResidentHousing WHERE resident_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private ResidentHousing mapRow(ResultSet rs) throws SQLException {
        ResidentHousing rh = new ResidentHousing();
        rh.setResidentId(rs.getString("resident_id"));
        rh.setHousingId(rs.getString("housing_id"));
        rh.setStartDate(rs.getString("start_date"));
        rh.setEndDate(rs.getString("end_date"));
        rh.setOwner(rs.getBoolean("is_owner"));
        return rh;
    }
}