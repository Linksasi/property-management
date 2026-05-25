package com.property.model;

public class AdSlot {
    private String slotId;
    private String location;
    private String standardId;
    private String status;

    public AdSlot() {}

    public String getSlotId() { return slotId; }
    public void setSlotId(String slotId) { this.slotId = slotId; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getStandardId() { return standardId; }
    public void setStandardId(String standardId) { this.standardId = standardId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}