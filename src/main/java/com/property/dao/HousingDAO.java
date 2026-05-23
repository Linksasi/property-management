package com.property.dao;

import com.property.entity.Housing;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.*;

public class HousingDAO {

    public List<Housing> findByResidentId(String residentId) {
        List<Housing> list = new ArrayList<>();
        String sql = "SELECT h.* FROM Housing h JOIN ResidentHousing rh ON h.housing_id=rh.housing_id WHERE rh.resident_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Housing findById(String housingId) {
        String sql = "SELECT * FROM Housing WHERE housing_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, housingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Housing h) {
        if (h.getHousingId() == null || h.getHousingId().isEmpty()) {
            h.setHousingId(generateId());
        }
        String sql = "INSERT INTO Housing (housing_id, building, unit, room_no, area, floor, house_type) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getHousingId());
            ps.setString(2, h.getBuilding());
            ps.setString(3, h.getUnit());
            ps.setString(4, h.getRoomNo());
            ps.setDouble(5, h.getArea());
            ps.setInt(6, h.getFloor());
            ps.setString(7, h.getHouseType());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public Housing findByAddress(String building, String unit, String roomNo) {
        String sql = "SELECT * FROM Housing WHERE building=? AND unit=? AND room_no=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, building);
            ps.setString(2, unit);
            ps.setString(3, roomNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public String generateId() {
        String sql = "SELECT CONCAT('H', RIGHT('0000'+CAST(ISNULL(MAX(CAST(SUBSTRING(housing_id,2,10) AS INT)),0)+1 AS VARCHAR),4)) FROM Housing";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getString(1) != null) return rs.getString(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return "H0001";
    }

    private Housing mapRow(ResultSet rs) throws SQLException {
        Housing h = new Housing();
        h.setHousingId(rs.getString("housing_id"));
        h.setBuilding(rs.getString("building"));
        h.setUnit(rs.getString("unit"));
        h.setRoomNo(rs.getString("room_no"));
        h.setArea(rs.getDouble("area"));
        h.setFloor(rs.getInt("floor"));
        h.setHouseType(rs.getString("house_type"));
        return h;
    }
}