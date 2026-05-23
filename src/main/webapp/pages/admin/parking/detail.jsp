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
    <title>车位详情 - <%=sp.getSpaceNo()%></title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .info-box h4 { margin-top: 0; border-bottom: 1px solid #ddd; padding-bottom: 8px; }
        .info-box p { margin: 6px 0; }
        .badge { padding: 2px 8px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-success { background-color: #28a745; }
        .badge-secondary { background-color: #6c757d; }
        .badge-warning { background-color: #ffc107; color: #000; }
        .badge-danger { background-color: #dc3545; }
        .badge-info { background-color: #17a2b8; }
        .badge-dark { background-color: #343a40; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; display: inline-block; }
        .btn-secondary { background-color: #6c757d; }
        .btn-danger { background-color: #dc3545; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px 10px; text-align: left; font-size: 13px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>车位详情 — <%=sp.getSpaceNo()%></h2>

            <div class="info-box">
                <h4>车位基本信息</h4>
                <p><strong>车位编号：</strong><%=sp.getSpaceNo()%></p>
                <p><strong>车位ID：</strong><%=sp.getSpaceId()%></p>
                <p><strong>位置：</strong><%=sp.getLocation()%></p>
                <p><strong>类型：</strong><%=sp.getType()%></p>
                <p><strong>状态：</strong><span class="badge <%= "已绑定".equals(sp.getStatus()) ? "badge-success" : "badge-secondary" %>"><%=sp.getStatus()%></span></p>
                <p><strong>创建时间：</strong><%=sp.getCreatedAt() != null ? sp.getCreatedAt().substring(0,16) : ""%></p>
            </div>

            <% if (sp.getResidentName() != null) { %>
            <div class="info-box">
                <h4>绑定住户信息</h4>
                <p><strong>住户姓名：</strong><%=sp.getResidentName()%></p>
                <p><strong>联系电话：</strong><%=sp.getResidentPhone() != null ? sp.getResidentPhone() : "暂无"%></p>
                <p><strong>住房地址：</strong><%=sp.getHousingAddress() != null ? sp.getHousingAddress() : "暂无"%></p>
            </div>
            <% } %>

            <% if (feeRecords != null && !feeRecords.isEmpty()) { %>
            <div class="info-box">
                <h4>费用记录</h4>
                <table>
                    <tr>
                        <th>月份</th><th>金额</th><th>状态</th><th>生成日期</th>
                    </tr>
                    <% for (ParkingFeeRecord fr : feeRecords) {
                        String frBadge = "badge-info";
                        if ("PAID".equals(fr.getStatus()) || "已缴纳".equals(fr.getStatus())) frBadge = "badge-success";
                        else if ("UNPAID".equals(fr.getStatus()) || "未缴纳".equals(fr.getStatus())) frBadge = "badge-danger";
                    %>
                    <tr>
                        <td><%=fr.getMonth()%></td>
                        <td>¥<%=String.format("%.2f", fr.getAmount())%></td>
                        <td><span class="badge <%=frBadge%>"><%=fr.getStatus()%></span></td>
                        <td><%=fr.getCreateDate() != null ? fr.getCreateDate().substring(0,10) : ""%></td>
                    </tr>
                    <% } %>
                </table>
            </div>
            <% } %>

            <div style="margin-top:15px;">
                <a href="${pageContext.request.contextPath}/admin/parking?action=list" class="btn btn-secondary">返回列表</a>
                <% if ("已绑定".equals(sp.getStatus())) { %>
                    <a href="${pageContext.request.contextPath}/admin/parking?action=unbind&spaceId=<%=sp.getSpaceId()%>" class="btn btn-danger" onclick="return confirm('确定要移除该车位的绑定吗？')">移除绑定</a>
                <% } %>
            </div>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>