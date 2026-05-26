package com.property.dao;

import com.property.entity.WorkType;
import com.property.exception.DataAccessException;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WorkTypeDAO {

    public List<WorkType> findAll() {
        List<WorkType> list = new ArrayList<>();
        String sql = "SELECT * FROM WorkType ORDER BY worktype_id";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询工种列表失败", e);
        }
        return list;
    }

    public List<WorkType> findForStaff() {
        List<WorkType> list = new ArrayList<>();
        String sql = "SELECT * FROM WorkType WHERE worktype_id != 'WT007' ORDER BY worktype_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询工种列表失败", e);
        }
        return list;
    }

    private WorkType mapRow(ResultSet rs) throws SQLException {
        WorkType w = new WorkType();
        w.setWorktypeId(rs.getString("worktype_id"));
        w.setWorktypeName(rs.getString("worktype_name"));
        return w;
    }

    public List<WorkType> getAll() {
        List<WorkType> list = new ArrayList<>();
        String sql = "SELECT worktype_id, worktype_name FROM WorkType";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                WorkType wt = new WorkType();
                wt.setWorktypeId(rs.getString("worktype_id"));
                wt.setWorktypeName(rs.getString("worktype_name"));
                list.add(wt);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询工种列表失败", e);
        }
        return list;
    }

    public WorkType getById(String id) {
        String sql = "SELECT worktype_id, worktype_name FROM WorkType WHERE worktype_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    WorkType wt = new WorkType();
                    wt.setWorktypeId(rs.getString("worktype_id"));
                    wt.setWorktypeName(rs.getString("worktype_name"));
                    return wt;
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询工种失败", e);
        }
        return null;
    }

    public void add(WorkType wt) {
        String sql = "INSERT INTO WorkType(worktype_id, worktype_name) VALUES(?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, wt.getWorktypeId());
            stmt.setString(2, wt.getWorktypeName());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("添加工种失败", e);
        }
    }

    public void update(WorkType wt) {
        String sql = "UPDATE WorkType SET worktype_name = ? WHERE worktype_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, wt.getWorktypeName());
            stmt.setString(2, wt.getWorktypeId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新工种失败", e);
        }
    }

    public void delete(String id) {
        String sql = "DELETE FROM WorkType WHERE worktype_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除工种失败", e);
        }
    }
}
