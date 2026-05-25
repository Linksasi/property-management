package com.property.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalDate;

/**
 * 水费账单实体类
 */
public class WaterFeeBill {
    private String billId;              // 账单ID
    private String meterId;             // 水表ID
    private String residentId;          // 住户ID
    private String billMonth;           // 计费月份（YYYY-MM）
    private BigDecimal lastRead;        // 上次读数
    private BigDecimal currentRead;     // 本次读数
    private BigDecimal usage;           // 用水量（吨）
    private BigDecimal unitPrice;       // 单价
    private BigDecimal amount;          // 应缴金额
    private BigDecimal paidAmount;      // 实缴金额
    private String status;              // 未缴/已缴/逾期
    private LocalDate dueDate;          // 截止日期
    private LocalDateTime createDate;   // 创建时间
    private LocalDateTime paidDate;     // 缴费时间

    // 关联信息（用于显示）
    private String housingAddress;       // 住房地址
    private String residentName;        // 住户姓名
    private String meterNo;             // 水表编号

    public WaterFeeBill() {}

    public String getBillId() { return billId; }
    public void setBillId(String billId) { this.billId = billId; }

    public String getMeterId() { return meterId; }
    public void setMeterId(String meterId) { this.meterId = meterId; }

    public String getResidentId() { return residentId; }
    public void setResidentId(String residentId) { this.residentId = residentId; }

    public String getBillMonth() { return billMonth; }
    public void setBillMonth(String billMonth) { this.billMonth = billMonth; }

    public BigDecimal getLastRead() { return lastRead; }
    public void setLastRead(BigDecimal lastRead) { this.lastRead = lastRead; }

    public BigDecimal getCurrentRead() { return currentRead; }
    public void setCurrentRead(BigDecimal currentRead) { this.currentRead = currentRead; }

    public BigDecimal getUsage() { return usage; }
    public void setUsage(BigDecimal usage) { this.usage = usage; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public BigDecimal getPaidAmount() { return paidAmount; }
    public void setPaidAmount(BigDecimal paidAmount) { this.paidAmount = paidAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDate getDueDate() { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }

    public LocalDateTime getCreateDate() { return createDate; }
    public void setCreateDate(LocalDateTime createDate) { this.createDate = createDate; }

    public LocalDateTime getPaidDate() { return paidDate; }
    public void setPaidDate(LocalDateTime paidDate) { this.paidDate = paidDate; }

    public String getHousingAddress() { return housingAddress; }
    public void setHousingAddress(String housingAddress) { this.housingAddress = housingAddress; }

    public String getResidentName() { return residentName; }
    public void setResidentName(String residentName) { this.residentName = residentName; }

    public String getMeterNo() { return meterNo; }
    public void setMeterNo(String meterNo) { this.meterNo = meterNo; }
}
