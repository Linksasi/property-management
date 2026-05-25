package com.property.servlet;

import com.property.dao.ResidentDAO;
import com.property.dao.WaterFeeBillDAO;
import com.property.entity.Resident;
import com.property.entity.WaterFeeBill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * 业主端 - 我的水费 Servlet
 */
@WebServlet("/owner/water")
public class OwnerWaterServlet extends BaseServlet {

    private ResidentDAO residentDAO = new ResidentDAO();
    private WaterFeeBillDAO billDAO = new WaterFeeBillDAO();

    /**
     * 水费列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = getCurrentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Resident resident = residentDAO.findByUserId(userId);
        List<WaterFeeBill> billList = null;
        if (resident != null) {
            billList = billDAO.findByResidentId(resident.getResidentId());
        }

        request.setAttribute("resident", resident);
        request.setAttribute("billList", billList);
        request.getRequestDispatcher("/pages/owner/water/list.jsp").forward(request, response);
    }

    /**
     * 账单详情
     */
    protected void detail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = getCurrentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String billId = request.getParameter("id");
        WaterFeeBill bill = null;
        if (billId != null && !billId.isEmpty()) {
            bill = billDAO.findById(billId);
        }

        request.setAttribute("bill", bill);
        request.getRequestDispatcher("/pages/owner/water/detail.jsp").forward(request, response);
    }

    /**
     * 从 Session 获取当前用户ID
     */
    private String getCurrentUserId(HttpServletRequest request) {
        Object userId = request.getSession().getAttribute("userId");
        return userId != null ? userId.toString() : null;
    }
}
