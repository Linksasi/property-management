package com.property.servlet;

import com.property.service.PropertyFeeDetailService;
import com.property.model.PropertyFeeDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 管理员-物业费明细管理Servlet（默认首页）
 */
@WebServlet("/admin/property")
public class AdminPropertyServlet extends BaseServlet {
    
    private final PropertyFeeDetailService service = new PropertyFeeDetailService();
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billMonth = request.getParameter("billMonth");
        String residentId = request.getParameter("residentId");
        String status = request.getParameter("status");
        
        List<PropertyFeeDetail> list;
        if (billMonth != null || residentId != null || status != null) {
            list = service.findByConditions(billMonth, residentId, status);
        } else {
            list = service.findAll();
        }
        
        request.setAttribute("module", "property");
        request.setAttribute("list", list);
        request.getRequestDispatcher("/pages/admin/property/detail-list.jsp").forward(request, response);
    }
    
    protected void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String detailId = request.getParameter("detailId");
        if (detailId == null) {
            detailId = request.getParameter("id");
        }
        
        PropertyFeeDetail detail = service.findById(detailId);
        request.setAttribute("module", "property");
        request.setAttribute("entity", detail);
        request.getRequestDispatcher("/pages/admin/property/detail-detail.jsp").forward(request, response);
    }
    
    protected void confirm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String detailId = request.getParameter("detailId");
        if (detailId == null) {
            detailId = request.getParameter("id");
        }
        
        service.confirmPayment(detailId);
        response.sendRedirect(request.getContextPath() + "/admin/property?action=list");
    }
}