package com.property.dao;

import com.property.entity.WaterFeeBill;
import com.property.exception.DataAccessException;
import com.property.util.DBUtil;
import com.property.util.FormatUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 水费账单数据访问层
 */
public class WaterFeeBillDAO {

    public List<WaterFeeBill> findAll() {
        List<WaterFeeBill> list = new ArrayList<>();
        String sql = "SELECT b.bill_id, b.meter_id, b.resident_id, b.bill_month, " +
                     "b.last_read, b.current_read, b.usage, b.unit_price, " +
                     "b.amount, b.paid_amount, b.status, b.due_date, b.create_date, b.paid_date, " +
                     "h.building, h.unit, h.room_no, " +
                     "r.name as resident_name, w.meter_id as meter_no " +
                     "FROM WaterFeeBill b " +
                     "LEFT JOIN WaterMeter w ON b.meter_id = w.meter_id " +
                     "LEFT JOIN Housing h ON w.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON b.resident_id = r.resident_id " +
                     "ORDER BY b.bill_month DESC, b.bill_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                WaterFeeBill bill = mapResultSet(rs);
                bill.setHousingAddress(FormatUtil.formatAddress(rs.getString("building"),
                    rs.getString("unit"), rs.getString("room_no")));
                bill.setResidentName(rs.getString("resident_name"));
                bill.setMeterNo(rs.getString("meter_no"));
                list.add(bill);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询水费账单列表失败", e);
        }
        return list;
    }

    public WaterFeeBill findById(String billId) {
        String sql = "SELECT b.bill_id, b.meter_id, b.resident_id, b.bill_month, " +
                     "b.last_read, b.current_read, b.usage, b.unit_price, " +
                     "b.amount, b.paid_amount, b.status, b.due_date, b.create_date, b.paid_date, " +
                     "h.building, h.unit, h.room_no, " +
                     "r.name as resident_name, w.meter_id as meter_no " +
                     "FROM WaterFeeBill b " +
                     "LEFT JOIN WaterMeter w ON b.meter_id = w.meter_id " +
                     "LEFT JOIN Housing h ON w.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON b.resident_id = r.resident_id " +
                     "WHERE b.bill_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    WaterFeeBill bill = mapResultSet(rs);
                    bill.setHousingAddress(FormatUtil.formatAddress(rs.getString("building"),
                        rs.getString("unit"), rs.getString("room_no")));
                    bill.setResidentName(rs.getString("resident_name"));
                    bill.setMeterNo(rs.getString("meter_no"));
                    return bill;
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询水费账单失败", e);
        }
        return null;
    }

    public List<WaterFeeBill> findByResidentId(String residentId) {
        List<WaterFeeBill> list = new ArrayList<>();
        String sql = "SELECT b.bill_id, b.meter_id, b.resident_id, b.bill_month, " +
                     "b.last_read, b.current_read, b.usage, b.unit_price, " +
                     "b.amount, b.paid_amount, b.status, b.due_date, b.create_date, b.paid_date, " +
                     "h.building, h.unit, h.room_no, " +
                     "r.name as resident_name, w.meter_id as meter_no " +
                     "FROM WaterFeeBill b " +
                     "LEFT JOIN WaterMeter w ON b.meter_id = w.meter_id " +
                     "LEFT JOIN Housing h ON w.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON b.resident_id = r.resident_id " +
                     "WHERE b.resident_id = ? " +
                     "ORDER BY b.bill_month DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WaterFeeBill bill = mapResultSet(rs);
                    bill.setHousingAddress(FormatUtil.formatAddress(rs.getString("building"),
                        rs.getString("unit"), rs.getString("room_no")));
                    bill.setResidentName(rs.getString("resident_name"));
                    bill.setMeterNo(rs.getString("meter_no"));
                    list.add(bill);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询水费账单列表失败", e);
        }
        return list;
    }

    /**
     * 检查某水表某月份是否已有账单
     */
    public boolean existsByMeterIdAndMonth(String meterId, String billMonth) {
        String sql = "SELECT COUNT(1) FROM WaterFeeBill WHERE meter_id = ? AND bill_month = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, meterId);
            ps.setString(2, billMonth);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new DataAccessException("检查账单是否存在失败", e);
        }
        return false;
    }

    public List<WaterFeeBill> findByMonth(String billMonth) {
        List<WaterFeeBill> list = new ArrayList<>();
        String sql = "SELECT b.bill_id, b.meter_id, b.resident_id, b.bill_month, " +
                     "b.last_read, b.current_read, b.usage, b.unit_price, " +
                     "b.amount, b.paid_amount, b.status, b.due_date, b.create_date, b.paid_date, " +
                     "h.building, h.unit, h.room_no, " +
                     "r.name as resident_name, w.meter_id as meter_no " +
                     "FROM WaterFeeBill b " +
                     "LEFT JOIN WaterMeter w ON b.meter_id = w.meter_id " +
                     "LEFT JOIN Housing h ON w.housing_id = h.housing_id " +
                     "LEFT JOIN Resident r ON b.resident_id = r.resident_id " +
                     "WHERE b.bill_month = ? " +
                     "ORDER BY b.bill_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, billMonth);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WaterFeeBill bill = mapResultSet(rs);
                    bill.setHousingAddress(FormatUtil.formatAddress(rs.getString("building"),
                        rs.getString("unit"), rs.getString("room_no")));
                    bill.setResidentName(rs.getString("resident_name"));
                    bill.setMeterNo(rs.getString("meter_no"));
                    list.add(bill);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询水费账单列表失败", e);
        }
        return list;
    }

    public boolean insert(WaterFeeBill bill) {
        if (bill.getBillId() == null || bill.getBillId().isEmpty()) {
            bill.setBillId(generateNextId());
        }

        String sql = "INSERT INTO WaterFeeBill (bill_id, meter_id, resident_id, bill_month, " +
                     "last_read, current_read, usage, unit_price, amount, paid_amount, " +
                     "status, due_date, create_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bill.getBillId());
            ps.setString(2, bill.getMeterId());
            ps.setString(3, bill.getResidentId());
            ps.setString(4, bill.getBillMonth());
            ps.setBigDecimal(5, bill.getLastRead());
            ps.setBigDecimal(6, bill.getCurrentRead());
            ps.setBigDecimal(7, bill.getUsage());
            ps.setBigDecimal(8, bill.getUnitPrice());
            ps.setBigDecimal(9, bill.getAmount());
            ps.setBigDecimal(10, bill.getPaidAmount() != null ? bill.getPaidAmount() : null);
            ps.setString(11, bill.getStatus() != null ? bill.getStatus() : "未缴");
            ps.setDate(12, bill.getDueDate() != null ? Date.valueOf(bill.getDueDate()) : null);
            ps.setTimestamp(13, bill.getCreateDate() != null ? Timestamp.valueOf(bill.getCreateDate()) : new Timestamp(System.currentTimeMillis()));

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("插入水费账单失败", e);
        }
    }

    public boolean update(WaterFeeBill bill) {
        String sql = "UPDATE WaterFeeBill SET meter_id = ?, resident_id = ?, bill_month = ?, " +
                     "last_read = ?, current_read = ?, usage = ?, unit_price = ?, " +
                     "amount = ?, paid_amount = ?, status = ?, due_date = ?, paid_date = ? " +
                     "WHERE bill_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bill.getMeterId());
            ps.setString(2, bill.getResidentId());
            ps.setString(3, bill.getBillMonth());
            ps.setBigDecimal(4, bill.getLastRead());
            ps.setBigDecimal(5, bill.getCurrentRead());
            ps.setBigDecimal(6, bill.getUsage());
            ps.setBigDecimal(7, bill.getUnitPrice());
            ps.setBigDecimal(8, bill.getAmount());
            ps.setBigDecimal(9, bill.getPaidAmount());
            ps.setString(10, bill.getStatus());
            ps.setDate(11, bill.getDueDate() != null ? Date.valueOf(bill.getDueDate()) : null);
            ps.setTimestamp(12, bill.getPaidDate() != null ? Timestamp.valueOf(bill.getPaidDate()) : null);
            ps.setString(13, bill.getBillId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("更新水费账单失败", e);
        }
    }

    public boolean confirmPayment(String billId, java.math.BigDecimal paidAmount) {
        String sql = "UPDATE WaterFeeBill SET status = '已缴', paid_amount = ?, paid_date = ? WHERE bill_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBigDecimal(1, paidAmount);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setString(3, billId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("确认缴费失败", e);
        }
    }

    public String generateNextId() {
        String sql = "SELECT TOP 1 bill_id FROM WaterFeeBill ORDER BY bill_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String lastId = rs.getString("bill_id");
                // 处理 WB202606001 和 W00001 两种格式
                String numStr = lastId.replaceAll("^W+", "");
                try {
                    int num = Integer.parseInt(numStr);
                    return "WB" + String.format("%06d", num + 1);
                } catch (NumberFormatException e) {
                    // fallback: 直接截取末尾数字
                    int num = Integer.parseInt(lastId.replaceAll("\\D", "").replaceAll("^0+", ""));
                    return "WB" + String.format("%06d", num + 1);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("生成水费账单ID失败", e);
        }
        return "W00001";
    }

    private WaterFeeBill mapResultSet(ResultSet rs) throws SQLException {
        WaterFeeBill bill = new WaterFeeBill();
        bill.setBillId(rs.getString("bill_id"));
        bill.setMeterId(rs.getString("meter_id"));
        bill.setResidentId(rs.getString("resident_id"));
        bill.setBillMonth(rs.getString("bill_month"));
        bill.setLastRead(rs.getBigDecimal("last_read"));
        bill.setCurrentRead(rs.getBigDecimal("current_read"));
        bill.setUsage(rs.getBigDecimal("usage"));
        bill.setUnitPrice(rs.getBigDecimal("unit_price"));
        bill.setAmount(rs.getBigDecimal("amount"));
        bill.setPaidAmount(rs.getBigDecimal("paid_amount"));
        bill.setStatus(rs.getString("status"));
        Date dueDate = rs.getDate("due_date");
        bill.setDueDate(dueDate != null ? dueDate.toLocalDate() : null);
        Timestamp createDate = rs.getTimestamp("create_date");
        bill.setCreateDate(createDate != null ? createDate.toLocalDateTime() : null);
        Timestamp paidDate = rs.getTimestamp("paid_date");
        bill.setPaidDate(paidDate != null ? paidDate.toLocalDateTime() : null);
        return bill;
    }

}
