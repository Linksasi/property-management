<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>车位收入统计</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .stats-box { display: flex; gap: 20px; margin-bottom: 20px; }
        .stat-item { flex: 1; padding: 20px; background-color: #f8f9fa; border-radius: 8px; text-align: center; }
        .stat-value { font-size: 24px; font-weight: bold; color: #007bff; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>车位收入统计</h2>
            <div class="stats-box">
                <div class="stat-item">
                    <div class="stat-value">50</div>
                    <div>总车位数</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">35</div>
                    <div>已绑定车位</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">¥7,000</div>
                    <div>月应收</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">¥6,300</div>
                    <div>月实收</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">90%</div>
                    <div>收缴率</div>
                </div>
            </div>
            <h3>车位类型统计</h3>
            <table>
                <tr>
                    <th>车位类型</th>
                    <th>数量</th>
                    <th>月应收</th>
                    <th>月实收</th>
                    <th>收缴率</th>
                </tr>
                <tr>
                    <td>地面车位</td>
                    <td>20</td>
                    <td>¥2,000</td>
                    <td>¥1,800</td>
                    <td>90%</td>
                </tr>
                <tr>
                    <td>地下车位</td>
                    <td>25</td>
                    <td>¥5,000</td>
                    <td>¥4,500</td>
                    <td>90%</td>
                </tr>
                <tr>
                    <td>车库</td>
                    <td>5</td>
                    <td>¥1,500</td>
                    <td>¥0</td>
                    <td>0%</td>
                </tr>
            </table>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>