package com.property.dao;

import com.property.model.PaymentOrder;
import java.util.List;

/**
 * 支付订单DAO接口
 */
public interface PaymentOrderDAO {
    
    /**
     * 查询所有订单
     */
    List<PaymentOrder> findAll();
    
    /**
     * 根据ID查询
     */
    PaymentOrder findById(String orderId);
    
    /**
     * 根据明细ID查询
     */
    PaymentOrder findByDetailId(String detailId);
    
    /**
     * 根据订单号查询
     */
    PaymentOrder findByOrderNo(String orderNo);
    
    /**
     * 新增订单
     */
    int insert(PaymentOrder order);
    
    /**
     * 更新订单状态
     */
    int updateStatus(String orderId, String status);
    
    /**
     * 删除订单
     */
    int delete(String orderId);
}