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
 * 管理员-统计报表Servlet
 */
@WebServlet("/admin/property/report")
public class AdminPropertyReportServlet extends BaseServlet {
    
    private final PropertyFeeDetailService service = new PropertyFeeDetailService();
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<PropertyFeeDetail> allDetails = service.findAll();
        
        int totalCount = allDetails.size();
        int paidCount = 0;
        int unpaidCount = 0;
        int appealCount = 0;
        int overdueCount = 0;
        double totalAmount = 0;
        double paidAmount = 0;
        
        for (PropertyFeeDetail detail : allDetails) {
            if (detail.getAmount() != null) {
                totalAmount += detail.getAmount().doubleValue();
            }
            if (detail.getPaidAmount() != null) {
                paidAmount += detail.getPaidAmount().doubleValue();
            }
            
            String status = detail.getStatus();
            if ("已缴".equals(status)) {
                paidCount++;
            } else if ("未缴".equals(status)) {
                unpaidCount++;
            } else if ("申诉中".equals(status)) {
                appealCount++;
            } else if ("逾期".equals(status)) {
                overdueCount++;
            }
        }
        
        double paymentRate = totalCount > 0 ? (double) paidCount / totalCount * 100 : 0;
        
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("paidCount", paidCount);
        request.setAttribute("unpaidCount", unpaidCount);
        request.setAttribute("appealCount", appealCount);
        request.setAttribute("overdueCount", overdueCount);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("paidAmount", paidAmount);
        request.setAttribute("paymentRate", paymentRate);
        
        request.getRequestDispatcher("/pages/admin/property/report.jsp").forward(request, response);
    }
}