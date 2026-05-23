package com.property.dao;

import com.property.entity.WorkType;
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
        } catch (SQLException e) { e.printStackTrace(); }
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
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private WorkType mapRow(ResultSet rs) throws SQLException {
        WorkType w = new WorkType();
        w.setWorktypeId(rs.getString("worktype_id"));
        w.setWorktypeName(rs.getString("worktype_name"));
        return w;
    }
}