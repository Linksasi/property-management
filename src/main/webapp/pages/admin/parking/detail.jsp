<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.ParkingSpace, com.property.entity.ParkingFeeRecord, java.util.List" %>
<%
    ParkingSpace sp = (ParkingSpace) request.getAttribute("space");
    List<ParkingFeeRecord> feeRecords = (List<ParkingFeeRecord>) request.getAttribute("feeRecords");
    if (sp == null) { response.sendRedirect(request.getContextPath() + "/admin/parking?action=list"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>车位详情 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/admin-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">车位详情 — <%= sp.getSpaceNo() %></h2>

            <div class="card mb-3">
                <h4 style="margin-top:0;border-bottom:1px solid var(--border);padding-bottom:8px;">车位基本信息</h4>
                <p><strong>车位编号：</strong><%= sp.getSpaceNo() %></p>
                <p><strong>位置：</strong><%= sp.getLocation() %></p>
                <p><strong>类型：</strong><%= sp.getType() %></p>
                <p><strong>状态：</strong><span class="status-tag <%= "已绑定".equals(sp.getStatus()) ? "status-success" : "status-info" %>"><%= sp.getStatus() %></span></p>
                <p><strong>创建时间：</strong><%= sp.getCreatedAt() != null ? sp.getCreatedAt().substring(0, 16) : "" %></p>
            </div>

            <% if (sp.getResidentName() != null) { %>
            <div class="card mb-3">
                <h4 style="margin-top:0;border-bottom:1px solid var(--border);padding-bottom:8px;">绑定住户信息</h4>
                <p><strong>住户姓名：</strong><%= sp.getResidentName() %></p>
                <p><strong>联系电话：</strong><%= sp.getResidentPhone() != null ? sp.getResidentPhone() : "暂无" %></p>
                <p><strong>住房地址：</strong><%= sp.getHousingAddress() != null ? sp.getHousingAddress() : "暂无" %></p>
            </div>
            <% } %>

            <% if (feeRecords != null && !feeRecords.isEmpty()) { %>
            <div class="card mb-3">
                <h4 style="margin-top:0;border-bottom:1px solid var(--border);padding-bottom:8px;">费用记录</h4>
                <table class="table-custom">
                    <thead>
                        <tr><th>月份</th><th>金额</th><th>状态</th><th>生成日期</th></tr>
                    </thead>
                    <tbody>
                        <% for (ParkingFeeRecord fr : feeRecords) {
                            String frBadge = "status-info";
                            if ("PAID".equals(fr.getStatus()) || "已缴纳".equals(fr.getStatus())) frBadge = "status-success";
                            else if ("UNPAID".equals(fr.getStatus()) || "未缴纳".equals(fr.getStatus())) frBadge = "status-error";
                        %>
                        <tr>
                            <td><%= fr.getMonth() %></td>
                            <td>¥<%= String.format("%.2f", fr.getAmount()) %></td>
                            <td><span class="status-tag <%= frBadge %>"><%= fr.getStatus() %></span></td>
                            <td><%= fr.getCreateDate() != null ? fr.getCreateDate().substring(0, 10) : "" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>

            <div class="d-flex gap-12">
                <a href="${pageContext.request.contextPath}/admin/parking?action=list" class="btn btn-secondary">返回列表</a>
                <% if ("已绑定".equals(sp.getStatus())) { %>
                <a href="${pageContext.request.contextPath}/admin/parking?action=unbind&spaceId=<%= sp.getSpaceId() %>" class="btn btn-danger" onclick="return confirm('确定要移除该车位的绑定吗？')">移除绑定</a>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>