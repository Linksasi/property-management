package com.property.servlet;

import com.property.dao.WaterFeeBillDAO;
import com.property.entity.WaterFeeBill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员端 - 用水统计 Servlet
 * URL: /admin/waterStat
 */
@WebServlet("/admin/waterStat")
public class AdminWaterStatServlet extends BaseServlet {

    private WaterFeeBillDAO billDAO = new WaterFeeBillDAO();

    /**
     * 统计列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String startMonth = request.getParameter("startMonth");
        String endMonth = request.getParameter("endMonth");
        String building = request.getParameter("building");

        // 获取所有账单
        List<WaterFeeBill> allBills = billDAO.findAll();

        // 按月份统计
        Map<String, MonthlyStat> monthlyStats = new HashMap<>();
        // 按楼栋统计
        Map<String, BuildingStat> buildingStats = new HashMap<>();

        for (WaterFeeBill bill : allBills) {
            String billMonth = bill.getBillMonth();
            String addr = bill.getHousingAddress();
            String bld = extractBuilding(addr);

            // 月份筛选
            if (startMonth != null && !startMonth.isEmpty() && billMonth.compareTo(startMonth) < 0) {
                continue;
            }
            if (endMonth != null && !endMonth.isEmpty() && billMonth.compareTo(endMonth) > 0) {
                continue;
            }

            // 楼栋筛选
            if (building != null && !building.isEmpty() && !building.equals(bld)) {
                continue;
            }

            // 累加月份统计
            MonthlyStat mStat = monthlyStats.get(billMonth);
            if (mStat == null) {
                mStat = new MonthlyStat();
                mStat.month = billMonth;
                monthlyStats.put(billMonth, mStat);
            }
            mStat.totalUsage = mStat.totalUsage.add(bill.getUsage() != null ? bill.getUsage() : BigDecimal.ZERO);
            mStat.totalAmount = mStat.totalAmount.add(bill.getAmount() != null ? bill.getAmount() : BigDecimal.ZERO);
            mStat.billCount++;

            // 累加楼栋统计
            if (bld != null && !bld.isEmpty()) {
                BuildingStat bs = buildingStats.get(bld);
                if (bs == null) {
                    bs = new BuildingStat();
                    bs.building = bld;
                    buildingStats.put(bld, bs);
                }
                bs.totalUsage = bs.totalUsage.add(bill.getUsage() != null ? bill.getUsage() : BigDecimal.ZERO);
                bs.totalAmount = bs.totalAmount.add(bill.getAmount() != null ? bill.getAmount() : BigDecimal.ZERO);
                bs.residentCount++;
            }
        }

        // 转换为列表并排序
        List<MonthlyStat> monthlyList = new ArrayList<>(monthlyStats.values());
        monthlyList.sort((a, b) -> b.month.compareTo(a.month));

        List<BuildingStat> buildingList = new ArrayList<>(buildingStats.values());
        buildingList.sort((a, b) -> b.totalUsage.compareTo(a.totalUsage));

        request.setAttribute("monthlyList", monthlyList);
        request.setAttribute("buildingList", buildingList);
        request.setAttribute("startMonth", startMonth);
        request.setAttribute("endMonth", endMonth);
        request.setAttribute("selectedBuilding", building);
        request.setAttribute("activeTab", "stat");
        request.getRequestDispatcher("/pages/admin/water/statistics.jsp").forward(request, response);
    }

    private String extractBuilding(String address) {
        if (address == null || address.isEmpty()) return "";
        int idx = address.indexOf("栋");
        if (idx > 0) {
            return address.substring(0, idx);
        }
        return "";
    }

    /**
     * 月度统计包装类
     */
    public static class MonthlyStat {
        public String month;
        public BigDecimal totalUsage = BigDecimal.ZERO;
        public BigDecimal totalAmount = BigDecimal.ZERO;
        public int billCount;

        public String getMonth() { return month; }
        public BigDecimal getTotalUsage() { return totalUsage; }
        public BigDecimal getTotalAmount() { return totalAmount; }
        public int getBillCount() { return billCount; }
    }

    /**
     * 楼栋统计包装类
     */
    public static class BuildingStat {
        public String building;
        public BigDecimal totalUsage = BigDecimal.ZERO;
        public BigDecimal totalAmount = BigDecimal.ZERO;
        public int residentCount;

        public String getBuilding() { return building; }
        public BigDecimal getTotalUsage() { return totalUsage; }
        public BigDecimal getTotalAmount() { return totalAmount; }
        public int getResidentCount() { return residentCount; }
    }
}
