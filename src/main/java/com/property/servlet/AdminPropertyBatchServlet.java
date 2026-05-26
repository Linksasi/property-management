package com.property.servlet;

import com.property.entity.Staff;
import com.property.service.PropertyFeeBatchService;
import com.property.service.PropertyFeeDetailService;
import com.property.service.PropertyStandardService;
import com.property.service.StaffService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 管理员-生成物业费批次Servlet
 */
@WebServlet("/admin/property/batch")
public class AdminPropertyBatchServlet extends BaseServlet {
    
    private final PropertyFeeBatchService batchService = new PropertyFeeBatchService();
    private final PropertyFeeDetailService detailService = new PropertyFeeDetailService();
    private final PropertyStandardService standardService = new PropertyStandardService();
    private final StaffService staffService = new StaffService();
    
    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int residentCount = detailService.countResidents();
        request.setAttribute("module", "property");
        request.setAttribute("residentCount", residentCount);
        request.setAttribute("standardList", standardService.findByStatus("生效"));
        request.getRequestDispatcher("/pages/admin/property/batch.jsp").forward(request, response);
    }
    
    /**
     * 预览账单生成
     */
    protected void preview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billMonth = request.getParameter("billMonth");
        String error = null;
        List<PropertyFeeDetailService.BatchPreviewItem> previewList = null;
        int residentCount = 0;
        
        if (billMonth == null || billMonth.isEmpty()) {
            error = "请选择计费月份";
        } else if (batchService.findByBillMonth(billMonth) != null) {
            error = "该月份的账单已存在，请勿重复生成";
        } else {
            previewList = detailService.generatePreview(billMonth);
            residentCount = detailService.countResidents();
        }
        
        request.setAttribute("module", "property");
        request.setAttribute("billMonth", billMonth);
        request.setAttribute("previewList", previewList);
        request.setAttribute("residentCount", residentCount);
        request.setAttribute("error", error);
        request.setAttribute("standardList", standardService.findByStatus("生效"));
        request.getRequestDispatcher("/pages/admin/property/batch.jsp").forward(request, response);
    }
    
    /**
     * 确认生成账单
     */
    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billMonth = request.getParameter("billMonth");
        String adminId = request.getParameter("adminId");
        
        if (adminId == null || adminId.isEmpty()) {
            Object adminIdObj = request.getSession().getAttribute("userId");
            String systemUserId = adminIdObj != null ? adminIdObj.toString() : null;
            if (systemUserId != null) {
                Staff staff = staffService.findByUserId(systemUserId);
                if (staff != null) {
                    adminId = staff.getStaffId();
                } else {
                    adminId = "ST001"; // fallback
                }
            } else {
                adminId = "ST001"; // fallback
            }
        }
        
        if (billMonth == null || billMonth.isEmpty()) {
            request.setAttribute("module", "property");
            request.setAttribute("error", "请选择计费月份");
            request.setAttribute("residentCount", detailService.countResidents());
            request.setAttribute("standardList", standardService.findByStatus("生效"));
            request.getRequestDispatcher("/pages/admin/property/batch.jsp").forward(request, response);
            return;
        }
        
        if (batchService.findByBillMonth(billMonth) != null) {
            request.setAttribute("module", "property");
            request.setAttribute("error", "该月份的账单已存在");
            request.setAttribute("residentCount", detailService.countResidents());
            request.setAttribute("standardList", standardService.findByStatus("生效"));
            request.getRequestDispatcher("/pages/admin/property/batch.jsp").forward(request, response);
            return;
        }
        
        String batchId = detailService.createBatchWithDetails(billMonth, adminId);
        
        if (batchId != null) {
            // 生成成功，跳转到明细列表
            response.sendRedirect(request.getContextPath() + "/admin/property?action=list&billMonth=" + billMonth);
        } else {
            request.setAttribute("module", "property");
            request.setAttribute("error", "生成失败，可能没有生效的收费标准或无住户数据");
            request.setAttribute("residentCount", detailService.countResidents());
            request.setAttribute("standardList", standardService.findByStatus("生效"));
            request.getRequestDispatcher("/pages/admin/property/batch.jsp").forward(request, response);
        }
    }
}