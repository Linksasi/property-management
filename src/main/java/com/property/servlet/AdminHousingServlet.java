package com.property.servlet;

import com.property.dao.HousingDAO;
import com.property.entity.Housing;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * 管理员端 - 住房管理 Servlet
 * URL: /admin/housing (侧边栏住户管理下暂无直接链接，暂用此路径)
 * 页面放在 /pages/admin/resident/ 下
 */
@WebServlet("/admin/housing")
public class AdminHousingServlet extends BaseServlet {

    private HousingDAO housingDAO = new HousingDAO();

    /**
     * 住房列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String building = request.getParameter("building");
        List<Housing> list;

        if (building != null && !building.isEmpty()) {
            list = housingDAO.findByBuilding(building);
        } else {
            list = housingDAO.findAll();
        }

        // 获取所有楼栋用于筛选
        List<String> buildings = housingDAO.findAllBuildings();

        request.setAttribute("list", list);
        request.setAttribute("buildings", buildings);
        request.setAttribute("selectedBuilding", building);
        request.getRequestDispatcher("/pages/admin/resident/housing-list.jsp").forward(request, response);
    }

    /**
     * 显示新增表单
     */
    protected void add(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("housing", null);
        request.setAttribute("nextId", housingDAO.generateNextId());
        request.getRequestDispatcher("/pages/admin/resident/housing-edit.jsp").forward(request, response);
    }

    /**
     * 显示编辑表单
     */
    protected void edit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String housingId = request.getParameter("id");
        if (housingId != null && !housingId.isEmpty()) {
            Housing housing = housingDAO.findById(housingId);
            request.setAttribute("housing", housing);
        }
        request.getRequestDispatcher("/pages/admin/resident/housing-edit.jsp").forward(request, response);
    }

    /**
     * 保存（新增或更新）
     */
    protected void save(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String housingId = request.getParameter("housingId");
        String building = request.getParameter("building");
        String unit = request.getParameter("unit");
        String roomNo = request.getParameter("roomNo");
        String areaStr = request.getParameter("area");
        String floorStr = request.getParameter("floor");
        String houseType = request.getParameter("houseType");

        Housing housing = new Housing();
        housing.setHousingId(housingId);
        housing.setBuilding(building);
        housing.setUnit(unit);
        housing.setRoomNo(roomNo);
        housing.setArea(Double.parseDouble(areaStr));
        housing.setFloor(Integer.parseInt(floorStr));
        housing.setHouseType(houseType);

        // 检查是新增还是更新
        Housing existing = housingDAO.findById(housingId);
        if (existing != null) {
            housingDAO.update(housing);
        } else {
            housingDAO.insert(housing);
        }

        response.sendRedirect(request.getContextPath() + "/admin/housing?action=list");
    }

    /**
     * 删除住房
     */
    protected void delete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String housingId = request.getParameter("id");
        if (housingId != null && !housingId.isEmpty()) {
            housingDAO.delete(housingId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/housing?action=list");
    }
}
