package com.property.entity;

public class ParkingStandard {
    private String standardId;
    private String parkingType;
    private double price;
    private String effectiveDate;
    private String status;

    public ParkingStandard() {}

    public String getStandardId() { return standardId; }
    public void setStandardId(String standardId) { this.standardId = standardId; }
    public String getParkingType() { return parkingType; }
    public void setParkingType(String parkingType) { this.parkingType = parkingType; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getEffectiveDate() { return effectiveDate; }
    public void setEffectiveDate(String effectiveDate) { this.effectiveDate = effectiveDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}