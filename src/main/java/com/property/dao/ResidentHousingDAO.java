package com.property.dao;

import com.property.entity.ResidentHousing;
import com.property.exception.DataAccessException;
import com.property.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResidentHousingDAO {

    public List<ResidentHousing> findAllByResidentId(String residentId) {
        List<ResidentHousing> list = new ArrayList<>();
        String sql = "SELECT * FROM ResidentHousing WHERE resident_id = ? ORDER BY start_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询住户住房关联失败", e);
        }
        return list;
    }

    public void deleteByResidentId(String residentId) {
        String sql = "DELETE FROM ResidentHousing WHERE resident_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, residentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除住户住房关联失败", e);
        }
    }

    public boolean delete(String residentId, String housingId) {
        String sql = "DELETE FROM ResidentHousing WHERE resident_id = ? AND housing_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, residentId);
            ps.setString(2, housingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("删除住户住房关联失败", e);
        }
    }

    public boolean insert(ResidentHousing rh) {
        String sql = "INSERT INTO ResidentHousing (resident_id, housing_id, start_date, is_owner) VALUES (?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rh.getResidentId());
            ps.setString(2, rh.getHousingId());
            ps.setString(3, rh.getStartDate());
            ps.setBoolean(4, rh.isOwner());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("插入住户住房关联失败", e);
        }
    }

    public ResidentHousing findByResidentId(String residentId) {
        String sql = "SELECT * FROM ResidentHousing WHERE resident_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询住户住房关联失败", e);
        }
        return null;
    }

    private ResidentHousing mapRow(ResultSet rs) throws SQLException {
        ResidentHousing rh = new ResidentHousing();
        rh.setResidentId(rs.getString("resident_id"));
        rh.setHousingId(rs.getString("housing_id"));
        rh.setStartDate(rs.getString("start_date"));
        rh.setEndDate(rs.getString("end_date"));
        rh.setOwner(rs.getBoolean("is_owner"));
        return rh;
    }
}
