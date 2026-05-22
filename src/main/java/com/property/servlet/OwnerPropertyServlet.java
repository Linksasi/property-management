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
 * 业主-物业费Servlet
 */
@WebServlet("/owner/property")
public class OwnerPropertyServlet extends BaseServlet {
    
    private final PropertyFeeDetailService service = new PropertyFeeDetailService();
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Object residentIdObj = request.getSession().getAttribute("userId");
        String residentId = residentIdObj != null ? residentIdObj.toString() : null;
        
        if (residentId == null) {
            response.sendRedirect(request.getContextPath() + "/login-test.jsp");
            return;
        }
        
        List<PropertyFeeDetail> list = service.findByResidentId(residentId);
        
        request.setAttribute("list", list);
        request.getRequestDispatcher("/pages/owner/property/list.jsp").forward(request, response);
    }
    
    protected void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String detailId = request.getParameter("detailId");
        if (detailId == null) {
            detailId = request.getParameter("id");
        }
        
        PropertyFeeDetail detail = service.findById(detailId);
        request.setAttribute("entity", detail);
        request.getRequestDispatcher("/pages/owner/property/detail.jsp").forward(request, response);
    }
    
    protected void pay(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String detailId = request.getParameter("detailId");
        if (detailId == null) {
            detailId = request.getParameter("id");
        }
        
        PropertyFeeDetail detail = service.findById(detailId);
        request.setAttribute("entity", detail);
        request.getRequestDispatcher("/pages/owner/property/pay.jsp").forward(request, response);
    }
}