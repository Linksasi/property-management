<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 侧边栏菜单 - 管理员端 - 公共组件 --%>
<%
String currentModule = (String) request.getAttribute("module");
if (currentModule == null) {
    currentModule = request.getParameter("module");
}
%>
<div class="sidebar">
    <div class="sidebar-title">管理菜单</div>
    <a href="${pageContext.request.contextPath}/admin/staff?action=list" class="sidebar-item <%= "staff".equals(currentModule) ? "active" : "" %>">工作人员管理</a>
    <a href="${pageContext.request.contextPath}/admin/resident?action=list" class="sidebar-item <%= "resident".equals(currentModule) ? "active" : "" %>">住户管理</a>
    <a href="${pageContext.request.contextPath}/admin/property?action=list" class="sidebar-item <%= "property".equals(currentModule) ? "active" : "" %>">物业费管理</a>
    <a href="${pageContext.request.contextPath}/admin/water?action=list" class="sidebar-item <%= "water".equals(currentModule) ? "active" : "" %>">水费管理</a>
    <a href="${pageContext.request.contextPath}/admin/parking?action=list" class="sidebar-item <%= "parking".equals(currentModule) ? "active" : "" %>">车位费管理</a>
    <a href="${pageContext.request.contextPath}/admin/repair?action=list" class="sidebar-item <%= "repair".equals(currentModule) ? "active" : "" %>">维修管理</a>
    <a href="${pageContext.request.contextPath}/admin/ad?action=list" class="sidebar-item <%= "ad".equals(currentModule) ? "active" : "" %>">广告管理</a>
    <div class="sidebar-divider"></div>
    <a href="${pageContext.request.contextPath}/logout" class="sidebar-item">退出登录</a>
</div>
