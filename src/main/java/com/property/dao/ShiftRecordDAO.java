package com.property.dao;

import com.property.model.ShiftRecord;
import com.property.util.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ShiftRecordDAO {
    public List<ShiftRecord> getAll() throws SQLException {
        List<ShiftRecord> list = new ArrayList<>();
        String sql = "SELECT sr.shift_id, sr.staff_id, sr.location_id, sr.shift_date, sr.shift_period, " +
                     "s.name as staff_name, wt.worktype_name, wl.location_name " +
                     "FROM ShiftRecord sr " +
                     "JOIN Staff s ON sr.staff_id = s.staff_id " +
                     "LEFT JOIN WorkType wt ON s.worktype_id = wt.worktype_id " +
                     "LEFT JOIN WorkLocation wl ON sr.location_id = wl.location_id " +
                     "ORDER BY sr.shift_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<ShiftRecord> getByStaffId(String staffId) throws SQLException {
        List<ShiftRecord> list = new ArrayList<>();
        String sql = "SELECT sr.shift_id, sr.staff_id, sr.location_id, sr.shift_date, sr.shift_period, " +
                     "s.name as staff_name, wt.worktype_name, wl.location_name " +
                     "FROM ShiftRecord sr " +
                     "JOIN Staff s ON sr.staff_id = s.staff_id " +
                     "LEFT JOIN WorkType wt ON s.worktype_id = wt.worktype_id " +
                     "LEFT JOIN WorkLocation wl ON sr.location_id = wl.location_id " +
                     "WHERE sr.staff_id = ? ORDER BY sr.shift_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, staffId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public ShiftRecord getById(String id) throws SQLException {
        String sql = "SELECT sr.shift_id, sr.staff_id, sr.location_id, sr.shift_date, sr.shift_period, " +
                     "s.name as staff_name, wt.worktype_name, wl.location_name " +
                     "FROM ShiftRecord sr " +
                     "JOIN Staff s ON sr.staff_id = s.staff_id " +
                     "LEFT JOIN WorkType wt ON s.worktype_id = wt.worktype_id " +
                     "LEFT JOIN WorkLocation wl ON sr.location_id = wl.location_id " +
                     "WHERE sr.shift_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public int add(ShiftRecord sr) throws SQLException {
        String newId = generateShiftId();
        sr.setShiftId(newId);
        String sql = "INSERT INTO ShiftRecord(shift_id, staff_id, location_id, shift_date, shift_period) VALUES(?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sr.getShiftId());
            stmt.setString(2, sr.getStaffId());
            stmt.setString(3, sr.getLocationId());
            stmt.setDate(4, new Date(sr.getShiftDate().getTime()));
            stmt.setString(5, sr.getShiftPeriod());
            stmt.executeUpdate();
        }
        return 1;
    }

    private String generateShiftId() throws SQLException {
        String sql = "SELECT TOP 1 shift_id FROM ShiftRecord ORDER BY shift_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("shift_id");
                String numStr = lastId.replaceAll("\\D", "");
                int nextNum = Integer.parseInt(numStr) + 1;
                return "SH" + String.format("%04d", nextNum);
            }
        }
        return "SH0001";
    }

    public void update(ShiftRecord sr) throws SQLException {
        String sql = "UPDATE ShiftRecord SET staff_id = ?, location_id = ?, shift_date = ?, shift_period = ? WHERE shift_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sr.getStaffId());
            stmt.setString(2, sr.getLocationId());
            stmt.setDate(3, new Date(sr.getShiftDate().getTime()));
            stmt.setString(4, sr.getShiftPeriod());
            stmt.setString(5, sr.getShiftId());
            stmt.executeUpdate();
        }
    }

    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM ShiftRecord WHERE shift_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    private ShiftRecord mapRow(ResultSet rs) throws SQLException {
        ShiftRecord sr = new ShiftRecord();
        sr.setShiftId(rs.getString("shift_id"));
        sr.setStaffId(rs.getString("staff_id"));
        sr.setLocationId(rs.getString("location_id"));
        sr.setShiftDate(rs.getDate("shift_date"));
        sr.setShiftPeriod(rs.getString("shift_period"));
        sr.setStaffName(rs.getString("staff_name"));
        sr.setWorkTypeName(rs.getString("worktype_name"));
        sr.setLocationName(rs.getString("location_name"));
        return sr;
    }
}