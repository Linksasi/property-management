<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 顶部栏 - 公共组件 --%>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
<div class="top-bar">
    <h4>小区物业管理系统</h4>
    <div>当前用户：<%= session.getAttribute("currentUser") != null ? session.getAttribute("currentUser") : "管理员" %></div>
</div>