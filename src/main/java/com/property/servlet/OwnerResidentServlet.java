package com.property.servlet;

import com.property.dao.ResidentDAO;
import com.property.dao.HousingDAO;
import com.property.dao.ResidentHousingDAO;
import com.property.entity.Resident;
import com.property.entity.Housing;
import com.property.entity.ResidentHousing;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 业主端 - 个人信息与住房 Servlet
 */
@WebServlet("/owner/resident")
public class OwnerResidentServlet extends BaseServlet {

    private ResidentDAO residentDAO = new ResidentDAO();
    private HousingDAO housingDAO = new HousingDAO();
    private ResidentHousingDAO residentHousingDAO = new ResidentHousingDAO();

    /**
     * 个人信息
     */
    protected void info(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = getCurrentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 通过 system userId 找到住户（Resident表有user_id字段关联SystemUser）
        Resident resident = residentDAO.findByUserId(userId);
        request.setAttribute("resident", resident);

        // 找到住户关联的住房列表
        List<HousingWithRelation> housingWithRelationList = new ArrayList<>();
        if (resident != null) {
            List<ResidentHousing> rhList = residentHousingDAO.findAllByResidentId(resident.getResidentId());
            for (ResidentHousing rh : rhList) {
                Housing h = housingDAO.findById(rh.getHousingId());
                if (h != null) {
                    HousingWithRelation hwr = new HousingWithRelation();
                    hwr.housing = h;
                    hwr.isOwner = rh.isOwner();
                    hwr.startDate = rh.getStartDate();
                    housingWithRelationList.add(hwr);
                }
            }
        }
        request.setAttribute("housingWithRelationList", housingWithRelationList);

        request.getRequestDispatcher("/pages/owner/resident/info.jsp").forward(request, response);
    }

    /**
     * 我的住房列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = getCurrentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Resident resident = residentDAO.findByUserId(userId);
        request.setAttribute("resident", resident);

        List<HousingWithRelation> housingWithRelationList = new ArrayList<>();
        if (resident != null) {
            List<ResidentHousing> rhList = residentHousingDAO.findAllByResidentId(resident.getResidentId());
            for (ResidentHousing rh : rhList) {
                Housing h = housingDAO.findById(rh.getHousingId());
                if (h != null) {
                    HousingWithRelation hwr = new HousingWithRelation();
                    hwr.housing = h;
                    hwr.isOwner = rh.isOwner();
                    hwr.startDate = rh.getStartDate();
                    housingWithRelationList.add(hwr);
                }
            }
        }
        request.setAttribute("housingWithRelationList", housingWithRelationList);

        request.getRequestDispatcher("/pages/owner/resident/list.jsp").forward(request, response);
    }

    /**
     * 从 Session 获取当前用户ID
     */
    private String getCurrentUserId(HttpServletRequest request) {
        Object userId = request.getSession().getAttribute("userId");
        return userId != null ? userId.toString() : null;
    }

    /**
     * 住房 + 关系包装类（不破坏 Housing 实体）
     */
    public static class HousingWithRelation {
        public Housing housing;
        public boolean isOwner;
        public String startDate;

        public Housing getHousing() { return housing; }
        public boolean getIsOwner() { return isOwner; }
        public String getStartDate() { return startDate; }
    }
}
