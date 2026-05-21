<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 侧边栏菜单 - 广告公司端 - 公共组件 --%>
<%
String currentModule = (String) request.getAttribute("module");
if (currentModule == null) {
    currentModule = request.getParameter("module");
}
%>
<div class="sidebar">
    <div class="sidebar-title">广告服务</div>
    <a href="${pageContext.request.contextPath}/ad/company?action=apply" class="sidebar-item <%= "apply".equals(currentModule) ? "active" : "" %>">提交申请</a>
    <a href="${pageContext.request.contextPath}/ad/company?action=list" class="sidebar-item <%= "myapply".equals(currentModule) ? "active" : "" %>">我的申请</a>
    <div class="sidebar-divider"></div>
    <a href="${pageContext.request.contextPath}/logout" class="sidebar-item">退出登录</a>
</div>
