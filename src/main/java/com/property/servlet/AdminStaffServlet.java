package com.property.servlet;

import com.property.entity.Staff;
import com.property.entity.WorkType;
import com.property.model.WorkLocation;
import com.property.service.StaffService;
import com.property.service.WorkTypeService;
import com.property.dao.WorkLocationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/staff")
public class AdminStaffServlet extends BaseServlet {
    private StaffService staffService = new StaffService();
    private WorkTypeService workTypeService = new WorkTypeService();
    private WorkLocationDAO locationDAO = new WorkLocationDAO();

    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Staff> list = staffService.getAll();
            List<WorkType> workTypes = workTypeService.getAll();
            request.setAttribute("list", list);
            request.setAttribute("workTypes", workTypes);
            request.getRequestDispatcher("/pages/admin/staff/staff-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<WorkType> workTypes = workTypeService.getAll();
            List<WorkLocation> locations = locationDAO.getAll();
            request.setAttribute("entity", new Staff());
            request.setAttribute("workTypes", workTypes);
            request.setAttribute("locations", locations);
            request.getRequestDispatcher("/pages/admin/staff/staff-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            Staff staff = staffService.getById(id);
            List<WorkType> workTypes = workTypeService.getAll();
            List<WorkLocation> locations = locationDAO.getAll();
            request.setAttribute("entity", staff);
            request.setAttribute("workTypes", workTypes);
            request.setAttribute("locations", locations);
            request.getRequestDispatcher("/pages/admin/staff/staff-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("staffId");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String idCard = request.getParameter("idCard");
            String worktypeId = request.getParameter("worktypeId");
            String isAdmin = request.getParameter("isAdmin");
            String status = request.getParameter("status");

            Staff staff = new Staff();
            if (id != null && !id.isEmpty()) {
                staff.setStaffId(id);
            }
            staff.setName(name);
            staff.setPhone(phone);
            staff.setIdCard(idCard);
            staff.setWorktypeId(worktypeId);
            staff.setAdmin("1".equals(isAdmin));
            staff.setStatus(status != null ? status : "在职");

            if (id != null && !id.isEmpty()) {
                staffService.update(staff);
            } else {
                staffService.add(staff);
            }
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            staffService.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }
}