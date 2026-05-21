package com.property.dao;

import com.property.model.PropertyFeeBatch;
import java.util.List;

/**
 * 物业费批次DAO接口
 */
public interface PropertyFeeBatchDAO {
    
    /**
     * 查询所有批次
     */
    List<PropertyFeeBatch> findAll();
    
    /**
     * 根据ID查询
     */
    PropertyFeeBatch findById(String batchId);
    
    /**
     * 根据计费月份查询
     */
    PropertyFeeBatch findByBillMonth(String billMonth);
    
    /**
     * 新增批次
     */
    int insert(PropertyFeeBatch batch);
    
    /**
     * 删除批次
     */
    int delete(String batchId);
}