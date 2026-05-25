package com.property.servlet;

import com.property.service.PaymentOrderService;
import com.property.service.ElectronicVoucherService;
import com.property.model.PaymentOrder;
import com.property.model.ElectronicVoucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * 业主-在线支付Servlet
 */
@WebServlet("/owner/property/pay")
public class OwnerPropertyPayServlet extends BaseServlet {
    
    private final PaymentOrderService orderService = new PaymentOrderService();
    private final ElectronicVoucherService voucherService = new ElectronicVoucherService();
    
    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        String detailId = request.getParameter("detailId");
        String amountStr = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");
        
        BigDecimal amount = new BigDecimal(amountStr);
        
        PaymentOrder order = orderService.createOrder(detailId, amount, paymentMethod);
        
        if (order != null) {
            ElectronicVoucher voucher = orderService.processPayment(order.getOrderId());
            
            if (voucher != null) {
                request.setAttribute("module", "property");
                request.setAttribute("voucher", voucher);
                request.getRequestDispatcher("/pages/owner/property/voucher.jsp").forward(request, response);
                return;
            }
        }
        
        request.setAttribute("error", "支付失败，请重试");
        response.sendRedirect(request.getContextPath() + "/owner/property?action=list");
    }
    
    protected void voucher(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        String orderId = request.getParameter("orderId");
        
        ElectronicVoucher voucher = voucherService.findByOrderId(orderId);
        request.setAttribute("module", "property");
        request.setAttribute("voucher", voucher);
        request.getRequestDispatcher("/pages/owner/property/voucher.jsp").forward(request, response);
    }
    
    private boolean checkLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Object residentIdObj = request.getSession().getAttribute("userId");
        if (residentIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login-test.jsp");
            return false;
        }
        return true;
    }
}