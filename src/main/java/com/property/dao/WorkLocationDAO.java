package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.WorkLocation;
import com.property.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WorkLocationDAO {

    public List<WorkLocation> getAll() {
        List<WorkLocation> list = new ArrayList<>();
        String sql = "SELECT location_id, location_name FROM WorkLocation";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                WorkLocation wl = new WorkLocation();
                wl.setLocationId(rs.getString("location_id"));
                wl.setLocationName(rs.getString("location_name"));
                list.add(wl);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询工作地点列表失败", e);
        }
        return list;
    }

    public WorkLocation getById(String id) {
        String sql = "SELECT location_id, location_name FROM WorkLocation WHERE location_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    WorkLocation wl = new WorkLocation();
                    wl.setLocationId(rs.getString("location_id"));
                    wl.setLocationName(rs.getString("location_name"));
                    return wl;
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询工作地点失败", e);
        }
        return null;
    }

    public void add(WorkLocation wl) {
        String sql = "INSERT INTO WorkLocation(location_id, location_name) VALUES(?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, wl.getLocationId());
            stmt.setString(2, wl.getLocationName());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("添加工作地点失败", e);
        }
    }

    public void update(WorkLocation wl) {
        String sql = "UPDATE WorkLocation SET location_name = ? WHERE location_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, wl.getLocationName());
            stmt.setString(2, wl.getLocationId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新工作地点失败", e);
        }
    }

    public void delete(String id) {
        String sql = "DELETE FROM WorkLocation WHERE location_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除工作地点失败", e);
        }
    }
}
