<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>账单详情</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .badge { padding: 2px 8px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-danger { background-color: #dc3545; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; }
        .btn-danger { background-color: #dc3545; }
        .btn-secondary { background-color: #6c757d; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>账单详情</h2>
            <div class="info-box">
                <h4>基本信息</h4>
                <p><strong>记录ID：</strong>PFR202606001</p>
                <p><strong>车位编号：</strong>D002</p>
                <p><strong>车位位置：</strong>地下一层A区</p>
                <p><strong>车位类型：</strong>地下车位</p>
            </div>
            <div class="info-box">
                <h4>费用信息</h4>
                <p><strong>有效期：</strong>2026-06-01 ~ 2026-07-01</p>
                <p><strong>应缴金额：</strong>¥200.00</p>
                <p><strong>实缴金额：</strong>¥0.00</p>
                <p><strong>状态：</strong><span class="badge badge-danger">未缴</span></p>
                <p><strong>截止日期：</strong>2026-06-08</p>
                <p><strong>创建时间：</strong>2026-06-01 09:00:00</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/owner/parking?action=payPage&recordId=PFR202606001" class="btn btn-danger">立即缴费</a>
                <a href="${pageContext.request.contextPath}/owner/parking?action=feeList" class="btn btn-secondary">返回列表</a>
            </div>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>