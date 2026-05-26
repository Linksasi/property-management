package com.property.servlet;

import com.property.exception.BusinessException;
import com.property.exception.DataAccessException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.lang.reflect.Method;

/**
 * Servlet基类 - 统一action分发（Tomcat 10 Jakarta EE）
 * 提供全局异常处理
 */
@WebServlet(name = "BaseServlet", urlPatterns = {"/"})
public class BaseServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        try {
            execute(request, response);
        } catch (DataAccessException e) {
            handleException(request, response, "数据操作失败: " + e.getMessage(), e);
        } catch (BusinessException e) {
            handleException(request, response, e.getMessage(), e);
        } catch (Exception e) {
            handleException(request, response, "系统错误，请稍后重试", e);
        }
    }

    /**
     * 处理异常：转发到统一错误页面
     */
    private void handleException(HttpServletRequest request, HttpServletResponse response,
                                  String message, Exception e) throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("errorMessage", message);
        request.setAttribute("errorDetail", e.getClass().getSimpleName());
        request.getRequestDispatcher(request.getContextPath() + "/pages/error.jsp").forward(request, response);
    }

    /**
     * 执行具体的action方法
     */
    protected void execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            Method method = this.getClass().getDeclaredMethod(action,
                HttpServletRequest.class, HttpServletResponse.class);
            method.setAccessible(true);
            method.invoke(this, request, response);
        } catch (NoSuchMethodException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not found: " + action);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.sendRedirect(request.getContextPath() + "/");
    }

    protected void add(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.sendRedirect(request.getContextPath() + "/");
    }

    protected void edit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.sendRedirect(request.getContextPath() + "/");
    }

    protected void save(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.sendRedirect(request.getContextPath() + "/");
    }

    protected void delete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.sendRedirect(request.getContextPath() + "/");
    }

    /**
     * 统一错误页面
     */
    protected void error(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
    }
}
