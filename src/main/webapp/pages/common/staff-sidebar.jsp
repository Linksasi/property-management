<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 侧边栏菜单 - 员工端 - 公共组件 --%>
<%
String currentModule = (String) request.getAttribute("module");
if (currentModule == null) {
    currentModule = request.getParameter("module");
}
%>
<div class="sidebar">
    <div class="sidebar-title">员工服务</div>
    <a href="${pageContext.request.contextPath}/staff/schedule?action=list" class="sidebar-item <%= "schedule".equals(currentModule) ? "active" : "" %>">我的排班</a>
    <a href="${pageContext.request.contextPath}/staff/repair?action=list" class="sidebar-item <%= "repair".equals(currentModule) ? "active" : "" %>">我的工单</a>
    <div class="sidebar-divider"></div>
    <a href="${pageContext.request.contextPath}/logout" class="sidebar-item">退出登录</a>
</div>
