package com.property.service;

import com.property.dao.PaymentOrderDAO;
import com.property.dao.PaymentOrderDAOImpl;
import com.property.dao.PropertyFeeDetailDAO;
import com.property.dao.PropertyFeeDetailDAOImpl;
import com.property.dao.ElectronicVoucherDAO;
import com.property.dao.ElectronicVoucherDAOImpl;
import com.property.model.PaymentOrder;
import com.property.model.PropertyFeeDetail;
import com.property.model.ElectronicVoucher;
import java.math.BigDecimal;
import java.util.UUID;

/**
 * 支付订单Service
 */
public class PaymentOrderService {
    
    private final PaymentOrderDAO orderDAO = new PaymentOrderDAOImpl();
    private final PropertyFeeDetailDAO detailDAO = new PropertyFeeDetailDAOImpl();
    private final ElectronicVoucherDAO voucherDAO = new ElectronicVoucherDAOImpl();
    
    /**
     * 创建支付订单
     */
    public PaymentOrder createOrder(String detailId, BigDecimal amount, String paymentMethod) {
        // 检查是否已有待支付的订单
        PaymentOrder existingOrder = orderDAO.findByDetailId(detailId);
        if (existingOrder != null && "待支付".equals(existingOrder.getStatus())) {
            return existingOrder; // 返回已有订单
        }
        
        PaymentOrder order = new PaymentOrder();
        order.setOrderId(generateId());
        order.setDetailId(detailId);
        order.setOrderNo(generateOrderNo());
        order.setAmount(amount);
        order.setPaymentMethod(paymentMethod);
        order.setStatus("待支付");
        
        if (orderDAO.insert(order) > 0) {
            return order;
        }
        return null;
    }
    
    /**
     * 模拟支付成功
     */
    public ElectronicVoucher processPayment(String orderId) {
        PaymentOrder order = orderDAO.findById(orderId);
        if (order == null) {
            return null;
        }
        
        // 1. 更新订单状态为已支付
        orderDAO.updateStatus(orderId, "已支付");
        
        // 2. 更新物业费明细状态为已缴
        detailDAO.updateStatus(order.getDetailId(), "已缴");
        
        // 3. 获取明细信息
        PropertyFeeDetail detail = detailDAO.findById(order.getDetailId());
        
        // 4. 生成电子凭证
        ElectronicVoucher voucher = new ElectronicVoucher();
        voucher.setVoucherId(generateId());
        voucher.setOrderId(orderId);
        voucher.setResidentId(detail.getResidentId());
        voucher.setHousingId(detail.getHousingId());
        voucher.setAmount(order.getAmount());
        voucher.setPaymentDate(new java.util.Date());
        voucher.setTransactionNo(order.getOrderNo());
        
        voucherDAO.insert(voucher);
        
        return voucher;
    }
    
    /**
     * 根据ID查询订单
     */
    public PaymentOrder findById(String orderId) {
        return orderDAO.findById(orderId);
    }
    
    /**
     * 根据明细ID查询订单
     */
    public PaymentOrder findByDetailId(String detailId) {
        return orderDAO.findByDetailId(detailId);
    }
    
    /**
     * 取消订单
     */
    public boolean cancelOrder(String orderId) {
        return orderDAO.updateStatus(orderId, "已取消") > 0;
    }
    
    /**
     * 生成订单ID
     */
    private String generateId() {
        return "ORD" + System.currentTimeMillis();
    }
    
    /**
     * 生成订单号
     */
    private String generateOrderNo() {
        return "PAY" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}