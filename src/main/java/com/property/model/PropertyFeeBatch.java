package com.property.model;

import java.util.Date;

/**
 * 物业费批次实体类
 */
public class PropertyFeeBatch {
    private String batchId;
    private String billMonth;
    private Date createTime;
    private String adminId;

    public PropertyFeeBatch() {
    }

    public PropertyFeeBatch(String batchId, String billMonth, Date createTime, String adminId) {
        this.batchId = batchId;
        this.billMonth = billMonth;
        this.createTime = createTime;
        this.adminId = adminId;
    }

    // Getters and Setters
    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId;
    }

    public String getBillMonth() {
        return billMonth;
    }

    public void setBillMonth(String billMonth) {
        this.billMonth = billMonth;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }
}