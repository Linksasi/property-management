package com.property.dao;

import com.property.entity.ParkingSpace;
import com.property.entity.ParkingFeeRecord;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.*;

public class ParkingSpaceDAO {

    public List<ParkingSpace> findAll() {
        return findAll("asc", null, null, null);
    }

    public List<ParkingSpace> findAll(String sortOrder, String status, String location, String overdue) {
        List<ParkingSpace> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, r.name AS resident_name, " +
            "CASE WHEN EXISTS (SELECT 1 FROM ParkingFeeRecord pfr WHERE pfr.space_id=p.space_id AND pfr.status='UNPAID') THEN N'欠费' ELSE N'正常' END AS fee_status " +
            "FROM ParkingSpace p " +
            "LEFT JOIN Resident r ON p.resident_id=r.resident_id " +
            "WHERE 1=1 "
        );

        List<String> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql.append("AND p.status=? ");
            params.add(status);
        }
        if (location != null && !location.isEmpty()) {
            sql.append("AND p.location=? ");
            params.add(location);
        }
        if ("true".equals(overdue)) {
            sql.append("AND p.resident_id IS NOT NULL AND EXISTS (SELECT 1 FROM ParkingFeeRecord pfr WHERE pfr.space_id=p.space_id AND pfr.status='UNPAID') ");
        }
        sql.append("ORDER BY p.space_no ");
        sql.append("desc".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ParkingSpace sp = mapRow(rs);
                    sp.setResidentName(rs.getString("resident_name"));
                    sp.setFeeStatus(rs.getString("fee_status"));
                    list.add(sp);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<ParkingSpace> findByResidentId(String residentId) {
        List<ParkingSpace> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingSpace WHERE resident_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<ParkingSpace> findAvailable() {
        List<ParkingSpace> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingSpace WHERE status=N'空闲' ORDER BY space_no";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ParkingSpace findById(String spaceId) {
        String sql = "SELECT p.*, r.name AS resident_name, r.phone FROM ParkingSpace p LEFT JOIN Resident r ON p.resident_id=r.resident_id WHERE p.space_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, spaceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ParkingSpace sp = mapRow(rs);
                    sp.setResidentName(rs.getString("resident_name"));
                    sp.setResidentPhone(rs.getString("phone"));
                    return sp;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<ParkingFeeRecord> findFeeRecordsBySpaceId(String spaceId) {
        List<ParkingFeeRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingFeeRecord WHERE space_id=? ORDER BY bill_month DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, spaceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ParkingFeeRecord r = new ParkingFeeRecord();
                    r.setRecordId(rs.getString("record_id"));
                    r.setSpaceId(rs.getString("space_id"));
                    r.setMonth(rs.getString("bill_month"));
                    r.setAmount(rs.getDouble("amount"));
                    r.setStatus(rs.getString("status"));
                    r.setCreateDate(rs.getString("create_date"));
                    list.add(r);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean bind(String spaceId, String residentId) {
        String sql = "UPDATE ParkingSpace SET status=N'已绑定', resident_id=? WHERE space_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, residentId);
            ps.setString(2, spaceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean unbind(String spaceId) {
        String sql = "UPDATE ParkingSpace SET status=N'空闲', resident_id=NULL WHERE space_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, spaceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private ParkingSpace mapRow(ResultSet rs) throws SQLException {
        ParkingSpace sp = new ParkingSpace();
        sp.setSpaceId(rs.getString("space_id"));
        sp.setSpaceNo(rs.getString("space_no"));
        sp.setLocation(rs.getString("location"));
        sp.setType(rs.getString("type"));
        sp.setStatus(rs.getString("status"));
        sp.setResidentId(rs.getString("resident_id"));
        sp.setCreatedAt(rs.getString("created_at"));
        return sp;
    }
}