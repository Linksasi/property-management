package com.property.servlet;

import com.property.dao.*;
import com.property.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/parking")
public class AdminParkingServlet extends HttpServlet {

    private ParkingSpaceDAO spaceDAO = new ParkingSpaceDAO();
    private ParkingApplyDAO applyDAO = new ParkingApplyDAO();
    private ParkingStandardDAO standardDAO = new ParkingStandardDAO();
    private ParkingFeeRecordDAO feeRecordDAO = new ParkingFeeRecordDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "list";

        SystemUser user = (SystemUser) req.getSession().getAttribute("currentUser");

        switch (action) {
            case "list":
                String sortOrder = req.getParameter("sortOrder");
                if (sortOrder == null || sortOrder.isEmpty()) sortOrder = "asc";
                String status = req.getParameter("status");
                String location = req.getParameter("location");
                String overdue = req.getParameter("overdue");
                List<ParkingSpace> list = spaceDAO.findAll(sortOrder, status, location, overdue);
                req.setAttribute("list", list);
                req.setAttribute("sortOrder", sortOrder);
                req.setAttribute("filterStatus", status);
                req.setAttribute("filterLocation", location);
                req.setAttribute("filterOverdue", overdue);
                req.getRequestDispatcher("/pages/admin/parking/list.jsp").forward(req, resp);
                break;

            case "detail":
                ParkingSpace sp = spaceDAO.findById(req.getParameter("spaceId"));
                req.setAttribute("space", sp);
                if (sp != null) {
                    List<ParkingFeeRecord> feeRecords = spaceDAO.findFeeRecordsBySpaceId(sp.getSpaceId());
                    req.setAttribute("feeRecords", feeRecords);
                }
                req.getRequestDispatcher("/pages/admin/parking/detail.jsp").forward(req, resp);
                break;

            case "unbind":
                spaceDAO.unbind(req.getParameter("spaceId"));
                resp.sendRedirect(req.getContextPath() + "/admin/parking?action=list");
                break;

            case "applyList":
                List<ParkingApply> applyList = applyDAO.findAll();
                req.setAttribute("applyList", applyList);
                req.getRequestDispatcher("/pages/admin/parking/apply-list.jsp").forward(req, resp);
                break;

            case "auditApply":
                String applyId = req.getParameter("applyId");
                boolean approved = "1".equals(req.getParameter("approved"));
                String reason = req.getParameter("reason");
                String adminId = (String) req.getSession().getAttribute("staffId");
                boolean audited = applyDAO.audit(applyId, adminId, approved, reason);
                if (approved && audited) {
                    ParkingApply pa = applyDAO.findById(applyId);
                    if (pa != null) {
                        ParkingSpace ps = spaceDAO.findById(pa.getSpaceId());
                        // bind the space
                        spaceDAO.bind(pa.getSpaceId(), pa.getResidentId());
                        // generate bills for N months
                        if (ps != null) {
                            double price = standardDAO.getPriceByType(ps.getType());
                            if (price <= 0) price = 200; // fallback
                            int months = pa.getMonths();
                            if (months < 1) months = 1;
                            java.time.LocalDate today = java.time.LocalDate.now();
                            for (int i = 0; i < months; i++) {
                                ParkingFeeRecord record = new ParkingFeeRecord();
                                record.setRecordId(feeRecordDAO.generateRecordId());
                                record.setSpaceId(pa.getSpaceId());
                                record.setAmount(price);
                                record.setMonth(today.plusMonths(i).toString().substring(0, 7));
                                feeRecordDAO.insertBill(record);
                            }
                        }
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/admin/parking?action=applyList");
                break;

            case "standardList":
                List<ParkingStandard> standards = standardDAO.findAll();
                req.setAttribute("standards", standards);
                req.getRequestDispatcher("/pages/admin/parking/standard-list.jsp").forward(req, resp);
                break;

            case "saveStandardPrices":
                standardDAO.upsertPrice("地下一层A区", Double.parseDouble(req.getParameter("price_A")));
                standardDAO.upsertPrice("地下一层B区", Double.parseDouble(req.getParameter("price_B")));
                standardDAO.upsertPrice("地下一层C区", Double.parseDouble(req.getParameter("price_C")));
                standardDAO.upsertPrice("户外停车场", Double.parseDouble(req.getParameter("price_outdoor")));
                req.setAttribute("msg", "月费标准已更新，即刻生效！");
                req.setAttribute("standards", standardDAO.findAll());
                req.getRequestDispatcher("/pages/admin/parking/standard-list.jsp").forward(req, resp);
                break;

            case "statistics":
                req.getRequestDispatcher("/pages/admin/parking/statistics.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/parking?action=list");
        }
    }
}