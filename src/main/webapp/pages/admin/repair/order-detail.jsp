<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.RepairRequest, com.property.entity.MaintenanceWorkOrder" %>
<%
    RepairRequest rr = (RepairRequest) request.getAttribute("request");
    MaintenanceWorkOrder wo = (MaintenanceWorkOrder) request.getAttribute("order");
    if (rr == null) { response.sendRedirect(request.getContextPath() + "/admin/repair?action=list"); return; }
    String badgeClass = "badge-info";
    if (wo != null) {
        switch (wo.getStatus()) {
            case "待接单": badgeClass = "badge-warning"; break;
            case "已接单": badgeClass = "badge-primary"; break;
            case "维修中": badgeClass = "badge-info"; break;
            case "待确认": badgeClass = "badge-warning"; break;
            case "已完成": badgeClass = "badge-success"; break;
        }
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
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; display: inline-block; }
        .btn-secondary { background-color: #6c757d; }
        .timeline { margin-left: 20px; }
        .timeline-item { position: relative; padding-left: 30px; margin-bottom: 12px; }
        .timeline-item::before { content: ''; position: absolute; left: 0; top: 3px; width: 12px; height: 12px; border-radius: 50%; background-color: #007bff; }
        .timeline-item::after { content: ''; position: absolute; left: 5px; top: 18px; width: 2px; height: calc(100% + 10px); background-color: #ddd; }
        .timeline-item:last-child::after { display: none; }
        .stars { font-size: 18px; color: #ffc107; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "repair"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>工单详情</h2>

            <div class="info-box">
                <h4>原始申请单信息</h4>
                <p><strong>申请ID：</strong><%=rr.getRequestId()%></p>
                <p><strong>住户姓名：</strong><%=rr.getResidentName() != null ? rr.getResidentName() : "未知"%></p>
                <p><strong>住房地址：</strong><%=rr.getHousingAddress() != null ? rr.getHousingAddress() : "未知"%></p>
                <p><strong>维修类型：</strong><%=rr.getRepairType()%></p>
                <p><strong>紧急程度：</strong><%=rr.getUrgency()%></p>
                <p><strong>申请时间：</strong><%=rr.getApplyTime() != null ? rr.getApplyTime().substring(0,16) : ""%></p>
                <p><strong>联系电话：</strong><%=rr.getResidentPhone() != null ? rr.getResidentPhone() : "暂无"%></p>
            </div>

            <div class="info-box">
                <h4>问题描述</h4>
                <p><%=rr.getDescription()%></p>
            </div>

            <% if (wo != null) { %>
            <div class="info-box">
                <h4>工单信息</h4>
                <p><strong>工单ID：</strong><%=wo.getWorkOrderId()%></p>
                <p><strong>当前状态：</strong><span class="badge <%=badgeClass%>"><%=wo.getStatus()%></span></p>
                <p><strong>维修人员：</strong><%=wo.getStaffName() != null ? wo.getStaffName() : "待指派"%></p>
                <p><strong>派工时间：</strong><%=wo.getAssignTime() != null ? wo.getAssignTime().substring(0,16) : ""%></p>
            </div>

            <div class="info-box">
                <h4>维修进度</h4>
                <div class="timeline">
                    <div class="timeline-item">提交申请 — <%=rr.getApplyTime() != null ? rr.getApplyTime().substring(0,16) : ""%></div>
                    <div class="timeline-item">派工 — <%=wo.getAssignTime() != null ? wo.getAssignTime().substring(0,16) : "未派工"%></div>
                    <% if (wo.getReceiveTime() != null) { %>
                    <div class="timeline-item">接单 — <%=wo.getReceiveTime().substring(0,16)%></div>
                    <% } %>
                    <% if (wo.getStartTime() != null) { %>
                    <div class="timeline-item">开始维修 — <%=wo.getStartTime().substring(0,16)%></div>
                    <% } %>
                    <% if (wo.getCompleteTime() != null) { %>
                    <div class="timeline-item">提交结果 — <%=wo.getCompleteTime().substring(0,16)%></div>
                    <% } %>
                    <% if (wo.getConfirmTime() != null) { %>
                    <div class="timeline-item">业主确认 — <%=wo.getConfirmTime().substring(0,16)%></div>
                    <% } %>
                </div>
            </div>

            <% if (wo.getRepairContent() != null || wo.getMaterialsUsed() != null || wo.getWorkHours() > 0 || wo.getRating() > 0) { %>
            <div class="info-box">
                <h4>维修结果</h4>
                <% if (wo.getRepairContent() != null && !wo.getRepairContent().isEmpty()) { %>
                    <p><strong>维修内容：</strong><%=wo.getRepairContent()%></p>
                <% } %>
                <% if (wo.getMaterialsUsed() != null && !wo.getMaterialsUsed().isEmpty()) { %>
                    <p><strong>使用材料：</strong><%=wo.getMaterialsUsed()%></p>
                <% } %>
                <% if (wo.getWorkHours() > 0) { %>
                    <p><strong>工时：</strong><%=wo.getWorkHours()%> 小时</p>
                <% } %>
                <% if (wo.getRating() > 0) { %>
                    <p><strong>评分：</strong>
                        <span class="stars">
                            <% for (int i = 0; i < wo.getRating(); i++) { %>★<% } %>
                            <% for (int i = wo.getRating(); i < 5; i++) { %>☆<% } %>
                        </span>
                    </p>
                <% } %>
                <% if (wo.getComment() != null && !wo.getComment().isEmpty()) { %>
                    <p><strong>评价内容：</strong><%=wo.getComment()%></p>
                <% } %>
            </div>
            <% } %>
            <% } else { %>
            <div class="info-box">
                <h4>工单信息</h4>
                <p style="color:#999;">工单尚未生成。</p>
            </div>
            <% } %>

            <div style="margin-top:15px;">
                <a href="${pageContext.request.contextPath}/admin/repair?action=list" class="btn btn-secondary">返回列表</a>
            </div>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>