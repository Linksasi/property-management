package com.property.service;

import com.property.dao.PropertyFeeDetailDAO;
import com.property.dao.PropertyFeeDetailDAOImpl;
import com.property.dao.PropertyStandardDAO;
import com.property.dao.PropertyStandardDAOImpl;
import com.property.model.PropertyFeeBatch;
import com.property.model.PropertyFeeDetail;
import com.property.model.PropertyStandard;
import com.property.util.DBUtil;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 物业费明细Service
 */
public class PropertyFeeDetailService {
    
    private final PropertyFeeDetailDAO dao = new PropertyFeeDetailDAOImpl();
    private final PropertyStandardDAO standardDAO = new PropertyStandardDAOImpl();
    private final PropertyFeeBatchService batchService = new PropertyFeeBatchService();
    
    /**
     * 查询所有明细
     */
    public List<PropertyFeeDetail> findAll() {
        return dao.findAll();
    }
    
    /**
     * 根据ID查询
     */
    public PropertyFeeDetail findById(String detailId) {
        return dao.findById(detailId);
    }
    
    /**
     * 根据住户ID查询
     */
    public List<PropertyFeeDetail> findByResidentId(String residentId) {
        return dao.findByResidentId(residentId);
    }
    
    /**
     * 根据状态查询
     */
    public List<PropertyFeeDetail> findByStatus(String status) {
        return dao.findByStatus(status);
    }
    
    /**
     * 根据月份查询
     */
    public List<PropertyFeeDetail> findByBillMonth(String billMonth) {
        return dao.findByBillMonth(billMonth);
    }
    
    /**
     * 条件查询
     */
    public List<PropertyFeeDetail> findByConditions(String billMonth, String residentId, String status) {
        return dao.findByConditions(billMonth, residentId, status);
    }
    
    /**
     * 获取住户数量
     */
    public int countResidents() {
        return dao.countResidents();
    }
    
    /**
     * 确认缴费（管理员手动标记）
     */
    public boolean confirmPayment(String detailId) {
        return dao.updateStatus(detailId, "已缴") > 0;
    }
    
    /**
     * 更新状态
     */
    public boolean updateStatus(String detailId, String status) {
        return dao.updateStatus(detailId, status) > 0;
    }
    
