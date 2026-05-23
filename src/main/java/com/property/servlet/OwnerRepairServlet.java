package com.property.servlet;

import com.property.dao.*;
import com.property.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/owner/repair")
public class OwnerRepairServlet extends HttpServlet {

    private RepairRequestDAO requestDAO = new RepairRequestDAO();
    private MaintenanceWorkOrderDAO workOrderDAO = new MaintenanceWorkOrderDAO();
    private ResidentDAO residentDAO = new ResidentDAO();
    private HousingDAO housingDAO = new HousingDAO();

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
                List<RepairRequest> list = requestDAO.findByUserId(user.getUserId());
                for (RepairRequest rr : list) {
                    if ("已派工".equals(rr.getStatus()) || "待确认".equals(rr.getStatus()) || "已完成".equals(rr.getStatus())) {
                        rr.setWorkOrder(workOrderDAO.findByRequestId(rr.getRequestId()));
                    }
                }
                req.setAttribute("list", list);
                req.getRequestDispatcher("/pages/owner/repair/my_repair_list.jsp").forward(req, resp);
                break;

            case "apply":
                List<Housing> housings = housingDAO.findByResidentId(resident.getResidentId());
                req.setAttribute("housings", housings);
                req.setAttribute("residentPhone", resident.getPhone());
                req.getRequestDispatcher("/pages/owner/repair/apply.jsp").forward(req, resp);
                break;

            case "detail":
                String requestId = req.getParameter("requestId");
                RepairRequest detail = requestDAO.findById(requestId);
                if (detail != null && ("已派工".equals(detail.getStatus()) || "待确认".equals(detail.getStatus()) || "已完成".equals(detail.getStatus()))) {
                    detail.setWorkOrder(workOrderDAO.findByRequestId(requestId));
                }
                if (detail != null) detail.setResidentPhone(resident.getPhone());
                req.setAttribute("detail", detail);
                req.getRequestDispatcher("/pages/owner/repair/repair_detail.jsp").forward(req, resp);
                break;

            case "submit":
                RepairRequest rr = new RepairRequest();
                rr.setRequestId(requestDAO.generateId());
                rr.setUserId(user.getUserId());
                rr.setHousingId(req.getParameter("housingId"));
                rr.setRepairType(req.getParameter("repairType"));
                rr.setDescription(req.getParameter("description"));
                rr.setUrgency(req.getParameter("urgency"));
                requestDAO.insert(rr);
                resp.sendRedirect(req.getContextPath() + "/owner/repair?action=list");
                break;

            case "cancel":
                requestDAO.cancel(req.getParameter("requestId"));
                resp.sendRedirect(req.getContextPath() + "/owner/repair?action=list");
                break;

            case "confirm":
                String woId2 = req.getParameter("workOrderId");
                int rating = Integer.parseInt(req.getParameter("rating"));
                String comment = req.getParameter("comment");
                workOrderDAO.confirm(woId2, rating, comment);
                resp.sendRedirect(req.getContextPath() + "/owner/repair?action=list");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/owner/repair?action=list");
        }
    }
}