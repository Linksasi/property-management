package com.property.entity;

public class ParkingSpace {
    private String spaceId;
    private String spaceNo;
    private String location;
    private String type;
    private String status;
    private String residentId;
    private String createdAt;
    private String residentName;
    private String housingAddress;
    private String residentPhone;
    private String feeStatus;

    public ParkingSpace() {}

    public String getSpaceId() { return spaceId; }
    public void setSpaceId(String spaceId) { this.spaceId = spaceId; }
    public String getSpaceNo() { return spaceNo; }
    public void setSpaceNo(String spaceNo) { this.spaceNo = spaceNo; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getResidentId() { return residentId; }
    public void setResidentId(String residentId) { this.residentId = residentId; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    public String getResidentName() { return residentName; }
    public void setResidentName(String residentName) { this.residentName = residentName; }
    public String getResidentPhone() { return residentPhone; }
    public void setResidentPhone(String residentPhone) { this.residentPhone = residentPhone; }
    public String getHousingAddress() { return housingAddress; }
    public void setHousingAddress(String housingAddress) { this.housingAddress = housingAddress; }
    public String getFeeStatus() { return feeStatus; }
    public void setFeeStatus(String feeStatus) { this.feeStatus = feeStatus; }
}