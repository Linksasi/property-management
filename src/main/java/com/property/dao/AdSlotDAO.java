package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.AdSlot;
import com.property.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdSlotDAO {

    public List<AdSlot> getAll() {
        List<AdSlot> list = new ArrayList<>();
        String sql = "SELECT slot_id, location, standard_id, status FROM AdSlot";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                AdSlot slot = mapRow(rs);
                list.add(slot);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告位列表失败", e);
        }
        return list;
    }

    public AdSlot getById(String id) {
        String sql = "SELECT slot_id, location, standard_id, status FROM AdSlot WHERE slot_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告位失败", e);
        }
        return null;
    }

    public void add(AdSlot slot) {
        String sql = "INSERT INTO AdSlot(slot_id, location, standard_id, status) VALUES(?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slot.getSlotId());
            stmt.setString(2, slot.getLocation());
            stmt.setString(3, slot.getStandardId());
            stmt.setString(4, slot.getStatus() != null ? slot.getStatus() : "空闲");
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("添加广告位失败", e);
        }
    }

    public void update(AdSlot slot) {
        String sql = "UPDATE AdSlot SET location = ?, standard_id = ?, status = ? WHERE slot_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slot.getLocation());
            stmt.setString(2, slot.getStandardId());
            stmt.setString(3, slot.getStatus());
            stmt.setString(4, slot.getSlotId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新广告位失败", e);
        }
    }

    public void delete(String id) {
        String sql = "DELETE FROM AdSlot WHERE slot_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("删除广告位失败", e);
        }
    }

    private AdSlot mapRow(ResultSet rs) throws SQLException {
        AdSlot slot = new AdSlot();
        slot.setSlotId(rs.getString("slot_id"));
        slot.setLocation(rs.getString("location"));
        slot.setStandardId(rs.getString("standard_id"));
        slot.setStatus(rs.getString("status"));
        return slot;
    }
}
