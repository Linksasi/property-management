package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.PaymentOrder;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 支付订单DAO实现类
 */
public class PaymentOrderDAOImpl implements PaymentOrderDAO {

    @Override
    public List<PaymentOrder> findAll() {
        List<PaymentOrder> list = new ArrayList<>();
        String sql = "SELECT o.*, r.name as resident_name, b.bill_month " +
                     "FROM PaymentOrder o " +
                     "LEFT JOIN PropertyFeeDetail d ON o.detail_id = d.detail_id " +
                     "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "ORDER BY o.create_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询支付订单列表失败", e);
        }
        return list;
    }

    @Override
    public PaymentOrder findById(String orderId) {
        String sql = "SELECT o.*, r.name as resident_name, b.bill_month " +
                     "FROM PaymentOrder o " +
                     "LEFT JOIN PropertyFeeDetail d ON o.detail_id = d.detail_id " +
                     "LEFT JOIN Resident r ON d.resident_id = r.resident_id " +
                     "LEFT JOIN PropertyFeeBatch b ON d.batch_id = b.batch_id " +
                     "WHERE o.order_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询支付订单失败", e);
        }
        return null;
    }

    @Override
    public PaymentOrder findByDetailId(String detailId) {
        String sql = "SELECT * FROM PaymentOrder WHERE detail_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, detailId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询支付订单失败", e);
        }
        return null;
    }

    @Override
    public PaymentOrder findByOrderNo(String orderNo) {
        String sql = "SELECT * FROM PaymentOrder WHERE order_no = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询支付订单失败", e);
        }
        return null;
    }

    @Override
    public int insert(PaymentOrder order) {
        String sql = "INSERT INTO PaymentOrder (order_id, detail_id, order_no, amount, payment_method, status, create_time) " +
                     "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, order.getOrderId());
            ps.setString(2, order.getDetailId());
            ps.setString(3, order.getOrderNo());
            ps.setBigDecimal(4, order.getAmount());
            ps.setString(5, order.getPaymentMethod());
            ps.setString(6, order.getStatus());
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("插入支付订单失败", e);
        }
    }

    @Override
    public int updateStatus(String orderId, String status) {
        String sql = "UPDATE PaymentOrder SET status = ?";
        if ("已支付".equals(status)) {
            sql += ", pay_time = GETDATE()";
        }
        sql += " WHERE order_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, orderId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新支付订单状态失败", e);
        }
    }

    @Override
    public int delete(String orderId) {
        String sql = "DELETE FROM PaymentOrder WHERE order_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除支付订单失败", e);
        }
    }

    private PaymentOrder mapResultSet(ResultSet rs) throws SQLException {
        PaymentOrder order = new PaymentOrder();
        order.setOrderId(rs.getString("order_id"));
        order.setDetailId(rs.getString("detail_id"));
        order.setOrderNo(rs.getString("order_no"));
        order.setAmount(rs.getBigDecimal("amount"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setStatus(rs.getString("status"));
        order.setCreateTime(rs.getTimestamp("create_time"));
        order.setPayTime(rs.getTimestamp("pay_time"));
        order.setResidentName(rs.getString("resident_name"));
        order.setBillMonth(rs.getString("bill_month"));
        return order;
    }
}
