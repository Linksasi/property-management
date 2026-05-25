package com.property.servlet;

import com.property.dao.SystemUserDAO;
import com.property.dao.ResidentDAO;
import com.property.dao.StaffDAO;
import com.property.dao.HousingDAO;
import com.property.dao.ResidentHousingDAO;
import com.property.dao.ExternalAdCompanyDAO;
import com.property.entity.SystemUser;
import com.property.entity.Resident;
import com.property.entity.Staff;
import com.property.entity.Housing;
import com.property.entity.ResidentHousing;
import com.property.model.ExternalAdCompany;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet({"/login", "/logout", "/register"})
public class LoginServlet extends HttpServlet {

    private SystemUserDAO userDAO = new SystemUserDAO();
    private ResidentDAO residentDAO = new ResidentDAO();
    private StaffDAO staffDAO = new StaffDAO();
    private HousingDAO housingDAO = new HousingDAO();
    private ResidentHousingDAO residentHousingDAO = new ResidentHousingDAO();
    private ExternalAdCompanyDAO companyDAO = new ExternalAdCompanyDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if ("/logout".equals(path)) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        if ("/login".equals(path)) {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if ("/register".equals(path)) {
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }


    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        // POST /login —— 用户名+密码登录
        if ("/login".equals(path)) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");

            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                req.setAttribute("error", "请输入用户名和密码");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            SystemUser user = userDAO.login(username.trim(), password);
            if (user == null) {
                req.setAttribute("error", "用户名或密码错误，或账号已被停用");
                req.setAttribute("username", username);
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            // 业主登录时检查是否已绑定 Resident
            if ("业主".equals(user.getUserType())) {
                Resident resident = residentDAO.findByUserId(user.getUserId());
                if (resident == null) {
                    req.setAttribute("error", "该账号尚未绑定住户信息，请联系管理员");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                    return;
                }
            }

            loginUser(req, user);
            redirectByRole(req, resp, user);
            return;
        }

        // POST /register —— 注册新账号
        if ("/register".equals(path)) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String userType = req.getParameter("userType");
            String name = req.getParameter("name");
            String phone = req.getParameter("phone");
            String idCard = req.getParameter("idCard");

            // 基础校验
            if (username == null || username.trim().isEmpty()) {
                req.setAttribute("error", "请输入用户名");
                forwardRegister(req, resp); return;
            }
            if (password == null || password.trim().isEmpty()) {
                req.setAttribute("error", "请输入密码");
                forwardRegister(req, resp); return;
            }
            if (!password.equals(confirmPassword)) {
                req.setAttribute("error", "两次输入的密码不一致");
                forwardRegister(req, resp); return;
            }
            if (userType == null || userType.trim().isEmpty()) {
                req.setAttribute("error", "请选择角色");
                forwardRegister(req, resp); return;
            }

            // 查重
            if (userDAO.findByUsername(username.trim()) != null) {
                req.setAttribute("error", "用户名已被占用，请换一个");
                forwardRegister(req, resp); return;
            }

            // 创建 SystemUser（BCrypt 加密）
            SystemUser u = new SystemUser();
            u.setUserId(userDAO.generateId(userType));
            u.setUsername(username.trim());
            u.setPassword(password);
            u.setUserType(userType);
            u.setRealName(name);
            u.setPhone(phone);

            boolean userOk = userDAO.register(u);
            boolean detailOk = true;
            String detailError = "";

            if (userOk) {
                if ("业主".equals(userType)) {
                    String checkInDate = req.getParameter("checkInDate");
                    String building = req.getParameter("building");
                    String unit = req.getParameter("unit");
                    String roomNo = req.getParameter("roomNo");
                    String areaStr = req.getParameter("area");
                    String floorStr = req.getParameter("floor");
                    String houseType = req.getParameter("houseType");

                    if (building == null || building.trim().isEmpty() ||
                        unit == null || unit.trim().isEmpty() ||
                        roomNo == null || roomNo.trim().isEmpty()) {
                        detailOk = false;
                        detailError = "请填写完整的房屋信息";
                    } else {
                        try {
                            Housing housing = housingDAO.findByAddress(building, unit, roomNo);
                            if (housing == null) {
                                housing = new Housing();
                                housing.setBuilding(building);
                                housing.setUnit(unit);
                                housing.setRoomNo(roomNo);
                                housing.setArea(areaStr != null && !areaStr.isEmpty() ? Double.parseDouble(areaStr) : 0);
                                housing.setFloor(floorStr != null && !floorStr.isEmpty() ? Integer.parseInt(floorStr) : 1);
                                housing.setHouseType(houseType != null && !houseType.isEmpty() ? houseType : "未指定");
                                housingDAO.insert(housing);
                            }
                            Resident r = new Resident();
                            r.setUserId(u.getUserId());
                            r.setName(name != null ? name : u.getRealName());
                            r.setPhone(phone != null ? phone : u.getPhone());
                            r.setIdCard(idCard != null && !idCard.isEmpty() ? idCard : "440000" + String.format("%012d", (long)(System.currentTimeMillis() % 1000000000000L)));
                            r.setCheckInDate(checkInDate != null && !checkInDate.isEmpty() ? checkInDate : new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
                            detailOk = residentDAO.insert(r);
                            if (detailOk) {
                                ResidentHousing rh = new ResidentHousing();
                                rh.setResidentId(r.getResidentId());
                                rh.setHousingId(housing.getHousingId());
                                rh.setStartDate(r.getCheckInDate());
                                rh.setOwner(true);
                                if (!residentHousingDAO.insert(rh)) detailOk = false;
                            }
                        } catch (NumberFormatException e) {
                            detailOk = false;
                            detailError = "面积或楼层格式不正确";
                        }
                    }
                } else if ("管理员".equals(userType)) {
                    Staff s = new Staff();
                    s.setStaffId(staffDAO.generateId());
                    s.setUserId(u.getUserId());
                    s.setName(name != null ? name : u.getRealName());
                    s.setPhone(phone != null ? phone : u.getPhone());
                    s.setIdCard(idCard != null && !idCard.isEmpty() ? idCard : "440000" + String.format("%012d", (long)(System.currentTimeMillis() % 1000000000000L)));
                    s.setAdmin(true);
                    s.setWorktypeId("WT007");
                    try {
                        detailOk = staffDAO.insert(s);
                        if (!detailOk) detailError = "管理员信息写入失败";
                    } catch (SQLException e) {
                        detailOk = false;
                        detailError = e.getMessage();
                    }
                } else if ("维修员".equals(userType)) {
                    String workTypeId = req.getParameter("workTypeId");
                    Staff s = new Staff();
                    s.setStaffId(staffDAO.generateId());
                    s.setUserId(u.getUserId());
                    s.setName(name != null ? name : u.getRealName());
                    s.setPhone(phone != null ? phone : u.getPhone());
                    s.setIdCard(idCard != null && !idCard.isEmpty() ? idCard : "440000" + String.format("%012d", (long)(System.currentTimeMillis() % 1000000000000L)));
                    s.setAdmin(false);
                    s.setWorktypeId(workTypeId != null && !workTypeId.isEmpty() ? workTypeId : "WT001");
                    try {
                        detailOk = staffDAO.insert(s);
                        if (!detailOk) detailError = "员工信息写入失败";
                    } catch (SQLException e) {
                        detailOk = false;
                        detailError = e.getMessage();
                    }
                } else if ("广告公司".equals(userType)) {
                    String companyName = req.getParameter("companyName");
                    if (companyName == null || companyName.trim().isEmpty()) {
                        detailOk = false;
                        detailError = "请填写公司名称";
                    } else {
                        ExternalAdCompany ec = new ExternalAdCompany();
                        ec.setCompanyId(companyDAO.generateId());
                        ec.setUserId(u.getUserId());
                        ec.setCompanyName(companyName);
                        ec.setContact(name != null ? name : u.getRealName());
                        ec.setPhone(phone != null ? phone : u.getPhone());
                        detailOk = companyDAO.insert(ec);
                    }
                }

                if (detailOk) {
                    // 注册成功 → 自动登录
                    loginUser(req, u);
                    redirectByRole(req, resp, u);
                    return;
                } else {
                    // 角色记录创建失败 → 删除已创建的 SystemUser，避免孤儿账号
                    try { userDAO.delete(u.getUserId()); } catch (Exception ignored) {}
                    req.setAttribute("error", detailError.isEmpty() ? "账号已创建，但详细信息保存失败，请联系管理员" : detailError);
                    forwardRegister(req, resp);
                    return;
                }
            } else {
                req.setAttribute("error", "注册失败，请稍后重试");
                forwardRegister(req, resp);
                return;
            }
        }

        // 其他 POST 请求（如 /test 表单）走 GET 逻辑
        doGet(req, resp);
    }

