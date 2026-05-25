package com.property.servlet;

import com.property.service.PropertyFeeDetailService;
import com.property.service.PropertyFeeBatchService;
import com.property.model.PropertyFeeDetail;
import com.property.model.PropertyFeeBatch;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

/**
 * 管理员-统计报表Servlet
 */
@WebServlet("/admin/property/report")
public class AdminPropertyReportServlet extends BaseServlet {
    
    private final PropertyFeeDetailService detailService = new PropertyFeeDetailService();
    private final PropertyFeeBatchService batchService = new PropertyFeeBatchService();
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String startMonth = request.getParameter("startMonth");
        String endMonth = request.getParameter("endMonth");
        
        // 获取所有批次
        List<PropertyFeeBatch> batches = batchService.findAll();
        Map<String, List<PropertyFeeDetail>> batchDetailsMap = new LinkedHashMap<>();
        
        for (PropertyFeeBatch batch : batches) {
            String billMonth = batch.getBillMonth();
            
            // 按月份筛选
            if (startMonth != null && !startMonth.isEmpty() && billMonth.compareTo(startMonth) < 0) {
                continue;
            }
            if (endMonth != null && !endMonth.isEmpty() && billMonth.compareTo(endMonth) > 0) {
                continue;
            }
            
            List<PropertyFeeDetail> details = detailService.findByBillMonth(billMonth);
            if (!details.isEmpty()) {
                batchDetailsMap.put(billMonth, details);
            }
        }
        
        // 统计汇总
        int totalCount = 0;
        int paidCount = 0;
        int unpaidCount = 0;
        int appealCount = 0;
        int overdueCount = 0;
        double totalAmount = 0;
        double paidAmount = 0;
        
        // 月度汇总
        List<Map<String, Object>> monthlyStats = new ArrayList<>();
        
        for (Map.Entry<String, List<PropertyFeeDetail>> entry : batchDetailsMap.entrySet()) {
            String billMonth = entry.getKey();
            List<PropertyFeeDetail> details = entry.getValue();
            
            int monthTotal = 0;
            int monthPaid = 0;
            int monthUnpaid = 0;
            int monthAppeal = 0;
            double monthTotalAmount = 0;
            double monthPaidAmount = 0;
            
            for (PropertyFeeDetail detail : details) {
                monthTotal++;
                totalCount++;
                
                if (detail.getAmount() != null) {
                    double amt = detail.getAmount().doubleValue();
                    monthTotalAmount += amt;
                    totalAmount += amt;
                }
                if (detail.getPaidAmount() != null) {
                    double paidAmt = detail.getPaidAmount().doubleValue();
                    monthPaidAmount += paidAmt;
                    paidAmount += paidAmt;
                }
                
                String status = detail.getStatus();
                if ("已缴".equals(status)) {
                    monthPaid++;
                    paidCount++;
                } else if ("未缴".equals(status)) {
                    monthUnpaid++;
                    unpaidCount++;
                } else if ("申诉中".equals(status)) {
                    monthAppeal++;
                    appealCount++;
                } else if ("逾期".equals(status)) {
                    overdueCount++;
                }
            }
            
            Map<String, Object> stats = new HashMap<>();
            stats.put("billMonth", billMonth);
            stats.put("totalCount", monthTotal);
            stats.put("paidCount", monthPaid);
            stats.put("unpaidCount", monthUnpaid);
            stats.put("appealCount", monthAppeal);
            stats.put("totalAmount", monthTotalAmount);
            stats.put("paidAmount", monthPaidAmount);
            stats.put("paymentRate", monthTotal > 0 ? (double) monthPaid / monthTotal * 100 : 0);
            monthlyStats.add(stats);
        }
        
        double paymentRate = totalCount > 0 ? (double) paidCount / totalCount * 100 : 0;
        
        request.setAttribute("startMonth", startMonth);
        request.setAttribute("endMonth", endMonth);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("paidCount", paidCount);
        request.setAttribute("unpaidCount", unpaidCount);
        request.setAttribute("appealCount", appealCount);
        request.setAttribute("overdueCount", overdueCount);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("paidAmount", paidAmount);
        request.setAttribute("paymentRate", paymentRate);
        request.setAttribute("module", "property");
        request.setAttribute("monthlyStats", monthlyStats);
        
        request.getRequestDispatcher("/pages/admin/property/report.jsp").forward(request, response);
    }
}