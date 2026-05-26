package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.ExternalAdCompany;
import com.property.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ExternalAdCompanyDAO {

    public List<ExternalAdCompany> getAll() {
        List<ExternalAdCompany> list = new ArrayList<>();
        String sql = "SELECT company_id, user_id, company_name, contact, phone FROM ExternalAdCompany";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ExternalAdCompany ec = mapRow(rs);
                list.add(ec);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告公司列表失败", e);
        }
        return list;
    }

    public ExternalAdCompany getById(String id) {
        String sql = "SELECT company_id, user_id, company_name, contact, phone FROM ExternalAdCompany WHERE company_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告公司失败", e);
        }
        return null;
    }

    public ExternalAdCompany findByUserId(String userId) {
        String sql = "SELECT company_id, user_id, company_name, contact, phone FROM ExternalAdCompany WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告公司失败", e);
        }
        return null;
    }

    public String generateId() {
        String sql = "SELECT TOP 1 company_id FROM ExternalAdCompany ORDER BY company_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("company_id");
                String numStr = lastId.replaceAll("\\D", "");
                int nextNum = Integer.parseInt(numStr) + 1;
                return "EC" + String.format("%04d", nextNum);
            }
        } catch (SQLException e) {
            throw new DataAccessException("生成广告公司ID失败", e);
        }
        return "EC0001";
    }

    public boolean insert(ExternalAdCompany ec) {
        String sql = "INSERT INTO ExternalAdCompany(company_id, user_id, company_name, contact, phone) VALUES(?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ec.getCompanyId());
            stmt.setString(2, ec.getUserId());
            stmt.setString(3, ec.getCompanyName());
            stmt.setString(4, ec.getContact());
            stmt.setString(5, ec.getPhone());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("插入广告公司失败", e);
        }
    }

    private ExternalAdCompany mapRow(ResultSet rs) throws SQLException {
        ExternalAdCompany ec = new ExternalAdCompany();
        ec.setCompanyId(rs.getString("company_id"));
        ec.setUserId(rs.getString("user_id"));
        ec.setCompanyName(rs.getString("company_name"));
        ec.setContact(rs.getString("contact"));
        ec.setPhone(rs.getString("phone"));
        return ec;
    }
}
