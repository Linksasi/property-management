package com.property.dao;

import com.property.model.PropertyFeeAppeal;
import java.util.List;

/**
 * 物业费申诉DAO接口
 */
public interface PropertyFeeAppealDAO {
    
    /**
     * 查询所有申诉
     */
    List<PropertyFeeAppeal> findAll();
    
    /**
     * 根据ID查询
     */
    PropertyFeeAppeal findById(String appealId);
    
    /**
     * 根据住户ID查询
     */
    List<PropertyFeeAppeal> findByResidentId(String residentId);
    
    /**
     * 根据状态查询
     */
    List<PropertyFeeAppeal> findByStatus(String status);
    
    /**
     * 根据明细ID查询
     */
    PropertyFeeAppeal findByDetailId(String detailId);
    
    /**
     * 新增申诉
     */
    int insert(PropertyFeeAppeal appeal);
    
    /**
     * 更新申诉状态
     */
    int updateStatus(String appealId, String status, String adminId, String adminReason);
    
    /**
     * 删除申诉
     */
    int delete(String appealId);
}