package com.property.dao;

import com.property.entity.SystemUser;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.*;

public class SystemUserDAO {

    public SystemUser login(String username, String password) {
        String sql = "SELECT * FROM SystemUser WHERE username=? AND password=? AND status=N'正常'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public SystemUser findById(String userId) {
        String sql = "SELECT * FROM SystemUser WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<SystemUser> findAll() {
        List<SystemUser> list = new ArrayList<>();
        String sql = "SELECT * FROM SystemUser ORDER BY user_type, user_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String generateId(String userType) {
        String prefix;
        switch (userType) {
            case "管理员": prefix = "A"; break;
            case "业主": prefix = "O"; break;
            case "维修员": prefix = "S"; break;
            default: prefix = "U";
        }
        String sql = "SELECT CONCAT(?, RIGHT('0000' + CAST(ISNULL(MAX(CAST(SUBSTRING(user_id,2,10) AS INT)),0)+1 AS VARCHAR),4)) FROM SystemUser WHERE user_id LIKE ?+'%'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix);
            ps.setString(2, prefix);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getString(1) != null) return rs.getString(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return prefix + "0001";
    }

    public boolean insert(SystemUser user) {
        String sql = "INSERT INTO SystemUser (user_id, username, password, user_type, real_name, phone, status, created_at) VALUES (?,?,?,?,?,?,N'正常',GETDATE())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUserId());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getUserType());
            ps.setString(5, user.getRealName());
            ps.setString(6, user.getPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private SystemUser mapRow(ResultSet rs) throws SQLException {
        SystemUser u = new SystemUser();
        u.setUserId(rs.getString("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setUserType(rs.getString("user_type"));
        u.setRealName(rs.getString("real_name"));
        u.setPhone(rs.getString("phone"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getString("created_at"));
        return u;
    }
}