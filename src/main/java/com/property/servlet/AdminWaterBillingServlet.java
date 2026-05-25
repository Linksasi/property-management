package com.property.servlet;

import com.property.dao.WaterBillingRuleDAO;
import com.property.entity.WaterBillingRule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * 管理员端 - 水费计费规则管理 Servlet
 * URL: /admin/water
 */
@WebServlet("/admin/water")
public class AdminWaterBillingServlet extends BaseServlet {

    private WaterBillingRuleDAO ruleDAO = new WaterBillingRuleDAO();

    /**
     * 水费管理首页（顶部导航入口）
     */
    protected void index(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 直接重定向到计费规则列表
        response.sendRedirect(request.getContextPath() + "/admin/water?action=list");
    }

    /**
     * 计费规则列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<WaterBillingRule> list = ruleDAO.findAll();
        request.setAttribute("list", list);
        request.setAttribute("activeTab", "billing");
        request.getRequestDispatcher("/pages/admin/water/billing-list.jsp").forward(request, response);
    }

    /**
     * 显示新增表单
     */
    protected void add(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("rule", null);
        request.setAttribute("nextId", ruleDAO.generateNextId());
        request.getRequestDispatcher("/pages/admin/water/billing-edit.jsp").forward(request, response);
    }

    /**
     * 显示编辑表单
     */
    protected void edit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ruleId = request.getParameter("id");
        if (ruleId != null && !ruleId.isEmpty()) {
            WaterBillingRule rule = ruleDAO.findById(ruleId);
            request.setAttribute("rule", rule);
        }
        request.getRequestDispatcher("/pages/admin/water/billing-edit.jsp").forward(request, response);
    }

    /**
     * 保存（新增或更新）
     */
    protected void save(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ruleId = request.getParameter("ruleId");
        String ruleName = request.getParameter("ruleName");
        String basePriceStr = request.getParameter("basePrice");
        String pressurePriceStr = request.getParameter("pressurePrice");
        String pressureFloorStr = request.getParameter("pressureFloor");
        String tier1ThresholdStr = request.getParameter("tier1Threshold");
        String tier1MultiplierStr = request.getParameter("tier1Multiplier");
        String tier2ThresholdStr = request.getParameter("tier2Threshold");
        String tier2MultiplierStr = request.getParameter("tier2Multiplier");
        String effectiveDateStr = request.getParameter("effectiveDate");
        String status = request.getParameter("status");

        WaterBillingRule rule = new WaterBillingRule();
        rule.setRuleId(ruleId);
        rule.setRuleName(ruleName);
        rule.setBasePrice(new BigDecimal(basePriceStr));
        rule.setPressurePrice(new BigDecimal(pressurePriceStr));
        rule.setPressureFloor(Integer.parseInt(pressureFloorStr));
        rule.setTier1Threshold(new BigDecimal(tier1ThresholdStr));
        rule.setTier1Multiplier(new BigDecimal(tier1MultiplierStr));
        rule.setTier2Threshold(new BigDecimal(tier2ThresholdStr));
        rule.setTier2Multiplier(new BigDecimal(tier2MultiplierStr));
        rule.setEffectiveDate(LocalDate.parse(effectiveDateStr));
        rule.setStatus(status != null && !status.isEmpty() ? status : "生效");

        // 检查是新增还是更新
        WaterBillingRule existing = ruleDAO.findById(ruleId);
        if (existing != null) {
            ruleDAO.update(rule);
        } else {
            ruleDAO.insert(rule);
        }

        response.sendRedirect(request.getContextPath() + "/admin/water?action=list");
    }

    /**
     * 删除计费规则
     */
    protected void delete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ruleId = request.getParameter("id");
        if (ruleId != null && !ruleId.isEmpty()) {
            ruleDAO.delete(ruleId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/water?action=list");
    }

    /**
     * 启用/停用计费规则
     */
    protected void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ruleId = request.getParameter("id");
        if (ruleId != null && !ruleId.isEmpty()) {
            ruleDAO.toggleStatus(ruleId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/water?action=list");
    }
}
