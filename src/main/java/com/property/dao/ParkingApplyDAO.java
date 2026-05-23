package com.property.dao;

import com.property.entity.ParkingApply;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.*;

public class ParkingApplyDAO {

    public List<ParkingApply> findAll() {
        List<ParkingApply> list = new ArrayList<>();
        String sql = "SELECT pa.*, ps.space_no, r.name AS resident_name FROM ParkingApply pa JOIN ParkingSpace ps ON pa.space_id=ps.space_id JOIN Resident r ON pa.resident_id=r.resident_id ORDER BY pa.apply_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ParkingApply pa = mapRow(rs);
                    pa.setSpaceNo(rs.getString("space_no"));
                    pa.setResidentName(rs.getString("resident_name"));
                    list.add(pa);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(ParkingApply pa) {
        String sql = "INSERT INTO ParkingApply (apply_id, space_id, resident_id, apply_time, status, months) VALUES (?,?,?,GETDATE(),N'待审核',?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pa.getApplyId());
            ps.setString(2, pa.getSpaceId());
            ps.setString(3, pa.getResidentId());
            ps.setInt(4, pa.getMonths());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean audit(String applyId, String adminId, boolean approved, String reason) {
        String status = approved ? "审核通过" : "审核不通过";
        String sql = "UPDATE ParkingApply SET status=?, admin_id=?, audit_time=GETDATE(), reject_reason=? WHERE apply_id=? AND status=N'待审核'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, adminId);
            ps.setString(3, reason);
            ps.setString(4, applyId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public ParkingApply findById(String applyId) {
        String sql = "SELECT pa.*, ps.space_no, r.name AS resident_name FROM ParkingApply pa JOIN ParkingSpace ps ON pa.space_id=ps.space_id JOIN Resident r ON pa.resident_id=r.resident_id WHERE pa.apply_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, applyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ParkingApply pa = mapRow(rs);
                    pa.setSpaceNo(rs.getString("space_no"));
                    pa.setResidentName(rs.getString("resident_name"));
                    return pa;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public String generateId() {
        String sql = "SELECT CONCAT('PA', FORMAT(GETDATE(),'yyyyMMdd'), RIGHT('000' + CAST(ISNULL(MAX(CAST(SUBSTRING(apply_id,11,10) AS INT)),0)+1 AS VARCHAR),3)) FROM ParkingApply WHERE apply_id LIKE 'PA' + FORMAT(GETDATE(),'yyyyMMdd') + '%'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getString(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private ParkingApply mapRow(ResultSet rs) throws SQLException {
        ParkingApply pa = new ParkingApply();
        pa.setApplyId(rs.getString("apply_id"));
        pa.setSpaceId(rs.getString("space_id"));
        pa.setResidentId(rs.getString("resident_id"));
        pa.setApplyTime(rs.getString("apply_time"));
        pa.setStatus(rs.getString("status"));
        pa.setAdminId(rs.getString("admin_id"));
        pa.setAuditTime(rs.getString("audit_time"));
        pa.setRejectReason(rs.getString("reject_reason"));
        pa.setMonths(rs.getInt("months"));
        return pa;
    }
}