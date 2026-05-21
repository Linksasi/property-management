package com.property.service;

import com.property.dao.PropertyFeeBatchDAO;
import com.property.dao.PropertyFeeBatchDAOImpl;
import com.property.model.PropertyFeeBatch;
import java.util.List;

/**
 * 物业费批次Service
 */
public class PropertyFeeBatchService {
    
    private final PropertyFeeBatchDAO dao = new PropertyFeeBatchDAOImpl();
    
    /**
     * 查询所有批次
     */
    public List<PropertyFeeBatch> findAll() {
        return dao.findAll();
    }
    
    /**
     * 根据ID查询
     */
    public PropertyFeeBatch findById(String batchId) {
        return dao.findById(batchId);
    }
    
    /**
     * 根据计费月份查询
     */
    public PropertyFeeBatch findByBillMonth(String billMonth) {
        return dao.findByBillMonth(billMonth);
    }
    
    /**
     * 创建批次
     */
    public boolean createBatch(String billMonth, String adminId) {
        // 检查是否已存在该月份的批次
        if (dao.findByBillMonth(billMonth) != null) {
            return false; // 已存在
        }
        PropertyFeeBatch batch = new PropertyFeeBatch();
        batch.setBatchId(generateId());
        batch.setBillMonth(billMonth);
        batch.setAdminId(adminId);
        return dao.insert(batch) > 0;
    }
    
    /**
     * 删除批次
     */
    public boolean delete(String batchId) {
        return dao.delete(batchId) > 0;
    }
    
    /**
     * 生成ID
     */
    private String generateId() {
        return "BAT" + System.currentTimeMillis();
    }
}