package com.property.filter;

import com.property.entity.SystemUser;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class LoginFilter implements Filter {

    public void init(FilterConfig config) throws ServletException {}

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        String path = request.getRequestURI().substring(request.getContextPath().length());

        // 放行静态资源和登录相关
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")
                || path.equals("/login.jsp") || path.equals("/login") || path.equals("/test")
                || path.equals("/index.jsp") || path.equals("/") || path.equals("/favicon.ico")) {
            chain.doFilter(req, resp);
            return;
        }

        // 放行 JSP include 片段
        if (path.startsWith("/pages/common/")) {
            chain.doFilter(req, resp);
            return;
        }

        // 检查登录
        HttpSession session = request.getSession(false);
        SystemUser user = (session != null) ? (SystemUser) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 角色权限控制
        String userType = user.getUserType();
        if (path.startsWith("/pages/admin/") && !"管理员".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        if (path.startsWith("/pages/owner/") && !"业主".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        if (path.startsWith("/pages/staff/") && !"维修员".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        if (path.startsWith("/admin/") && !"管理员".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        if (path.startsWith("/owner/") && !"业主".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        if (path.startsWith("/staff/") && !"维修员".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        chain.doFilter(req, resp);
    }

    public void destroy() {}
}