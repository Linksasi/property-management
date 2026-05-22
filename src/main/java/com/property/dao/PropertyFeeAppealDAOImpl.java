package com.property.dao;

import com.property.model.PropertyFeeAppeal;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 物业费申诉DAO实现类
 */
public class PropertyFeeAppealDAOImpl implements PropertyFeeAppealDAO {

    @Override
    public List<PropertyFeeAppeal> findAll() {
        List<PropertyFeeAppeal> list = new ArrayList<>();
        String sql = "SELECT a.*, r.name as resident_name, " +
                     "b.bill_month, d.amount, d.area, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "s.fee_type as standard_type " +
                     "FROM PropertyFeeAppeal a " +
                     "LEFT JOIN Resident r ON a.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeDetail d ON a.detail_id = d.detail_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN PropertyStandard s ON d.standard_id = s.standard_id " +
                     "ORDER BY a.create_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public PropertyFeeAppeal findById(String appealId) {
        String sql = "SELECT a.*, r.name as resident_name, " +
                     "b.bill_month, d.amount, d.area, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "s.fee_type as standard_type " +
                     "FROM PropertyFeeAppeal a " +
                     "LEFT JOIN Resident r ON a.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeDetail d ON a.detail_id = d.detail_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN PropertyStandard s ON d.standard_id = s.standard_id " +
                     "WHERE a.appeal_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, appealId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<PropertyFeeAppeal> findByResidentId(String residentId) {
        List<PropertyFeeAppeal> list = new ArrayList<>();
        String sql = "SELECT a.*, r.name as resident_name, " +
                     "b.bill_month, d.amount, d.area, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "s.fee_type as standard_type " +
                     "FROM PropertyFeeAppeal a " +
                     "LEFT JOIN Resident r ON a.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeDetail d ON a.detail_id = d.detail_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN PropertyStandard s ON d.standard_id = s.standard_id " +
                     "WHERE a.resident_id = ? " +
                     "ORDER BY a.create_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<PropertyFeeAppeal> findByStatus(String status) {
        List<PropertyFeeAppeal> list = new ArrayList<>();
        String sql = "SELECT a.*, r.name as resident_name, " +
                     "b.bill_month, d.amount, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address " +
                     "FROM PropertyFeeAppeal a " +
                     "LEFT JOIN Resident r ON a.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeDetail d ON a.detail_id = d.detail_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "WHERE a.status = ? " +
                     "ORDER BY a.create_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public PropertyFeeAppeal findByDetailId(String detailId) {
        String sql = "SELECT * FROM PropertyFeeAppeal WHERE detail_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, detailId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(PropertyFeeAppeal appeal) {
        String sql = "INSERT INTO PropertyFeeAppeal (appeal_id, detail_id, resident_id, reason, status, create_time) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, appeal.getAppealId());
            ps.setString(2, appeal.getDetailId());
            ps.setString(3, appeal.getResidentId());
            ps.setString(4, appeal.getReason());
            ps.setString(5, appeal.getStatus());
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int updateStatus(String appealId, String status, String adminId, String adminReason) {
        String sql = "UPDATE PropertyFeeAppeal SET status = ?, admin_id = ?, admin_reason = ?, handle_time = GETDATE() " +
                     "WHERE appeal_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, adminId);
            ps.setString(3, adminReason);
            ps.setString(4, appealId);
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(String appealId) {
        String sql = "DELETE FROM PropertyFeeAppeal WHERE appeal_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, appealId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 将ResultSet映射为PropertyFeeAppeal对象
     */
    private PropertyFeeAppeal mapResultSet(ResultSet rs) throws SQLException {
        PropertyFeeAppeal appeal = new PropertyFeeAppeal();
        appeal.setAppealId(rs.getString("appeal_id"));
        appeal.setDetailId(rs.getString("detail_id"));
        appeal.setResidentId(rs.getString("resident_id"));
        appeal.setReason(rs.getString("reason"));
        appeal.setStatus(rs.getString("status"));
        appeal.setAdminId(rs.getString("admin_id"));
        appeal.setAdminReason(rs.getString("admin_reason"));
        appeal.setCreateTime(rs.getTimestamp("create_time"));
        appeal.setHandleTime(rs.getTimestamp("handle_time"));
        appeal.setResidentName(rs.getString("resident_name"));
        appeal.setBillMonth(rs.getString("bill_month"));
        appeal.setAmount(rs.getBigDecimal("amount"));
        appeal.setHousingAddress(rs.getString("housing_address"));
        appeal.setStandardType(rs.getString("standard_type"));
        return appeal;
    }
}