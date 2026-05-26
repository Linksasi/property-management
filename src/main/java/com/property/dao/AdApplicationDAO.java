package com.property.dao;

import com.property.exception.DataAccessException;
import com.property.model.AdApplication;
import com.property.util.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdApplicationDAO {

    public List<AdApplication> getAll() {
        List<AdApplication> list = new ArrayList<>();
        String sql = "SELECT aa.app_id, aa.ad_content, aa.expect_slot, aa.start_date, aa.end_date, " +
                     "aa.apply_date, aa.status, aa.slot_id, aa.company_id, " +
                     "eac.company_name, adsl.location, es.location as expect_slot_name " +
                     "FROM AdApplication aa " +
                     "LEFT JOIN ExternalAdCompany eac ON aa.company_id = eac.company_id " +
                     "LEFT JOIN AdSlot adsl ON aa.slot_id = adsl.slot_id " +
                     "LEFT JOIN AdSlot es ON aa.expect_slot = es.slot_id " +
                     "ORDER BY aa.apply_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告申请列表失败", e);
        }
        return list;
    }

    public List<AdApplication> getByCompanyId(String companyId) {
        List<AdApplication> list = new ArrayList<>();
        String sql = "SELECT aa.app_id, aa.ad_content, aa.expect_slot, aa.start_date, aa.end_date, " +
                     "aa.apply_date, aa.status, aa.slot_id, aa.company_id, " +
                     "eac.company_name, adsl.location, es.location as expect_slot_name " +
                     "FROM AdApplication aa " +
                     "LEFT JOIN ExternalAdCompany eac ON aa.company_id = eac.company_id " +
                     "LEFT JOIN AdSlot adsl ON aa.slot_id = adsl.slot_id " +
                     "LEFT JOIN AdSlot es ON aa.expect_slot = es.slot_id " +
                     "WHERE aa.company_id = ? ORDER BY aa.apply_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, companyId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告申请列表失败", e);
        }
        return list;
    }

    public AdApplication getById(String id) {
        String sql = "SELECT aa.app_id, aa.ad_content, aa.expect_slot, aa.start_date, aa.end_date, " +
                     "aa.apply_date, aa.status, aa.slot_id, aa.company_id, " +
                     "eac.company_name, adsl.location, es.location as expect_slot_name " +
                     "FROM AdApplication aa " +
                     "LEFT JOIN ExternalAdCompany eac ON aa.company_id = eac.company_id " +
                     "LEFT JOIN AdSlot adsl ON aa.slot_id = adsl.slot_id " +
                     "LEFT JOIN AdSlot es ON aa.expect_slot = es.slot_id " +
                     "WHERE aa.app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告申请失败", e);
        }
        return null;
    }

    public void add(AdApplication app) {
        String sql = "INSERT INTO AdApplication(app_id, ad_content, expect_slot, start_date, end_date, apply_date, status, company_id) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, app.getAppId());
            stmt.setString(2, app.getAdContent());
            stmt.setString(3, app.getExpectSlot());
            stmt.setDate(4, new Date(app.getStartDate().getTime()));
            stmt.setDate(5, new Date(app.getEndDate().getTime()));
            stmt.setTimestamp(6, app.getApplyDate() != null ? new java.sql.Timestamp(app.getApplyDate().getTime()) : null);
            stmt.setString(7, app.getStatus());
            stmt.setString(8, app.getCompanyId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("添加广告申请失败", e);
        }
    }

    public void update(AdApplication app) {
        String sql = "UPDATE AdApplication SET ad_content = ?, expect_slot = ?, start_date = ?, end_date = ?, status = ?, slot_id = ? WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, app.getAdContent());
            stmt.setString(2, app.getExpectSlot());
            stmt.setDate(3, new Date(app.getStartDate().getTime()));
            stmt.setDate(4, new Date(app.getEndDate().getTime()));
            stmt.setString(5, app.getStatus());
            stmt.setString(6, app.getSlotId());
            stmt.setString(7, app.getAppId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new DataAccessException("更新广告申请失败", e);
        }
    }

    public List<AdApplication> getBySlotId(String slotId) {
        List<AdApplication> list = new ArrayList<>();
        String sql = "SELECT aa.app_id, aa.ad_content, aa.expect_slot, aa.start_date, aa.end_date, " +
                     "aa.apply_date, aa.status, aa.slot_id, aa.company_id, " +
                     "eac.company_name, adsl.location, es.location as expect_slot_name " +
                     "FROM AdApplication aa " +
                     "LEFT JOIN ExternalAdCompany eac ON aa.company_id = eac.company_id " +
                     "LEFT JOIN AdSlot adsl ON aa.slot_id = adsl.slot_id " +
                     "LEFT JOIN AdSlot es ON aa.expect_slot = es.slot_id " +
                     "WHERE aa.slot_id = ? AND aa.status = N'已通过' ORDER BY aa.start_date";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询广告申请列表失败", e);
        }
        return list;
    }

    public boolean hasTimeConflict(String slotId, java.util.Date startDate, java.util.Date endDate, String excludeAppId) {
        String sql = "SELECT COUNT(*) FROM AdApplication WHERE slot_id = ? AND status = N'已通过' " +
                     "AND start_date < ? AND end_date > ?";
        if (excludeAppId != null && !excludeAppId.isEmpty()) {
            sql += " AND app_id <> ?";
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slotId);
            stmt.setDate(2, new Date(endDate.getTime()));
            stmt.setDate(3, new Date(startDate.getTime()));
            if (excludeAppId != null && !excludeAppId.isEmpty()) {
                stmt.setString(4, excludeAppId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("检查时间冲突失败", e);
        }
        return false;
    }

    private AdApplication mapRow(ResultSet rs) throws SQLException {
        AdApplication app = new AdApplication();
        app.setAppId(rs.getString("app_id"));
        app.setAdContent(rs.getString("ad_content"));
        app.setExpectSlot(rs.getString("expect_slot"));
        app.setStartDate(rs.getDate("start_date"));
        app.setEndDate(rs.getDate("end_date"));
        app.setApplyDate(rs.getTimestamp("apply_date"));
        app.setStatus(rs.getString("status"));
        app.setSlotId(rs.getString("slot_id"));
        app.setCompanyId(rs.getString("company_id"));
        app.setCompanyName(rs.getString("company_name"));
        app.setLocation(rs.getString("location"));
        app.setExpectSlotName(rs.getString("expect_slot_name"));
        return app;
    }
}
