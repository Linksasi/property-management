package com.property.dao;

import com.property.entity.ParkingFeeRecord;
import com.property.exception.DataAccessException;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.*;

public class ParkingFeeRecordDAO {

    public List<ParkingFeeRecord> findByResidentId(String residentId) {
        List<ParkingFeeRecord> list = new ArrayList<>();
        String sql = "SELECT pfr.*, ps.space_no FROM ParkingFeeRecord pfr JOIN ParkingSpace ps ON pfr.space_id=ps.space_id WHERE ps.resident_id=? ORDER BY pfr.create_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, residentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ParkingFeeRecord pf = mapRow(rs);
                    pf.setSpaceNo(rs.getString("space_no"));
                    list.add(pf);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询停车费记录失败", e);
        }
        return list;
    }

    public ParkingFeeRecord findById(String recordId) {
        String sql = "SELECT pf.*, ps.space_no FROM ParkingFeeRecord pf JOIN ParkingSpace ps ON pf.space_id=ps.space_id WHERE pf.record_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, recordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ParkingFeeRecord pf = mapRow(rs);
                    pf.setSpaceNo(rs.getString("space_no"));
                    return pf;
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询停车费记录失败", e);
        }
        return null;
    }

    public boolean pay(String recordId, double amount, String payMethod, String transactionNo) {
        String sql = "UPDATE ParkingFeeRecord SET status=N'已缴', paid_date=GETDATE(), pay_method=?, transaction_no=? WHERE record_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, payMethod);
            ps.setString(2, transactionNo);
            ps.setString(3, recordId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("支付停车费失败", e);
        }
    }

    public boolean insertBill(ParkingFeeRecord record) {
        String sql = "INSERT INTO ParkingFeeRecord (record_id, space_id, bill_month, amount, status, create_date) VALUES (?,?,?,?,N'UNPAID',GETDATE())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, record.getRecordId());
            ps.setString(2, record.getSpaceId());
            ps.setString(3, record.getMonth());
            ps.setDouble(4, record.getAmount());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("插入停车费记录失败", e);
        }
    }

    public String generateRecordId() {
        String sql = "SELECT CONCAT('PFR', FORMAT(GETDATE(),'yyyyMMdd'), RIGHT('000' + CAST(ISNULL(MAX(CAST(SUBSTRING(record_id,13,10) AS INT)),0)+1 AS VARCHAR),3)) FROM ParkingFeeRecord WHERE record_id LIKE 'PFR' + FORMAT(GETDATE(),'yyyyMMdd') + '%'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getString(1);
        } catch (SQLException e) {
            throw new DataAccessException("生成停车费记录ID失败", e);
        }
        return null;
    }

    private ParkingFeeRecord mapRow(ResultSet rs) throws SQLException {
        ParkingFeeRecord pf = new ParkingFeeRecord();
        pf.setRecordId(rs.getString("record_id"));
        pf.setSpaceId(rs.getString("space_id"));
        pf.setMonth(rs.getString("bill_month"));
        pf.setAmount(rs.getDouble("amount"));
        pf.setStatus(rs.getString("status"));
        pf.setCreateDate(rs.getString("create_date"));
        return pf;
    }
}
