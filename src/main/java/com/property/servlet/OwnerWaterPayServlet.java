package com.property.servlet;

import com.property.dao.WaterFeeBillDAO;
import com.property.entity.WaterFeeBill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * 业主端 - 水费在线支付 Servlet
 */
@WebServlet("/owner/waterPay")
public class OwnerWaterPayServlet extends BaseServlet {

    private WaterFeeBillDAO billDAO = new WaterFeeBillDAO();

    /**
     * 显示支付页面
     */
    protected void pay(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billId = request.getParameter("id");
        WaterFeeBill bill = null;
        if (billId != null && !billId.isEmpty()) {
            bill = billDAO.findById(billId);
        }

        request.setAttribute("bill", bill);
        request.getRequestDispatcher("/pages/owner/water/pay.jsp").forward(request, response);
    }

    /**
     * 处理支付（模拟）
     */
    protected void doPay(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billId = request.getParameter("billId");
        String payMethod = request.getParameter("payMethod");

        if (billId != null && !billId.isEmpty()) {
            WaterFeeBill bill = billDAO.findById(billId);
            if (bill != null) {
                // 模拟支付成功
                billDAO.confirmPayment(billId, bill.getAmount());

                // 生成交易流水号
                String transactionId = "WX" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
                String payTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                request.setAttribute("bill", bill);
                request.setAttribute("transactionId", transactionId);
                request.setAttribute("payTime", payTime);
                request.setAttribute("payMethod", payMethod);
            }
        }

        request.getRequestDispatcher("/pages/owner/water/voucher.jsp").forward(request, response);
    }
}
