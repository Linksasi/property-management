package com.property.entity;

public class ResidentHousing {
    private String residentId;
    private String housingId;
    private String startDate;
    private String endDate;
    private boolean isOwner;

    public ResidentHousing() {}

    public String getResidentId() { return residentId; }
    public void setResidentId(String residentId) { this.residentId = residentId; }
    public String getHousingId() { return housingId; }
    public void setHousingId(String housingId) { this.housingId = housingId; }
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
    public boolean isOwner() { return isOwner; }
    public void setOwner(boolean owner) { isOwner = owner; }
}