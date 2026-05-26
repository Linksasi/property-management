package com.property.servlet;

import com.property.dao.ResidentDAO;
import com.property.entity.Resident;
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
    private final ResidentDAO residentDAO = new ResidentDAO();
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        Object userIdObj = request.getSession().getAttribute("userId");
        String systemUserId = userIdObj != null ? userIdObj.toString() : null;
        
        // 把 SystemUser ID 转成 Resident ID
        String residentId = null;
        if (systemUserId != null) {
            Resident resident = residentDAO.findByUserId(systemUserId);
            if (resident != null) {
                residentId = resident.getResidentId();
            }
        }
        
        List<PropertyFeeDetail> list = service.findByResidentId(residentId);
        
        request.setAttribute("module", "property");
        request.setAttribute("list", list);
        request.getRequestDispatcher("/pages/owner/property/list.jsp").forward(request, response);
    }
    
    protected void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        String detailId = request.getParameter("detailId");
        if (detailId == null) {
            detailId = request.getParameter("id");
        }
        
        PropertyFeeDetail detail = service.findById(detailId);
        request.setAttribute("module", "property");
        request.setAttribute("entity", detail);
        request.getRequestDispatcher("/pages/owner/property/detail.jsp").forward(request, response);
    }
    
    protected void pay(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        
        String detailId = request.getParameter("detailId");
        if (detailId == null) {
            detailId = request.getParameter("id");
        }
        
        PropertyFeeDetail detail = service.findById(detailId);
        request.setAttribute("module", "property");
        request.setAttribute("entity", detail);
        request.getRequestDispatcher("/pages/owner/property/pay.jsp").forward(request, response);
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