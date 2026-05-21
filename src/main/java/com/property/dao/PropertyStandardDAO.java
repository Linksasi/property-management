package com.property.dao;

import com.property.model.PropertyStandard;
import java.util.List;

/**
 * 收费标准DAO接口
 */
public interface PropertyStandardDAO {
    
    /**
     * 查询所有收费标准
     */
    List<PropertyStandard> findAll();
    
    /**
     * 根据ID查询
     */
    PropertyStandard findById(String standardId);
    
    /**
     * 根据状态查询（生效/失效）
     */
    List<PropertyStandard> findByStatus(String status);
    
    /**
     * 根据收费类型查询
     */
    List<PropertyStandard> findByFeeType(String feeType);
    
    /**
     * 新增收费标准
     */
    int insert(PropertyStandard standard);
    
    /**
     * 更新收费标准
     */
    int update(PropertyStandard standard);
    
    /**
     * 删除收费标准（根据ID）
     */
    int delete(String standardId);
}