<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.MaintenanceWorkOrder, com.property.entity.RepairRequest" %>
<%
    MaintenanceWorkOrder wo = (MaintenanceWorkOrder) request.getAttribute("order");
    RepairRequest rr = (RepairRequest) request.getAttribute("request");
    if (wo == null) { response.sendRedirect(request.getContextPath() + "/staff/repair?action=list"); return; }
    String badgeClass = "badge-info";
    switch (wo.getStatus()) {
        case "待接单": badgeClass = "badge-warning"; break;
        case "已接单": badgeClass = "badge-primary"; break;
        case "维修中": badgeClass = "badge-info"; break;
        case "待确认": badgeClass = "badge-warning"; break;
        case "已完成": badgeClass = "badge-success"; break;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>工单详情</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .info-box h4 { margin-top: 0; }
        .info-box p { margin: 6px 0; }
        .badge { padding: 2px 8px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-warning { background-color: #ffc107; color: #000; }
        .badge-primary { background-color: #007bff; }
        .badge-info { background-color: #17a2b8; }
        .badge-success { background-color: #28a745; }
        .badge-dark { background-color: #343a40; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; display: inline-block; margin-right: 5px; }
        .btn-primary { background-color: #007bff; }
        .btn-success { background-color: #28a745; }
        .btn-warning { background-color: #ffc107; color: #000; }
        .btn-secondary { background-color: #6c757d; }
        .timeline { margin-left: 20px; }
        .timeline-item { position: relative; padding-left: 30px; margin-bottom: 12px; }
        .timeline-item::before { content: ''; position: absolute; left: 0; top: 3px; width: 12px; height: 12px; border-radius: 50%; background-color: #007bff; }
        .timeline-item::after { content: ''; position: absolute; left: 5px; top: 18px; width: 2px; height: calc(100% + 10px); background-color: #ddd; }
        .timeline-item:last-child::after { display: none; }
        .action-bar { margin-top: 20px; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "repair"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/staff-sidebar.jsp" />
    <div class="content-area">
        <h2>工单详情</h2>

            <div class="info-box">
                <h4>工单信息</h4>
                <p><strong>工单ID：</strong><%=wo.getWorkOrderId()%></p>
                <p><strong>申请ID：</strong><%=wo.getRequestId()%></p>
                <p><strong>工单状态：</strong><span class="badge <%=badgeClass%>"><%=wo.getStatus()%></span></p>
                <p><strong>维修人员：</strong><%=wo.getStaffName() != null ? wo.getStaffName() : "待指派"%></p>
                <p><strong>派工时间：</strong><%=wo.getAssignTime() != null ? wo.getAssignTime().substring(0,16) : ""%></p>
            </div>

            <% if (rr != null) { %>
            <div class="info-box">
                <h4>住户信息</h4>
                <p><strong>住户姓名：</strong><%=rr.getResidentName() != null ? rr.getResidentName() : "未知"%></p>
                <p><strong>住房地址：</strong><%=rr.getHousingAddress() != null ? rr.getHousingAddress() : "未知"%></p>
                <p><strong>联系电话：</strong><%=rr.getResidentPhone() != null ? rr.getResidentPhone() : "暂无"%></p>
            </div>

            <div class="info-box">
                <h4>维修需求</h4>
                <p><strong>维修类型：</strong><%=rr.getRepairType()%></p>
                <p><strong>紧急程度：</strong><%=rr.getUrgency()%></p>
                <p><strong>问题描述：</strong><%=rr.getDescription()%></p>
            </div>
            <% } %>

            <div class="info-box">
                <h4>工单进度</h4>
                <div class="timeline">
                    <% if (rr != null) { %>
                    <div class="timeline-item"><strong><%=rr.getApplyTime() != null ? rr.getApplyTime().substring(0,16) : ""%></strong> 提交维修申请</div>
                    <% } %>
                    <% if (wo.getAssignTime() != null) { %>
                    <div class="timeline-item"><strong><%=wo.getAssignTime().substring(0,16)%></strong> 派工</div>
                    <% } %>
                    <% if (wo.getReceiveTime() != null) { %>
                    <div class="timeline-item"><strong><%=wo.getReceiveTime().substring(0,16)%></strong> 接单</div>
                    <% } %>
                    <% if (wo.getStartTime() != null) { %>
                    <div class="timeline-item"><strong><%=wo.getStartTime().substring(0,16)%></strong> 开始维修</div>
                    <% } %>
                    <% if (wo.getCompleteTime() != null) { %>
                    <div class="timeline-item"><strong><%=wo.getCompleteTime().substring(0,16)%></strong> 提交结果</div>
                    <% } %>
                    <% if (wo.getConfirmTime() != null) { %>
                    <div class="timeline-item"><strong><%=wo.getConfirmTime().substring(0,16)%></strong> 业主确认</div>
                    <% } %>
                </div>
            </div>

            <div class="action-bar">
                <% if ("待接单".equals(wo.getStatus())) { %>
                    <a href="${pageContext.request.contextPath}/staff/repair?action=receive&workOrderId=<%=wo.getWorkOrderId()%>" class="btn btn-primary">接单</a>
                <% } else if ("已接单".equals(wo.getStatus())) { %>
                    <a href="${pageContext.request.contextPath}/staff/repair?action=start&workOrderId=<%=wo.getWorkOrderId()%>" class="btn btn-warning">开始维修</a>
                <% } else if ("维修中".equals(wo.getStatus())) { %>
                    <a href="${pageContext.request.contextPath}/staff/repair?action=submit&workOrderId=<%=wo.getWorkOrderId()%>" class="btn btn-success">提交结果</a>
                <% } %>
                <a href="${pageContext.request.contextPath}/staff/repair?action=list" class="btn btn-secondary">返回列表</a>
            </div>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>