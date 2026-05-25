package com.property.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 水费计费规则实体类
 */
public class WaterBillingRule {
    private String ruleId;              // 规则ID
    private String ruleName;            // 规则名称
    private BigDecimal basePrice;       // 基础单价（元/吨）
    private BigDecimal pressurePrice;   // 加压单价（高楼层）
    private Integer pressureFloor;      // 加压起始楼层
    private BigDecimal tier1Threshold;  // 第一阶梯阈值
    private BigDecimal tier1Multiplier; // 第一阶梯倍率
    private BigDecimal tier2Threshold;  // 第二阶梯阈值
    private BigDecimal tier2Multiplier; // 第二阶梯倍率
    private LocalDate effectiveDate;    // 生效日期
    private String status;              // 生效/失效

    public WaterBillingRule() {}

    public String getRuleId() { return ruleId; }
    public void setRuleId(String ruleId) { this.ruleId = ruleId; }

    public String getRuleName() { return ruleName; }
    public void setRuleName(String ruleName) { this.ruleName = ruleName; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public BigDecimal getPressurePrice() { return pressurePrice; }
    public void setPressurePrice(BigDecimal pressurePrice) { this.pressurePrice = pressurePrice; }

    public Integer getPressureFloor() { return pressureFloor; }
    public void setPressureFloor(Integer pressureFloor) { this.pressureFloor = pressureFloor; }

    public BigDecimal getTier1Threshold() { return tier1Threshold; }
    public void setTier1Threshold(BigDecimal tier1Threshold) { this.tier1Threshold = tier1Threshold; }

    public BigDecimal getTier1Multiplier() { return tier1Multiplier; }
    public void setTier1Multiplier(BigDecimal tier1Multiplier) { this.tier1Multiplier = tier1Multiplier; }

    public BigDecimal getTier2Threshold() { return tier2Threshold; }
    public void setTier2Threshold(BigDecimal tier2Threshold) { this.tier2Threshold = tier2Threshold; }

    public BigDecimal getTier2Multiplier() { return tier2Multiplier; }
    public void setTier2Multiplier(BigDecimal tier2Multiplier) { this.tier2Multiplier = tier2Multiplier; }

    public LocalDate getEffectiveDate() { return effectiveDate; }
    public void setEffectiveDate(LocalDate effectiveDate) { this.effectiveDate = effectiveDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
