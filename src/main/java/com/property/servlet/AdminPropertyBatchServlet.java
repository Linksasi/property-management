package com.property.servlet;

import com.property.service.PropertyFeeBatchService;
import com.property.service.PropertyFeeDetailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 管理员-生成物业费批次Servlet
 */
@WebServlet("/admin/property/batch")
public class AdminPropertyBatchServlet extends BaseServlet {
    
    private final PropertyFeeBatchService batchService = new PropertyFeeBatchService();
    private final PropertyFeeDetailService detailService = new PropertyFeeDetailService();
    
    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int residentCount = detailService.countResidents();
        request.setAttribute("residentCount", residentCount);
        request.getRequestDispatcher("/pages/admin/property/batch.jsp").forward(request, response);
    }
    
    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billMonth = request.getParameter("billMonth");
        String adminId = request.getParameter("adminId");
        
        if (adminId == null || adminId.isEmpty()) {
            Object adminIdObj = request.getSession().getAttribute("userId");
            adminId = adminIdObj != null ? adminIdObj.toString() : "ADMIN001";
        }
        
        if (batchService.findByBillMonth(billMonth) != null) {
            request.setAttribute("error", "该月份的账单已存在");
            request.setAttribute("residentCount", detailService.countResidents());
            request.getRequestDispatcher("/pages/admin/property/batch.jsp").forward(request, response);
            return;
        }
        
        boolean success = batchService.createBatch(billMonth, adminId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/property?action=list");
        } else {
            request.setAttribute("error", "生成失败，该月份账单可能已存在");
            request.setAttribute("residentCount", detailService.countResidents());
            request.getRequestDispatcher("/pages/admin/property/batch.jsp").forward(request, response);
        }
    }
}