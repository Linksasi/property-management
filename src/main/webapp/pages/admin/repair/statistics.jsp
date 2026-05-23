<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>工单统计</title>
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
    <% request.setAttribute("module", "repair"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>工单统计</h2>
            <div class="stats-box">
                <div class="stat-item">
                    <div class="stat-value">120</div>
                    <div>总申请数</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">95</div>
                    <div>已完成</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">79.2%</div>
                    <div>完成率</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">4.5</div>
                    <div>平均评分</div>
                </div>
            </div>
            <h3>维修类型统计</h3>
            <table>
                <tr>
                    <th>维修类型</th>
                    <th>申请数</th>
                    <th>完成数</th>
                    <th>完成率</th>
                </tr>
                <tr>
                    <td>水电维修</td>
                    <td>45</td>
                    <td>40</td>
                    <td>88.9%</td>
                </tr>
                <tr>
                    <td>家电维修</td>
                    <td>35</td>
                    <td>30</td>
                    <td>85.7%</td>
                </tr>
                <tr>
                    <td>墙面维修</td>
                    <td>25</td>
                    <td>18</td>
                    <td>72.0%</td>
                </tr>
                <tr>
                    <td>其他</td>
                    <td>15</td>
                    <td>7</td>
                    <td>46.7%</td>
                </tr>
            </table>
            <h3>员工绩效统计</h3>
            <table>
                <tr>
                    <th>员工姓名</th>
                    <th>工单数</th>
                    <th>完成数</th>
                    <th>平均评分</th>
                </tr>
                <tr>
                    <td>王五</td>
                    <td>50</td>
                    <td>45</td>
                    <td>4.6</td>
                </tr>
                <tr>
                    <td>赵六</td>
                    <td>45</td>
                    <td>38</td>
                    <td>4.4</td>
                </tr>
                <tr>
                    <td>钱七</td>
                    <td>25</td>
                    <td>12</td>
                    <td>4.2</td>
                </tr>
            </table>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>