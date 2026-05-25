package com.property.servlet;

import com.property.service.PropertyStandardService;
import com.property.model.PropertyStandard;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 管理员-收费标准管理Servlet
 */
@WebServlet("/admin/property/standard")
public class AdminPropertyStandardServlet extends BaseServlet {
    
    private final PropertyStandardService service = new PropertyStandardService();
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<PropertyStandard> list = service.findAll();
        request.setAttribute("module", "property");
        request.setAttribute("list", list);
        request.getRequestDispatcher("/pages/admin/property/standard-list.jsp").forward(request, response);
    }
    
    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("module", "property");
        request.setAttribute("entity", new PropertyStandard());
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/pages/admin/property/standard-edit.jsp").forward(request, response);
    }
    
    protected void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String standardId = request.getParameter("standardId");
        if (standardId == null) {
            standardId = request.getParameter("id");
        }
        
        PropertyStandard standard = service.findById(standardId);
        request.setAttribute("module", "property");
        request.setAttribute("entity", standard);
        request.setAttribute("isEdit", true);
        request.getRequestDispatcher("/pages/admin/property/standard-edit.jsp").forward(request, response);
    }
    
    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String standardId = request.getParameter("standardId");
        String feeType = request.getParameter("feeType");
        String unitPriceStr = request.getParameter("unitPrice");
        String effectiveDateStr = request.getParameter("effectiveDate");
        String status = request.getParameter("status");
        
        PropertyStandard standard = new PropertyStandard();
        if (standardId != null && !standardId.isEmpty()) {
            standard.setStandardId(standardId);
        }
        standard.setFeeType(feeType);
        standard.setUnitPrice(new java.math.BigDecimal(unitPriceStr));
        
        try {
            standard.setEffectiveDate(java.sql.Date.valueOf(effectiveDateStr));
        } catch (Exception e) {
            standard.setEffectiveDate(new java.util.Date());
        }
        standard.setStatus(status != null ? status : "生效");
        
        boolean success;
        if (standardId != null && !standardId.isEmpty()) {
            success = service.update(standard);
        } else {
            success = service.insert(standard);
        }
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/property/standard?action=list");
        } else {
            request.setAttribute("module", "property");
            request.setAttribute("error", "保存失败");
            request.setAttribute("entity", standard);
            request.setAttribute("isEdit", standardId != null && !standardId.isEmpty());
            request.getRequestDispatcher("/pages/admin/property/standard-edit.jsp").forward(request, response);
        }
    }
    
    protected void disable(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String standardId = request.getParameter("standardId");
        if (standardId == null) {
            standardId = request.getParameter("id");
        }
        service.disable(standardId);
        response.sendRedirect(request.getContextPath() + "/admin/property/standard?action=list");
    }
    
    protected void enable(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String standardId = request.getParameter("standardId");
        if (standardId == null) {
            standardId = request.getParameter("id");
        }
        service.enable(standardId);
        response.sendRedirect(request.getContextPath() + "/admin/property/standard?action=list");
    }
    
    protected void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String standardId = request.getParameter("standardId");
        if (standardId == null) {
            standardId = request.getParameter("id");
        }
        service.delete(standardId);
        response.sendRedirect(request.getContextPath() + "/admin/property/standard?action=list");
    }
}