    /**
     * 生成物业费账单（根据收费标准和住户信息）
     * @param batchId 批次ID
     * @param residentId 住户ID
     * @param housingId 住房ID
     * @param area 住房面积
     * @param billMonth 计费月份
     * @return 生成是否成功
     */
    public boolean generateBill(String batchId, String residentId, String housingId, 
                                BigDecimal area, String billMonth) {
        // 获取所有生效的收费标准
        List<PropertyStandard> standards = standardDAO.findByStatus("生效");
        if (standards.isEmpty()) {
            return false;
        }
        
        Calendar cal = Calendar.getInstance();
        // 设置截止日期为下个月15日
        cal.add(Calendar.MONTH, 1);
        cal.set(Calendar.DAY_OF_MONTH, 15);
        
        for (PropertyStandard standard : standards) {
            PropertyFeeDetail detail = new PropertyFeeDetail();
            detail.setDetailId(generateId());
            detail.setBatchId(batchId);
            detail.setResidentId(residentId);
            detail.setHousingId(housingId);
            detail.setStandardId(standard.getStandardId());
            detail.setArea(area);
            // 金额 = 面积 × 单价
            detail.setAmount(area.multiply(standard.getUnitPrice()));
            detail.setPaidAmount(BigDecimal.ZERO);
            detail.setStatus("未缴");
            detail.setDueDate(cal.getTime());
            
            if (dao.insert(detail) <= 0) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * 生成ID
     */
    private String generateId() {
        return "DET" + System.currentTimeMillis();
    }
    
    /**
     * 获取所有住户及其住房信息（用于生成账单预览）
     */
    public List<ResidentHousingInfo> getAllResidentsWithHousing() {
        List<ResidentHousingInfo> list = new java.util.ArrayList<>();
        String sql = "SELECT r.resident_id, r.name as resident_name, h.housing_id, " +
                     "h.building + '-' + h.unit + '-' + h.room_no as housing_address, h.area " +
                     "FROM Resident r " +
                     "INNER JOIN ResidentHousing rh ON r.resident_id = rh.resident_id " +
                     "INNER JOIN Housing h ON rh.housing_id = h.housing_id";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ResidentHousingInfo info = new ResidentHousingInfo();
                info.setResidentId(rs.getString("resident_id"));
                info.setResidentName(rs.getString("resident_name"));
                info.setHousingId(rs.getString("housing_id"));
                info.setHousingAddress(rs.getString("housing_address"));
                info.setArea(rs.getBigDecimal("area"));
                list.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * 生成账单预览数据（计算每户的物业费）
     * @param billMonth 计费月份
     * @return 预览列表
     */
    public List<BatchPreviewItem> generatePreview(String billMonth) {
        List<BatchPreviewItem> previews = new java.util.ArrayList<>();
        List<PropertyStandard> standards = standardDAO.findByStatus("生效");
        if (standards.isEmpty()) {
            return previews;
        }
        
        List<ResidentHousingInfo> residents = getAllResidentsWithHousing();
        for (ResidentHousingInfo resident : residents) {
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (PropertyStandard standard : standards) {
                if (resident.getArea() != null && standard.getUnitPrice() != null) {
                    totalAmount = totalAmount.add(resident.getArea().multiply(standard.getUnitPrice()));
                }
            }
            
            BatchPreviewItem item = new BatchPreviewItem();
            item.setResidentId(resident.getResidentId());
            item.setResidentName(resident.getResidentName());
            item.setHousingId(resident.getHousingId());
            item.setHousingAddress(resident.getHousingAddress());
            item.setArea(resident.getArea());
            item.setBillMonth(billMonth);
            item.setTotalAmount(totalAmount);
            
            // 费用明细
            for (PropertyStandard standard : standards) {
                BatchFeeItem feeItem = new BatchFeeItem();
                feeItem.setFeeType(standard.getFeeType());
                feeItem.setUnitPrice(standard.getUnitPrice());
                if (resident.getArea() != null && standard.getUnitPrice() != null) {
                    feeItem.setAmount(resident.getArea().multiply(standard.getUnitPrice()));
                }
                item.addFeeItem(feeItem);
            }
            
            previews.add(item);
        }
        return previews;
    }
    
    /**
     * 根据预览数据生成物业费批次
     * @param billMonth 计费月份
     * @param adminId 管理员ID
     * @return 生成的批次ID，失败返回null
     */
    public String createBatchWithDetails(String billMonth, String adminId) {
        // 检查是否已存在
        PropertyFeeBatch existingBatch = batchService.findByBillMonth(billMonth);
        if (existingBatch != null) {
            return null;
        }
        
        // 获取生效的收费标准
        List<PropertyStandard> standards = standardDAO.findByStatus("生效");
        if (standards.isEmpty()) {
            return null;
        }
        
        // 获取住户住房信息
        List<ResidentHousingInfo> residents = getAllResidentsWithHousing();
        if (residents.isEmpty()) {
            return null;
        }
        
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // 1. 创建批次
            String batchId = generateBatchId();
            String batchSql = "INSERT INTO PropertyFeeBatch (batch_id, bill_month, create_time, admin_id) VALUES (?, ?, GETDATE(), ?)";
            try (PreparedStatement ps = conn.prepareStatement(batchSql)) {
                ps.setString(1, batchId);
                ps.setString(2, billMonth);
                ps.setString(3, adminId);
                ps.executeUpdate();
            }
            
            // 3. 计算截止日期（下个月15日）
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.MONTH, 1);
            cal.set(Calendar.DAY_OF_MONTH, 15);
            Date dueDate = cal.getTime();
            
            // 4. 为每个住户的每种收费类型生成明细
            int detailCount = 0;
            String detailSql = "INSERT INTO PropertyFeeDetail (detail_id, batch_id, housing_id, resident_id, " +
                              "standard_id, area, amount, paid_amount, status, due_date, create_date) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?, 0, '未缴', ?, GETDATE())";
            
            try (PreparedStatement ps = conn.prepareStatement(detailSql)) {
                for (ResidentHousingInfo resident : residents) {
                    for (PropertyStandard standard : standards) {
                        ps.setString(1, generateDetailId());
                        ps.setString(2, batchId);
                        ps.setString(3, resident.getHousingId());
                        ps.setString(4, resident.getResidentId());
                        ps.setString(5, standard.getStandardId());
                        ps.setBigDecimal(6, resident.getArea());
                        if (resident.getArea() != null && standard.getUnitPrice() != null) {
                            ps.setBigDecimal(7, resident.getArea().multiply(standard.getUnitPrice()));
                        } else {
                            ps.setBigDecimal(7, BigDecimal.ZERO);
                        }
                        ps.setDate(8, new java.sql.Date(dueDate.getTime()));
                        ps.addBatch();
                        detailCount++;
                    }
                }
                ps.executeBatch();
            }
            
            conn.commit();
            return batchId;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return null;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
                DBUtil.closeConnection();
            }
        }
    }
    
