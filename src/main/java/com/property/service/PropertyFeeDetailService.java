package com.property.service;

import com.property.dao.PropertyFeeDetailDAO;
import com.property.dao.PropertyFeeDetailDAOImpl;
import com.property.dao.PropertyStandardDAO;
import com.property.dao.PropertyStandardDAOImpl;
import com.property.model.PropertyFeeDetail;
import com.property.model.PropertyStandard;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 物业费明细Service
 */
public class PropertyFeeDetailService {
    
    private final PropertyFeeDetailDAO dao = new PropertyFeeDetailDAOImpl();
    private final PropertyStandardDAO standardDAO = new PropertyStandardDAOImpl();
    
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
}