package com.property.entity;

public class Housing {
    private String housingId;
    private String building;
    private String unit;
    private String roomNo;
    private double area;
    private int floor;
    private String houseType;

    public Housing() {}

    public String getHousingId() { return housingId; }
    public void setHousingId(String housingId) { this.housingId = housingId; }
    public String getBuilding() { return building; }
    public void setBuilding(String building) { this.building = building; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }
    public double getArea() { return area; }
    public void setArea(double area) { this.area = area; }
    public int getFloor() { return floor; }
    public void setFloor(int floor) { this.floor = floor; }
    public String getHouseType() { return houseType; }
    public void setHouseType(String houseType) { this.houseType = houseType; }

    public String getFullAddress() {
        return building + "号楼" + unit + "单元" + roomNo + "室";
    }
}