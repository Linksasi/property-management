package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.AdStandard;
import com.property.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdStandardDAO {

    public List<AdStandard> getAll() {
        List<AdStandard> list = new ArrayList<>();
        String sql = "SELECT standard_id, ad_type, unit_price FROM AdStandard";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                AdStandard as = mapRow(rs);
                list.add(as);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告标准列表失败", e);
        }
        return list;
    }

    public AdStandard getById(String id) {
        String sql = "SELECT standard_id, ad_type, unit_price FROM AdStandard WHERE standard_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告标准失败", e);
        }
        return null;
    }

    public void add(AdStandard as) {
        String sql = "INSERT INTO AdStandard(standard_id, ad_type, unit_price) VALUES(?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, as.getStandardId());
            stmt.setString(2, as.getAdType());
            stmt.setBigDecimal(3, as.getUnitPrice());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("添加广告标准失败", e);
        }
    }

    public void update(AdStandard as) {
        String sql = "UPDATE AdStandard SET ad_type = ?, unit_price = ? WHERE standard_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, as.getAdType());
            stmt.setBigDecimal(2, as.getUnitPrice());
            stmt.setString(3, as.getStandardId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新广告标准失败", e);
        }
    }

    public void delete(String id) {
        String sql = "DELETE FROM AdStandard WHERE standard_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除广告标准失败", e);
        }
    }

    private AdStandard mapRow(ResultSet rs) throws SQLException {
        AdStandard as = new AdStandard();
        as.setStandardId(rs.getString("standard_id"));
        as.setAdType(rs.getString("ad_type"));
        as.setUnitPrice(rs.getBigDecimal("unit_price"));
        return as;
    }
}
