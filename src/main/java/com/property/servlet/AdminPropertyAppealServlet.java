package com.property.servlet;

import com.property.service.PropertyFeeAppealService;
import com.property.model.PropertyFeeAppeal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 管理员-申诉管理Servlet
 */
@WebServlet("/admin/property/appeal")
public class AdminPropertyAppealServlet extends BaseServlet {
    
    private final PropertyFeeAppealService service = new PropertyFeeAppealService();
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String status = request.getParameter("status");
        
        List<PropertyFeeAppeal> list;
        if (status != null && !status.isEmpty()) {
            list = service.findByStatus(status);
        } else {
            list = service.findAll();
        }
        
        request.setAttribute("list", list);
        request.getRequestDispatcher("/pages/admin/property/appeal-list.jsp").forward(request, response);
    }
    
    protected void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appealId = request.getParameter("appealId");
        if (appealId == null) {
            appealId = request.getParameter("id");
        }
        
        PropertyFeeAppeal appeal = service.findById(appealId);
        request.setAttribute("entity", appeal);
        
        request.getRequestDispatcher("/pages/admin/property/appeal-detail.jsp").forward(request, response);
    }
    
    protected void review(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appealId = request.getParameter("appealId");
        String status = request.getParameter("status");
        String adminReason = request.getParameter("adminReason");
        
        String adminId = request.getParameter("adminId");
        if (adminId == null || adminId.isEmpty()) {
            Object adminIdObj = request.getSession().getAttribute("userId");
            adminId = adminIdObj != null ? adminIdObj.toString() : "ADMIN001";
        }
        
        service.reviewAppeal(appealId, status, adminId, adminReason);
        response.sendRedirect(request.getContextPath() + "/admin/property/appeal?action=list");
    }
}