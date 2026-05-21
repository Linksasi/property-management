package com.property.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 电子凭证实体类
 */
public class ElectronicVoucher {
    private String voucherId;          // 凭证ID（主键）
    private String orderId;            // 订单ID
    private String residentId;         // 住户ID
    private String housingId;          // 住房ID
    private BigDecimal amount;        // 缴费金额
    private Date paymentDate;          // 缴费时间
    private String transactionNo;      // 交易流水号
    private Date createTime;           // 创建时间

    // 扩展字段
    private String residentName;       // 住户姓名
    private String housingAddress;     // 住房地址

    public ElectronicVoucher() {
    }

    public ElectronicVoucher(String voucherId, String orderId, String residentId,
                              String housingId, BigDecimal amount, Date paymentDate,
                              String transactionNo, Date createTime) {
        this.voucherId = voucherId;
        this.orderId = orderId;
        this.residentId = residentId;
        this.housingId = housingId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.transactionNo = transactionNo;
        this.createTime = createTime;
    }

    // Getters and Setters
    public String getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(String voucherId) {
        this.voucherId = voucherId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getResidentId() {
        return residentId;
    }

    public void setResidentId(String residentId) {
        this.residentId = residentId;
    }

    public String getHousingId() {
        return housingId;
    }

    public void setHousingId(String housingId) {
        this.housingId = housingId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getTransactionNo() {
        return transactionNo;
    }

    public void setTransactionNo(String transactionNo) {
        this.transactionNo = transactionNo;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getResidentName() {
        return residentName;
    }

    public void setResidentName(String residentName) {
        this.residentName = residentName;
    }

    public String getHousingAddress() {
        return housingAddress;
    }

    public void setHousingAddress(String housingAddress) {
        this.housingAddress = housingAddress;
    }
}