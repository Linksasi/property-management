package com.property.entity;

public class ParkingApply {
    private String applyId;
    private String spaceId;
    private String residentId;
    private String applyTime;
    private String status;
    private String adminId;
    private String auditTime;
    private String rejectReason;
    private String spaceNo;
    private String residentName;
    private int months;

    public ParkingApply() {}

    public String getApplyId() { return applyId; }
    public void setApplyId(String applyId) { this.applyId = applyId; }
    public String getSpaceId() { return spaceId; }
    public void setSpaceId(String spaceId) { this.spaceId = spaceId; }
    public String getResidentId() { return residentId; }
    public void setResidentId(String residentId) { this.residentId = residentId; }
    public String getApplyTime() { return applyTime; }
    public void setApplyTime(String applyTime) { this.applyTime = applyTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAdminId() { return adminId; }
    public void setAdminId(String adminId) { this.adminId = adminId; }
    public String getAuditTime() { return auditTime; }
    public void setAuditTime(String auditTime) { this.auditTime = auditTime; }
    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }
    public String getSpaceNo() { return spaceNo; }
    public void setSpaceNo(String spaceNo) { this.spaceNo = spaceNo; }
    public String getResidentName() { return residentName; }
    public void setResidentName(String residentName) { this.residentName = residentName; }
    public int getMonths() { return months; }
    public void setMonths(int months) { this.months = months; }
}