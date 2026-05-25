package com.property.servlet;

import com.property.dao.WaterFeeBillDAO;
import com.property.entity.WaterFeeBill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * 管理员端 - 水费账单管理 Servlet
 * URL: /admin/waterFee
 */
@WebServlet("/admin/waterFee")
public class AdminWaterFeeServlet extends BaseServlet {

    private WaterFeeBillDAO billDAO = new WaterFeeBillDAO();

    /**
     * 账单列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billMonth = request.getParameter("billMonth");
        List<WaterFeeBill> list;

        if (billMonth != null && !billMonth.isEmpty()) {
            list = billDAO.findByMonth(billMonth);
            request.setAttribute("selectedMonth", billMonth);
        } else {
            list = billDAO.findAll();
        }

        request.setAttribute("list", list);
        request.setAttribute("activeTab", "fee");
        request.getRequestDispatcher("/pages/admin/water/fee-list.jsp").forward(request, response);
    }

    /**
     * 账单详情
     */
    protected void detail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billId = request.getParameter("id");
        if (billId != null && !billId.isEmpty()) {
            WaterFeeBill bill = billDAO.findById(billId);
            request.setAttribute("bill", bill);
        }
        request.setAttribute("activeTab", "fee");
        request.getRequestDispatcher("/pages/admin/water/fee-detail.jsp").forward(request, response);
    }

    /**
     * 确认缴费
     */
    protected void confirmPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billId = request.getParameter("id");
        if (billId != null && !billId.isEmpty()) {
            WaterFeeBill bill = billDAO.findById(billId);
            if (bill != null) {
                billDAO.confirmPayment(billId, bill.getAmount());
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/waterFee?action=list");
    }
}
