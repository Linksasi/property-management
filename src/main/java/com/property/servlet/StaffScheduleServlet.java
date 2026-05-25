package com.property.servlet;

import com.property.model.ShiftRecord;
import com.property.entity.Staff;
import com.property.service.ShiftRecordService;
import com.property.service.StaffService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/staff/schedule")
public class StaffScheduleServlet extends BaseServlet {
    private ShiftRecordService shiftService = new ShiftRecordService();
    private StaffService staffService = new StaffService();

    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String staffId = (String) session.getAttribute("staffId");

            if (staffId == null || staffId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            Staff staff = staffService.getById(staffId);
            List<ShiftRecord> list = shiftService.getByStaffId(staffId);
            request.setAttribute("list", list);
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/pages/staff/schedule/schedule.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }
}