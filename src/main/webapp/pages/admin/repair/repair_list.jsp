<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.RepairRequest" %>
<%
    List<RepairRequest> list = (List<RepairRequest>) request.getAttribute("list");
%>
<!DOCTYPE html>
<html>
<head>
    <title>维修申请管理</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; font-size: 14px; }
        th { background-color: #f2f2f2; }
        .badge { padding: 3px 10px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-warning { background-color: #ffc107; color: #000; }
        .badge-danger { background-color: #dc3545; }
        .badge-primary { background-color: #007bff; }
        .badge-success { background-color: #28a745; }
        .badge-secondary { background-color: #6c757d; }
        .badge-info { background-color: #17a2b8; }
        .badge-dark { background-color: #343a40; }
        .btn { padding: 5px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 12px; }
        .btn-info { background-color: #17a2b8; }
        .btn-warning { background-color: #ffc107; color: #000; }
        .btn-primary { background-color: #007bff; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "admin_repair");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>维修申请管理</h2>
        <div style="margin-bottom:15px;">
            <a href="${pageContext.request.contextPath}/admin/repair?action=orderList" class="btn btn-primary">查看工单列表</a>
        </div>
        <% if (list == null || list.isEmpty()) { %>
            <p style="color:#999;margin-top:30px;">暂无维修申请。</p>
        <% } else { %>
        <table>
            <tr>
                <th>申请ID</th><th>申请人</th><th>地址</th><th>维修类型</th><th>申请时间</th><th>状态</th><th>操作</th>
            </tr>
            <% for (RepairRequest rr : list) {
                String badgeClass = "";
                switch (rr.getStatus()) {
                    case "待审核": badgeClass = "badge-warning"; break;
                    case "已派工": badgeClass = "badge-primary"; break;
                    case "已完成": badgeClass = "badge-success"; break;
                    case "审核不通过": badgeClass = "badge-danger"; break;
                    case "已取消": badgeClass = "badge-secondary"; break;
                }
            %>
            <tr>
                <td><%=rr.getRequestId()%></td>
                <td><%=rr.getResidentName()%></td>
                <td><%=rr.getHousingAddress()%></td>
                <td><%=rr.getRepairType()%></td>
                <td><%=rr.getApplyTime() != null ? rr.getApplyTime().substring(0,16) : ""%></td>
                <td><span class="badge <%=badgeClass%>"><%=rr.getStatus()%></span></td>
                <td>
                    <% if ("待审核".equals(rr.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/admin/repair?action=audit&requestId=<%=rr.getRequestId()%>" class="btn btn-warning">审核</a>
                    <% } else if ("已派工".equals(rr.getStatus()) || "已完成".equals(rr.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/admin/repair?action=orderDetail&requestId=<%=rr.getRequestId()%>" class="btn btn-primary">查看工单</a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/admin/repair?action=detail&requestId=<%=rr.getRequestId()%>" class="btn btn-info">查看详情</a>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
        </div>
    </div>
</div>
<jsp:include page="/pages/common/footer.jsp" />
</body>
</html>