    private static final java.util.concurrent.atomic.AtomicLong idCounter = new java.util.concurrent.atomic.AtomicLong(System.currentTimeMillis() % 10000);
    
    private String generateBatchId() {
        return "BAT" + System.currentTimeMillis();
    }
    
    private String generateDetailId() {
        return "DET" + (idCounter.incrementAndGet());
    }
    
    // 内部类：住户住房信息
    public static class ResidentHousingInfo {
        private String residentId;
        private String residentName;
        private String housingId;
        private String housingAddress;
        private BigDecimal area;
        
        public String getResidentId() { return residentId; }
        public void setResidentId(String residentId) { this.residentId = residentId; }
        public String getResidentName() { return residentName; }
        public void setResidentName(String residentName) { this.residentName = residentName; }
        public String getHousingId() { return housingId; }
        public void setHousingId(String housingId) { this.housingId = housingId; }
        public String getHousingAddress() { return housingAddress; }
        public void setHousingAddress(String housingAddress) { this.housingAddress = housingAddress; }
        public BigDecimal getArea() { return area; }
        public void setArea(BigDecimal area) { this.area = area; }
    }
    
    // 内部类：批次预览项
    public static class BatchPreviewItem {
        private String residentId;
        private String residentName;
        private String housingId;
        private String housingAddress;
        private BigDecimal area;
        private String billMonth;
        private BigDecimal totalAmount;
        private java.util.List<BatchFeeItem> feeItems = new java.util.ArrayList<>();
        
        public String getResidentId() { return residentId; }
        public void setResidentId(String residentId) { this.residentId = residentId; }
        public String getResidentName() { return residentName; }
        public void setResidentName(String residentName) { this.residentName = residentName; }
        public String getHousingId() { return housingId; }
        public void setHousingId(String housingId) { this.housingId = housingId; }
        public String getHousingAddress() { return housingAddress; }
        public void setHousingAddress(String housingAddress) { this.housingAddress = housingAddress; }
        public BigDecimal getArea() { return area; }
        public void setArea(BigDecimal area) { this.area = area; }
        public String getBillMonth() { return billMonth; }
        public void setBillMonth(String billMonth) { this.billMonth = billMonth; }
        public BigDecimal getTotalAmount() { return totalAmount; }
        public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
        public void addFeeItem(BatchFeeItem item) { this.feeItems.add(item); }
        public java.util.List<BatchFeeItem> getFeeItems() { return feeItems; }
    }
    
    // 内部类：费用明细项
    public static class BatchFeeItem {
        private String feeType;
        private BigDecimal unitPrice;
        private BigDecimal amount;
        
        public String getFeeType() { return feeType; }
        public void setFeeType(String feeType) { this.feeType = feeType; }
        public BigDecimal getUnitPrice() { return unitPrice; }
        public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
        public BigDecimal getAmount() { return amount; }
        public void setAmount(BigDecimal amount) { this.amount = amount; }
    }
}