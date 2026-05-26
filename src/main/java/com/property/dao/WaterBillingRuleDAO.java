package com.property.dao;

import com.property.entity.WaterBillingRule;
import com.property.exception.DataAccessException;
import com.property.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 水费计费规则数据访问层
 */
public class WaterBillingRuleDAO {

    public List<WaterBillingRule> findAll() {
        List<WaterBillingRule> list = new ArrayList<>();
        String sql = "SELECT rule_id, rule_name, base_price, pressure_price, pressure_floor, " +
                     "tier1_threshold, tier1_multiplier, tier2_threshold, tier2_multiplier, " +
                     "effective_date, status FROM WaterBillingRule ORDER BY rule_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                WaterBillingRule rule = mapResultSet(rs);
                list.add(rule);
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询计费规则列表失败", e);
        }
        return list;
    }

    public WaterBillingRule findById(String ruleId) {
        String sql = "SELECT rule_id, rule_name, base_price, pressure_price, pressure_floor, " +
                     "tier1_threshold, tier1_multiplier, tier2_threshold, tier2_multiplier, " +
                     "effective_date, status FROM WaterBillingRule WHERE rule_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ruleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("查询计费规则失败", e);
        }
        return null;
    }

    public boolean insert(WaterBillingRule rule) {
        if (rule.getRuleId() == null || rule.getRuleId().isEmpty()) {
            rule.setRuleId(generateNextId());
        }

        String sql = "INSERT INTO WaterBillingRule (rule_id, rule_name, base_price, pressure_price, " +
                     "pressure_floor, tier1_threshold, tier1_multiplier, tier2_threshold, " +
                     "tier2_multiplier, effective_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, rule.getRuleId());
            ps.setString(2, rule.getRuleName());
            ps.setBigDecimal(3, rule.getBasePrice());
            ps.setBigDecimal(4, rule.getPressurePrice());
            ps.setInt(5, rule.getPressureFloor());
            ps.setBigDecimal(6, rule.getTier1Threshold());
            ps.setBigDecimal(7, rule.getTier1Multiplier());
            ps.setBigDecimal(8, rule.getTier2Threshold());
            ps.setBigDecimal(9, rule.getTier2Multiplier());
            ps.setDate(10, rule.getEffectiveDate() != null ? Date.valueOf(rule.getEffectiveDate()) : null);
            ps.setString(11, rule.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("插入计费规则失败", e);
        }
    }

    public boolean update(WaterBillingRule rule) {
        String sql = "UPDATE WaterBillingRule SET rule_name = ?, base_price = ?, pressure_price = ?, " +
                     "pressure_floor = ?, tier1_threshold = ?, tier1_multiplier = ?, tier2_threshold = ?, " +
                     "tier2_multiplier = ?, effective_date = ?, status = ? WHERE rule_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, rule.getRuleName());
            ps.setBigDecimal(2, rule.getBasePrice());
            ps.setBigDecimal(3, rule.getPressurePrice());
            ps.setInt(4, rule.getPressureFloor());
            ps.setBigDecimal(5, rule.getTier1Threshold());
            ps.setBigDecimal(6, rule.getTier1Multiplier());
            ps.setBigDecimal(7, rule.getTier2Threshold());
            ps.setBigDecimal(8, rule.getTier2Multiplier());
            ps.setDate(9, rule.getEffectiveDate() != null ? Date.valueOf(rule.getEffectiveDate()) : null);
            ps.setString(10, rule.getStatus());
            ps.setString(11, rule.getRuleId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("更新计费规则失败", e);
        }
    }

    public boolean delete(String ruleId) {
        String sql = "DELETE FROM WaterBillingRule WHERE rule_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ruleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("删除计费规则失败", e);
        }
    }

    public boolean toggleStatus(String ruleId) {
        String sql = "UPDATE WaterBillingRule SET status = CASE WHEN status = '生效' THEN '失效' ELSE '生效' END WHERE rule_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ruleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DataAccessException("切换计费规则状态失败", e);
        }
    }

    public String generateNextId() {
        String sql = "SELECT TOP 1 rule_id FROM WaterBillingRule ORDER BY rule_id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String lastId = rs.getString("rule_id");
                int num = Integer.parseInt(lastId.substring(3));
                return "RUL" + String.format("%03d", num + 1);
            }
        } catch (SQLException e) {
            throw new DataAccessException("生成计费规则ID失败", e);
        }
        return "RUL001";
    }

    private WaterBillingRule mapResultSet(ResultSet rs) throws SQLException {
        WaterBillingRule rule = new WaterBillingRule();
        rule.setRuleId(rs.getString("rule_id"));
        rule.setRuleName(rs.getString("rule_name"));
        rule.setBasePrice(rs.getBigDecimal("base_price"));
        rule.setPressurePrice(rs.getBigDecimal("pressure_price"));
        rule.setPressureFloor(rs.getInt("pressure_floor"));
        rule.setTier1Threshold(rs.getBigDecimal("tier1_threshold"));
        rule.setTier1Multiplier(rs.getBigDecimal("tier1_multiplier"));
        rule.setTier2Threshold(rs.getBigDecimal("tier2_threshold"));
        rule.setTier2Multiplier(rs.getBigDecimal("tier2_multiplier"));
        Date effectiveDate = rs.getDate("effective_date");
        rule.setEffectiveDate(effectiveDate != null ? effectiveDate.toLocalDate() : null);
        rule.setStatus(rs.getString("status"));
        return rule;
    }
}
