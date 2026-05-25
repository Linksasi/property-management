package com.property.servlet;

import com.property.dao.SystemUserDAO;
import com.property.dao.ResidentDAO;
import com.property.dao.StaffDAO;
import com.property.dao.WorkTypeDAO;
import com.property.dao.HousingDAO;
import com.property.dao.ResidentHousingDAO;
import com.property.dao.ExternalAdCompanyDAO;
import com.property.entity.SystemUser;
import com.property.entity.Resident;
import com.property.entity.Staff;
import com.property.entity.WorkType;
import com.property.entity.Housing;
import com.property.entity.ResidentHousing;
import com.property.model.ExternalAdCompany;
import com.property.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet({"/login", "/logout", "/test"})
public class LoginServlet extends HttpServlet {

    private SystemUserDAO userDAO = new SystemUserDAO();
    private ResidentDAO residentDAO = new ResidentDAO();
    private StaffDAO staffDAO = new StaffDAO();
    private WorkTypeDAO workTypeDAO = new WorkTypeDAO();
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
            String userId = req.getParameter("userId");
            if (userId != null && !userId.isEmpty()) {
                SystemUser user = userDAO.findById(userId);
                if (user != null) {
                    if ("业主".equals(user.getUserType())) {
                        Resident resident = residentDAO.findByUserId(user.getUserId());
                        if (resident == null) {
                            resp.sendRedirect(req.getContextPath() + "/index.jsp?error=noresident");
                            return;
                        }
                    }
                    loginUser(req, user);
                    redirectByRole(req, resp, user);
                    return;
                }
            }
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        if ("/test".equals(path)) {
            String action = req.getParameter("action");
            resp.setContentType("application/json;charset=UTF-8");

            if ("db".equals(action)) {
                String result = DBUtil.testConnection();
                boolean ok = result.startsWith("SUCCESS");
                String msg = result.substring(result.indexOf("|") + 1);
                resp.getWriter().write("{\"success\":" + ok + ",\"message\":\"" + msg + "\"}");
                return;
            }

            if ("addUser".equals(action)) {
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String userType = req.getParameter("userType");

                // 详细信息（根据角色从动态表单传入）
                String name = req.getParameter("name");
                String phone = req.getParameter("phone");
                String idCard = req.getParameter("idCard");
                String checkInDate = req.getParameter("checkInDate");
                String workTypeId = req.getParameter("workTypeId");
                String companyName = req.getParameter("companyName");

                SystemUser u = new SystemUser();
                u.setUserId(userDAO.generateId(userType));
                u.setUsername(username);
                u.setPassword(password != null && !password.isEmpty() ? password : "123456");
                u.setUserType(userType);
                u.setRealName(name);
                u.setPhone(phone);

                boolean userOk = userDAO.insert(u);
                boolean detailOk = true;

                if (userOk) {
                    if ("业主".equals(userType)) {
                        // 先查房屋是否已存在，不存在则创建
                        String building = req.getParameter("building");
                        String unit = req.getParameter("unit");
                        String roomNo = req.getParameter("roomNo");
                        Housing housing = housingDAO.findByAddress(building, unit, roomNo);
                        if (housing == null) {
                            housing = new Housing();
                            housing.setBuilding(building);
                            housing.setUnit(unit);
                            housing.setRoomNo(roomNo);
                            housing.setArea(Double.parseDouble(req.getParameter("area")));
                            housing.setFloor(Integer.parseInt(req.getParameter("floor")));
                            housing.setHouseType(req.getParameter("houseType"));
                            housingDAO.insert(housing);
                        }
                        // 创建住户
                        Resident r = new Resident();
                        r.setUserId(u.getUserId());
                        r.setName(name != null ? name : u.getRealName());
                        r.setPhone(phone != null ? phone : u.getPhone());
                        r.setIdCard(idCard != null ? idCard : "440000" + String.format("%012d", (long)(System.currentTimeMillis() % 1000000000000L)));
                        r.setCheckInDate(checkInDate != null ? checkInDate : new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
                        detailOk = residentDAO.insert(r);
                        // 绑定房屋
                        if (detailOk) {
                            ResidentHousing rh = new ResidentHousing();
                            rh.setResidentId(r.getResidentId());
                            rh.setHousingId(housing.getHousingId());
                            rh.setStartDate(r.getCheckInDate());
                            rh.setOwner(true);
                            if (!residentHousingDAO.insert(rh)) {
                                detailOk = false;
                            }
                        }
                    } else if ("管理员".equals(userType)) {
                        Staff s = new Staff();
                        s.setStaffId(staffDAO.generateId());
                        s.setUserId(u.getUserId());
                        s.setName(name != null ? name : u.getRealName());
                        s.setPhone(phone != null ? phone : u.getPhone());
                        s.setIdCard(idCard != null ? idCard : "440000" + String.format("%012d", (long)(System.currentTimeMillis() % 1000000000000L)));
                        s.setAdmin(true);
                        s.setWorktypeId("WT007");
                        detailOk = staffDAO.insert(s);
                    } else if ("维修员".equals(userType)) {
                        Staff s = new Staff();
                        s.setStaffId(staffDAO.generateId());
                        s.setUserId(u.getUserId());
                        s.setName(name != null ? name : u.getRealName());
                        s.setPhone(phone != null ? phone : u.getPhone());
                        s.setIdCard(idCard != null ? idCard : "440000" + String.format("%012d", (long)(System.currentTimeMillis() % 1000000000000L)));
                        s.setAdmin(false);
                        s.setWorktypeId(workTypeId != null ? workTypeId : "WT001");
                        detailOk = staffDAO.insert(s);
                    } else if ("广告公司".equals(userType)) {
                        ExternalAdCompany ec = new ExternalAdCompany();
                        ec.setCompanyId(companyDAO.generateId());
                        ec.setUserId(u.getUserId());
                        ec.setCompanyName(companyName);
                        ec.setContact(name != null ? name : u.getRealName());
                        ec.setPhone(phone != null ? phone : u.getPhone());
                        detailOk = companyDAO.insert(ec);
                    }
                }

                resp.getWriter().write("{\"success\":" + userOk + ",\"message\":\"" +
                        (userOk ? (detailOk ? "账号创建成功" : "账号已创建，但详细信息创建失败") : "创建失败") + "\"}");
                return;
            }

            if ("workTypes".equals(action)) {
                List<WorkType> list = workTypeDAO.findForStaff();
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < list.size(); i++) {
                    if (i > 0) json.append(",");
                    json.append("{\"worktypeId\":\"").append(list.get(i).getWorktypeId())
                            .append("\",\"worktypeName\":\"").append(list.get(i).getWorktypeName())
                            .append("\"}");
                }
                json.append("]");
                resp.getWriter().write(json.toString());
                return;
            }

            if ("users".equals(action)) {
                List<SystemUser> users = userDAO.findAll();
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < users.size(); i++) {
                    SystemUser su = users.get(i);
                    if (i > 0) json.append(",");
                    json.append("{\"userId\":\"").append(su.getUserId())
                            .append("\",\"username\":\"").append(su.getUsername())
                            .append("\",\"userType\":\"").append(su.getUserType())
                            .append("\",\"realName\":\"").append(su.getRealName() != null ? su.getRealName() : "")
                            .append("\",\"phone\":\"").append(su.getPhone() != null ? su.getPhone() : "")
                            .append("\"}");
                }
                json.append("]");
                resp.getWriter().write(json.toString());
                return;
            }
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        doGet(req, resp);
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
                resp.sendRedirect(req.getContextPath() + "/admin/repair?action=list");
                break;
            case "业主":
                resp.sendRedirect(req.getContextPath() + "/owner/repair?action=list");
                break;
            case "维修员":
                resp.sendRedirect(req.getContextPath() + "/staff/repair?action=list");
                break;
            case "广告公司":
                resp.sendRedirect(req.getContextPath() + "/ad/company?action=myList");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}