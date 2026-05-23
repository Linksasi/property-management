<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingFeeRecord" %>
<%
    List<ParkingFeeRecord> feeList = (List<ParkingFeeRecord>) request.getAttribute("feeList");
    String txnNo = (String) request.getAttribute("txnNo");
    double totalAmount = 0;
    if (feeList != null) {
        for (ParkingFeeRecord f : feeList) totalAmount += f.getAmount();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>电子凭证</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .voucher { max-width: 600px; margin: 0 auto; padding: 30px; border: 2px solid #007bff; border-radius: 12px; background-color: #fff; }
        .voucher-header { text-align: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px dashed #ddd; }
        .voucher-title { font-size: 24px; font-weight: bold; color: #007bff; }
        .voucher-subtitle { color: #666; }
        .voucher-body { margin-bottom: 20px; }
        .voucher-row { display: flex; justify-content: space-between; margin-bottom: 10px; }
        .voucher-label { color: #666; }
        .voucher-value { font-weight: bold; }
        .voucher-footer { text-align: center; padding-top: 15px; border-top: 1px dashed #ddd; color: #999; font-size: 12px; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; border: none; cursor: pointer; }
        .btn-secondary { background-color: #6c757d; }
        .amount { font-size: 28px; color: #28a745; }
        .mini-table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        .mini-table th, .mini-table td { border: 1px solid #ddd; padding: 6px 10px; font-size: 13px; }
        .mini-table th { background-color: #eee; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>电子凭证</h2>
            <div class="voucher">
                <div class="voucher-header">
                    <div class="voucher-title">小区物业管理系统</div>
                    <div class="voucher-subtitle">车位费缴费凭证</div>
                </div>
                <div class="voucher-body">
                    <div class="voucher-row">
                        <span class="voucher-label">交易流水号：</span>
                        <span class="voucher-value"><%=txnNo != null ? txnNo : "--"%></span>
                    </div>
                    <div class="voucher-row">
                        <span class="voucher-label">缴费金额：</span>
                        <span class="voucher-value amount">¥<%=String.format("%.2f", totalAmount)%></span>
                    </div>
                    <% if (feeList != null && feeList.size() > 1) { %>
                    <div style="height:10px;"></div>
                    <p style="color:#666;font-size:13px;">合并支付明细：</p>
                    <table class="mini-table">
                        <tr><th>车位编号</th><th>月份</th><th>金额</th></tr>
                        <% for (ParkingFeeRecord f : feeList) { %>
                        <tr>
                            <td><%=f.getSpaceNo() != null ? f.getSpaceNo() : "--"%></td>
                            <td><%=f.getMonth() != null ? f.getMonth() : "--"%></td>
                            <td>¥<%=String.format("%.2f", f.getAmount())%></td>
                        </tr>
                        <% } %>
                    </table>
                    <% } else if (feeList != null && feeList.size() == 1) { %>
                    <div style="height: 10px;"></div>
                    <div class="voucher-row">
                        <span class="voucher-label">车位编号：</span>
                        <span class="voucher-value"><%=feeList.get(0).getSpaceNo() != null ? feeList.get(0).getSpaceNo() : "--"%></span>
                    </div>
                    <div class="voucher-row">
                        <span class="voucher-label">账单月份：</span>
                        <span class="voucher-value"><%=feeList.get(0).getMonth() != null ? feeList.get(0).getMonth() : "--"%></span>
                    </div>
                    <% } %>
                </div>
                <div class="voucher-footer">
                    <p>此凭证为电子凭证，与纸质凭证具有同等法律效力</p>
                    <p>如有疑问，请联系物业客服</p>
                </div>
            </div>
            <div style="text-align: center; margin-top: 20px;">
                <button class="btn btn-secondary" onclick="window.print()">打印凭证</button>
                <a href="${pageContext.request.contextPath}/owner/parking?action=feeList" class="btn btn-secondary" style="margin-left: 10px;">返回列表</a>
            </div>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>