<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.MaintenanceWorkOrder" %>
<%
    MaintenanceWorkOrder wo = (MaintenanceWorkOrder) request.getAttribute("order");
    if (wo == null) { response.sendRedirect(request.getContextPath() + "/staff/repair?action=list"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>提交维修结果</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 100px; }
        input, textarea { padding: 5px; width: 300px; }
        textarea { height: 100px; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; border: none; cursor: pointer; }
        .btn-primary { background-color: #007bff; }
        .btn-secondary { background-color: #6c757d; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .required { color: red; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "repair"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/staff-sidebar.jsp" />
    <div class="content-area">
        <h2>提交维修结果</h2>
            <div class="info-box">
                <h4>工单信息</h4>
                <p><strong>工单ID：</strong><%=wo.getWorkOrderId()%></p>
                <p><strong>申请ID：</strong><%=wo.getRequestId()%></p>
                <p><strong>当前状态：</strong><%=wo.getStatus()%></p>
            </div>
            <form action="${pageContext.request.contextPath}/staff/repair" method="post">
                <input type="hidden" name="action" value="doSubmit">
                <input type="hidden" name="workOrderId" value="<%=wo.getWorkOrderId()%>">
                <div class="form-group">
                    <label>维修内容<span class="required">*</span>：</label>
                    <textarea name="repairContent" required></textarea>
                </div>
                <div class="form-group">
                    <label>使用材料：</label>
                    <input type="text" name="materialsUsed">
                </div>
                <div class="form-group">
                    <label>工时（小时）<span class="required">*</span>：</label>
                    <input type="number" name="workHours" step="0.5" min="0" required>
                </div>
                <div class="form-group">
                    <input type="submit" class="btn btn-primary" value="提交维修结果">
                    <a href="${pageContext.request.contextPath}/staff/repair?action=list" class="btn btn-secondary">返回</a>
                </div>
            </form>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>