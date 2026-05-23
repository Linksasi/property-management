package com.property.entity;

public class RepairRequest {
    private String requestId;
    private String userId;
    private String housingId;
    private String repairType;
    private String description;
    private String urgency;
    private String applyTime;
    private String status;
    private String rejectReason;
    private String adminId;
    private String residentName;
    private String housingAddress;
    private String residentPhone;
    private String adminName;
    private String adminPhone;
    private MaintenanceWorkOrder workOrder;

    public RepairRequest() {}

    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getHousingId() { return housingId; }
    public void setHousingId(String housingId) { this.housingId = housingId; }
    public String getRepairType() { return repairType; }
    public void setRepairType(String repairType) { this.repairType = repairType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }
    public String getApplyTime() { return applyTime; }
    public void setApplyTime(String applyTime) { this.applyTime = applyTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }
    public String getAdminId() { return adminId; }
    public void setAdminId(String adminId) { this.adminId = adminId; }
    public String getResidentName() { return residentName; }
    public void setResidentName(String residentName) { this.residentName = residentName; }
    public String getHousingAddress() { return housingAddress; }
    public void setHousingAddress(String housingAddress) { this.housingAddress = housingAddress; }
    public String getResidentPhone() { return residentPhone; }
    public void setResidentPhone(String residentPhone) { this.residentPhone = residentPhone; }
    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }
    public String getAdminPhone() { return adminPhone; }
    public void setAdminPhone(String adminPhone) { this.adminPhone = adminPhone; }
    public MaintenanceWorkOrder getWorkOrder() { return workOrder; }
    public void setWorkOrder(MaintenanceWorkOrder workOrder) { this.workOrder = workOrder; }
}