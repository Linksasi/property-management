package com.property.servlet;

import com.property.dao.*;
import com.property.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/owner/parking")
public class OwnerParkingServlet extends HttpServlet {

    private ParkingSpaceDAO spaceDAO = new ParkingSpaceDAO();
    private ParkingApplyDAO applyDAO = new ParkingApplyDAO();
    private ParkingFeeRecordDAO feeDAO = new ParkingFeeRecordDAO();
    private ParkingStandardDAO standardDAO = new ParkingStandardDAO();
    private ResidentDAO residentDAO = new ResidentDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "list";

        SystemUser user = (SystemUser) req.getSession().getAttribute("currentUser");
        Resident resident = residentDAO.findByUserId(user.getUserId());

        if (resident == null) {
            req.getSession().setAttribute("error", "未找到您的住户信息，请联系管理员绑定房屋");
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        switch (action) {
            case "list":
                List<ParkingSpace> list = spaceDAO.findByResidentId(resident.getResidentId());
                req.setAttribute("list", list);
                req.getRequestDispatcher("/pages/owner/parking/list.jsp").forward(req, resp);
                break;

            case "query":
                String sortOrder = req.getParameter("sortOrder");
                if (sortOrder == null || sortOrder.isEmpty()) sortOrder = "asc";
                String status = req.getParameter("status");
                String location = req.getParameter("location");
                List<ParkingSpace> available = spaceDAO.findAll(sortOrder, status, location, null);
                req.setAttribute("available", available);
                req.setAttribute("sortOrder", sortOrder);
                req.setAttribute("filterStatus", status);
                req.setAttribute("filterLocation", location);
                req.getRequestDispatcher("/pages/owner/parking/query.jsp").forward(req, resp);
                break;

            case "apply":
                String spaceId = req.getParameter("spaceId");
                ParkingSpace sp = spaceDAO.findById(spaceId);
                req.setAttribute("space", sp);
                req.getRequestDispatcher("/pages/owner/parking/apply.jsp").forward(req, resp);
                break;

            case "submitApply":
                ParkingApply pa = new ParkingApply();
                pa.setApplyId(applyDAO.generateId());
                pa.setSpaceId(req.getParameter("spaceId"));
                pa.setResidentId(resident.getResidentId());
                int months = 1;
                try { months = Integer.parseInt(req.getParameter("months")); } catch (Exception e) {}
                if (months < 1) months = 1;
                pa.setMonths(months);
                applyDAO.insert(pa);
                resp.sendRedirect(req.getContextPath() + "/owner/parking?action=query");
                break;

            case "feeList":
                List<ParkingFeeRecord> fees = feeDAO.findByResidentId(resident.getResidentId());
                req.setAttribute("fees", fees);
                req.getRequestDispatcher("/pages/owner/parking/fee-list.jsp").forward(req, resp);
                break;

            case "feeDetail":
                ParkingFeeRecord pf = feeDAO.findById(req.getParameter("recordId"));
                req.setAttribute("fee", pf);
                req.getRequestDispatcher("/pages/owner/parking/fee-detail.jsp").forward(req, resp);
                break;

            case "pay":
                String recordIdsParam = req.getParameter("recordIds");
                if (recordIdsParam != null && !recordIdsParam.isEmpty()) {
                    // multi-record combined payment
                    String[] ids = recordIdsParam.split(",");
                    List<ParkingFeeRecord> feeList = new ArrayList<>();
                    for (String id : ids) {
                        ParkingFeeRecord f = feeDAO.findById(id.trim());
                        if (f != null) feeList.add(f);
                    }
                    req.setAttribute("feeList", feeList);
                } else {
                    // single record
                    ParkingFeeRecord feeRecord = feeDAO.findById(req.getParameter("recordId"));
                    req.setAttribute("fee", feeRecord);
                }
                req.getRequestDispatcher("/pages/owner/parking/pay.jsp").forward(req, resp);
                break;

            case "doPay":
                String rids = req.getParameter("recordIds");
                double totalAmt = Double.parseDouble(req.getParameter("amount"));
                String method = req.getParameter("payMethod");
                String txnNo = "TXN" + System.currentTimeMillis();
                List<ParkingFeeRecord> paidList = new ArrayList<>();
                if (rids != null && rids.contains(",")) {
                    // multiple records
                    String[] idArr = rids.split(",");
                    double eachAmt = totalAmt / idArr.length;
                    for (String id : idArr) {
                        feeDAO.pay(id.trim(), eachAmt, method, txnNo);
                        ParkingFeeRecord f = feeDAO.findById(id.trim());
                        if (f != null) paidList.add(f);
                    }
                } else {
                    // single record
                    feeDAO.pay(rids, totalAmt, method, txnNo);
                    ParkingFeeRecord paidRecord = feeDAO.findById(rids);
                    if (paidRecord != null) paidList.add(paidRecord);
                }
                req.setAttribute("feeList", paidList);
                req.setAttribute("txnNo", txnNo);
                req.getRequestDispatcher("/pages/owner/parking/voucher.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/owner/parking?action=list");
        }
    }
}