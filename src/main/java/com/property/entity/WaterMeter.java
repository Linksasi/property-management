package com.property.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 水表实体类
 */
public class WaterMeter {
    private String meterId;           // 水表编号
    private String housingId;        // 住房ID
    private LocalDate installDate;   // 安装日期
    private BigDecimal initialRead;  // 初始读数
    private BigDecimal currentRead; // 当前读数
    private BigDecimal lastRead;     // 上次读数
    private LocalDate lastReadDate;  // 上次抄表日期
    private LocalDate updateDate;    // 更新时间
    private String status;           // 正常/异常/停用

    // 关联的住房信息（用于列表显示）
    private String housingAddress;   // 住房地址
    private String building;
    private String unit;
    private String roomNo;

    public WaterMeter() {}

    public String getMeterId() { return meterId; }
    public void setMeterId(String meterId) { this.meterId = meterId; }

    public String getHousingId() { return housingId; }
    public void setHousingId(String housingId) { this.housingId = housingId; }

    public LocalDate getInstallDate() { return installDate; }
    public void setInstallDate(LocalDate installDate) { this.installDate = installDate; }

    public BigDecimal getInitialRead() { return initialRead; }
    public void setInitialRead(BigDecimal initialRead) { this.initialRead = initialRead; }

    public BigDecimal getCurrentRead() { return currentRead; }
    public void setCurrentRead(BigDecimal currentRead) { this.currentRead = currentRead; }

    public BigDecimal getLastRead() { return lastRead; }
    public void setLastRead(BigDecimal lastRead) { this.lastRead = lastRead; }

    public LocalDate getLastReadDate() { return lastReadDate; }
    public void setLastReadDate(LocalDate lastReadDate) { this.lastReadDate = lastReadDate; }

    public LocalDate getUpdateDate() { return updateDate; }
    public void setUpdateDate(LocalDate updateDate) { this.updateDate = updateDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getHousingAddress() { return housingAddress; }
    public void setHousingAddress(String housingAddress) { this.housingAddress = housingAddress; }

    public String getBuilding() { return building; }
    public void setBuilding(String building) { this.building = building; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    /**
     * 获取完整地址
     */
    public String getFullAddress() {
        if (housingAddress != null) {
            return housingAddress;
        }
        if (building != null && unit != null && roomNo != null) {
            return building + "栋" + unit + "单元" + roomNo + "室";
        }
        return "";
    }
}
