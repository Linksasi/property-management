<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.dao.WorkTypeDAO" %>
<%@ page import="com.property.entity.WorkType" %>
<%@ page import="java.util.List" %>
<%
    String error = (String) request.getAttribute("error");
    if (error == null) error = "";

    // 回显表单数据（注册失败时）
    String reg_username = (String) request.getAttribute("reg_username");
    String reg_userType = (String) request.getAttribute("reg_userType");
    String reg_name = (String) request.getAttribute("reg_name");
    String reg_phone = (String) request.getAttribute("reg_phone");
    String reg_idCard = (String) request.getAttribute("reg_idCard");
    String reg_checkInDate = (String) request.getAttribute("reg_checkInDate");
    String reg_building = (String) request.getAttribute("reg_building");
    String reg_unit = (String) request.getAttribute("reg_unit");
    String reg_roomNo = (String) request.getAttribute("reg_roomNo");
    String reg_area = (String) request.getAttribute("reg_area");
    String reg_floor = (String) request.getAttribute("reg_floor");
    String reg_houseType = (String) request.getAttribute("reg_houseType");
    String reg_workTypeId = (String) request.getAttribute("reg_workTypeId");
    String reg_companyName = (String) request.getAttribute("reg_companyName");

    if (reg_username == null) reg_username = "";
    if (reg_userType == null) reg_userType = "业主";
    if (reg_name == null) reg_name = "";
    if (reg_phone == null) reg_phone = "";
    if (reg_idCard == null) reg_idCard = "";
    if (reg_checkInDate == null) reg_checkInDate = "";
    if (reg_building == null) reg_building = "";
    if (reg_unit == null) reg_unit = "";
    if (reg_roomNo == null) reg_roomNo = "";
    if (reg_area == null) reg_area = "";
    if (reg_floor == null) reg_floor = "";
    if (reg_houseType == null) reg_houseType = "";
    if (reg_workTypeId == null) reg_workTypeId = "";
    if (reg_companyName == null) reg_companyName = "";

    // 加载工种列表
    WorkTypeDAO workTypeDAO = new WorkTypeDAO();
    List<WorkType> workTypes = workTypeDAO.findForStaff();
