package com.property.dao;

import com.property.model.ElectronicVoucher;
import java.util.List;

/**
 * 电子凭证DAO接口
 */
public interface ElectronicVoucherDAO {
    
    /**
     * 查询所有凭证
     */
    List<ElectronicVoucher> findAll();
    
    /**
     * 根据ID查询
     */
    ElectronicVoucher findById(String voucherId);
    
    /**
     * 根据订单ID查询
     */
    ElectronicVoucher findByOrderId(String orderId);
    
    /**
     * 根据住户ID查询
     */
    List<ElectronicVoucher> findByResidentId(String residentId);
    
    /**
     * 新增凭证
     */
    int insert(ElectronicVoucher voucher);
    
    /**
     * 删除凭证
     */
    int delete(String voucherId);
}