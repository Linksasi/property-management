package com.property.model;

import java.math.BigDecimal;

public class AdStandard {
    private String standardId;
    private String adType;
    private BigDecimal unitPrice;

    public AdStandard() {}

    public String getStandardId() { return standardId; }
    public void setStandardId(String standardId) { this.standardId = standardId; }

    public String getAdType() { return adType; }
    public void setAdType(String adType) { this.adType = adType; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}