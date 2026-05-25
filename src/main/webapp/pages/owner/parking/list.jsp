<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingSpace" %>
<%
    List<ParkingSpace> list = (List<ParkingSpace>) request.getAttribute("list");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的车位 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/owner-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">我的车位</h2>

            <div class="d-flex gap-12 mb-3">
                <a href="${pageContext.request.contextPath}/owner/parking?action=query" class="btn btn-primary">查询空闲车位</a>
                <a href="${pageContext.request.contextPath}/owner/parking?action=feeList" class="btn btn-secondary">查看账单</a>
            </div>

            <% if (list == null || list.isEmpty()) { %>
            <div class="card">
                <p style="color:var(--text-secondary);">您尚未绑定车位，可点击"查询空闲车位"申请绑定。</p>
            </div>
            <% } else {
                for (ParkingSpace sp : list) { %>
            <div class="card mb-3">
                <h4 style="margin-top:0;color:var(--primary);">
                    <%= sp.getSpaceNo() %>
                    <span class="status-tag status-success"><%= sp.getStatus() %></span>
                </h4>
                <p><strong>位置：</strong><%= sp.getLocation() %></p>
                <p><strong>类型：</strong><%= sp.getType() %></p>
                <p><strong>绑定时间：</strong><%= sp.getCreatedAt() != null ? sp.getCreatedAt().substring(0, 10) : "" %></p>
            </div>
            <% } } %>
        </div>
    </div>
</body>
</html>