package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.PropertyFeeBatch;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 物业费批次DAO实现类
 */
public class PropertyFeeBatchDAOImpl implements PropertyFeeBatchDAO {

    @Override
    public List<PropertyFeeBatch> findAll() {
        List<PropertyFeeBatch> list = new ArrayList<>();
        String sql = "SELECT * FROM PropertyFeeBatch ORDER BY create_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费批次列表失败", e);
        }
        return list;
    }

    @Override
    public PropertyFeeBatch findById(String batchId) {
        String sql = "SELECT * FROM PropertyFeeBatch WHERE batch_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费批次失败", e);
        }
        return null;
    }

    @Override
    public PropertyFeeBatch findByBillMonth(String billMonth) {
        String sql = "SELECT * FROM PropertyFeeBatch WHERE bill_month = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, billMonth);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费批次失败", e);
        }
        return null;
    }

    @Override
    public int insert(PropertyFeeBatch batch) {
        String sql = "INSERT INTO PropertyFeeBatch (batch_id, bill_month, create_time, admin_id) " +
                     "VALUES (?, ?, GETDATE(), ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, batch.getBatchId());
            ps.setString(2, batch.getBillMonth());
            ps.setString(3, batch.getAdminId());
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("插入物业费批次失败", e);
        }
    }

    @Override
    public int delete(String batchId) {
        String sql = "DELETE FROM PropertyFeeBatch WHERE batch_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, batchId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除物业费批次失败", e);
        }
    }

    private PropertyFeeBatch mapResultSet(ResultSet rs) throws SQLException {
        PropertyFeeBatch batch = new PropertyFeeBatch();
        batch.setBatchId(rs.getString("batch_id"));
        batch.setBillMonth(rs.getString("bill_month"));
        batch.setCreateTime(rs.getTimestamp("create_time"));
        batch.setAdminId(rs.getString("admin_id"));
        return batch;
    }
}
