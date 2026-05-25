package com.property.dao;

import com.property.entity.WaterMeter;
import com.property.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 水表数据访问层
 */
public class WaterMeterDAO {

    /**
     * 查询所有水表（关联住房信息）
     */
    public List<WaterMeter> findAll() {
        List<WaterMeter> list = new ArrayList<>();
        String sql = "SELECT w.meter_id, w.housing_id, w.install_date, w.initial_read, " +
                     "w.current_read, w.last_read, w.last_read_date, w.update_date, w.status, " +
                     "h.building, h.unit, h.room_no " +
                     "FROM WaterMeter w " +
                     "LEFT JOIN Housing h ON w.housing_id = h.housing_id " +
                     "ORDER BY w.meter_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                WaterMeter meter = mapResultSet(rs);
                meter.setBuilding(rs.getString("building"));
                meter.setUnit(rs.getString("unit"));
                meter.setRoomNo(rs.getString("room_no"));
                list.add(meter);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 根据ID查询水表
     */
    public WaterMeter findById(String meterId) {
        String sql = "SELECT w.meter_id, w.housing_id, w.install_date, w.initial_read, " +
                     "w.current_read, w.last_read, w.last_read_date, w.update_date, w.status, " +
                     "h.building, h.unit, h.room_no " +
                     "FROM WaterMeter w " +
                     "LEFT JOIN Housing h ON w.housing_id = h.housing_id " +
                     "WHERE w.meter_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, meterId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    WaterMeter meter = mapResultSet(rs);
                    meter.setBuilding(rs.getString("building"));
                    meter.setUnit(rs.getString("unit"));
                    meter.setRoomNo(rs.getString("room_no"));
                    return meter;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据住房ID查询水表
     */
    public List<WaterMeter> findByHousingId(String housingId) {
        List<WaterMeter> list = new ArrayList<>();
        String sql = "SELECT w.meter_id, w.housing_id, w.install_date, w.initial_read, " +
                     "w.current_read, w.last_read, w.last_read_date, w.update_date, w.status, " +
                     "h.building, h.unit, h.room_no " +
                     "FROM WaterMeter w " +
                     "LEFT JOIN Housing h ON w.housing_id = h.housing_id " +
                     "WHERE w.housing_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, housingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WaterMeter meter = mapResultSet(rs);
                    meter.setBuilding(rs.getString("building"));
                    meter.setUnit(rs.getString("unit"));
                    meter.setRoomNo(rs.getString("room_no"));
                    list.add(meter);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 新增水表
     */
    public boolean insert(WaterMeter meter) {
        // 如果没有指定ID，自动生成
        if (meter.getMeterId() == null || meter.getMeterId().isEmpty()) {
            meter.setMeterId(generateNextId());
        }

        String sql = "INSERT INTO WaterMeter (meter_id, housing_id, install_date, initial_read, " +
                     "current_read, last_read, last_read_date, update_date, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, meter.getMeterId());
            ps.setString(2, meter.getHousingId());
            ps.setDate(3, meter.getInstallDate() != null ? Date.valueOf(meter.getInstallDate()) : null);
            ps.setBigDecimal(4, meter.getInitialRead());
            ps.setBigDecimal(5, meter.getCurrentRead());
            ps.setBigDecimal(6, meter.getLastRead());
            ps.setDate(7, meter.getLastReadDate() != null ? Date.valueOf(meter.getLastReadDate()) : null);
            ps.setDate(8, meter.getUpdateDate() != null ? Date.valueOf(meter.getUpdateDate()) : null);
            ps.setString(9, meter.getStatus() != null ? meter.getStatus() : "正常");

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新水表
     */
    public boolean update(WaterMeter meter) {
        String sql = "UPDATE WaterMeter SET housing_id = ?, install_date = ?, initial_read = ?, " +
                     "current_read = ?, last_read = ?, last_read_date = ?, update_date = ?, status = ? " +
                     "WHERE meter_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, meter.getHousingId());
            ps.setDate(2, meter.getInstallDate() != null ? Date.valueOf(meter.getInstallDate()) : null);
            ps.setBigDecimal(3, meter.getInitialRead());
            ps.setBigDecimal(4, meter.getCurrentRead());
            ps.setBigDecimal(5, meter.getLastRead());
            ps.setDate(6, meter.getLastReadDate() != null ? Date.valueOf(meter.getLastReadDate()) : null);
            ps.setDate(7, meter.getUpdateDate() != null ? Date.valueOf(meter.getUpdateDate()) : null);
            ps.setString(8, meter.getStatus());
            ps.setString(9, meter.getMeterId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除水表
     */
    public boolean delete(String meterId) {
        String sql = "DELETE FROM WaterMeter WHERE meter_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, meterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 生成下一个水表ID（格式 MTR001）
     */
    public String generateNextId() {
        String sql = "SELECT TOP 1 meter_id FROM WaterMeter ORDER BY meter_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String lastId = rs.getString("meter_id");
                int num = Integer.parseInt(lastId.substring(3));
                return "MTR" + String.format("%03d", num + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "MTR001";
    }

    private WaterMeter mapResultSet(ResultSet rs) throws SQLException {
        WaterMeter meter = new WaterMeter();
        meter.setMeterId(rs.getString("meter_id"));
        meter.setHousingId(rs.getString("housing_id"));
        Date installDate = rs.getDate("install_date");
        meter.setInstallDate(installDate != null ? installDate.toLocalDate() : null);
        meter.setInitialRead(rs.getBigDecimal("initial_read"));
        meter.setCurrentRead(rs.getBigDecimal("current_read"));
        meter.setLastRead(rs.getBigDecimal("last_read"));
        Date lastReadDate = rs.getDate("last_read_date");
        meter.setLastReadDate(lastReadDate != null ? lastReadDate.toLocalDate() : null);
        Date updateDate = rs.getDate("update_date");
        meter.setUpdateDate(updateDate != null ? updateDate.toLocalDate() : null);
        meter.setStatus(rs.getString("status"));
        return meter;
    }
}
