package com.property.service;

import com.property.dao.ElectronicVoucherDAO;
import com.property.dao.ElectronicVoucherDAOImpl;
import com.property.model.ElectronicVoucher;
import java.util.List;

/**
 * 电子凭证Service
 */
public class ElectronicVoucherService {
    
    private final ElectronicVoucherDAO dao = new ElectronicVoucherDAOImpl();
    
    /**
     * 查询所有凭证
     */
    public List<ElectronicVoucher> findAll() {
        return dao.findAll();
    }
    
    /**
     * 根据ID查询
     */
    public ElectronicVoucher findById(String voucherId) {
        return dao.findById(voucherId);
    }
    
    /**
     * 根据订单ID查询
     */
    public ElectronicVoucher findByOrderId(String orderId) {
        return dao.findByOrderId(orderId);
    }
    
    /**
     * 根据住户ID查询
     */
    public List<ElectronicVoucher> findByResidentId(String residentId) {
        return dao.findByResidentId(residentId);
    }
}