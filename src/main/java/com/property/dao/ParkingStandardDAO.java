package com.property.dao;

import com.property.entity.ParkingStandard;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.*;

public class ParkingStandardDAO {

    public List<ParkingStandard> findAll() {
        List<ParkingStandard> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingStandard ORDER BY parking_type";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public double getPriceByType(String parkingType) {
        String sql = "SELECT price FROM ParkingStandard WHERE parking_type=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, parkingType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("price");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean upsertPrice(String parkingType, double price) {
        try (Connection conn = DBUtil.getConnection()) {
            // try update first
            String updateSql = "UPDATE ParkingStandard SET price=? WHERE parking_type=?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setDouble(1, price);
                ps.setString(2, parkingType);
                int rows = ps.executeUpdate();
                if (rows > 0) return true;
            }
            // insert if not exists
            String insertSql = "INSERT INTO ParkingStandard (standard_id, parking_type, price, status) VALUES (?,?,?,N'生效')";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                String id = "PS" + java.time.LocalDate.now().toString().replace("-","") +
                    String.format("%03d", new java.util.Random().nextInt(900)+100);
                ps.setString(1, id);
                ps.setString(2, parkingType);
                ps.setDouble(3, price);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private ParkingStandard mapRow(ResultSet rs) throws SQLException {
        ParkingStandard ps = new ParkingStandard();
        ps.setStandardId(rs.getString("standard_id"));
        ps.setParkingType(rs.getString("parking_type"));
        ps.setPrice(rs.getDouble("price"));
        ps.setEffectiveDate(rs.getString("effective_date"));
        ps.setStatus(rs.getString("status"));
        return ps;
    }
}