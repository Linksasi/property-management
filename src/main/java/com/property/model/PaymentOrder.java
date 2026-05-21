package com.property.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 支付订单实体类
 */
public class PaymentOrder {
    private String orderId;            // 订单ID（主键）
    private String detailId;            // 物业费明细ID
    private String orderNo;             // 订单号
    private BigDecimal amount;         // 支付金额
    private String paymentMethod;       // 支付方式（微信/支付宝）
    private String status;              // 待支付/已支付/已取消
    private Date createTime;            // 创建时间
    private Date payTime;               // 支付时间

    // 扩展字段
    private String residentName;        // 住户姓名
    private String billMonth;           // 计费月份

    public PaymentOrder() {
    }

    public PaymentOrder(String orderId, String detailId, String orderNo, 
                       BigDecimal amount, String paymentMethod, String status,
                       Date createTime, Date payTime) {
        this.orderId = orderId;
        this.detailId = detailId;
        this.orderNo = orderNo;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.createTime = createTime;
        this.payTime = payTime;
    }

    // Getters and Setters
    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getDetailId() {
        return detailId;
    }

    public void setDetailId(String detailId) {
        this.detailId = detailId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getPayTime() {
        return payTime;
    }

    public void setPayTime(Date payTime) {
        this.payTime = payTime;
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
}