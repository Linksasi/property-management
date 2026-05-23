package com.property.entity;

public class MaintenanceWorkOrder {
    private String workOrderId;
    private String requestId;
    private String staffId;
    private String adminId;
    private String assignTime;
    private String receiveTime;
    private String startTime;
    private String completeTime;
    private String confirmTime;
    private String repairContent;
    private String materialsUsed;
    private double workHours;
    private String status;
    private int rating;
    private String comment;
    private String staffName;
    private String adminName;

    public MaintenanceWorkOrder() {}

    public String getWorkOrderId() { return workOrderId; }
    public void setWorkOrderId(String workOrderId) { this.workOrderId = workOrderId; }
    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }
    public String getStaffId() { return staffId; }
    public void setStaffId(String staffId) { this.staffId = staffId; }
    public String getAdminId() { return adminId; }
    public void setAdminId(String adminId) { this.adminId = adminId; }
    public String getAssignTime() { return assignTime; }
    public void setAssignTime(String assignTime) { this.assignTime = assignTime; }
    public String getReceiveTime() { return receiveTime; }
    public void setReceiveTime(String receiveTime) { this.receiveTime = receiveTime; }
    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }
    public String getCompleteTime() { return completeTime; }
    public void setCompleteTime(String completeTime) { this.completeTime = completeTime; }
    public String getConfirmTime() { return confirmTime; }
    public void setConfirmTime(String confirmTime) { this.confirmTime = confirmTime; }
    public String getRepairContent() { return repairContent; }
    public void setRepairContent(String repairContent) { this.repairContent = repairContent; }
    public String getMaterialsUsed() { return materialsUsed; }
    public void setMaterialsUsed(String materialsUsed) { this.materialsUsed = materialsUsed; }
    public double getWorkHours() { return workHours; }
    public void setWorkHours(double workHours) { this.workHours = workHours; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }
    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }
}