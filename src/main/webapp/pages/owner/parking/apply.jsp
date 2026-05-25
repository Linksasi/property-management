<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.ParkingSpace" %>
<%
    ParkingSpace sp = (ParkingSpace) request.getAttribute("space");
    if (sp == null) { response.sendRedirect(request.getContextPath() + "/owner/parking?action=query"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>申请绑定车位 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/owner-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">申请绑定车位</h2>

            <div class="card mb-3">
                <h4 style="margin-top:0;border-bottom:1px solid var(--border);padding-bottom:8px;">车位信息</h4>
                <p><strong>车位编号：</strong><%= sp.getSpaceNo() %></p>
                <p><strong>位置：</strong><%= sp.getLocation() %></p>
                <p><strong>类型：</strong><%= sp.getType() %></p>
                <p><strong>状态：</strong><span class="status-tag status-info"><%= sp.getStatus() %></span></p>
            </div>

            <div class="card">
                <form action="${pageContext.request.contextPath}/owner/parking?action=submitApply" method="post">
                    <input type="hidden" name="spaceId" value="<%= sp.getSpaceId() %>">
                    <div class="form-group">
                        <label class="form-label">绑定月数</label>
                        <select name="months" class="form-control" style="max-width:200px;">
                            <option value="1">1个月</option>
                            <option value="3">3个月</option>
                            <option value="6">6个月</option>
                            <option value="12">12个月</option>
                        </select>
                    </div>
                    <p class="mb-3">确认申请绑定此车位？</p>
                    <div class="d-flex gap-12">
                        <button type="submit" class="btn btn-primary">确认申请</button>
                        <a href="${pageContext.request.contextPath}/owner/parking?action=query" class="btn btn-secondary">取消</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>