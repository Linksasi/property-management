package com.property.servlet;

import com.property.dao.HousingDAO;
import com.property.dao.WaterMeterDAO;
import com.property.entity.Housing;
import com.property.entity.WaterMeter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * 管理员端 - 水表管理 Servlet
 * URL: /admin/waterMeter
 */
@WebServlet("/admin/waterMeter")
public class AdminWaterMeterServlet extends BaseServlet {

    private WaterMeterDAO meterDAO = new WaterMeterDAO();
    private HousingDAO housingDAO = new HousingDAO();

    /**
     * 水表列表
     */
    protected void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<WaterMeter> list = meterDAO.findAll();
        request.setAttribute("list", list);
        request.getRequestDispatcher("/pages/admin/water/meter-list.jsp").forward(request, response);
    }

    /**
     * 显示新增表单
     */
    protected void add(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("meter", null);
        request.setAttribute("nextId", meterDAO.generateNextId());
        // 获取所有住房用于选择
        List<Housing> houses = housingDAO.findAll();
        request.setAttribute("houses", houses);
        request.getRequestDispatcher("/pages/admin/water/meter-edit.jsp").forward(request, response);
    }

    /**
     * 显示编辑表单
     */
    protected void edit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String meterId = request.getParameter("id");
        if (meterId != null && !meterId.isEmpty()) {
            WaterMeter meter = meterDAO.findById(meterId);
            request.setAttribute("meter", meter);
        }
        // 获取所有住房用于选择
        List<Housing> houses = housingDAO.findAll();
        request.setAttribute("houses", houses);
        request.getRequestDispatcher("/pages/admin/water/meter-edit.jsp").forward(request, response);
    }

    /**
     * 保存（新增或更新）
     */
    protected void save(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String meterId = request.getParameter("meterId");
        String housingId = request.getParameter("housingId");
        String installDateStr = request.getParameter("installDate");
        String initialReadStr = request.getParameter("initialRead");
        String currentReadStr = request.getParameter("currentRead");
        String lastReadStr = request.getParameter("lastRead");
        String lastReadDateStr = request.getParameter("lastReadDate");
        String status = request.getParameter("status");

        WaterMeter meter = new WaterMeter();
        meter.setMeterId(meterId);
        meter.setHousingId(housingId);
        meter.setInstallDate(installDateStr != null && !installDateStr.isEmpty() ? LocalDate.parse(installDateStr) : null);
        meter.setInitialRead(initialReadStr != null && !initialReadStr.isEmpty() ? new BigDecimal(initialReadStr) : BigDecimal.ZERO);
        meter.setCurrentRead(currentReadStr != null && !currentReadStr.isEmpty() ? new BigDecimal(currentReadStr) : BigDecimal.ZERO);
        meter.setLastRead(lastReadStr != null && !lastReadStr.isEmpty() ? new BigDecimal(lastReadStr) : null);
        meter.setLastReadDate(lastReadDateStr != null && !lastReadDateStr.isEmpty() ? LocalDate.parse(lastReadDateStr) : null);
        meter.setUpdateDate(LocalDate.now());
        meter.setStatus(status != null && !status.isEmpty() ? status : "正常");

        // 检查是新增还是更新
        WaterMeter existing = meterDAO.findById(meterId);
        if (existing != null) {
            meterDAO.update(meter);
        } else {
            meterDAO.insert(meter);
        }

        response.sendRedirect(request.getContextPath() + "/admin/waterMeter?action=list");
    }

    /**
     * 删除水表
     */
    protected void delete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String meterId = request.getParameter("id");
        if (meterId != null && !meterId.isEmpty()) {
            meterDAO.delete(meterId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/waterMeter?action=list");
    }

    /**
     * 抄表录入页面
     */
    protected void meterRead(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<WaterMeter> list = meterDAO.findAll();
        request.setAttribute("list", list);
        request.setAttribute("today", LocalDate.now().toString());
        request.getRequestDispatcher("/pages/admin/water/meter-read.jsp").forward(request, response);
    }

    /**
     * 批量保存抄表记录
     */
    protected void saveReading(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] meterIds = request.getParameterValues("meterId");
        String[] currentReads = request.getParameterValues("currentRead");
        String[] readDates = request.getParameterValues("readDate");
        String[] lastReads = request.getParameterValues("lastRead");

        if (meterIds != null) {
            for (int i = 0; i < meterIds.length; i++) {
                String meterId = meterIds[i];
                String currentReadStr = currentReads[i];
                String readDateStr = readDates[i];

                // 只处理有输入的记录
                if (currentReadStr != null && !currentReadStr.isEmpty() && !currentReadStr.trim().isEmpty()) {
                    WaterMeter meter = meterDAO.findById(meterId);
                    if (meter != null) {
                        BigDecimal currentRead = new BigDecimal(currentReadStr);
                        meter.setLastRead(meter.getCurrentRead());
                        meter.setLastReadDate(meter.getCurrentRead() != null ? meter.getUpdateDate() : null);
                        meter.setCurrentRead(currentRead);
                        meter.setUpdateDate(readDateStr != null && !readDateStr.isEmpty() ? LocalDate.parse(readDateStr) : LocalDate.now());
                        meterDAO.update(meter);
                    }
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/waterMeter?action=list");
    }
}
