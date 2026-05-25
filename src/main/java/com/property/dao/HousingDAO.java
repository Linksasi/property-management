package com.property.dao;

import com.property.entity.Housing;
import com.property.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 住房数据访问层
 */
public class HousingDAO {

    /**
     * 查询所有住房
     */
    public List<Housing> findAll() {
        List<Housing> list = new ArrayList<>();
        String sql = "SELECT housing_id, building, unit, room_no, area, floor, house_type FROM Housing ORDER BY building, unit, room_no";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Housing h = mapResultSet(rs);
                list.add(h);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 根据ID查询住房
     */
    public Housing findById(String housingId) {
        String sql = "SELECT housing_id, building, unit, room_no, area, floor, house_type FROM Housing WHERE housing_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, housingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 新增住房（如果 housingId 为空则自动生成）
     * 插入后回填 housingId
     */
    public boolean insert(Housing housing) {
        // 如果没有指定ID，自动生成
        if (housing.getHousingId() == null || housing.getHousingId().isEmpty()) {
            housing.setHousingId(generateNextId());
        }

        String sql = "INSERT INTO Housing (housing_id, building, unit, room_no, area, floor, house_type) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, housing.getHousingId());
            ps.setString(2, housing.getBuilding());
            ps.setString(3, housing.getUnit());
            ps.setString(4, housing.getRoomNo());
            ps.setDouble(5, housing.getArea());
            ps.setInt(6, housing.getFloor());
            ps.setString(7, housing.getHouseType());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新住房
     */
    public boolean update(Housing housing) {
        String sql = "UPDATE Housing SET building = ?, unit = ?, room_no = ?, area = ?, floor = ?, house_type = ? WHERE housing_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, housing.getBuilding());
            ps.setString(2, housing.getUnit());
            ps.setString(3, housing.getRoomNo());
            ps.setDouble(4, housing.getArea());
            ps.setInt(5, housing.getFloor());
            ps.setString(6, housing.getHouseType());
            ps.setString(7, housing.getHousingId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除住房
     */
    public boolean delete(String housingId) {
        String sql = "DELETE FROM Housing WHERE housing_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, housingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 生成下一个住房ID
     */
    public String generateNextId() {
        String sql = "SELECT TOP 1 housing_id FROM Housing ORDER BY housing_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String lastId = rs.getString("housing_id");
                // 假设格式为 H + 数字，如 H001
                int num = Integer.parseInt(lastId.substring(1));
                return "H" + String.format("%03d", num + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "H001";
    }

    /**
     * 根据楼栋筛选
     */
    public List<Housing> findByBuilding(String building) {
        List<Housing> list = new ArrayList<>();
        String sql = "SELECT housing_id, building, unit, room_no, area, floor, house_type FROM Housing WHERE building = ? ORDER BY unit, room_no";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, building);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取所有楼栋列表
     */
    public List<String> findAllBuildings() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT building FROM Housing ORDER BY building";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("building"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 根据楼栋+单元+房号查找住房
     */
    public Housing findByAddress(String building, String unit, String roomNo) {
        String sql = "SELECT housing_id, building, unit, room_no, area, floor, house_type " +
                     "FROM Housing WHERE building = ? AND unit = ? AND room_no = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, building);
            ps.setString(2, unit);
            ps.setString(3, roomNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据住户ID查询关联的住房列表
     * 关联 ResidentHousing 表查询
     */
    public List<Housing> findByResidentId(String residentId) {
        List<Housing> list = new ArrayList<>();
        String sql = "SELECT h.housing_id, h.building, h.unit, h.room_no, h.area, h.floor, h.house_type " +
                     "FROM Housing h " +
                     "INNER JOIN ResidentHousing rh ON h.housing_id = rh.housing_id " +
                     "WHERE rh.resident_id = ? AND rh.end_date IS NULL " +
                     "ORDER BY h.building, h.unit, h.room_no";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Housing mapResultSet(ResultSet rs) throws SQLException {
        Housing h = new Housing();
        h.setHousingId(rs.getString("housing_id"));
        h.setBuilding(rs.getString("building"));
        h.setUnit(rs.getString("unit"));
        h.setRoomNo(rs.getString("room_no"));
        h.setArea(rs.getDouble("area"));
        h.setFloor(rs.getInt("floor"));
        h.setHouseType(rs.getString("house_type"));
        return h;
    }
}