%>
<!DOCTYPE html>
<html>
<head>
    <title>物业管理系统 - 注册</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", Arial, sans-serif; background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 20px; }
        .register-box { background: white; padding: 36px 40px; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 520px; max-width: 100%; }
        .register-box h2 { text-align: center; color: #2E7D32; margin-bottom: 6px; font-size: 22px; }
        .register-box .subtitle { text-align: center; color: #999; font-size: 13px; margin-bottom: 22px; }
        .form-row { display: flex; gap: 12px; margin-bottom: 14px; }
        .form-group { flex: 1; min-width: 0; margin-bottom: 14px; }
        .form-group label { display: block; margin-bottom: 5px; color: #555; font-size: 13px; }
        .form-group label .req { color: red; }
        .form-group input, .form-group select { width: 100%; padding: 9px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #2E7D32; }
        .section-title { font-size: 14px; font-weight: bold; color: #333; border-bottom: 1px dashed #ddd; padding-bottom: 6px; margin: 6px 0 12px; }
        .btn-register { width: 100%; padding: 12px; background: #2E7D32; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; transition: background 0.2s; margin-top: 4px; }
        .btn-register:hover { background: #1B5E20; }
        .error-msg { background: #FFEBEE; color: #C62828; border: 1px solid #EF9A9A; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 13px; text-align: center; }
        .links { text-align: center; margin-top: 16px; font-size: 13px; color: #999; }
        .links a { color: #2E7D32; text-decoration: none; }
        .links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="register-box">
        <h2>创建账号</h2>
        <p class="subtitle">注册后可登录使用物业管理系统</p>

        <% if (!error.isEmpty()) { %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <!-- 登录信息 -->
            <p class="section-title">登录信息</p>
            <div class="form-row">
                <div class="form-group">
                    <label><span class="req">*</span> 用户名</label>
                    <input type="text" name="username" value="<%= reg_username %>" placeholder="登录用户名">
                </div>
                <div class="form-group">
                    <label><span class="req">*</span> 角色</label>
                    <select name="userType" id="userType" onchange="onRoleChange()">
                        <option value="业主" <%= "业主".equals(reg_userType) ? "selected" : "" %>>业主</option>
                        <option value="管理员" <%= "管理员".equals(reg_userType) ? "selected" : "" %>>管理员</option>
                        <option value="维修员" <%= "维修员".equals(reg_userType) ? "selected" : "" %>>维修员</option>
                        <option value="广告公司" <%= "广告公司".equals(reg_userType) ? "selected" : "" %>>广告公司</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label><span class="req">*</span> 密码</label>
                    <input type="password" name="password" placeholder="至少6位">
                </div>
                <div class="form-group">
                    <label><span class="req">*</span> 确认密码</label>
                    <input type="password" name="confirmPassword" placeholder="再次输入密码">
                </div>
            </div>

            <!-- 个人信息 -->
            <p class="section-title">个人信息</p>
            <div class="form-row">
                <div class="form-group">
                    <label><span class="req">*</span> 姓名</label>
                    <input type="text" name="name" value="<%= reg_name %>" placeholder="真实姓名">
                </div>
                <div class="form-group">
                    <label><span class="req">*</span> 电话</label>
                    <input type="text" name="phone" value="<%= reg_phone %>" placeholder="手机号">
                </div>
                <div class="form-group">
                    <label>身份证号</label>
                    <input type="text" name="idCard" value="<%= reg_idCard %>" placeholder="18位身份证号">
                </div>
            </div>

            <!-- 业主专属 -->
            <div id="ownerFields">
                <div class="form-group">
                    <label>入住日期</label>
                    <input type="date" name="checkInDate" value="<%= reg_checkInDate %>">
                </div>
                <p class="section-title">房屋信息</p>
                <div class="form-row">
                    <div class="form-group">
                        <label><span class="req">*</span> 楼栋</label>
                        <input type="text" name="building" value="<%= reg_building %>" placeholder="如：A">
                    </div>
                    <div class="form-group">
                        <label><span class="req">*</span> 单元</label>
                        <input type="text" name="unit" value="<%= reg_unit %>" placeholder="如：1">
                    </div>
                    <div class="form-group">
                        <label><span class="req">*</span> 房号</label>
                        <input type="text" name="roomNo" value="<%= reg_roomNo %>" placeholder="如：101">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>面积(m²)</label>
                        <input type="number" step="0.01" name="area" value="<%= reg_area %>" placeholder="如：89.50">
                    </div>
                    <div class="form-group">
                        <label>楼层</label>
                        <input type="number" name="floor" value="<%= reg_floor %>" placeholder="如：1">
                    </div>
                    <div class="form-group">
                        <label>户型</label>
                        <select name="houseType">
                            <option value="">请选择</option>
                            <option value="一室一厅" <%= "一室一厅".equals(reg_houseType) ? "selected" : "" %>>一室一厅</option>
                            <option value="两室一厅" <%= "两室一厅".equals(reg_houseType) ? "selected" : "" %>>两室一厅</option>
                            <option value="三室一厅" <%= "三室一厅".equals(reg_houseType) ? "selected" : "" %>>三室一厅</option>
                            <option value="三室两厅" <%= "三室两厅".equals(reg_houseType) ? "selected" : "" %>>三室两厅</option>
                            <option value="四室两厅" <%= "四室两厅".equals(reg_houseType) ? "selected" : "" %>>四室两厅</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- 维修员专属 -->
            <div id="staffFields" style="display:none;">
                <div class="form-group" style="max-width:300px;">
                    <label><span class="req">*</span> 工种</label>
                    <select name="workTypeId">
                        <% for (WorkType wt : workTypes) { %>
                        <option value="<%= wt.getWorktypeId() %>" <%= wt.getWorktypeId().equals(reg_workTypeId) ? "selected" : "" %>><%= wt.getWorktypeName() %></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <!-- 广告公司专属 -->
            <div id="companyFields" style="display:none;">
                <div class="form-row">
                    <div class="form-group">
                        <label><span class="req">*</span> 公司名称</label>
                        <input type="text" name="companyName" value="<%= reg_companyName %>" placeholder="广告公司全称">
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-register">注 册</button>
        </form>

        <div class="links">
            <a href="${pageContext.request.contextPath}/login.jsp">已有账号？去登录</a>
        </div>
    </div>

    <script>
    function onRoleChange() {
        var role = document.getElementById('userType').value;
        document.getElementById('ownerFields').style.display = (role === '业主') ? '' : 'none';
        document.getElementById('staffFields').style.display = (role === '维修员') ? '' : 'none';
        document.getElementById('companyFields').style.display = (role === '广告公司') ? '' : 'none';
    }
    window.onload = function() { onRoleChange(); };
    </script>
</body>
</html>
