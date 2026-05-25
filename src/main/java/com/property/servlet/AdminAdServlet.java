package com.property.servlet;

import com.property.model.AdSlot;
import com.property.model.AdApplication;
import com.property.service.AdSlotService;
import com.property.service.AdApplicationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/ad")
public class AdminAdServlet extends BaseServlet {
    private AdSlotService slotService = new AdSlotService();
    private AdApplicationService appService = new AdApplicationService();

    protected void slotList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<AdSlot> list = slotService.getAll();
            Map<String, List<AdApplication>> slotOccupancy = new HashMap<>();
            for (AdSlot slot : list) {
                List<AdApplication> apps = appService.getBySlotId(slot.getSlotId());
                slotOccupancy.put(slot.getSlotId(), apps);
            }
            request.setAttribute("list", list);
            request.setAttribute("slotOccupancy", slotOccupancy);
            request.getRequestDispatcher("/pages/admin/ad/slot-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void appList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<AdApplication> list = appService.getAll();
            request.setAttribute("list", list);
            request.getRequestDispatcher("/pages/admin/ad/application-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void appDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            AdApplication app = appService.getById(id);
            List<AdSlot> slots = slotService.getAll();
            request.setAttribute("entity", app);
            request.setAttribute("slots", slots);
            request.getRequestDispatcher("/pages/admin/ad/application-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void appApprove(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String appId = request.getParameter("applicationId");
            String slotId = request.getParameter("slotId");
            AdApplication app = appService.getById(appId);
            if (slotId == null || slotId.isEmpty()) {
                request.setAttribute("errorMsg", "请选择要分配的广告位");
                request.setAttribute("entity", app);
                request.setAttribute("slots", slotService.getAll());
                request.getRequestDispatcher("/pages/admin/ad/application-detail.jsp").forward(request, response);
                return;
            }
            if (app != null && app.getStartDate() != null && app.getEndDate() != null) {
                boolean conflict = appService.hasTimeConflict(slotId, app.getStartDate(), app.getEndDate(), appId);
                if (conflict) {
                    request.setAttribute("errorMsg", "该广告位在所选时间段内已被占用，请选择其他广告位或调整时间");
                    request.setAttribute("entity", app);
                    request.setAttribute("slots", slotService.getAll());
                    request.getRequestDispatcher("/pages/admin/ad/application-detail.jsp").forward(request, response);
                    return;
                }
            }
            appService.approve(appId, slotId);
            response.sendRedirect(request.getContextPath() + "/admin/ad?action=appList");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void appReject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String appId = request.getParameter("applicationId");
            String comments = request.getParameter("comments");
            appService.reject(appId, comments);
            response.sendRedirect(request.getContextPath() + "/admin/ad?action=appList");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void slotAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/admin/ad/slot-edit.jsp").forward(request, response);
    }

    protected void slotEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            AdSlot slot = slotService.getById(id);
            request.setAttribute("entity", slot);
            request.getRequestDispatcher("/pages/admin/ad/slot-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void slotSave(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String slotId = request.getParameter("slotId");
            String location = request.getParameter("locationDescription");

            AdSlot slot = new AdSlot();
            if (slotId != null && !slotId.isEmpty()) {
                slot.setSlotId(slotId);
            }
            slot.setLocation(location);
            slot.setStatus("空闲");

            if (slotId != null && !slotId.isEmpty()) {
                slotService.update(slot);
            } else {
                slot.setSlotId("SL" + System.currentTimeMillis());
                slotService.add(slot);
            }
            response.sendRedirect(request.getContextPath() + "/admin/ad?action=slotList");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }
}