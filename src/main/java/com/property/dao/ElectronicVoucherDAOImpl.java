package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.ElectronicVoucher;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 电子凭证DAO实现类
 */
public class ElectronicVoucherDAOImpl implements ElectronicVoucherDAO {

    @Override
    public List<ElectronicVoucher> findAll() {
        List<ElectronicVoucher> list = new ArrayList<>();
        String sql = "SELECT v.*, r.name as resident_name, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address " +
                     "FROM ElectronicVoucher v " +
                     "LEFT JOIN Resident r ON v.resident_id = r.resident_id " +
                     "LEFT JOIN Housing h ON v.housing_id = h.housing_id " +
                     "ORDER BY v.create_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询电子凭证列表失败", e);
        }
        return list;
    }

    @Override
    public ElectronicVoucher findById(String voucherId) {
        String sql = "SELECT v.*, r.name as resident_name, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address " +
                     "FROM ElectronicVoucher v " +
                     "LEFT JOIN Resident r ON v.resident_id = r.resident_id " +
                     "LEFT JOIN Housing h ON v.housing_id = h.housing_id " +
                     "WHERE v.voucher_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, voucherId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询电子凭证失败", e);
        }
        return null;
    }

    @Override
    public ElectronicVoucher findByOrderId(String orderId) {
        String sql = "SELECT v.*, r.name as resident_name, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address " +
                     "FROM ElectronicVoucher v " +
                     "LEFT JOIN Resident r ON v.resident_id = r.resident_id " +
                     "LEFT JOIN Housing h ON v.housing_id = h.housing_id " +
                     "WHERE v.order_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询电子凭证失败", e);
        }
        return null;
    }

    @Override
    public List<ElectronicVoucher> findByResidentId(String residentId) {
        List<ElectronicVoucher> list = new ArrayList<>();
        String sql = "SELECT v.*, r.name as resident_name, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address " +
                     "FROM ElectronicVoucher v " +
                     "LEFT JOIN Resident r ON v.resident_id = r.resident_id " +
                     "LEFT JOIN Housing h ON v.housing_id = h.housing_id " +
                     "WHERE v.resident_id = ? " +
                     "ORDER BY v.create_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询电子凭证列表失败", e);
        }
        return list;
    }

    @Override
    public int insert(ElectronicVoucher voucher) {
        String sql = "INSERT INTO ElectronicVoucher (voucher_id, order_id, resident_id, housing_id, " +
                     "amount, payment_date, transaction_no, create_time) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, voucher.getVoucherId());
            ps.setString(2, voucher.getOrderId());
            ps.setString(3, voucher.getResidentId());
            ps.setString(4, voucher.getHousingId());
            ps.setBigDecimal(5, voucher.getAmount());
            ps.setTimestamp(6, voucher.getPaymentDate() != null ? 
                new Timestamp(voucher.getPaymentDate().getTime()) : null);
            ps.setString(7, voucher.getTransactionNo());
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("插入电子凭证失败", e);
        }
    }

    @Override
    public int delete(String voucherId) {
        String sql = "DELETE FROM ElectronicVoucher WHERE voucher_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, voucherId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除电子凭证失败", e);
        }
    }

    private ElectronicVoucher mapResultSet(ResultSet rs) throws SQLException {
        ElectronicVoucher voucher = new ElectronicVoucher();
        voucher.setVoucherId(rs.getString("voucher_id"));
        voucher.setOrderId(rs.getString("order_id"));
        voucher.setResidentId(rs.getString("resident_id"));
        voucher.setHousingId(rs.getString("housing_id"));
        voucher.setAmount(rs.getBigDecimal("amount"));
        voucher.setPaymentDate(rs.getTimestamp("payment_date"));
        voucher.setTransactionNo(rs.getString("transaction_no"));
        voucher.setCreateTime(rs.getTimestamp("create_time"));
        voucher.setResidentName(rs.getString("resident_name"));
        voucher.setHousingAddress(rs.getString("housing_address"));
        return voucher;
    }
}
