package com.property.servlet;

import com.property.dao.HousingDAO;
import com.property.dao.WaterBillingRuleDAO;
import com.property.dao.WaterFeeBillDAO;
import com.property.dao.WaterMeterDAO;
import com.property.entity.Housing;
import com.property.entity.WaterBillingRule;
import com.property.entity.WaterFeeBill;
import com.property.entity.WaterMeter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * 管理员端 - 水表管理 Servlet
 * URL: /admin/waterMeter
 */
@WebServlet("/admin/waterMeter")
public class AdminWaterMeterServlet extends BaseServlet {

    private WaterMeterDAO meterDAO = new WaterMeterDAO();
    private HousingDAO housingDAO = new HousingDAO();
    private WaterFeeBillDAO billDAO = new WaterFeeBillDAO();
    private WaterBillingRuleDAO ruleDAO = new WaterBillingRuleDAO();

    /**
     * 水表列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<WaterMeter> list = meterDAO.findAll();
        request.setAttribute("list", list);
        request.getRequestDispatcher("/pages/admin/water/meter-list.jsp").forward(request, response);
    }

    /**
     * 显示新增表单
     */
    protected void add(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("meter", null);
        request.setAttribute("nextId", meterDAO.generateNextId());
        // 获取所有住房用于选择
        List<Housing> houses = housingDAO.findAll();
        request.setAttribute("houses", houses);
        request.getRequestDispatcher("/pages/admin/water/meter-edit.jsp").forward(request, response);
    }

