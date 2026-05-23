package com.property.dao;

import com.property.entity.MaintenanceWorkOrder;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.*;

public class MaintenanceWorkOrderDAO {

    public MaintenanceWorkOrder findByRequestId(String requestId) {
        String sql = "SELECT w.*, s.name AS staff_name FROM MaintenanceWorkOrder w LEFT JOIN Staff s ON w.staff_id=s.staff_id WHERE w.request_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MaintenanceWorkOrder wo = mapRow(rs);
                    wo.setStaffName(rs.getString("staff_name"));
                    return wo;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<MaintenanceWorkOrder> findByStaffId(String staffId) {
        List<MaintenanceWorkOrder> list = new ArrayList<>();
        String sql = "SELECT w.*, rr.description AS request_desc, h.building, h.unit, h.room_no FROM MaintenanceWorkOrder w JOIN RepairRequest rr ON w.request_id=rr.request_id JOIN Housing h ON rr.housing_id=h.housing_id WHERE w.staff_id=? ORDER BY w.assign_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceWorkOrder wo = mapRow(rs);
                    wo.setRepairContent(rs.getString("request_desc"));
                    list.add(wo);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<MaintenanceWorkOrder> findAll() {
        List<MaintenanceWorkOrder> list = new ArrayList<>();
        String sql = "SELECT w.*, s.name AS staff_name, rr.description AS request_desc, h.building, h.unit, h.room_no FROM MaintenanceWorkOrder w LEFT JOIN Staff s ON w.staff_id=s.staff_id JOIN RepairRequest rr ON w.request_id=rr.request_id JOIN Housing h ON rr.housing_id=h.housing_id ORDER BY w.assign_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceWorkOrder wo = mapRow(rs);
                    wo.setStaffName(rs.getString("staff_name"));
                    wo.setRepairContent(rs.getString("request_desc"));
                    list.add(wo);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public MaintenanceWorkOrder findById(String workOrderId) {
        String sql = "SELECT w.*, s.name AS staff_name FROM MaintenanceWorkOrder w LEFT JOIN Staff s ON w.staff_id=s.staff_id WHERE w.work_order_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, workOrderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MaintenanceWorkOrder wo = mapRow(rs);
                    wo.setStaffName(rs.getString("staff_name"));
                    return wo;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(MaintenanceWorkOrder wo) {
        String sql = "INSERT INTO MaintenanceWorkOrder (work_order_id, request_id, staff_id, admin_id, assign_time, status) VALUES (?,?,?,?,GETDATE(),N'待接单')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, wo.getWorkOrderId());
            ps.setString(2, wo.getRequestId());
            ps.setString(3, wo.getStaffId());
            ps.setString(4, wo.getAdminId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean receive(String workOrderId) {
        String sql = "UPDATE MaintenanceWorkOrder SET status=N'已接单', receive_time=GETDATE() WHERE work_order_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, workOrderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean startRepair(String workOrderId) {
        String sql = "UPDATE MaintenanceWorkOrder SET status=N'维修中', start_time=GETDATE() WHERE work_order_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, workOrderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean submitResult(String workOrderId, String repairContent, String materialsUsed, double workHours) {
        String sql = "UPDATE MaintenanceWorkOrder SET status=N'待确认', complete_time=GETDATE(), repair_content=?, materials_used=?, work_hours=? WHERE work_order_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, repairContent);
            ps.setString(2, materialsUsed);
            ps.setDouble(3, workHours);
            ps.setString(4, workOrderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean confirm(String workOrderId, int rating, String comment) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            // update work order
            String sql1 = "UPDATE MaintenanceWorkOrder SET status=N'已完成', confirm_time=GETDATE(), rating=?, comment=? WHERE work_order_id=?";
            try (PreparedStatement ps = conn.prepareStatement(sql1)) {
                ps.setInt(1, rating);
                ps.setString(2, comment);
                ps.setString(3, workOrderId);
                ps.executeUpdate();
            }
            // update repair request status
            String sql2 = "UPDATE RepairRequest SET status=N'已完成' WHERE request_id=(SELECT request_id FROM MaintenanceWorkOrder WHERE work_order_id=?)";
            try (PreparedStatement ps = conn.prepareStatement(sql2)) {
                ps.setString(1, workOrderId);
                ps.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return false;
    }

    public String generateId() {
        String sql = "SELECT CONCAT('WO', FORMAT(GETDATE(),'yyyyMMdd'), RIGHT('000' + CAST(ISNULL(MAX(CAST(SUBSTRING(work_order_id,11,10) AS INT)),0)+1 AS VARCHAR),3)) FROM MaintenanceWorkOrder WHERE work_order_id LIKE 'WO' + FORMAT(GETDATE(),'yyyyMMdd') + '%'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getString(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private MaintenanceWorkOrder mapRow(ResultSet rs) throws SQLException {
        MaintenanceWorkOrder wo = new MaintenanceWorkOrder();
        wo.setWorkOrderId(rs.getString("work_order_id"));
        wo.setRequestId(rs.getString("request_id"));
        wo.setStaffId(rs.getString("staff_id"));
        wo.setAdminId(rs.getString("admin_id"));
        wo.setAssignTime(rs.getString("assign_time"));
        wo.setReceiveTime(rs.getString("receive_time"));
        wo.setStartTime(rs.getString("start_time"));
        wo.setCompleteTime(rs.getString("complete_time"));
        wo.setConfirmTime(rs.getString("confirm_time"));
        wo.setRepairContent(rs.getString("repair_content"));
        wo.setMaterialsUsed(rs.getString("materials_used"));
        wo.setWorkHours(rs.getDouble("work_hours"));
        wo.setStatus(rs.getString("status"));
        wo.setRating(rs.getInt("rating"));
        wo.setComment(rs.getString("comment"));
        return wo;
    }
}