    /**
     * 注册失败时回显表单
     */
    private void forwardRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 回显已填数据
        req.setAttribute("reg_username", req.getParameter("username"));
        req.setAttribute("reg_userType", req.getParameter("userType"));
        req.setAttribute("reg_name", req.getParameter("name"));
        req.setAttribute("reg_phone", req.getParameter("phone"));
        req.setAttribute("reg_idCard", req.getParameter("idCard"));
        req.setAttribute("reg_checkInDate", req.getParameter("checkInDate"));
        req.setAttribute("reg_building", req.getParameter("building"));
        req.setAttribute("reg_unit", req.getParameter("unit"));
        req.setAttribute("reg_roomNo", req.getParameter("roomNo"));
        req.setAttribute("reg_area", req.getParameter("area"));
        req.setAttribute("reg_floor", req.getParameter("floor"));
        req.setAttribute("reg_houseType", req.getParameter("houseType"));
        req.setAttribute("reg_workTypeId", req.getParameter("workTypeId"));
        req.setAttribute("reg_companyName", req.getParameter("companyName"));
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    private void loginUser(HttpServletRequest req, SystemUser user) {
        HttpSession session = req.getSession();
        session.setAttribute("currentUser", user);
        session.setAttribute("userId", user.getUserId());
        // 管理员/维修员登录时，同时存 staffId 方便后续操作
        if ("管理员".equals(user.getUserType()) || "维修员".equals(user.getUserType())) {
            Staff staff = staffDAO.findByUserId(user.getUserId());
            if (staff != null) {
                session.setAttribute("staffId", staff.getStaffId());
            }
        }
        // 广告公司登录时，存 companyId
        if ("广告公司".equals(user.getUserType())) {
            ExternalAdCompany company = companyDAO.findByUserId(user.getUserId());
            if (company != null) {
                session.setAttribute("companyId", company.getCompanyId());
            }
        }
    }

    private void redirectByRole(HttpServletRequest req, HttpServletResponse resp, SystemUser user) throws IOException {
        switch (user.getUserType()) {
            case "管理员":
                resp.sendRedirect(req.getContextPath() + "/admin/staff?action=list");
                break;
            case "业主":
                resp.sendRedirect(req.getContextPath() + "/owner/resident?action=info");
                break;
            case "维修员":
                resp.sendRedirect(req.getContextPath() + "/staff/schedule?action=list");
                break;
            case "广告公司":
                resp.sendRedirect(req.getContextPath() + "/ad/company?action=apply");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}