package com.property.service;

import com.property.dao.PropertyFeeAppealDAO;
import com.property.dao.PropertyFeeAppealDAOImpl;
import com.property.dao.PropertyFeeDetailDAO;
import com.property.dao.PropertyFeeDetailDAOImpl;
import com.property.model.PropertyFeeAppeal;
import com.property.model.PropertyFeeDetail;

import java.util.List;

/**
 * 物业费申诉Service
 */
public class PropertyFeeAppealService {
    
    private final PropertyFeeAppealDAO appealDAO = new PropertyFeeAppealDAOImpl();
    private final PropertyFeeDetailDAO detailDAO = new PropertyFeeDetailDAOImpl();
    
    /**
     * 查询所有申诉
     */
    public List<PropertyFeeAppeal> findAll() {
        return appealDAO.findAll();
    }
    
    /**
     * 根据ID查询
     */
    public PropertyFeeAppeal findById(String appealId) {
        return appealDAO.findById(appealId);
    }
    
    /**
     * 根据账单明细ID查询
     */
    public PropertyFeeDetail getDetailById(String detailId) {
        return detailDAO.findById(detailId);
    }
    
    /**
     * 根据住户ID查询
     */
    public List<PropertyFeeAppeal> findByResidentId(String residentId) {
        return appealDAO.findByResidentId(residentId);
    }
    
    /**
     * 根据状态查询
     */
    public List<PropertyFeeAppeal> findByStatus(String status) {
        return appealDAO.findByStatus(status);
    }
    
    /**
     * 提交申诉
     */
    public boolean submitAppeal(String detailId, String residentId, String reason) {
        // 检查是否已有未处理的申诉
        PropertyFeeAppeal existingAppeal = appealDAO.findByDetailId(detailId);
        if (existingAppeal != null && "待处理".equals(existingAppeal.getStatus())) {
            return false; // 已有待处理的申诉
        }
        
        PropertyFeeAppeal appeal = new PropertyFeeAppeal();
        appeal.setAppealId(generateId());
        appeal.setDetailId(detailId);
        appeal.setResidentId(residentId);
        appeal.setReason(reason);
        appeal.setStatus("待处理");
        
        // 同时更新物业费明细状态为申诉中
        detailDAO.updateStatus(detailId, "申诉中");
        
        return appealDAO.insert(appeal) > 0;
    }
    
    /**
     * 审核申诉
     * @param appealId 申诉ID
     * @param status 审核结果（已通过/已驳回）
     * @param adminId 管理员ID
     * @param adminReason 审核意见
     * @param adjustedAmountStr 调整后的金额（可选）
     */
    public boolean reviewAppeal(String appealId, String status, String adminId, String adminReason, String adjustedAmountStr) {
        PropertyFeeAppeal appeal = appealDAO.findById(appealId);
        if (appeal == null) {
            return false;
        }
        
        // 更新申诉状态
        appealDAO.updateStatus(appealId, status, adminId, adminReason);
        
        if ("已通过".equals(status)) {
            // 如果有调整金额，更新账单金额
            if (adjustedAmountStr != null && !adjustedAmountStr.isEmpty()) {
                try {
                    java.math.BigDecimal adjustedAmount = new java.math.BigDecimal(adjustedAmountStr);
                    detailDAO.updateAmount(appeal.getDetailId(), adjustedAmount);
                } catch (NumberFormatException e) {
                    // 金额格式错误，跳过
                }
            }
            // 申诉通过后状态改为"未缴"，住户需重新缴费
            detailDAO.updateStatus(appeal.getDetailId(), "未缴");
        } else if ("已驳回".equals(status)) {
            // 驳回（申诉失败）后状态改回"未缴"
            detailDAO.updateStatus(appeal.getDetailId(), "未缴");
        }
        
        return true;
    }
    
    /**
     * 删除申诉
     */
    public boolean delete(String appealId) {
        return appealDAO.delete(appealId) > 0;
    }
    
    /**
     * 生成ID
     */
    private String generateId() {
        return "APL" + System.currentTimeMillis();
    }
}