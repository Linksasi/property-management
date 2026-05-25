package com.property.servlet;

import com.property.entity.WorkType;
import com.property.service.WorkTypeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/worktype")
public class AdminWorkTypeServlet extends BaseServlet {
    private WorkTypeService service = new WorkTypeService();

    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<WorkType> list = service.getAll();
            request.setAttribute("list", list);
            request.getRequestDispatcher("/pages/admin/staff/worktype-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/pages/admin/staff/worktype-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            WorkType wt = service.getById(id);
            request.setAttribute("entity", wt);
            request.getRequestDispatcher("/pages/admin/staff/worktype-edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("worktypeId");
            String name = request.getParameter("worktypeName");

            WorkType wt = new WorkType();
            wt.setWorktypeId(id);
            wt.setWorktypeName(name);

            if (id != null && !id.isEmpty()) {
                service.update(wt);
            } else {
                service.add(wt);
            }
            response.sendRedirect(request.getContextPath() + "/admin/worktype?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            service.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/worktype?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }
}