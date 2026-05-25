package com.property.model;

import java.util.Date;

public class ShiftRecord {
    private String shiftId;
    private String staffId;
    private String locationId;
    private Date shiftDate;
    private String shiftPeriod;
    private String staffName;
    private String workTypeName;
    private String locationName;

    public ShiftRecord() {}

    public String getShiftId() { return shiftId; }
    public void setShiftId(String shiftId) { this.shiftId = shiftId; }

    public String getStaffId() { return staffId; }
    public void setStaffId(String staffId) { this.staffId = staffId; }

    public String getLocationId() { return locationId; }
    public void setLocationId(String locationId) { this.locationId = locationId; }

    public Date getShiftDate() { return shiftDate; }
    public void setShiftDate(Date shiftDate) { this.shiftDate = shiftDate; }

    public String getShiftPeriod() { return shiftPeriod; }
    public void setShiftPeriod(String shiftPeriod) { this.shiftPeriod = shiftPeriod; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public String getWorkTypeName() { return workTypeName; }
    public void setWorkTypeName(String workTypeName) { this.workTypeName = workTypeName; }

    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }
}