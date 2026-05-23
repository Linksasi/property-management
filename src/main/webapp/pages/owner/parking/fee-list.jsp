<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingFeeRecord" %>
<%
    List<ParkingFeeRecord> fees = (List<ParkingFeeRecord>) request.getAttribute("fees");
%>
<!DOCTYPE html>
<html>
<head>
    <title>车位费账单</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; font-size: 14px; }
        th { background-color: #f2f2f2; }
        .badge { padding: 3px 10px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-success { background-color: #28a745; }
        .badge-danger { background-color: #dc3545; }
        .badge-info { background-color: #17a2b8; }
        .btn { padding: 5px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 12px; display: inline-block; border: none; cursor: pointer; }
        .btn-info { background-color: #17a2b8; }
        .btn-primary { background-color: #007bff; }
        .btn-secondary { background-color: #6c757d; }
        .btn-warning { background-color: #ff9800; }
        .btn-warning:disabled { background-color: #ccc; cursor: not-allowed; }
        .summary-bar { background-color: #fff3cd; padding: 12px 16px; border-radius: 4px; margin-bottom: 15px; display: flex; align-items: center; gap: 20px; }
        .summary-bar .total { font-size: 18px; font-weight: bold; color: #d32f2f; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "parking");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>车位费账单</h2>
        <div style="margin-bottom:15px;">
            <a href="${pageContext.request.contextPath}/owner/parking?action=list" class="btn btn-secondary">我的车位</a>
            <a href="${pageContext.request.contextPath}/owner/parking?action=query" class="btn btn-secondary">查询空闲车位</a>
        </div>
        <% if (fees == null || fees.isEmpty()) { %>
            <p style="color:#999;">暂无车位费账单。</p>
        <% } else { %>
        <div class="summary-bar" id="summaryBar" style="display:none;">
            <span>已选 <strong id="selectedCount">0</strong> 笔账单</span>
            <span>合计：<span class="total" id="totalAmount">¥0.00</span></span>
            <button class="btn btn-warning" id="multiPayBtn" disabled onclick="goMultiPay()">合并支付</button>
            <a href="javascript:void(0)" onclick="clearSelection()" style="color:#666;font-size:12px;">取消选择</a>
        </div>
        <table>
            <tr>
                <th><input type="checkbox" id="selectAll" onchange="toggleAll(this)"></th>
                <th>记录ID</th><th>车位编号</th><th>月份</th><th>金额</th><th>状态</th><th>操作</th>
            </tr>
            <% for (ParkingFeeRecord pf : fees) {
                String badgeClass = "badge-info";
                if ("PAID".equals(pf.getStatus()) || "已缴".equals(pf.getStatus())) badgeClass = "badge-success";
                else if ("UNPAID".equals(pf.getStatus()) || "未缴".equals(pf.getStatus())) badgeClass = "badge-danger";
                boolean isUnpaid = ("UNPAID".equals(pf.getStatus()) || "未缴".equals(pf.getStatus()));
            %>
            <tr>
                <td>
                    <% if (isUnpaid) { %>
                        <input type="checkbox" class="fee-check" data-id="<%=pf.getRecordId()%>" data-amount="<%=pf.getAmount()%>" onchange="updateSummary()">
                    <% } %>
                </td>
                <td><%=pf.getRecordId()%></td>
                <td><%=pf.getSpaceNo() != null ? pf.getSpaceNo() : "--"%></td>
                <td><%=pf.getMonth() != null ? pf.getMonth() : "--"%></td>
                <td>¥<%=String.format("%.2f", pf.getAmount())%></td>
                <td><span class="badge <%=badgeClass%>"><%=pf.getStatus() != null ? pf.getStatus() : "--"%></span></td>
                <td>
                    <% if (isUnpaid) { %>
                        <a href="${pageContext.request.contextPath}/owner/parking?action=pay&recordId=<%=pf.getRecordId()%>" class="btn btn-primary">去缴费</a>
                    <% } else { %>
                        <span style="color:#999;">已缴费</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
</table>
        <% } %>
        <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>