package com.property.service;

import com.property.dao.PropertyStandardDAO;
import com.property.dao.PropertyStandardDAOImpl;
import com.property.model.PropertyStandard;
import java.util.List;

/**
 * 收费标准Service
 */
public class PropertyStandardService {
    
    private final PropertyStandardDAO dao = new PropertyStandardDAOImpl();
    
    /**
     * 查询所有收费标准
     */
    public List<PropertyStandard> findAll() {
        return dao.findAll();
    }
    
    /**
     * 根据ID查询
     */
    public PropertyStandard findById(String standardId) {
        return dao.findById(standardId);
    }
    
    /**
     * 根据状态查询
     */
    public List<PropertyStandard> findByStatus(String status) {
        return dao.findByStatus(status);
    }
    
    /**
     * 根据收费类型查询
     */
    public List<PropertyStandard> findByFeeType(String feeType) {
        return dao.findByFeeType(feeType);
    }
    
    /**
     * 获取生效中的收费标准
     */
    public List<PropertyStandard> findActive() {
        return dao.findByStatus("生效");
    }
    
    /**
     * 新增收费标准
     */
    public boolean insert(PropertyStandard standard) {
        // 生成ID
        if (standard.getStandardId() == null || standard.getStandardId().isEmpty()) {
            standard.setStandardId(generateId());
        }
        // 默认状态为生效
        if (standard.getStatus() == null || standard.getStatus().isEmpty()) {
            standard.setStatus("生效");
        }
        return dao.insert(standard) > 0;
    }
    
    /**
     * 更新收费标准
     */
    public boolean update(PropertyStandard standard) {
        return dao.update(standard) > 0;
    }
    
    /**
     * 停用收费标准
     */
    public boolean disable(String standardId) {
        PropertyStandard standard = dao.findById(standardId);
        if (standard != null) {
            standard.setStatus("失效");
            return dao.update(standard) > 0;
        }
        return false;
    }
    
    /**
     * 启用收费标准
     */
    public boolean enable(String standardId) {
        PropertyStandard standard = dao.findById(standardId);
        if (standard != null) {
            standard.setStatus("生效");
            return dao.update(standard) > 0;
        }
        return false;
    }
    
    /**
     * 删除收费标准
     */
    public boolean delete(String standardId) {
        return dao.delete(standardId) > 0;
    }
    
    /**
     * 生成ID
     */
    private String generateId() {
        return "STD" + System.currentTimeMillis();
    }
}