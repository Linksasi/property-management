package com.property.servlet;

import com.property.dao.SystemUserDAO;
import com.property.entity.Staff;
import com.property.entity.SystemUser;
import com.property.entity.WorkType;
import com.property.model.WorkLocation;
import com.property.service.StaffService;
import com.property.service.WorkTypeService;
import com.property.dao.WorkLocationDAO;
import com.property.exception.BusinessException;
import com.property.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/staff")
public class AdminStaffServlet extends BaseServlet {
    private StaffService staffService = new StaffService();
    private WorkTypeService workTypeService = new WorkTypeService();
    private WorkLocationDAO locationDAO = new WorkLocationDAO();
    private SystemUserDAO userDAO = new SystemUserDAO();

    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
        List<Staff> list = staffService.getAll();
        List<WorkType> workTypes = workTypeService.getAll();
        request.setAttribute("list", list);
        request.setAttribute("workTypes", workTypes);
        request.getRequestDispatcher("/pages/admin/staff/staff-list.jsp").forward(request, response);
    }

    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
        List<WorkType> workTypes = workTypeService.getAll();
        List<WorkLocation> locations = locationDAO.getAll();
        request.setAttribute("entity", new Staff());
        request.setAttribute("workTypes", workTypes);
        request.setAttribute("locations", locations);
        request.getRequestDispatcher("/pages/admin/staff/staff-edit.jsp").forward(request, response);
    }

    protected void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
        String id = request.getParameter("id");
        Staff staff = staffService.getById(id);
        List<WorkType> workTypes = workTypeService.getAll();
        List<WorkLocation> locations = locationDAO.getAll();
        request.setAttribute("entity", staff);
        request.setAttribute("workTypes", workTypes);
        request.setAttribute("locations", locations);
        request.getRequestDispatcher("/pages/admin/staff/staff-edit.jsp").forward(request, response);
    }

    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
        try {
            String id = request.getParameter("staffId");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String idCard = request.getParameter("idCard");
            String worktypeId = request.getParameter("worktypeId");
            String status = request.getParameter("status");
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            Staff staff = new Staff();
            boolean isNew = (id == null || id.isEmpty());
            if (!isNew) {
                staff.setStaffId(id);
            }
            staff.setName(name);
            staff.setPhone(phone);
            staff.setIdCard(idCard);
            staff.setWorktypeId(worktypeId);
            staff.setAdmin(false);
            staff.setStatus(status != null ? status : "在职");

            if (!isNew) {
                staffService.update(staff);
            } else {
                // 事务保护：创建账号 + 员工记录必须在同一个事务中
                DBUtil.beginTransaction();
                SystemUser u = new SystemUser();
                u.setUserId(userDAO.generateId("维修员"));
                u.setUsername(username != null && !username.isEmpty() ? username.trim() : phone);
                u.setPassword(password != null && !password.isEmpty() ? password : "123456");
                u.setUserType("维修员");
                u.setRealName(name);
                u.setPhone(phone);
                userDAO.register(u);
                staff.setUserId(u.getUserId());
                staffService.add(staff);
                DBUtil.commit();
                DBUtil.closeConnection();
            }
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
        } catch (Exception e) {
            DBUtil.rollback();
            DBUtil.closeConnection();
            throw new BusinessException("创建员工失败: " + e.getMessage());
        }
    }

    protected void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
        String id = request.getParameter("id");
        staffService.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
    }
}