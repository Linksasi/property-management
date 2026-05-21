<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 侧边栏菜单 - 业主端 - 公共组件 --%>
<%
String currentModule = (String) request.getAttribute("module");
if (currentModule == null) {
    currentModule = request.getParameter("module");
}
%>
<div class="sidebar">
    <div class="sidebar-title">业主服务</div>
    <a href="${pageContext.request.contextPath}/owner/resident?action=info" class="sidebar-item <%= "resident".equals(currentModule) ? "active" : "" %>">个人信息</a>
    <a href="${pageContext.request.contextPath}/owner/property?action=list" class="sidebar-item <%= "property".equals(currentModule) ? "active" : "" %>">物业费</a>
    <a href="${pageContext.request.contextPath}/owner/water?action=list" class="sidebar-item <%= "water".equals(currentModule) ? "active" : "" %>">水费</a>
    <a href="${pageContext.request.contextPath}/owner/parking?action=list" class="sidebar-item <%= "parking".equals(currentModule) ? "active" : "" %>">车位费</a>
    <a href="${pageContext.request.contextPath}/owner/repair?action=list" class="sidebar-item <%= "repair".equals(currentModule) ? "active" : "" %>">维修申请</a>
    <div class="sidebar-divider"></div>
    <a href="${pageContext.request.contextPath}/logout" class="sidebar-item">退出登录</a>
</div>
