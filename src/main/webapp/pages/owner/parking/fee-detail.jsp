<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>账单详情 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/owner-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">账单详情</h2>

            <div class="card mb-3">
                <h4 style="margin-top:0;border-bottom:1px solid var(--border);padding-bottom:8px;">基本信息</h4>
                <p><strong>记录ID：</strong>PFR202606001</p>
                <p><strong>车位编号：</strong>D002</p>
                <p><strong>车位位置：</strong>地下一层A区</p>
                <p><strong>车位类型：</strong>地下车位</p>
            </div>
            <div class="card mb-3">
                <h4 style="margin-top:0;border-bottom:1px solid var(--border);padding-bottom:8px;">费用信息</h4>
                <p><strong>有效期：</strong>2026-06-01 ~ 2026-07-01</p>
                <p><strong>应缴金额：</strong>¥200.00</p>
                <p><strong>实缴金额：</strong>¥0.00</p>
                <p><strong>状态：</strong><span class="status-tag status-error">未缴</span></p>
                <p><strong>截止日期：</strong>2026-06-08</p>
                <p><strong>创建时间：</strong>2026-06-01 09:00:00</p>
            </div>

            <div class="d-flex gap-12">
                <a href="${pageContext.request.contextPath}/owner/parking?action=payPage&recordId=PFR202606001" class="btn btn-primary">立即缴费</a>
                <a href="${pageContext.request.contextPath}/owner/parking?action=feeList" class="btn btn-secondary">返回列表</a>
            </div>
        </div>
    </div>
</body>
</html>