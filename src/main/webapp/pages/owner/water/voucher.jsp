<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "缴费凭证"); %>
<% request.setAttribute("module", "water"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">缴费凭证</h1>

    <div class="card">
        <div class="card-body text-center p-5">
            <!-- 成功图标 -->
            <div class="success-icon mb-4">
                <svg viewBox="0 0 24 24" fill="currentColor" width="80" height="80">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" fill="#198754"/>
                </svg>
            </div>

            <h3 class="text-success mb-2">支付成功！</h3>
            <p class="text-muted mb-4">您的水费已缴纳成功，以下是缴费凭证</p>

            <c:if test="${not empty bill}">
                <!-- 凭证内容 -->
                <div class="voucher-card mx-auto">
                    <div class="voucher-header">
                        <h5 class="mb-0">电子缴费凭证</h5>
                    </div>
                    <div class="voucher-body">
                        <table class="table table-borderless text-start mb-0">
                            <tr>
                                <td class="text-muted" style="width: 100px;">交易流水号</td>
                                <td class="fw-bold">${transactionId}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">账单编号</td>
                                <td>${bill.billId}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">计费月份</td>
                                <td>${bill.billMonth}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">住房地址</td>
                                <td>${bill.housingAddress}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">用水量</td>
                                <td>${bill.usage} 吨</td>
                            </tr>
                            <tr>
                                <td class="text-muted">单价</td>
                                <td>${bill.unitPrice} 元/吨</td>
                            </tr>
                            <tr>
                                <td class="text-muted">支付金额</td>
                                <td class="text-danger fw-bold fs-5">${bill.amount} 元</td>
                            </tr>
                            <tr>
                                <td class="text-muted">支付方式</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${payMethod == 'wechat'}">微信支付</c:when>
                                        <c:otherwise>支付宝</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted">缴费时间</td>
                                <td>${payTime}</td>
                            </tr>
                        </table>
                    </div>
                    <div class="voucher-footer">
                        <small class="text-muted">小区物业管理系统</small>
                    </div>
                </div>

                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/owner/water?action=list" class="btn btn-primary">查看我的水费</a>
                    <a href="${pageContext.request.contextPath}/owner/resident?action=info" class="btn btn-secondary">返回首页</a>
                </div>
            </c:if>
        </div>
    </div>
</div>

<style>
.success-icon {
    animation: bounce 0.5s ease-out;
}
@keyframes bounce {
    0% { transform: scale(0); }
    50% { transform: scale(1.2); }
    100% { transform: scale(1); }
}
.voucher-card {
    max-width: 500px;
    border: 1px solid #dee2e6;
    border-radius: 12px;
    overflow: hidden;
}
.voucher-header {
    background: linear-gradient(135deg, #198754 0%, #157347 100%);
    color: white;
    padding: 16px;
    text-align: center;
}
.voucher-body {
    padding: 24px;
    background: white;
}
.voucher-footer {
    padding: 12px;
    text-align: center;
    border-top: 1px solid #dee2e6;
    background: #f8f9fa;
}
</style>

<%@ include file="/pages/common/footer.jsp" %>
