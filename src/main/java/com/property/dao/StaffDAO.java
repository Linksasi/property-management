package com.property.dao;

import com.property.entity.Staff;
import com.property.exception.DataAccessException;
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
        } catch (SQLException e) {
            throw new DataAccessException("查询员工失败", e);
        }
        return null;
    }

    public Staff insert(Staff s) throws SQLException {
        if (s.getStaffId() == null || s.getStaffId().isEmpty()) {
            s.setStaffId(generateId());
        }
        String sql = "INSERT INTO Staff (staff_id, user_id, name, phone, id_card, worktype_id, is_admin) VALUES (?,?,?,?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getStaffId());
            ps.setString(2, s.getUserId());
            ps.setString(3, s.getName());
            ps.setString(4, s.getPhone());
            ps.setString(5, s.getIdCard());
            ps.setString(6, s.getWorktypeId());
            ps.setBoolean(7, s.isAdmin());
            ps.executeUpdate();
            return s;
        } catch (SQLException e) {
            throw new DataAccessException("插入员工失败", e);
        }
    }

    public List<Staff> findAllNonAdmin() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT s.*, wt.worktype_name FROM Staff s LEFT JOIN WorkType wt ON s.worktype_id=wt.worktype_id WHERE s.is_admin=0 AND (s.status IS NULL OR s.status=N'在职')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Staff staff = mapRow(rs);
                staff.setWorktypeName(rs.getString("worktype_name"));
                list.add(staff);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询员工列表失败", e);
        }
        return list;
    }

    public String generateId() {
        String sql = "SELECT CONCAT('ST', RIGHT('0000'+CAST(ISNULL(MAX(CAST(SUBSTRING(staff_id,3,10) AS INT)),0)+1 AS VARCHAR),4)) FROM Staff";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getString(1) != null) return rs.getString(1);
        } catch (SQLException e) {
            throw new DataAccessException("生成员工ID失败", e);
        }
        return "ST0001";
    }

    public List<Staff> getAll() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT s.staff_id, s.user_id, s.name, s.phone, s.id_card, s.worktype_id, s.is_admin, s.status, w.worktype_name " +
                     "FROM Staff s LEFT JOIN WorkType w ON s.worktype_id = w.worktype_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowAll(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询员工列表失败", e);
        }
        return list;
    }

    public Staff getById(String id) {
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
        } catch (SQLException e) {
            throw new DataAccessException("查询员工失败", e);
        }
        return null;
    }

    public void update(Staff staff) {
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
        } catch (SQLException e) {
            throw new DataAccessException("更新员工失败", e);
        }
    }

    public void delete(String id) {
        String sql = "DELETE FROM Staff WHERE staff_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除员工失败", e);
        }
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
