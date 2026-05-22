package com.property.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 物业费明细实体类
 */
public class PropertyFeeDetail {
    private String detailId;       // 明细ID（主键）
    private String batchId;         // 批次ID
    private String housingId;       // 住房ID
    private String residentId;      // 住户ID
    private String standardId;      // 收费标准ID
    private BigDecimal area;        // 收费面积
    private BigDecimal amount;      // 应缴金额
    private BigDecimal paidAmount;  // 实缴金额
    private String status;          // 未缴/已缴/申诉中/逾期
    private Date dueDate;           // 截止日期
    private Date createDate;        // 创建时间
    private Date paidDate;          // 缴费时间

    // 扩展字段（用于联表查询显示）
    private String housingAddress;  // 住房地址（楼栋+单元+房号）
    private String residentName;    // 住户姓名
    private String billMonth;       // 计费月份
    private String standardType;    // 收费类型（物业费/绿化费/电梯费）

    public PropertyFeeDetail() {
    }

    public PropertyFeeDetail(String detailId, String batchId, String housingId, 
                            String residentId, String standardId, BigDecimal area,
                            BigDecimal amount, BigDecimal paidAmount, String status,
                            Date dueDate, Date createDate, Date paidDate) {
        this.detailId = detailId;
        this.batchId = batchId;
        this.housingId = housingId;
        this.residentId = residentId;
        this.standardId = standardId;
        this.area = area;
        this.amount = amount;
        this.paidAmount = paidAmount;
        this.status = status;
        this.dueDate = dueDate;
        this.createDate = createDate;
        this.paidDate = paidDate;
    }

    // Getters and Setters
    public String getDetailId() {
        return detailId;
    }

    public void setDetailId(String detailId) {
        this.detailId = detailId;
    }

    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId;
    }

    public String getHousingId() {
        return housingId;
    }

    public void setHousingId(String housingId) {
        this.housingId = housingId;
    }

    public String getResidentId() {
        return residentId;
    }

    public void setResidentId(String residentId) {
        this.residentId = residentId;
    }

    public String getStandardId() {
        return standardId;
    }

    public void setStandardId(String standardId) {
        this.standardId = standardId;
    }

    public BigDecimal getArea() {
        return area;
    }

    public void setArea(BigDecimal area) {
        this.area = area;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public BigDecimal getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getPaidDate() {
        return paidDate;
    }

    public void setPaidDate(Date paidDate) {
        this.paidDate = paidDate;
    }

    public String getHousingAddress() {
        return housingAddress;
    }

    public void setHousingAddress(String housingAddress) {
        this.housingAddress = housingAddress;
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
    
    public String getStandardType() {
        return standardType;
    }
    
    public void setStandardType(String standardType) {
        this.standardType = standardType;
    }
}