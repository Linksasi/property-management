<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.RepairRequest" %>
<%
    RepairRequest detail = (RepairRequest) request.getAttribute("detail");
    if (detail == null) { response.sendRedirect(request.getContextPath() + "/admin/repair?action=list"); return; }
    String badgeClass = "";
    switch (detail.getStatus()) {
        case "待审核": badgeClass = "badge-warning"; break;
        case "已派工": badgeClass = "badge-primary"; break;
        case "已完成": badgeClass = "badge-success"; break;
        case "审核不通过": badgeClass = "badge-danger"; break;
        case "已取消": badgeClass = "badge-secondary"; break;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>维修申请详情</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .info-box h4 { margin-top: 0; }
        .info-box p { margin: 6px 0; }
        .badge { padding: 2px 8px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-warning { background-color: #ffc107; color: #000; }
        .badge-danger { background-color: #dc3545; }
        .badge-primary { background-color: #007bff; }
        .badge-success { background-color: #28a745; }
        .badge-secondary { background-color: #6c757d; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; display: inline-block; }
        .btn-secondary { background-color: #6c757d; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "repair"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>维修申请详情</h2>
            <div class="info-box">
                <h4>基本信息</h4>
                <p><strong>申请ID：</strong><%=detail.getRequestId()%></p>
                <p><strong>住户姓名：</strong><%=detail.getResidentName() != null ? detail.getResidentName() : "未知"%></p>
                <p><strong>住房地址：</strong><%=detail.getHousingAddress() != null ? detail.getHousingAddress() : "未知"%></p>
                <p><strong>维修类型：</strong><%=detail.getRepairType()%></p>
                <p><strong>紧急程度：</strong><%=detail.getUrgency()%></p>
                <p><strong>申请时间：</strong><%=detail.getApplyTime() != null ? detail.getApplyTime().substring(0,16) : ""%></p>
                <p><strong>当前状态：</strong><span class="badge <%=badgeClass%>"><%=detail.getStatus()%></span></p>
            </div>
            <div class="info-box">
                <h4>问题描述</h4>
                <p><%=detail.getDescription()%></p>
            </div>
            <% if ("审核不通过".equals(detail.getStatus())) { %>
            <div class="info-box" style="border-left: 3px solid #dc3545;">
                <h4 style="color:#dc3545;">审核信息</h4>
                <p><strong>驳回原因：</strong><%=detail.getRejectReason() != null ? detail.getRejectReason() : "未填写"%></p>
                <% if (detail.getAdminName() != null) { %>
                    <p><strong>审核人：</strong><%=detail.getAdminName()%></p>
                    <p><strong>联系电话：</strong><%=detail.getAdminPhone() != null ? detail.getAdminPhone() : "暂无"%></p>
                <% } %>
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