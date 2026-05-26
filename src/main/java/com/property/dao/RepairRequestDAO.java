package com.property.dao;

import com.property.entity.*;
import com.property.exception.DataAccessException;
import com.property.util.DBUtil;
import com.property.util.FormatUtil;
import java.sql.*;
import java.util.*;

public class RepairRequestDAO {

    public List<RepairRequest> findByUserId(String userId) {
        List<RepairRequest> list = new ArrayList<>();
        String sql = "SELECT rr.*, h.building, h.unit, h.room_no FROM RepairRequest rr JOIN Housing h ON rr.housing_id=h.housing_id WHERE rr.user_id=? ORDER BY rr.apply_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RepairRequest rr = mapRow(rs);
                    rr.setHousingAddress(FormatUtil.formatAddressHao(rs.getString("building"), rs.getString("unit"), rs.getString("room_no")));
                    list.add(rr);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询维修申请列表失败", e);
        }
        return list;
    }

    public List<RepairRequest> findAll() {
        List<RepairRequest> list = new ArrayList<>();
        String sql = "SELECT rr.*, su.real_name AS resident_name, h.building, h.unit, h.room_no FROM RepairRequest rr JOIN SystemUser su ON rr.user_id=su.user_id JOIN Housing h ON rr.housing_id=h.housing_id ORDER BY rr.apply_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RepairRequest rr = mapRow(rs);
                    rr.setResidentName(rs.getString("resident_name"));
                    rr.setHousingAddress(FormatUtil.formatAddressHao(rs.getString("building"), rs.getString("unit"), rs.getString("room_no")));
                    list.add(rr);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询维修申请列表失败", e);
        }
        return list;
    }

    public RepairRequest findById(String requestId) {
        String sql = "SELECT rr.*, su.real_name AS resident_name, h.building, h.unit, h.room_no, a.name AS admin_name, a.phone AS admin_phone FROM RepairRequest rr JOIN SystemUser su ON rr.user_id=su.user_id JOIN Housing h ON rr.housing_id=h.housing_id LEFT JOIN Staff a ON rr.admin_id=a.staff_id WHERE rr.request_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RepairRequest rr = mapRow(rs);
                    rr.setResidentName(rs.getString("resident_name"));
                    rr.setHousingAddress(FormatUtil.formatAddressHao(rs.getString("building"), rs.getString("unit"), rs.getString("room_no")));
                    try { rr.setAdminName(rs.getString("admin_name")); } catch (SQLException e) {}
                    try { rr.setAdminPhone(rs.getString("admin_phone")); } catch (SQLException e) {}
                    return rr;
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询维修申请失败", e);
        }
        return null;
    }

    public boolean insert(RepairRequest rr) {
        String sql = "INSERT INTO RepairRequest (request_id, user_id, housing_id, repair_type, description, urgency, apply_time, status) VALUES (?,?,?,?,?,?,GETDATE(),N'待审核')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rr.getRequestId());
            ps.setString(2, rr.getUserId());
            ps.setString(3, rr.getHousingId());
            ps.setString(4, rr.getRepairType());
            ps.setString(5, rr.getDescription());
            ps.setString(6, rr.getUrgency() != null ? rr.getUrgency() : "普通");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("插入维修申请失败", e);
        }
    }

    public boolean cancel(String requestId) {
        String sql = "UPDATE RepairRequest SET status=N'已取消' WHERE request_id=? AND status=N'待审核'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("取消维修申请失败", e);
        }
    }

    public boolean audit(String requestId, boolean approved, String reason, String adminId) throws SQLException {
        return audit(requestId, approved, reason, adminId, null);
    }

    public boolean audit(String requestId, boolean approved, String reason, String adminId, Connection externalConn) throws SQLException {
        Connection conn = externalConn;
        boolean needClose = false;
        if (conn == null) {
            conn = DBUtil.getConnection();
            needClose = true;
        }
        try {
            if (approved) {
                String sql = "UPDATE RepairRequest SET status=N'已派工', admin_id=? WHERE request_id=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, adminId);
                    ps.setString(2, requestId);
                    return ps.executeUpdate() > 0;
                }
            } else {
                String sql = "UPDATE RepairRequest SET status=N'审核不通过', reject_reason=?, admin_id=? WHERE request_id=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, reason);
                    ps.setString(2, adminId);
                    ps.setString(3, requestId);
                    return ps.executeUpdate() > 0;
                }
            }
        } finally {
            if (needClose) DBUtil.closeConnection();
        }
    }

    public String generateId() {
        String sql = "SELECT CONCAT('RR', FORMAT(GETDATE(),'yyyyMMdd'), RIGHT('000'+CAST(ISNULL(MAX(CAST(SUBSTRING(request_id,11,10) AS INT)),0)+1 AS VARCHAR),3)) FROM RepairRequest WHERE request_id LIKE 'RR'+FORMAT(GETDATE(),'yyyyMMdd')+'%'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getString(1);
        } catch (SQLException e) {
            throw new DataAccessException("生成维修申请ID失败", e);
        }
        return null;
    }

    private RepairRequest mapRow(ResultSet rs) throws SQLException {
        RepairRequest rr = new RepairRequest();
        rr.setRequestId(rs.getString("request_id"));
        rr.setUserId(rs.getString("user_id"));
        rr.setHousingId(rs.getString("housing_id"));
        rr.setRepairType(rs.getString("repair_type"));
        rr.setDescription(rs.getString("description"));
        rr.setUrgency(rs.getString("urgency"));
        rr.setApplyTime(rs.getString("apply_time"));
        rr.setStatus(rs.getString("status"));
        try { rr.setRejectReason(rs.getString("reject_reason")); } catch (SQLException e) {}
        try { rr.setAdminId(rs.getString("admin_id")); } catch (SQLException e) {}
        return rr;
    }
}
