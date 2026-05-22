package com.property.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 测试登录Servlet
 */
@WebServlet("/login")
public class LoginServlet extends BaseServlet {
    
    protected void testLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String role = request.getParameter("role");
        
        HttpSession session = request.getSession();
        session.setAttribute("userId", userId);
        session.setAttribute("userType", role);
        session.setAttribute("currentUser", getDisplayName(userId));
        
        String contextPath = request.getContextPath();
        if ("admin".equals(role)) {
            response.sendRedirect(contextPath + "/admin/property?action=list");
        } else {
            response.sendRedirect(contextPath + "/owner/property?action=list");
        }
    }
    
    protected void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/pages/login-test.jsp");
    }
    
    protected void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/login-test.jsp").forward(request, response);
    }
    
    private String getDisplayName(String userId) {
        if (userId == null) return "用户";
        switch (userId) {
            case "ADMIN001": return "系统管理员";
            case "R001": return "张三";
            case "R002": return "李四";
            case "R003": return "王五";
            case "R004": return "赵六";
            case "R005": return "钱七";
            case "R006": return "孙八";
            case "R007": return "周九";
            case "R008": return "吴十";
            default: return userId;
        }
    }
}