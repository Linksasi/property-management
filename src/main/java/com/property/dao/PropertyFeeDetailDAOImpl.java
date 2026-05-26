package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.PropertyFeeDetail;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 物业费明细DAO实现类
 */
public class PropertyFeeDetailDAOImpl implements PropertyFeeDetailDAO {

    @Override
    public List<PropertyFeeDetail> findAll() {
        List<PropertyFeeDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "r.name as resident_name " +
                     "FROM PropertyFeeDetail d " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
                     "ORDER BY d.create_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费明细列表失败", e);
        }
        return list;
    }

    @Override
    public PropertyFeeDetail findById(String detailId) {
        String sql = "SELECT d.*, h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "r.name as resident_name, b.bill_month, s.fee_type as standard_type " +
                     "FROM PropertyFeeDetail d " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "LEFT JOIN PropertyStandard s ON d.standard_id = s.standard_id " +
                     "WHERE d.detail_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, detailId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费明细失败", e);
        }
        return null;
    }

    @Override
    public List<PropertyFeeDetail> findByBatchId(String batchId) {
        List<PropertyFeeDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "r.name as resident_name " +
                     "FROM PropertyFeeDetail d " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
                     "WHERE d.batch_id = ? " +
                     "ORDER BY d.create_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费明细列表失败", e);
        }
        return list;
    }

    @Override
    public List<PropertyFeeDetail> findByResidentId(String residentId) {
        List<PropertyFeeDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "r.name as resident_name, b.bill_month, s.fee_type as standard_type " +
                     "FROM PropertyFeeDetail d " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "LEFT JOIN PropertyStandard s ON d.standard_id = s.standard_id " +
                     "WHERE d.resident_id = ? " +
                     "ORDER BY b.bill_month DESC, d.create_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费明细列表失败", e);
        }
        return list;
    }

    @Override
    public List<PropertyFeeDetail> findByStatus(String status) {
        List<PropertyFeeDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "r.name as resident_name " +
                     "FROM PropertyFeeDetail d " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
                     "WHERE d.status = ? " +
                     "ORDER BY d.create_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费明细列表失败", e);
        }
        return list;
    }

    @Override
    public List<PropertyFeeDetail> findByBillMonth(String billMonth) {
        List<PropertyFeeDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
                     "r.name as resident_name, b.bill_month " +
                     "FROM PropertyFeeDetail d " +
                     "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "WHERE b.bill_month = ? " +
                     "ORDER BY d.create_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, billMonth);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费明细列表失败", e);
        }
        return list;
    }

    @Override
    public List<PropertyFeeDetail> findByConditions(String billMonth, String residentId, String status) {
        List<PropertyFeeDetail> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT d.*, h.building + '-' + h.unit + '-' + h.room_no as housing_address, " +
            "r.name as resident_name, b.bill_month " +
            "FROM PropertyFeeDetail d " +
            "LEFT JOIN Housing h ON d.housing_id = h.housing_id " +
            "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
            "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id WHERE 1=1 ");
        
        if (billMonth != null && !billMonth.isEmpty()) {
            sql.append(" AND b.bill_month = ?");
        }
        if (residentId != null && !residentId.isEmpty()) {
            sql.append(" AND d.resident_id = ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND d.status = ?");
        }
        sql.append(" ORDER BY d.create_date DESC");
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            if (billMonth != null && !billMonth.isEmpty()) {
                ps.setString(index++, billMonth);
            }
            if (residentId != null && !residentId.isEmpty()) {
                ps.setString(index++, residentId);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询物业费明细列表失败", e);
        }
        return list;
    }

    @Override
    public int insert(PropertyFeeDetail detail) {
        String sql = "INSERT INTO PropertyFeeDetail (detail_id, batch_id, housing_id, resident_id, " +
                     "standard_id, area, amount, paid_amount, status, due_date, create_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, detail.getDetailId());
            ps.setString(2, detail.getBatchId());
            ps.setString(3, detail.getHousingId());
            ps.setString(4, detail.getResidentId());
            ps.setString(5, detail.getStandardId());
            ps.setBigDecimal(6, detail.getArea());
            ps.setBigDecimal(7, detail.getAmount());
            ps.setBigDecimal(8, detail.getPaidAmount() != null ? detail.getPaidAmount() : java.math.BigDecimal.ZERO);
            ps.setString(9, detail.getStatus());
            ps.setDate(10, detail.getDueDate() != null ? new java.sql.Date(detail.getDueDate().getTime()) : null);
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("插入物业费明细失败", e);
        }
    }

    @Override
    public int insertBatch(List<PropertyFeeDetail> details) {
        String sql = "INSERT INTO PropertyFeeDetail (detail_id, batch_id, housing_id, resident_id, " +
                     "standard_id, area, amount, paid_amount, status, due_date, create_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?, ?, GETDATE())";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false);
            for (PropertyFeeDetail detail : details) {
                ps.setString(1, detail.getDetailId());
                ps.setString(2, detail.getBatchId());
                ps.setString(3, detail.getHousingId());
                ps.setString(4, detail.getResidentId());
                ps.setString(5, detail.getStandardId());
                ps.setBigDecimal(6, detail.getArea());
                ps.setBigDecimal(7, detail.getAmount());
                ps.setString(8, detail.getStatus());
                ps.setDate(9, detail.getDueDate() != null ? new java.sql.Date(detail.getDueDate().getTime()) : null);
                ps.addBatch();
            }
            ps.executeBatch();
            conn.commit();
            conn.setAutoCommit(true);
            return details.size();
        } catch (SQLException e) {
            throw new DataAccessException("批量插入物业费明细失败", e);
        }
    }

    @Override
    public int update(PropertyFeeDetail detail) {
        String sql = "UPDATE PropertyFeeDetail SET housing_id = ?, resident_id = ?, standard_id = ?, " +
                     "area = ?, amount = ?, paid_amount = ?, status = ?, due_date = ? " +
                     "WHERE detail_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, detail.getHousingId());
            ps.setString(2, detail.getResidentId());
            ps.setString(3, detail.getStandardId());
            ps.setBigDecimal(4, detail.getArea());
            ps.setBigDecimal(5, detail.getAmount());
            ps.setBigDecimal(6, detail.getPaidAmount());
            ps.setString(7, detail.getStatus());
            ps.setDate(8, detail.getDueDate() != null ? new java.sql.Date(detail.getDueDate().getTime()) : null);
            ps.setString(9, detail.getDetailId());
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新物业费明细失败", e);
        }
    }

    @Override
    public int updateStatus(String detailId, String status) {
        String sql = "UPDATE PropertyFeeDetail SET status = ?";
        if ("已缴".equals(status)) {
            sql += ", paid_date = GETDATE()";
        }
        sql += " WHERE detail_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, detailId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新物业费状态失败", e);
        }
    }
    
    @Override
    public int updateAmount(String detailId, java.math.BigDecimal amount) {
        String sql = "UPDATE PropertyFeeDetail SET amount = ? WHERE detail_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBigDecimal(1, amount);
            ps.setString(2, detailId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新物业费金额失败", e);
        }
    }
    
    @Override
    public int updateStatusAndPaidAmount(String detailId, String status, java.math.BigDecimal paidAmount) {
        String sql = "UPDATE PropertyFeeDetail SET status = ?, paid_amount = ? WHERE detail_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setBigDecimal(2, paidAmount);
            ps.setString(3, detailId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新物业费状态和金额失败", e);
        }
    }

    @Override
    public int delete(String detailId) {
        String sql = "DELETE FROM PropertyFeeDetail WHERE detail_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, detailId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除物业费明细失败", e);
        }
    }

    @Override
    public int countResidents() {
        String sql = "SELECT COUNT(DISTINCT resident_id) FROM ResidentHousing";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DataAccessException("统计住户数量失败", e);
        }
        return 0;
    }

    @Override
    public int countByStatus(String billMonth, String status) {
        String sql = "SELECT COUNT(*) FROM PropertyFeeDetail d " +
                     "JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "WHERE b.bill_month = ? AND d.status = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, billMonth);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("统计物业费状态数量失败", e);
        }
        return 0;
    }

    private PropertyFeeDetail mapResultSet(ResultSet rs) throws SQLException {
        PropertyFeeDetail detail = new PropertyFeeDetail();
        detail.setDetailId(rs.getString("detail_id"));
        detail.setBatchId(rs.getString("batch_id"));
        detail.setHousingId(rs.getString("housing_id"));
        detail.setResidentId(rs.getString("resident_id"));
        detail.setStandardId(rs.getString("standard_id"));
        detail.setArea(rs.getBigDecimal("area"));
        detail.setAmount(rs.getBigDecimal("amount"));
        detail.setPaidAmount(rs.getBigDecimal("paid_amount"));
        detail.setStatus(rs.getString("status"));
        detail.setDueDate(rs.getDate("due_date"));
        detail.setCreateDate(rs.getTimestamp("create_date"));
        detail.setPaidDate(rs.getTimestamp("paid_date"));
        detail.setHousingAddress(rs.getString("housing_address"));
        detail.setResidentName(rs.getString("resident_name"));
        try {
            detail.setBillMonth(rs.getString("bill_month"));
            detail.setStandardType(rs.getString("standard_type"));
        } catch (SQLException e) {
            // 列不存在，忽略
        }
        return detail;
    }
}
