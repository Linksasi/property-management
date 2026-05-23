package com.property.servlet;

import com.property.dao.*;
import com.property.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/repair")
public class StaffRepairServlet extends HttpServlet {

    private MaintenanceWorkOrderDAO workOrderDAO = new MaintenanceWorkOrderDAO();
    private StaffDAO staffDAO = new StaffDAO();
    private RepairRequestDAO requestDAO = new RepairRequestDAO();

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
                Staff staff = staffDAO.findByUserId(user.getUserId());
                if (staff != null) {
                    List<MaintenanceWorkOrder> list = workOrderDAO.findByStaffId(staff.getStaffId());
                    req.setAttribute("list", list);
                }
                req.getRequestDispatcher("/pages/staff/repair/my_work_order.jsp").forward(req, resp);
                break;

            case "detail":
                MaintenanceWorkOrder wo = workOrderDAO.findById(req.getParameter("workOrderId"));
                req.setAttribute("order", wo);
                if (wo != null) {
                    RepairRequest rr = requestDAO.findById(wo.getRequestId());
                    req.setAttribute("request", rr);
                }
                req.getRequestDispatcher("/pages/staff/repair/work_order_detail.jsp").forward(req, resp);
                break;

            case "receive":
                workOrderDAO.receive(req.getParameter("workOrderId"));
                resp.sendRedirect(req.getContextPath() + "/staff/repair?action=list");
                break;

            case "start":
                workOrderDAO.startRepair(req.getParameter("workOrderId"));
                resp.sendRedirect(req.getContextPath() + "/staff/repair?action=list");
                break;

            case "submit":
                MaintenanceWorkOrder submitWo = workOrderDAO.findById(req.getParameter("workOrderId"));
                req.setAttribute("order", submitWo);
                req.getRequestDispatcher("/pages/staff/repair/submit_result.jsp").forward(req, resp);
                break;

            case "doSubmit":
                String woId = req.getParameter("workOrderId");
                String content = req.getParameter("repairContent");
                String materials = req.getParameter("materialsUsed");
                double hours = Double.parseDouble(req.getParameter("workHours"));
                workOrderDAO.submitResult(woId, content, materials, hours);
                resp.sendRedirect(req.getContextPath() + "/staff/repair?action=list");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/staff/repair?action=list");
        }
    }
}