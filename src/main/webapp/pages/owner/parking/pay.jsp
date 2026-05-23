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
    <title>在线缴费</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .info-box h4 { margin-top: 0; border-bottom: 1px solid #ddd; padding-bottom: 8px; }
        .info-box p { margin: 6px 0; }
        .mini-table { width: 100%; border-collapse: collapse; margin-bottom: 10px; }
        .mini-table th, .mini-table td { border: 1px solid #ddd; padding: 6px 10px; font-size: 13px; }
        .mini-table th { background-color: #eee; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; border: none; cursor: pointer; }
        .btn-primary { background-color: #007bff; }
        .btn-secondary { background-color: #6c757d; }
        .payment-method { display: flex; gap: 20px; margin-bottom: 20px; }
        .payment-option { padding: 15px 25px; border: 2px solid #ddd; border-radius: 8px; cursor: pointer; text-align: center; }
        .payment-option.selected { border-color: #007bff; background-color: #e7f1ff; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>在线缴费</h2>
            <div class="info-box">
                <h4><%=isMulti ? "合并支付账单 (" + feeList.size() + "笔)" : "账单信息"%></h4>
                <% if (isMulti) { %>
                <table class="mini-table">
                    <tr><th>记录ID</th><th>车位编号</th><th>月份</th><th>金额</th></tr>
                    <% for (ParkingFeeRecord f : feeList) { %>
                    <tr>
                        <td><%=f.getRecordId()%></td>
                        <td><%=f.getSpaceNo() != null ? f.getSpaceNo() : "--"%></td>
                        <td><%=f.getMonth() != null ? f.getMonth() : "--"%></td>
                        <td>¥<%=String.format("%.2f", f.getAmount())%></td>
                    </tr>
                    <% } %>
                </table>
                <% } else { %>
                <p><strong>车位编号：</strong><%=feeList.get(0).getSpaceNo() != null ? feeList.get(0).getSpaceNo() : "--"%></p>
                <p><strong>月份：</strong><%=feeList.get(0).getMonth() != null ? feeList.get(0).getMonth() : "--"%></p>
                <% } %>
                <p><strong>应付金额：</strong><span style="font-size: 24px; color: #dc3545; font-weight: bold;">¥<%=String.format("%.2f", totalAmount)%></span></p>
            </div>
            <form action="${pageContext.request.contextPath}/owner/parking?action=doPay" method="post">
                <input type="hidden" name="recordIds" value="<%
                    java.util.StringJoiner sj = new java.util.StringJoiner(",");
                    for (ParkingFeeRecord f : feeList) sj.add(f.getRecordId());
                    out.print(sj.toString());
                %>">
                <input type="hidden" name="amount" value="<%=totalAmount%>">
                <h4>选择支付方式</h4>
                <div class="payment-method">
                    <label class="payment-option selected">
                        <input type="radio" name="payMethod" value="微信支付" checked onchange="selectPay(this)"> 微信支付
                    </label>
                    <label class="payment-option">
                        <input type="radio" name="payMethod" value="支付宝支付" onchange="selectPay(this)"> 支付宝支付
                    </label>
                </div>
                <div>
                    <input type="submit" class="btn btn-primary" value="确认支付">
                    <a href="${pageContext.request.contextPath}/owner/parking?action=feeList" class="btn btn-secondary">取消</a>
                </div>
            </form>
            <script>
                function selectPay(radio) {
                    document.querySelectorAll('.payment-option').forEach(function(el) { el.classList.remove('selected'); });
                    radio.parentElement.classList.add('selected');
                }
            </script>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>