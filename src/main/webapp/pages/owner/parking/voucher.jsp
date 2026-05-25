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
    <meta charset="UTF-8">
    <title>电子凭证 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/owner-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">电子凭证</h2>

            <div class="card" style="max-width:600px;border:2px solid var(--primary);">
                <div style="text-align:center;margin-bottom:20px;padding-bottom:15px;border-bottom:1px dashed var(--border);">
                    <div style="font-size:24px;font-weight:bold;color:var(--primary);">小区物业管理系统</div>
                    <div style="color:var(--text-secondary);">车位费缴费凭证</div>
                </div>
                <div style="margin-bottom:20px;">
                    <div class="d-flex justify-content-between mb-2">
                        <span style="color:var(--text-secondary);">交易流水号：</span>
                        <span style="font-weight:bold;"><%= txnNo != null ? txnNo : "--" %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span style="color:var(--text-secondary);">缴费金额：</span>
                        <span style="font-size:20px;font-weight:bold;color:var(--success);">¥<%= String.format("%.2f", totalAmount) %></span>
                    </div>
                    <% if (feeList != null && feeList.size() > 1) { %>
                    <table class="table-custom" style="margin-top:12px;">
                        <thead><tr><th>车位编号</th><th>月份</th><th>金额</th></tr></thead>
                        <tbody>
                            <% for (ParkingFeeRecord f : feeList) { %>
                            <tr>
                                <td><%= f.getSpaceNo() != null ? f.getSpaceNo() : "--" %></td>
                                <td><%= f.getMonth() != null ? f.getMonth() : "--" %></td>
                                <td>¥<%= String.format("%.2f", f.getAmount()) %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } else if (feeList != null && feeList.size() == 1) { %>
                    <div class="d-flex justify-content-between mb-2">
                        <span style="color:var(--text-secondary);">车位编号：</span>
                        <span style="font-weight:bold;"><%= feeList.get(0).getSpaceNo() != null ? feeList.get(0).getSpaceNo() : "--" %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span style="color:var(--text-secondary);">账单月份：</span>
                        <span style="font-weight:bold;"><%= feeList.get(0).getMonth() != null ? feeList.get(0).getMonth() : "--" %></span>
                    </div>
                    <% } %>
                </div>
                <div style="text-align:center;padding-top:15px;border-top:1px dashed var(--border);color:var(--text-disabled);font-size:12px;">
                    <p>此凭证为电子凭证，与纸质凭证具有同等法律效力</p>
                    <p>如有疑问，请联系物业客服</p>
                </div>
            </div>

            <div class="d-flex gap-12 mt-3 justify-content-center">
                <button class="btn btn-secondary" onclick="window.print()">打印凭证</button>
                <a href="${pageContext.request.contextPath}/owner/parking?action=feeList" class="btn btn-secondary">返回列表</a>
            </div>
        </div>
    </div>
</body>
</html>