package com.property.dao;

import com.property.entity.SystemUser;
import com.property.exception.DataAccessException;
import com.property.util.DBUtil;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.*;

public class SystemUserDAO {

    /**
     * 登录验证（BCrypt 密码校验）
     */
    public SystemUser login(String username, String password) {
        String sql = "SELECT * FROM SystemUser WHERE username=? AND status=N'正常'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemUser user = mapRow(rs);
                    if (BCrypt.checkpw(password, user.getPassword())) {
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            // 表不存在等底层错误不向上抛，返回 null 让上层给友好提示
            System.err.println("[SystemUserDAO] 数据库访问异常: " + e.getMessage());
            return null;
        }
        return null;
    }

    /**
     * 根据用户名查找（注册时查重）
     */
    public SystemUser findByUsername(String username) {
        String sql = "SELECT * FROM SystemUser WHERE username=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询用户失败", e);
        }
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
        } catch (SQLException e) {
            throw new DataAccessException("查询用户失败", e);
        }
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
        } catch (SQLException e) {
            throw new DataAccessException("查询用户列表失败", e);
        }
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
        } catch (SQLException e) {
            throw new DataAccessException("生成ID失败", e);
        }
        return prefix + "0001";
    }

    /**
     * 删除用户（注册失败回滚用）
     */
    public boolean delete(String userId) {
        String sql = "DELETE FROM SystemUser WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("删除用户失败", e);
        }
    }

    /**
     * 注册新用户（BCrypt 加密密码）
     */
    public boolean register(SystemUser user) {
        String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        user.setPassword(hashed);

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
        } catch (SQLException e) {
            throw new DataAccessException("注册用户失败", e);
        }
    }

    /**
     * 直接插入用户（不加密，供迁移/测试用）
     */
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
        } catch (SQLException e) {
            throw new DataAccessException("插入用户失败", e);
        }
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
