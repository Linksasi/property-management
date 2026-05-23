package com.property.entity;

public class ParkingFeeRecord {
    private String recordId;
    private String spaceId;
    private String residentId;
    private String startDate;
    private String endDate;
    private double amount;
    private double paidAmount;
    private String status;
    private String dueDate;
    private String createDate;
    private String paidDate;
    private String payMethod;
    private String transactionNo;
    private String spaceNo;
    private String month;

    public ParkingFeeRecord() {}

    public String getRecordId() { return recordId; }
    public void setRecordId(String recordId) { this.recordId = recordId; }
    public String getSpaceId() { return spaceId; }
    public void setSpaceId(String spaceId) { this.spaceId = spaceId; }
    public String getResidentId() { return residentId; }
    public void setResidentId(String residentId) { this.residentId = residentId; }
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public double getPaidAmount() { return paidAmount; }
    public void setPaidAmount(double paidAmount) { this.paidAmount = paidAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDueDate() { return dueDate; }
    public void setDueDate(String dueDate) { this.dueDate = dueDate; }
    public String getCreateDate() { return createDate; }
    public void setCreateDate(String createDate) { this.createDate = createDate; }
    public String getPaidDate() { return paidDate; }
    public void setPaidDate(String paidDate) { this.paidDate = paidDate; }
    public String getPayMethod() { return payMethod; }
    public void setPayMethod(String payMethod) { this.payMethod = payMethod; }
    public String getTransactionNo() { return transactionNo; }
    public void setTransactionNo(String transactionNo) { this.transactionNo = transactionNo; }
    public String getSpaceNo() { return spaceNo; }
    public void setSpaceNo(String spaceNo) { this.spaceNo = spaceNo; }
    public String getMonth() { return month; }
    public void setMonth(String month) { this.month = month; }
}