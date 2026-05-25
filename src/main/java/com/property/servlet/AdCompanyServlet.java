package com.property.servlet;

import com.property.dao.ExternalAdCompanyDAO;
import com.property.model.AdSlot;
import com.property.model.AdApplication;
import com.property.model.ExternalAdCompany;
import com.property.service.AdApplicationService;
import com.property.service.AdSlotService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/ad/company")
public class AdCompanyServlet extends BaseServlet {
    private AdApplicationService appService = new AdApplicationService();
    private ExternalAdCompanyDAO companyDAO = new ExternalAdCompanyDAO();
    private AdSlotService slotService = new AdSlotService();

    protected void apply(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String companyId = (String) session.getAttribute("companyId");

            if (companyId == null || companyId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            ExternalAdCompany company = companyDAO.getById(companyId);
            List<AdSlot> slots = slotService.getAll();
            request.setAttribute("company", company);
            request.setAttribute("slots", slots);
            request.setAttribute("companyId", companyId);
            request.getRequestDispatcher("/pages/ad/company/apply.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void submitApply(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String companyId = (String) session.getAttribute("companyId");

            String adContent = request.getParameter("adContent");
            String expectSlot = request.getParameter("expectSlot");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            AdApplication app = new AdApplication();
            app.setAppId("AP" + System.currentTimeMillis());
            app.setCompanyId(companyId);
            app.setAdContent(adContent);
            app.setExpectSlot(expectSlot);
            app.setStartDate(Date.valueOf(startDate));
            app.setEndDate(Date.valueOf(endDate));

            appService.add(app);
            response.sendRedirect(request.getContextPath() + "/ad/company?action=myList");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void myList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String companyId = (String) session.getAttribute("companyId");

            if (companyId == null || companyId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            List<AdApplication> list = appService.getByCompanyId(companyId);
            request.setAttribute("list", list);
            request.setAttribute("companyId", companyId);
            request.getRequestDispatcher("/pages/ad/company/list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    protected void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            HttpSession session = request.getSession();
            String companyId = (String) session.getAttribute("companyId");
            AdApplication app = appService.getById(id);
            request.setAttribute("entity", app);
            request.setAttribute("companyId", companyId);
            request.getRequestDispatcher("/pages/ad/company/detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }
}