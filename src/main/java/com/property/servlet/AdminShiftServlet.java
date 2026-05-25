package com.property.servlet;

import com.property.model.ShiftRecord;
import com.property.entity.Staff;
import com.property.model.WorkLocation;
import com.property.service.ShiftRecordService;
import com.property.service.StaffService;
import com.property.dao.WorkLocationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/shift")
public class AdminShiftServlet extends BaseServlet {
    private ShiftRecordService shiftService = new ShiftRecordService();
    private StaffService staffService = new StaffService();
    private WorkLocationDAO locationDAO = new WorkLocationDAO();

    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<ShiftRecord> list = shiftService.getAll();
            request.setAttribute("list", list);
            request.getRequestDispatcher("/pages/admin/staff/shift-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Staff> staffs = staffService.getAll();
            List<WorkLocation> locations = locationDAO.getAll();
            request.setAttribute("staffs", staffs);
            request.setAttribute("locations", locations);
            request.getRequestDispatcher("/pages/admin/staff/shift-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            ShiftRecord sr = shiftService.getById(id);
            List<Staff> staffs = staffService.getAll();
            List<WorkLocation> locations = locationDAO.getAll();
            request.setAttribute("entity", sr);
            request.setAttribute("staffs", staffs);
            request.setAttribute("locations", locations);
            request.getRequestDispatcher("/pages/admin/staff/shift-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("shiftId");
            String staffId = request.getParameter("staffId");
            String locationId = request.getParameter("locationId");
            String dateStr = request.getParameter("shiftDate");
            String period = request.getParameter("shiftPeriod");

            ShiftRecord sr = new ShiftRecord();
            sr.setStaffId(staffId);
            sr.setLocationId(locationId);
            sr.setShiftDate(Date.valueOf(dateStr));
            sr.setShiftPeriod(period);

            if (id != null && !id.isEmpty()) {
                sr.setShiftId(id);
                shiftService.update(sr);
            } else {
                shiftService.add(sr);
            }
            response.sendRedirect(request.getContextPath() + "/admin/shift?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            shiftService.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/shift?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }
}