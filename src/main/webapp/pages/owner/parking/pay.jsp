<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.property.entity.ParkingFeeRecord" %>
<%
    Object feeObj = request.getAttribute("fee");
    List<ParkingFeeRecord> feeList = (List<ParkingFeeRecord>) request.getAttribute("feeList");
    boolean isMulti = feeObj == null && feeList != null && feeList.size() > 1;
    ParkingFeeRecord singleFee = feeObj instanceof ParkingFeeRecord ? (ParkingFeeRecord) feeObj : null;
    if (feeList == null) feeList = new ArrayList<>();
    if (singleFee != null && feeList.isEmpty()) { feeList.add(singleFee); isMulti = false; }
    double totalAmount = 0;
    for (ParkingFeeRecord f : feeList) totalAmount += f.getAmount();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>在线缴费 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/owner-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">在线缴费</h2>

            <div class="card mb-3">
                <h4 style="margin-top:0;border-bottom:1px solid var(--border);padding-bottom:8px;">
                    <%= isMulti ? "合并支付账单（" + feeList.size() + "笔）" : "账单信息" %>
                </h4>
                <% if (isMulti) { %>
                <table class="table-custom" style="margin-top:12px;">
                    <thead><tr><th>记录ID</th><th>车位编号</th><th>月份</th><th>金额</th></tr></thead>
                    <tbody>
                        <% for (ParkingFeeRecord f : feeList) { %>
                        <tr>
                            <td><%= f.getRecordId() %></td>
                            <td><%= f.getSpaceNo() != null ? f.getSpaceNo() : "--" %></td>
                            <td><%= f.getMonth() != null ? f.getMonth() : "--" %></td>
                            <td>¥<%= String.format("%.2f", f.getAmount()) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p><strong>车位编号：</strong><%= feeList.get(0).getSpaceNo() != null ? feeList.get(0).getSpaceNo() : "--" %></p>
                <p><strong>月份：</strong><%= feeList.get(0).getMonth() != null ? feeList.get(0).getMonth() : "--" %></p>
                <% } %>
                <p style="margin-top:16px;"><strong>应付金额：</strong><span style="font-size:24px;color:var(--error);font-weight:bold;">¥<%= String.format("%.2f", totalAmount) %></span></p>
            </div>

            <div class="card">
                <h4 class="mb-3">选择支付方式</h4>
                <form action="${pageContext.request.contextPath}/owner/parking?action=doPay" method="post">
                    <input type="hidden" name="recordIds" value="<%
                        java.util.StringJoiner sj = new java.util.StringJoiner(",");
                        for (ParkingFeeRecord f : feeList) sj.add(f.getRecordId());
                        out.print(sj.toString());
                    %>">
                    <input type="hidden" name="amount" value="<%= totalAmount %>">
                    <div class="d-flex gap-12 mb-3">
                        <label class="payment-option selected" style="flex:1;padding:15px 25px;border:2px solid var(--border);border-radius:8px;cursor:pointer;text-align:center;max-width:200px;">
                            <input type="radio" name="payMethod" value="微信支付" checked onchange="selectPay(this)">
                            <div style="margin-top:8px;font-weight:bold;">微信支付</div>
                        </label>
                        <label class="payment-option" style="flex:1;padding:15px 25px;border:2px solid var(--border);border-radius:8px;cursor:pointer;text-align:center;max-width:200px;">
                            <input type="radio" name="payMethod" value="支付宝支付" onchange="selectPay(this)">
                            <div style="margin-top:8px;font-weight:bold;">支付宝支付</div>
                        </label>
                    </div>
                    <div class="d-flex gap-12">
                        <button type="submit" class="btn btn-primary">确认支付</button>
                        <a href="${pageContext.request.contextPath}/owner/parking?action=feeList" class="btn btn-secondary">取消</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
        function selectPay(radio) {
            document.querySelectorAll('.payment-option').forEach(function(el) {
                el.style.borderColor = 'var(--border)';
                el.style.backgroundColor = '';
            });
            radio.parentElement.style.borderColor = 'var(--primary)';
            radio.parentElement.style.backgroundColor = '#E8F5E9';
        }
    </script>
    <style>
        .payment-option input { display: none; }
    </style>
</body>
</html>