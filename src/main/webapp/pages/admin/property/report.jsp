<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    if (totalCount == null) totalCount = 0;
    Integer paidCount = (Integer) request.getAttribute("paidCount");
    if (paidCount == null) paidCount = 0;
    Integer unpaidCount = (Integer) request.getAttribute("unpaidCount");
    if (unpaidCount == null) unpaidCount = 0;
    Integer appealCount = (Integer) request.getAttribute("appealCount");
    if (appealCount == null) appealCount = 0;
    Integer overdueCount = (Integer) request.getAttribute("overdueCount");
    if (overdueCount == null) overdueCount = 0;
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    if (totalAmount == null) totalAmount = 0.0;
    Double paidAmount = (Double) request.getAttribute("paidAmount");
    if (paidAmount == null) paidAmount = 0.0;
    Double paymentRate = (Double) request.getAttribute("paymentRate");
    if (paymentRate == null) paymentRate = 0.0;
    
    List<Map<String, Object>> monthlyStats = (List<Map<String, Object>>) request.getAttribute("monthlyStats");
    if (monthlyStats == null) monthlyStats = new java.util.ArrayList<>();
    
    String startMonth = (String) request.getAttribute("startMonth");
    if (startMonth == null) startMonth = "";
    String endMonth = (String) request.getAttribute("endMonth");
    if (endMonth == null) endMonth = "";
%>

<% request.setAttribute("pageTitle", "统计报表"); %>
<% request.setAttribute("module", "property"); %>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/admin/property?action=list">物业费明细</a>
                <a href="${pageContext.request.contextPath}/admin/property/standard?action=list">收费标准</a>
                <a href="${pageContext.request.contextPath}/admin/property/batch?action=add">生成账单</a>
                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list">申诉管理</a>
                <a href="${pageContext.request.contextPath}/admin/property/report?action=list" class="active">统计报表</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">物业费统计报表</h2>
            
            <!-- 筛选表单 -->
            <div class="card mb-3">
                <form method="get" action="${pageContext.request.contextPath}/admin/property/report" class="d-flex gap-12 align-items-end flex-wrap">
                    <input type="hidden" name="action" value="list">
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">开始月份</label>
                        <input type="month" name="startMonth" class="form-control" value="<%= startMonth %>">
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">结束月份</label>
                        <input type="month" name="endMonth" class="form-control" value="<%= endMonth %>">
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <button type="submit" class="btn btn-primary btn-sm">查询</button>
                        <a href="${pageContext.request.contextPath}/admin/property/report?action=list" class="btn btn-secondary btn-sm">重置</a>
                    </div>
                </form>
            </div>
            
            <!-- 统计卡片 -->
            <div class="row mb-3">
                <div class="col-md-3">
                    <div class="card" style="text-align:center;padding:20px">
                        <div style="font-size:32px;font-weight:bold;color:var(--primary)"><%= totalCount %></div>
                        <div style="color:var(--text-secondary)">总账单数</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card" style="text-align:center;padding:20px">
                        <div style="font-size:32px;font-weight:bold;color:#198754"><%= paidCount %></div>
                        <div style="color:var(--text-secondary)">已缴费数</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card" style="text-align:center;padding:20px">
                        <div style="font-size:32px;font-weight:bold;color:#dc3545"><%= unpaidCount + overdueCount %></div>
                        <div style="color:var(--text-secondary)">未缴费数</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card" style="text-align:center;padding:20px">
                        <div style="font-size:32px;font-weight:bold;color:var(--primary)"><%= String.format("%.1f", paymentRate) %>%</div>
                        <div style="color:var(--text-secondary)">收缴率</div>
                    </div>
                </div>
            </div>
            
            <!-- 金额统计 + 饼图 -->
            <div class="row mb-3">
                <div class="col-md-4">
                    <div class="card" style="padding:20px">
                        <h5 style="margin-bottom:16px">费用统计</h5>
                        <div class="d-flex justify-content-between mb-2" style="border-bottom:1px solid var(--border);padding-bottom:8px">
                            <span>应缴总额</span>
                            <span style="font-weight:bold">¥<%= String.format("%.2f", totalAmount) %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2" style="border-bottom:1px solid var(--border);padding-bottom:8px">
                            <span>实缴总额</span>
                            <span style="font-weight:bold;color:#198754">¥<%= String.format("%.2f", paidAmount) %></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span>待缴总额</span>
                            <span style="font-weight:bold;color:#dc3545">¥<%= String.format("%.2f", totalAmount - paidAmount) %></span>
                        </div>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="card" style="padding:20px">
                        <h5 style="margin-bottom:16px">收缴状态分布</h5>
                        <canvas id="paymentChart" width="400" height="200"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- 月度汇总表格 -->
            <div class="card">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">月度汇总</h5>
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>月份</th>
                            <th>总账单数</th>
                            <th>已缴数</th>
                            <th>未缴数</th>
                            <th>申诉中</th>
                            <th>应缴金额</th>
                            <th>实缴金额</th>
                            <th>收缴率</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (monthlyStats.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="8" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无数据
                            </td>
                        </tr>
                        <%
                        } else {
                            for (Map<String, Object> stats : monthlyStats) {
                        %>
                        <tr>
                            <td><%= stats.get("billMonth") != null ? stats.get("billMonth") : "" %></td>
                            <td><%= stats.get("totalCount") != null ? stats.get("totalCount") : 0 %></td>
                            <td><%= stats.get("paidCount") != null ? stats.get("paidCount") : 0 %></td>
                            <td><%= stats.get("unpaidCount") != null ? stats.get("unpaidCount") : 0 %></td>
                            <td><%= stats.get("appealCount") != null ? stats.get("appealCount") : 0 %></td>
                            <td>¥<%= stats.get("totalAmount") != null ? String.format("%.2f", stats.get("totalAmount")) : "0.00" %></td>
                            <td>¥<%= stats.get("paidAmount") != null ? String.format("%.2f", stats.get("paidAmount")) : "0.00" %></td>
                            <td>
                                <%
                                    double rate = 0;
                                    if (stats.get("paymentRate") != null) {
                                        rate = ((Number) stats.get("paymentRate")).doubleValue();
                                    }
                                    String rateColor = rate >= 80 ? "#198754" : rate >= 50 ? "#ffc107" : "#dc3545";
                                %>
                                <span style="color:<%= rateColor %>;font-weight:bold"><%= String.format("%.1f", rate) %>%</span>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                        <tr style="background:#f5f5f5;font-weight:bold">
                            <td>合计</td>
                            <td><%= totalCount %></td>
                            <td><%= paidCount %></td>
                            <td><%= unpaidCount + overdueCount %></td>
                            <td><%= appealCount %></td>
                            <td>¥<%= String.format("%.2f", totalAmount) %></td>
                            <td>¥<%= String.format("%.2f", paidAmount) %></td>
                            <td><span style="color:<%= paymentRate >= 80 ? "#198754" : paymentRate >= 50 ? "#ffc107" : "#dc3545" %>"><%= String.format("%.1f", paymentRate) %>%</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
    // 收缴状态饼图
    const ctx = document.getElementById('paymentChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['已缴', '未缴', '申诉中', '逾期'],
            datasets: [{
                data: [<%= paidCount %>, <%= unpaidCount %>, <%= appealCount %>, <%= overdueCount %>],
                backgroundColor: ['#198754', '#dc3545', '#ffc107', '#fd7e14'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        padding: 20,
                        usePointStyle: true
                    }
                }
            }
        }
    });
    </script>

<%@ include file="/pages/common/footer.jsp" %>