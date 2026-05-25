package com.property.servlet;

import com.property.service.PropertyFeeAppealService;
import com.property.service.PropertyFeeDetailService;
import com.property.model.PropertyFeeAppeal;
import com.property.model.PropertyFeeDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 业主-费用申诉Servlet
 */
@WebServlet("/owner/property/appeal")
public class OwnerPropertyAppealServlet extends BaseServlet {
    
    private final PropertyFeeAppealService appealService = new PropertyFeeAppealService();
    private final PropertyFeeDetailService detailService = new PropertyFeeDetailService();
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        Object residentIdObj = request.getSession().getAttribute("userId");
        String residentId = residentIdObj != null ? residentIdObj.toString() : null;
        
        List<PropertyFeeAppeal> list = appealService.findByResidentId(residentId);
        
        request.setAttribute("module", "property");
        request.setAttribute("list", list);
        request.getRequestDispatcher("/pages/owner/property/appeal-list.jsp").forward(request, response);
    }
    
    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        String detailId = request.getParameter("detailId");
        if (detailId != null) {
            PropertyFeeDetail detail = detailService.findById(detailId);
            request.setAttribute("module", "property");
            request.setAttribute("detail", detail);
        }
        request.getRequestDispatcher("/pages/owner/property/appeal.jsp").forward(request, response);
    }
    
    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        String detailId = request.getParameter("detailId");
        String reason = request.getParameter("reason");
        
        Object residentIdObj = request.getSession().getAttribute("userId");
        String residentId = residentIdObj != null ? residentIdObj.toString() : "RES001";
        
        boolean success = appealService.submitAppeal(detailId, residentId, reason);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/owner/property/appeal?action=list");
        } else {
            request.setAttribute("error", "提交失败，可能已有待审核的申诉");
            request.setAttribute("module", "property");
            request.getRequestDispatcher("/pages/owner/property/appeal-list.jsp").forward(request, response);
        }
    }
    
    protected void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        String appealId = request.getParameter("appealId");
        if (appealId == null) {
            appealId = request.getParameter("id");
        }
        
        PropertyFeeAppeal appeal = appealService.findById(appealId);
        request.setAttribute("module", "property");
        request.setAttribute("entity", appeal);
        request.getRequestDispatcher("/pages/owner/property/appeal-detail.jsp").forward(request, response);
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