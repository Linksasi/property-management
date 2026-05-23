package com.property.entity;

public class Resident {
    private String residentId;
    private String userId;
    private String name;
    private String phone;
    private String idCard;
    private String checkInDate;

    public Resident() {}

    public String getResidentId() { return residentId; }
    public void setResidentId(String residentId) { this.residentId = residentId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getIdCard() { return idCard; }
    public void setIdCard(String idCard) { this.idCard = idCard; }
    public String getCheckInDate() { return checkInDate; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }
}