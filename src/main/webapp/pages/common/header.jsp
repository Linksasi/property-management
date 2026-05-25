<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
<div class="top-bar">
    <h4>小区物业管理系统</h4>
    <div>当前用户：<%= session.getAttribute("currentUser") != null ? session.getAttribute("currentUser") : "管理员" %></div>
</div>
<div class="main-container">