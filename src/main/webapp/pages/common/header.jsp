<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
<div class="top-bar">
    <h4>小区物业管理系统</h4>
    <%
    com.property.entity.SystemUser currentUser = (com.property.entity.SystemUser) session.getAttribute("currentUser");
    String displayName = "未登录";
    if (currentUser != null) {
        displayName = currentUser.getRealName() != null && !currentUser.getRealName().isEmpty()
                      ? currentUser.getRealName() : currentUser.getUsername();
    }
%>
    <div>当前用户：<%= displayName %></div>
</div>
<div class="main-container">