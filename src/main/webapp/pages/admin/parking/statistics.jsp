<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>车位收入统计 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/admin-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">车位收入统计</h2>

            <div class="statistics-row">
                <div class="stat-card">
                    <div class="stat-value">50</div>
                    <div class="stat-label">总车位数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">35</div>
                    <div class="stat-label">已绑定车位</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">¥7,000</div>
                    <div class="stat-label">月应收</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">90%</div>
                    <div class="stat-label">收缴率</div>
                </div>
            </div>

            <h3 class="mb-3">车位类型统计</h3>
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>车位类型</th>
                            <th>数量</th>
                            <th>月应收</th>
                            <th>月实收</th>
                            <th>收缴率</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>地面车位</td><td>20</td><td>¥2,000</td><td>¥1,800</td><td>90%</td>
                        </tr>
                        <tr>
                            <td>地下车位</td><td>25</td><td>¥5,000</td><td>¥4,500</td><td>90%</td>
                        </tr>
                        <tr>
                            <td>车库</td><td>5</td><td>¥1,500</td><td>¥0</td><td>0%</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>