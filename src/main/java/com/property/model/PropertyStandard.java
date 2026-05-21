package com.property.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 收费标准实体类
 */
public class PropertyStandard {
    private String standardId;
    private String feeType;          // 收费类型：物业费/绿化费/电梯费
    private BigDecimal unitPrice;   // 单价（元/平方米/月）
    private Date effectiveDate;     // 生效日期
    private String status;          // 生效/失效
    private Date createdAt;         // 创建时间

    public PropertyStandard() {
    }

    public PropertyStandard(String standardId, String feeType, BigDecimal unitPrice, 
                           Date effectiveDate, String status, Date createdAt) {
        this.standardId = standardId;
        this.feeType = feeType;
        this.unitPrice = unitPrice;
        this.effectiveDate = effectiveDate;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public String getStandardId() {
        return standardId;
    }

    public void setStandardId(String standardId) {
        this.standardId = standardId;
    }

    public String getFeeType() {
        return feeType;
    }

    public void setFeeType(String feeType) {
        this.feeType = feeType;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public Date getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}