<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.MaintenanceWorkOrder" %>
<%
    List<MaintenanceWorkOrder> list = (List<MaintenanceWorkOrder>) request.getAttribute("list");
%>
<!DOCTYPE html>
<html>
<head>
    <title>我的工单</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; font-size: 14px; }
        th { background-color: #f2f2f2; }
        .badge { padding: 3px 10px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-warning { background-color: #ffc107; color: #000; }
        .badge-primary { background-color: #007bff; }
        .badge-info { background-color: #17a2b8; }
        .badge-success { background-color: #28a745; }
        .btn { padding: 5px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 12px; }
        .btn-info { background-color: #17a2b8; }
        .btn-warning { background-color: #ffc107; color: #000; }
        .btn-primary { background-color: #007bff; }
        .btn-success { background-color: #28a745; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "staff_repair");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/staff-sidebar.jsp" />
    <div class="content-area">
        <h2>我的工单</h2>
        <% if (list == null || list.isEmpty()) { %>
            <p style="color:#999;margin-top:30px;">暂无工单。</p>
        <% } else { %>
        <table>
            <tr>
                <th>工单ID</th><th>问题描述</th><th>派工时间</th><th>状态</th><th>操作</th>
            </tr>
            <% for (MaintenanceWorkOrder wo : list) {
                String badgeClass = "badge-info";
                switch (wo.getStatus()) {
                    case "待接单": badgeClass = "badge-warning"; break;
                    case "已接单": badgeClass = "badge-primary"; break;
                    case "维修中": badgeClass = "badge-info"; break;
                    case "待确认": badgeClass = "badge-warning"; break;
                    case "已完成": badgeClass = "badge-success"; break;
                }
            %>
            <tr>
                <td><%=wo.getWorkOrderId()%></td>
                <td><%=wo.getRepairContent() != null && wo.getRepairContent().length() > 20 ? wo.getRepairContent().substring(0,20)+"..." : (wo.getRepairContent() != null ? wo.getRepairContent() : "")%></td>
                <td><%=wo.getAssignTime() != null ? wo.getAssignTime().substring(0,16) : ""%></td>
                <td><span class="badge <%=badgeClass%>"><%=wo.getStatus()%></span></td>
                <td>
                    <a href="${pageContext.request.contextPath}/staff/repair?action=detail&workOrderId=<%=wo.getWorkOrderId()%>" class="btn btn-info">查看详情</a>
                    <% if ("待接单".equals(wo.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/staff/repair?action=receive&workOrderId=<%=wo.getWorkOrderId()%>" class="btn btn-primary">接单</a>
                    <% } %>
                    <% if ("已接单".equals(wo.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/staff/repair?action=start&workOrderId=<%=wo.getWorkOrderId()%>" class="btn btn-warning">开始维修</a>
                    <% } %>
                    <% if ("维修中".equals(wo.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/staff/repair?action=submit&workOrderId=<%=wo.getWorkOrderId()%>" class="btn btn-success">提交结果</a>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
        <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>