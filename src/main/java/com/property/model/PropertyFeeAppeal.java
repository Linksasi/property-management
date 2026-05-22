package com.property.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 物业费申诉实体类
 */
public class PropertyFeeAppeal {
    private String appealId;           // 申诉ID（主键）
    private String detailId;           // 物业费明细ID
    private String residentId;          // 住户ID
    private String reason;             // 申诉原因
    private String status;             // 待审核/通过/驳回
    private String adminId;            // 审核人
    private String adminReason;        // 审核意见
    private Date createTime;           // 申诉时间
    private Date handleTime;           // 处理时间

    // 扩展字段
    private String residentName;       // 住户姓名
    private String billMonth;          // 计费月份
    private BigDecimal amount;        // 账单金额
    private String housingAddress;    // 住房地址
    private String standardType;     // 收费类型

    public PropertyFeeAppeal() {
    }

    public PropertyFeeAppeal(String appealId, String detailId, String residentId,
                            String reason, String status, String adminId,
                            String adminReason, Date createTime, Date handleTime) {
        this.appealId = appealId;
        this.detailId = detailId;
        this.residentId = residentId;
        this.reason = reason;
        this.status = status;
        this.adminId = adminId;
        this.adminReason = adminReason;
        this.createTime = createTime;
        this.handleTime = handleTime;
    }

    // Getters and Setters
    public String getAppealId() {
        return appealId;
    }

    public void setAppealId(String appealId) {
        this.appealId = appealId;
    }

    public String getDetailId() {
        return detailId;
    }

    public void setDetailId(String detailId) {
        this.detailId = detailId;
    }

    public String getResidentId() {
        return residentId;
    }

    public void setResidentId(String residentId) {
        this.residentId = residentId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getAdminReason() {
        return adminReason;
    }

    public void setAdminReason(String adminReason) {
        this.adminReason = adminReason;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getHandleTime() {
        return handleTime;
    }

    public void setHandleTime(Date handleTime) {
        this.handleTime = handleTime;
    }

    public String getResidentName() {
        return residentName;
    }

    public void setResidentName(String residentName) {
        this.residentName = residentName;
    }

    public String getBillMonth() {
        return billMonth;
    }

    public void setBillMonth(String billMonth) {
        this.billMonth = billMonth;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getHousingAddress() {
        return housingAddress;
    }

    public void setHousingAddress(String housingAddress) {
        this.housingAddress = housingAddress;
    }
    
    public String getStandardType() {
        return standardType;
    }
    
    public void setStandardType(String standardType) {
        this.standardType = standardType;
    }
}