package com.property.dao;

import com.property.entity.Staff;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    public Staff findByUserId(String userId) {
        String sql = "SELECT * FROM Staff WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Staff s) {
        if (s.getStaffId() == null || s.getStaffId().isEmpty()) {
            s.setStaffId(generateId());
        }
        String sql = "INSERT INTO Staff (staff_id, user_id, name, phone, id_card, worktype_id, is_admin) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getStaffId());
            ps.setString(2, s.getUserId());
            ps.setString(3, s.getName());
            ps.setString(4, s.getPhone());
            ps.setString(5, s.getIdCard());
            ps.setString(6, s.getWorktypeId());
            ps.setBoolean(7, s.isAdmin());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Staff> findAllNonAdmin() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT s.*, wt.worktype_name FROM Staff s LEFT JOIN WorkType wt ON s.worktype_id=wt.worktype_id WHERE s.is_admin=0 AND (s.status IS NULL OR s.status=N'在职')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Staff s = mapRow(rs);
                s.setWorktypeName(rs.getString("worktype_name"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String generateId() {
        String sql = "SELECT CONCAT('S', RIGHT('0000'+CAST(ISNULL(MAX(CAST(SUBSTRING(staff_id,2,10) AS INT)),0)+1 AS VARCHAR),4)) FROM Staff";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getString(1) != null) return rs.getString(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return "S0001";
    }

    private Staff mapRow(ResultSet rs) throws SQLException {
        Staff s = new Staff();
        s.setStaffId(rs.getString("staff_id"));
        s.setUserId(rs.getString("user_id"));
        s.setName(rs.getString("name"));
        s.setPhone(rs.getString("phone"));
        s.setIdCard(rs.getString("id_card"));
        s.setWorktypeId(rs.getString("worktype_id"));
        s.setAdmin(rs.getBoolean("is_admin"));
        s.setStatus(rs.getString("status"));
        return s;
    }
}