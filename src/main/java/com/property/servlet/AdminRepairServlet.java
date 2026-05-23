package com.property.servlet;

import com.property.dao.*;
import com.property.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/repair")
public class AdminRepairServlet extends HttpServlet {

    private RepairRequestDAO requestDAO = new RepairRequestDAO();
    private MaintenanceWorkOrderDAO workOrderDAO = new MaintenanceWorkOrderDAO();
    private StaffDAO staffDAO = new StaffDAO();

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
                List<RepairRequest> list = requestDAO.findAll();
                req.setAttribute("list", list);
                req.getRequestDispatcher("/pages/admin/repair/repair_list.jsp").forward(req, resp);
                break;

            case "detail":
                RepairRequest detail = requestDAO.findById(req.getParameter("requestId"));
                req.setAttribute("detail", detail);
                req.getRequestDispatcher("/pages/admin/repair/repair_detail.jsp").forward(req, resp);
                break;

            case "audit":
                RepairRequest toAudit = requestDAO.findById(req.getParameter("requestId"));
                req.setAttribute("detail", toAudit);
                req.setAttribute("staffList", staffDAO.findAllNonAdmin());
                req.getRequestDispatcher("/pages/admin/repair/audit.jsp").forward(req, resp);
                break;

            case "doAudit":
                String requestId = req.getParameter("requestId");
                boolean approved = "1".equals(req.getParameter("approved"));
                String reason = req.getParameter("reason");

                // 通过时必须选择维修人员
                if (approved) {
                    String staffId = req.getParameter("staffId");
                    if (staffId == null || staffId.isEmpty()) {
                        req.getSession().setAttribute("error", "请选择维修人员");
                        resp.sendRedirect(req.getContextPath() + "/admin/repair?action=audit&requestId=" + requestId);
                        return;
                    }
                }

                // 获取当前管理员对应的 staff_id
                Staff adminStaff = staffDAO.findByUserId(user.getUserId());
                String adminId = adminStaff != null ? adminStaff.getStaffId() : user.getUserId();
                requestDAO.audit(requestId, approved, reason, adminId);

                if (approved) {
                    MaintenanceWorkOrder wo = new MaintenanceWorkOrder();
                    wo.setWorkOrderId(workOrderDAO.generateId());
                    wo.setRequestId(requestId);
                    wo.setStaffId(req.getParameter("staffId"));
                    wo.setAdminId(user.getUserId());
                    workOrderDAO.insert(wo);
                }
                resp.sendRedirect(req.getContextPath() + "/admin/repair?action=list");
                break;

            case "orderList":
                List<MaintenanceWorkOrder> orders = workOrderDAO.findAll();
                req.setAttribute("orders", orders);
                req.getRequestDispatcher("/pages/admin/repair/order-list.jsp").forward(req, resp);
                break;

            case "orderDetail":
                String workOrderId = req.getParameter("workOrderId");
                MaintenanceWorkOrder woDetail;
                if (workOrderId != null && !workOrderId.isEmpty()) {
                    woDetail = workOrderDAO.findById(workOrderId);
                } else {
                    woDetail = workOrderDAO.findByRequestId(req.getParameter("requestId"));
                }
                if (woDetail != null) {
                    RepairRequest rr = requestDAO.findById(woDetail.getRequestId());
                    req.setAttribute("order", woDetail);
                    req.setAttribute("request", rr);
                }
                req.getRequestDispatcher("/pages/admin/repair/order-detail.jsp").forward(req, resp);
                break;

            case "statistics":
                req.getRequestDispatcher("/pages/admin/repair/statistics.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/repair?action=list");
        }
    }
}