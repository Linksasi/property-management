<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingSpace" %>
<%
    List<ParkingSpace> list = (List<ParkingSpace>) request.getAttribute("list");
%>
<!DOCTYPE html>
<html>
<head>
    <title>我的车位</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .card { border: 1px solid #ddd; border-radius: 8px; padding: 20px; margin-bottom: 15px; }
        .card h4 { margin-top: 0; color: #2E7D32; }
        .card p { margin: 5px 0; }
        .badge { padding: 3px 10px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-success { background-color: #28a745; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; font-size: 13px; }
        .btn-primary { background-color: #007bff; }
        .btn-secondary { background-color: #6c757d; }
        .actions { margin-bottom: 15px; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "parking");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>我的车位</h2>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/owner/parking?action=query" class="btn btn-primary">查询空闲车位</a>
            <a href="${pageContext.request.contextPath}/owner/parking?action=feeList" class="btn btn-primary">查看账单</a>
        </div>
        <% if (list == null || list.isEmpty()) { %>
            <p style="color:#999;">您尚未绑定车位，可点击"查询空闲车位"申请绑定。</p>
        <% } else {
            for (ParkingSpace sp : list) { %>
                <div class="card">
                    <h4><%=sp.getSpaceNo()%> <span class="badge badge-success"><%=sp.getStatus()%></span></h4>
                    <p><strong>位置：</strong><%=sp.getLocation()%></p>
                    <p><strong>类型：</strong><%=sp.getType()%></p>
                    <p><strong>绑定时间：</strong><%=sp.getCreatedAt() != null ? sp.getCreatedAt().substring(0,10) : ""%></p>
                </div>
        <%  }
        } %>
        </div>
    </div>
</div>
<jsp:include page="/pages/common/footer.jsp" />
</body>
</html>