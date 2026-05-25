package com.property.dao;

import com.property.entity.Staff;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    // ===== 原 property-management 的方法 =====
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

    public boolean insert(Staff s) throws SQLException {
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
        }
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

    // ===== 合并自 sbh 的方法 =====
    public List<Staff> getAll() throws SQLException {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT s.staff_id, s.user_id, s.name, s.phone, s.id_card, s.worktype_id, s.is_admin, s.status, w.worktype_name " +
                     "FROM Staff s LEFT JOIN WorkType w ON s.worktype_id = w.worktype_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowAll(rs));
            }
        }
        return list;
    }

    public Staff getById(String id) throws SQLException {
        String sql = "SELECT s.staff_id, s.user_id, s.name, s.phone, s.id_card, s.worktype_id, s.is_admin, s.status, w.worktype_name " +
                     "FROM Staff s LEFT JOIN WorkType w ON s.worktype_id = w.worktype_id WHERE s.staff_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowAll(rs);
                }
            }
        }
        return null;
    }

    public void update(Staff staff) throws SQLException {
        String sql = "UPDATE Staff SET name = ?, phone = ?, id_card = ?, worktype_id = ?, is_admin = ?, status = ? WHERE staff_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, staff.getName());
            stmt.setString(2, staff.getPhone());
            stmt.setString(3, staff.getIdCard());
            stmt.setString(4, staff.getWorktypeId());
            stmt.setBoolean(5, staff.isAdmin());
            stmt.setString(6, staff.getStatus());
            stmt.setString(7, staff.getStaffId());
            stmt.executeUpdate();
        }
    }

    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM Staff WHERE staff_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    // ===== mapRow 方法 =====
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

    private Staff mapRowAll(ResultSet rs) throws SQLException {
        Staff staff = new Staff();
        staff.setStaffId(rs.getString("staff_id"));
        staff.setUserId(rs.getString("user_id"));
        staff.setName(rs.getString("name"));
        staff.setPhone(rs.getString("phone"));
        staff.setIdCard(rs.getString("id_card"));
        staff.setWorktypeId(rs.getString("worktype_id"));
        staff.setAdmin(rs.getBoolean("is_admin"));
        staff.setStatus(rs.getString("status"));
        staff.setWorktypeName(rs.getString("worktype_name"));
        return staff;
    }
}