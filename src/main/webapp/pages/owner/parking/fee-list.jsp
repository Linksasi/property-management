<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingFeeRecord" %>
<%
    List<ParkingFeeRecord> fees = (List<ParkingFeeRecord>) request.getAttribute("fees");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>车位费账单 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/owner-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">车位费账单</h2>

            <div class="d-flex gap-12 mb-3">
                <a href="${pageContext.request.contextPath}/owner/parking?action=list" class="btn btn-secondary btn-sm">我的车位</a>
                <a href="${pageContext.request.contextPath}/owner/parking?action=query" class="btn btn-secondary btn-sm">查询空闲车位</a>
            </div>

            <!-- 合并支付摘要栏 -->
            <div id="summaryBar" class="card mb-3" style="display:none;background:#FFF3E0;border-left:4px solid var(--warning);">
                <div class="d-flex gap-12 align-items-center">
                    <span>已选 <strong id="selectedCount">0</strong> 笔账单，合计：</span>
                    <span style="font-size:18px;font-weight:bold;color:var(--error);" id="totalAmount">¥0.00</span>
                    <button class="btn btn-warning" id="multiPayBtn" disabled onclick="goMultiPay()">合并支付</button>
                    <a href="javascript:void(0)" onclick="clearSelection()" style="color:var(--text-secondary);font-size:12px;">取消选择</a>
                </div>
            </div>

            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th style="width:40px;"><input type="checkbox" id="selectAll" onchange="toggleAll(this)"></th>
                            <th>记录ID</th>
                            <th>车位编号</th>
                            <th>月份</th>
                            <th>金额</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (fees == null || fees.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center" style="color:var(--text-secondary);padding:40px">暂无车位费账单</td>
                        </tr>
                        <% } else {
                            for (ParkingFeeRecord pf : fees) {
                                String badgeClass = "status-info";
                                if ("PAID".equals(pf.getStatus()) || "已缴".equals(pf.getStatus())) badgeClass = "status-success";
                                else if ("UNPAID".equals(pf.getStatus()) || "未缴".equals(pf.getStatus())) badgeClass = "status-error";
                                boolean isUnpaid = ("UNPAID".equals(pf.getStatus()) || "未缴".equals(pf.getStatus()));
                        %>
                        <tr>
                            <td>
                                <% if (isUnpaid) { %>
                                <input type="checkbox" class="fee-check" data-id="<%= pf.getRecordId() %>" data-amount="<%= pf.getAmount() %>" onchange="updateSummary()">
                                <% } %>
                            </td>
                            <td><%= pf.getRecordId() %></td>
                            <td><%= pf.getSpaceNo() != null ? pf.getSpaceNo() : "--" %></td>
                            <td><%= pf.getMonth() != null ? pf.getMonth() : "--" %></td>
                            <td>¥<%= String.format("%.2f", pf.getAmount()) %></td>
                            <td><span class="status-tag <%= badgeClass %>"><%= pf.getStatus() != null ? pf.getStatus() : "--" %></span></td>
                            <td>
                                <% if (isUnpaid) { %>
                                <a href="${pageContext.request.contextPath}/owner/parking?action=pay&recordId=<%= pf.getRecordId() %>" class="btn btn-primary btn-sm">去缴费</a>
                                <% } else { %>
                                <span style="color:var(--text-disabled);">已缴费</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script>
        function toggleAll(cb) {
            document.querySelectorAll('.fee-check').forEach(function(c) { c.checked = cb.checked; });
            updateSummary();
        }
        function updateSummary() {
            var total = 0, count = 0;
            document.querySelectorAll('.fee-check:checked').forEach(function(c) {
                total += parseFloat(c.dataset.amount);
                count++;
            });
            document.getElementById('selectedCount').textContent = count;
            document.getElementById('totalAmount').textContent = '¥' + total.toFixed(2);
            document.getElementById('summaryBar').style.display = count > 0 ? 'block' : 'none';
            document.getElementById('multiPayBtn').disabled = count === 0;
        }
        function clearSelection() {
            document.querySelectorAll('.fee-check').forEach(function(c) { c.checked = false; });
            updateSummary();
        }
        function goMultiPay() {
            var ids = [];
            document.querySelectorAll('.fee-check:checked').forEach(function(c) { ids.push(c.dataset.id); });
            if (ids.length > 0) {
                window.location.href = '${pageContext.request.contextPath}/owner/parking?action=pay&recordIds=' + ids.join(',');
            }
        }
    </script>
</body>
</html>