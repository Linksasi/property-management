package com.property.dao;

import com.property.model.PropertyFeeDetail;
import java.util.List;

/**
 * 物业费明细DAO接口
 */
public interface PropertyFeeDetailDAO {
    
    /**
     * 查询所有明细
     */
    List<PropertyFeeDetail> findAll();
    
    /**
     * 根据ID查询
     */
    PropertyFeeDetail findById(String detailId);
    
    /**
     * 根据批次ID查询
     */
    List<PropertyFeeDetail> findByBatchId(String batchId);
    
    /**
     * 根据住户ID查询
     */
    List<PropertyFeeDetail> findByResidentId(String residentId);
    
    /**
     * 根据状态查询
     */
    List<PropertyFeeDetail> findByStatus(String status);
    
    /**
     * 根据月份查询
     */
    List<PropertyFeeDetail> findByBillMonth(String billMonth);
    
    /**
     * 条件查询（动态SQL）
     */
    List<PropertyFeeDetail> findByConditions(String billMonth, String residentId, String status);
    
    /**
     * 新增明细
     */
    int insert(PropertyFeeDetail detail);
    
    /**
     * 批量新增明细
     */
    int insertBatch(List<PropertyFeeDetail> details);
    
    /**
     * 更新明细
     */
    int update(PropertyFeeDetail detail);
    
    /**
     * 更新缴费状态
     */
    int updateStatus(String detailId, String status);
    
    /**
     * 删除明细
     */
    int delete(String detailId);
    
    /**
     * 统计：获取住户数量
     */
    int countResidents();
    
    /**
     * 统计：根据月份统计各状态数量
     */
    int countByStatus(String billMonth, String status);
    
    /**
     * 更新金额
     */
    int updateAmount(String detailId, java.math.BigDecimal amount);
    
    /**
     * 更新状态和实缴金额（用于支付完成后）
     */
    int updateStatusAndPaidAmount(String detailId, String status, java.math.BigDecimal paidAmount);
}