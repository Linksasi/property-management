package com.property.model;

import java.util.Date;

public class AdApplication {
    private String appId;
    private String adContent;
    private String expectSlot;
    private Date startDate;
    private Date endDate;
    private Date applyDate;
    private String status;
    private String slotId;
    private String companyId;
    private String companyName;
    private String location;
    private String expectSlotName;

    public AdApplication() {}

    public String getAppId() { return appId; }
    public void setAppId(String appId) { this.appId = appId; }

    public String getAdContent() { return adContent; }
    public void setAdContent(String adContent) { this.adContent = adContent; }

    public String getExpectSlot() { return expectSlot; }
    public void setExpectSlot(String expectSlot) { this.expectSlot = expectSlot; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public Date getApplyDate() { return applyDate; }
    public void setApplyDate(Date applyDate) { this.applyDate = applyDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSlotId() { return slotId; }
    public void setSlotId(String slotId) { this.slotId = slotId; }

    public String getCompanyId() { return companyId; }
    public void setCompanyId(String companyId) { this.companyId = companyId; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getExpectSlotName() { return expectSlotName; }
    public void setExpectSlotName(String expectSlotName) { this.expectSlotName = expectSlotName; }
}