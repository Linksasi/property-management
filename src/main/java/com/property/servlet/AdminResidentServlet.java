package com.property.servlet;

import com.property.dao.ResidentDAO;
import com.property.dao.HousingDAO;
import com.property.dao.ResidentHousingDAO;
import com.property.dao.SystemUserDAO;
import com.property.entity.Resident;
import com.property.entity.Housing;
import com.property.entity.ResidentHousing;
import com.property.entity.SystemUser;
import com.property.exception.BusinessException;
import com.property.util.DBUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.ServletException;
import java.io.IOException;
import java.util.List;

/**
 * 管理员端 - 住户管理 Servlet
 */
@WebServlet("/admin/resident")
public class AdminResidentServlet extends BaseServlet {

    private ResidentDAO residentDAO = new ResidentDAO();
    private HousingDAO housingDAO = new HousingDAO();
    private ResidentHousingDAO residentHousingDAO = new ResidentHousingDAO();
    private SystemUserDAO userDAO = new SystemUserDAO();

    /**
     * 住户列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<Resident> list;

        if (keyword != null && !keyword.isEmpty()) {
            // 简单的模糊查询（这里在后端先查全量，JSP里筛选）
            list = residentDAO.findAll();
        } else {
            list = residentDAO.findAll();
        }

        request.setAttribute("list", list);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/pages/admin/resident/resident-list.jsp").forward(request, response);
    }

    /**
     * 显示新增表单
     */
    protected void add(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("resident", null);
        request.setAttribute("nextId", residentDAO.generateId());
        request.getRequestDispatcher("/pages/admin/resident/resident-edit.jsp").forward(request, response);
    }

    /**
     * 显示编辑表单
     */
    protected void edit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String residentId = request.getParameter("id");
        if (residentId != null && !residentId.isEmpty()) {
            Resident resident = residentDAO.findById(residentId);
            request.setAttribute("resident", resident);
        }
        request.getRequestDispatcher("/pages/admin/resident/resident-edit.jsp").forward(request, response);
    }

    /**
     * 保存（新增或更新）
     */
    protected void save(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String residentId = request.getParameter("residentId");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String idCard = request.getParameter("idCard");
        String checkInDate = request.getParameter("checkInDate");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Resident resident = new Resident();
        resident.setResidentId(residentId);
        resident.setName(name);
        resident.setPhone(phone);
        resident.setIdCard(idCard);
        resident.setCheckInDate(checkInDate);

        // 检查是新增还是更新
        Resident existing = residentDAO.findById(residentId);
        if (existing != null) {
            residentDAO.update(resident);
        } else {
            // 事务保护：创建账号 + 插入住户必须在同一个事务中
            try {
                DBUtil.beginTransaction();
                SystemUser u = new SystemUser();
                u.setUserId(userDAO.generateId("业主"));
                u.setUsername(username != null && !username.isEmpty() ? username.trim() : phone);
                u.setPassword(password != null && !password.isEmpty() ? password : "123456");
                u.setUserType("业主");
                u.setRealName(name);
                u.setPhone(phone);
                userDAO.register(u);
                resident.setUserId(u.getUserId());
                residentDAO.insert(resident);
                DBUtil.commit();
            } catch (Exception e) {
                DBUtil.rollback();
                throw new BusinessException("创建住户失败: " + e.getMessage());
            } finally {
                DBUtil.closeConnection();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/resident?action=list");
    }

    /**
     * 删除住户
     */
    protected void delete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String residentId = request.getParameter("id");
        if (residentId != null && !residentId.isEmpty()) {
            // 事务保护：删除关联住房 + 删除住户必须在同一个事务中
            try {
                DBUtil.beginTransaction();
                residentHousingDAO.deleteByResidentId(residentId);
                residentDAO.delete(residentId);
                DBUtil.commit();
            } catch (Exception e) {
                DBUtil.rollback();
                throw new BusinessException("删除住户失败: " + e.getMessage());
            } finally {
                DBUtil.closeConnection();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/resident?action=list");
    }

    // ========== 关联住房子功能 ==========

    /**
     * 关联住房列表
     */
    protected void housingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String residentId = request.getParameter("residentId");
        request.setAttribute("residentId", residentId);

        if (residentId != null && !residentId.isEmpty()) {
            Resident resident = residentDAO.findById(residentId);
            List<ResidentHousing> rhList = residentHousingDAO.findAllByResidentId(residentId);
            List<Housing> housingList = housingDAO.findAll();

            request.setAttribute("resident", resident);
            request.setAttribute("rhList", rhList);
            request.setAttribute("housingList", housingList);
        }

        request.getRequestDispatcher("/pages/admin/resident/resident-housing-list.jsp").forward(request, response);
    }

    /**
     * 显示添加关联表单
     */
    protected void housingAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String residentId = request.getParameter("residentId");
        List<Housing> housingList = housingDAO.findAll();

        request.setAttribute("residentId", residentId);
        request.setAttribute("housingList", housingList);
        request.getRequestDispatcher("/pages/admin/resident/resident-housing-add.jsp").forward(request, response);
    }

    /**
     * 保存关联住房
     */
    protected void housingSave(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String residentId = request.getParameter("residentId");
        String housingId = request.getParameter("housingId");
        String isOwner = request.getParameter("isOwner");
        String startDate = request.getParameter("startDate");

        ResidentHousing rh = new ResidentHousing();
        rh.setResidentId(residentId);
        rh.setHousingId(housingId);
        rh.setOwner("1".equals(isOwner));
        rh.setStartDate(startDate);

        residentHousingDAO.insert(rh);

        response.sendRedirect(request.getContextPath() + "/admin/resident?action=housingList&residentId=" + residentId);
    }

    /**
     * 解除关联
     */
    protected void housingDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String residentId = request.getParameter("residentId");
        String housingId = request.getParameter("housingId");

        residentHousingDAO.delete(residentId, housingId);

        response.sendRedirect(request.getContextPath() + "/admin/resident?action=housingList&residentId=" + residentId);
    }
}