    /**
     * 显示编辑表单
     */
    protected void edit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String meterId = request.getParameter("id");
        if (meterId != null && !meterId.isEmpty()) {
            WaterMeter meter = meterDAO.findById(meterId);
            request.setAttribute("meter", meter);
        }
        // 获取所有住房用于选择
        List<Housing> houses = housingDAO.findAll();
        request.setAttribute("houses", houses);
        request.getRequestDispatcher("/pages/admin/water/meter-edit.jsp").forward(request, response);
    }

    /**
     * 保存（新增或更新）
     */
    protected void save(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String meterId = request.getParameter("meterId");
        String housingId = request.getParameter("housingId");
        String installDateStr = request.getParameter("installDate");
        String initialReadStr = request.getParameter("initialRead");
        String currentReadStr = request.getParameter("currentRead");
        String lastReadStr = request.getParameter("lastRead");
        String lastReadDateStr = request.getParameter("lastReadDate");
        String status = request.getParameter("status");

        WaterMeter meter = new WaterMeter();
        meter.setMeterId(meterId);
        meter.setHousingId(housingId);
        meter.setInstallDate(installDateStr != null && !installDateStr.isEmpty() ? LocalDate.parse(installDateStr) : null);
        meter.setInitialRead(initialReadStr != null && !initialReadStr.isEmpty() ? new BigDecimal(initialReadStr) : BigDecimal.ZERO);
        meter.setCurrentRead(currentReadStr != null && !currentReadStr.isEmpty() ? new BigDecimal(currentReadStr) : BigDecimal.ZERO);
        meter.setLastRead(lastReadStr != null && !lastReadStr.isEmpty() ? new BigDecimal(lastReadStr) : null);
        meter.setLastReadDate(lastReadDateStr != null && !lastReadDateStr.isEmpty() ? LocalDate.parse(lastReadDateStr) : null);
        meter.setUpdateDate(LocalDate.now());
        meter.setStatus(status != null && !status.isEmpty() ? status : "正常");

        // 检查是新增还是更新
        WaterMeter existing = meterDAO.findById(meterId);
        if (existing != null) {
            meterDAO.update(meter);
        } else {
            meterDAO.insert(meter);
        }

        response.sendRedirect(request.getContextPath() + "/admin/waterMeter?action=list");
    }

    /**
     * 删除水表
     */
    protected void delete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String meterId = request.getParameter("id");
        if (meterId != null && !meterId.isEmpty()) {
            meterDAO.delete(meterId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/waterMeter?action=list");
    }

    /**
     * 抄表录入页面
     */
    protected void meterRead(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<WaterMeter> list = meterDAO.findAll();
        request.setAttribute("list", list);
        request.setAttribute("today", LocalDate.now().toString());
        request.getRequestDispatcher("/pages/admin/water/meter-read.jsp").forward(request, response);
    }

    /**
     * 批量保存抄表记录
     */
    protected void saveReading(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String[] meterIds = request.getParameterValues("meterId");
            String[] currentReads = request.getParameterValues("currentRead");
            String[] readDates = request.getParameterValues("readDate");

            System.out.println(">>> saveReading START");
            System.out.println("meterIds=" + (meterIds == null ? "NULL" : java.util.Arrays.toString(meterIds)));
            System.out.println("currentReads=" + (currentReads == null ? "NULL" : java.util.Arrays.toString(currentReads)));
            System.out.println("readDates=" + (readDates == null ? "NULL" : java.util.Arrays.toString(readDates)));

            if (meterIds != null) {
                // 获取生效的计费规则
                List<WaterBillingRule> rules = ruleDAO.findAll();
                WaterBillingRule rule = rules.stream()
                        .filter(r -> "生效".equals(r.getStatus()))
                        .findFirst().orElse(null);
                System.out.println("rule=" + (rule != null ? rule.getRuleName() : "NULL"));

                for (int i = 0; i < meterIds.length; i++) {
                    String meterId = meterIds[i];
                    String currentReadStr = (currentReads != null && i < currentReads.length) ? currentReads[i] : "";
                    String readDateStr = (readDates != null && i < readDates.length) ? readDates[i] : "";
                    System.out.println("i=" + i + " meterId=" + meterId + " currentRead=" + currentReadStr + " readDate=" + readDateStr);

                    if (currentReadStr == null || currentReadStr.trim().isEmpty()) continue;

                    WaterMeter meter;
                    try {
                        meter = meterDAO.findById(meterId);
                    } catch (Exception e) {
                        e.printStackTrace();
                        continue;
                    }
                    if (meter == null) continue;

                    BigDecimal currentRead = new BigDecimal(currentReadStr);
                    LocalDate readDate = (readDateStr != null && !readDateStr.isEmpty())
                            ? LocalDate.parse(readDateStr) : LocalDate.now();
                    String billMonth = readDate.format(DateTimeFormatter.ofPattern("yyyy-MM"));

                    // 防重：同一水表同月份不重复生成
                    boolean exists = billDAO.existsByMeterIdAndMonth(meterId, billMonth);
                    System.out.println("exists=" + exists);
                    if (exists) continue;

                    // 1. 更新水表读数
                    BigDecimal lastRead = meter.getCurrentRead() != null ? meter.getCurrentRead() : BigDecimal.ZERO;
                    System.out.println("lastRead=" + lastRead + " residentId=" + meter.getResidentId());
                    meter.setLastRead(lastRead);
                    meter.setLastReadDate(readDate);  // 上次抄录时间就是这次抄表的日期
                    meter.setCurrentRead(currentRead);
                    meter.setUpdateDate(readDate);
                    meterDAO.update(meter);
                    System.out.println("meter updated");

                    // 2. 计算用水量和费用
                    BigDecimal usage = currentRead.subtract(lastRead);
                    System.out.println("usage=" + usage);
                    if (usage.compareTo(BigDecimal.ZERO) <= 0) continue;

                    // 根据计费规则计算金额
                    BigDecimal amount = calculateWaterFee(usage, rule);
                    System.out.println("amount=" + amount);

                    // 3. 生成水费账单
                    WaterFeeBill bill = new WaterFeeBill();
                    bill.setMeterId(meterId);
                    bill.setResidentId(meter.getResidentId());
                    bill.setBillMonth(billMonth);
                    bill.setLastRead(lastRead);
                    bill.setCurrentRead(currentRead);
                    bill.setUsage(usage);
                    bill.setUnitPrice(rule != null ? rule.getBasePrice() : new BigDecimal("3.50"));
                    bill.setAmount(amount);
                    bill.setStatus("未缴");
                    bill.setDueDate(readDate.plusMonths(1).withDayOfMonth(15));
                    System.out.println("inserting bill...");
                    billDAO.insert(bill);
                    System.out.println("bill inserted OK");
                }
            }

            System.out.println("<<< saveReading END, redirecting");
            response.sendRedirect(request.getContextPath() + "/admin/waterMeter?action=list");
        } catch (Exception e) {
            System.out.println("!!! saveReading EXCEPTION: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/waterMeter?action=list");
        }
    }

    /**
     * 按阶梯水价计算水费
     */
    private BigDecimal calculateWaterFee(BigDecimal usage, WaterBillingRule rule) {
        if (rule == null) {
            return usage.multiply(new BigDecimal("3.50")).setScale(2, RoundingMode.HALF_UP);
        }
        BigDecimal base = rule.getBasePrice();
        BigDecimal tier1 = rule.getTier1Threshold();
        BigDecimal tier2 = rule.getTier2Threshold();
        BigDecimal m1 = rule.getTier1Multiplier();
        BigDecimal m2 = rule.getTier2Multiplier();

        BigDecimal amount = BigDecimal.ZERO;
        if (usage.compareTo(tier1) <= 0) {
            amount = usage.multiply(base);
        } else if (usage.compareTo(tier2) <= 0) {
            amount = tier1.multiply(base)
                    .add(usage.subtract(tier1).multiply(base).multiply(m1));
        } else {
            amount = tier1.multiply(base)
                    .add(tier2.subtract(tier1).multiply(base).multiply(m1))
                    .add(usage.subtract(tier2).multiply(base).multiply(m2));
        }
        return amount.setScale(2, RoundingMode.HALF_UP);
    }
}
