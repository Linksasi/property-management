package com.property.dao;

import com.property.model.AdStandard;
import com.property.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdStandardDAO {
    public List<AdStandard> getAll() throws SQLException {
        List<AdStandard> list = new ArrayList<>();
        String sql = "SELECT standard_id, ad_type, unit_price FROM AdStandard";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                AdStandard as = new AdStandard();
                as.setStandardId(rs.getString("standard_id"));
                as.setAdType(rs.getString("ad_type"));
                as.setUnitPrice(rs.getBigDecimal("unit_price"));
                list.add(as);
            }
        }
        return list;
    }

    public AdStandard getById(String id) throws SQLException {
        String sql = "SELECT standard_id, ad_type, unit_price FROM AdStandard WHERE standard_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    AdStandard as = new AdStandard();
                    as.setStandardId(rs.getString("standard_id"));
                    as.setAdType(rs.getString("ad_type"));
                    as.setUnitPrice(rs.getBigDecimal("unit_price"));
                    return as;
                }
            }
        }
        return null;
    }

    public void add(AdStandard as) throws SQLException {
        String sql = "INSERT INTO AdStandard(standard_id, ad_type, unit_price) VALUES(?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, as.getStandardId());
            stmt.setString(2, as.getAdType());
            stmt.setBigDecimal(3, as.getUnitPrice());
            stmt.executeUpdate();
        }
    }

    public void update(AdStandard as) throws SQLException {
        String sql = "UPDATE AdStandard SET ad_type = ?, unit_price = ? WHERE standard_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, as.getAdType());
            stmt.setBigDecimal(2, as.getUnitPrice());
            stmt.setString(3, as.getStandardId());
            stmt.executeUpdate();
        }
    }

    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM AdStandard WHERE standard_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }
}