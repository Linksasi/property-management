package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.PropertyStandard;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 收费标准DAO实现类
 */
public class PropertyStandardDAOImpl implements PropertyStandardDAO {

    @Override
    public List<PropertyStandard> findAll() {
        List<PropertyStandard> list = new ArrayList<>();
        String sql = "SELECT * FROM PropertyStandard ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询收费标准列表失败", e);
        }
        return list;
    }

    @Override
    public PropertyStandard findById(String standardId) {
        String sql = "SELECT * FROM PropertyStandard WHERE standard_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, standardId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询收费标准失败", e);
        }
        return null;
    }

    @Override
    public List<PropertyStandard> findByStatus(String status) {
        List<PropertyStandard> list = new ArrayList<>();
        String sql = "SELECT * FROM PropertyStandard WHERE status = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询收费标准列表失败", e);
        }
        return list;
    }

    @Override
    public List<PropertyStandard> findByFeeType(String feeType) {
        List<PropertyStandard> list = new ArrayList<>();
        String sql = "SELECT * FROM PropertyStandard WHERE fee_type = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, feeType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询收费标准列表失败", e);
        }
        return list;
    }

    @Override
    public int insert(PropertyStandard standard) {
        String sql = "INSERT INTO PropertyStandard (standard_id, fee_type, unit_price, effective_date, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, standard.getStandardId());
            ps.setString(2, standard.getFeeType());
            ps.setBigDecimal(3, standard.getUnitPrice());
            ps.setDate(4, new java.sql.Date(standard.getEffectiveDate().getTime()));
            ps.setString(5, standard.getStatus());
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("插入收费标准失败", e);
        }
    }

    @Override
    public int update(PropertyStandard standard) {
        String sql = "UPDATE PropertyStandard SET fee_type = ?, unit_price = ?, effective_date = ?, status = ? " +
                     "WHERE standard_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, standard.getFeeType());
            ps.setBigDecimal(2, standard.getUnitPrice());
            ps.setDate(3, new java.sql.Date(standard.getEffectiveDate().getTime()));
            ps.setString(4, standard.getStatus());
            ps.setString(5, standard.getStandardId());
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新收费标准失败", e);
        }
    }

    @Override
    public int delete(String standardId) {
        String sql = "DELETE FROM PropertyStandard WHERE standard_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, standardId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除收费标准失败", e);
        }
    }
    
    private PropertyStandard mapResultSet(ResultSet rs) throws SQLException {
        PropertyStandard standard = new PropertyStandard();
        standard.setStandardId(rs.getString("standard_id"));
        standard.setFeeType(rs.getString("fee_type"));
        standard.setUnitPrice(rs.getBigDecimal("unit_price"));
        standard.setEffectiveDate(rs.getDate("effective_date"));
        standard.setStatus(rs.getString("status"));
        standard.setCreatedAt(rs.getTimestamp("created_at"));
        return standard;
    }
}
