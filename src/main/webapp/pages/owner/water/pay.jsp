<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "在线支付"); %>
<% request.setAttribute("module", "water"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">在线支付</h1>

    <div class="card">
        <c:if test="${not empty bill}">
            <div class="card-header">
                <h5 class="mb-0">支付信息确认</h5>
            </div>
            <div class="card-body">
                <!-- 账单信息 -->
                <div class="alert alert-info">
                    <div class="row">
                        <div class="col-md-4">
                            <small class="text-muted">账单编号</small>
                            <div class="fw-bold">${bill.billId}</div>
                        </div>
                        <div class="col-md-4">
                            <small class="text-muted">计费月份</small>
                            <div class="fw-bold">${bill.billMonth}</div>
                        </div>
                        <div class="col-md-4">
                            <small class="text-muted">应付金额</small>
                            <div class="fw-bold text-danger fs-4">${bill.amount} 元</div>
                        </div>
                    </div>
                </div>

                <!-- 支付方式选择 -->
                <form action="${pageContext.request.contextPath}/owner/waterPay" method="post">
                    <input type="hidden" name="action" value="doPay">
                    <input type="hidden" name="billId" value="${bill.billId}">

                    <h6 class="mb-3">选择支付方式</h6>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="payment-method-card">
                                <input type="radio" name="payMethod" value="wechat" checked>
                                <div class="payment-method">
                                    <div class="payment-icon wechat">
                                        <svg viewBox="0 0 24 24" fill="currentColor" width="32" height="32">
                                            <path d="M8.5 11a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3zm5 0a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3zm7.5 2c-2.14 0-3.92 1.12-5 2.85-.36-.57-.86-.85-1.5-.85-1.16 0-2 .84-2 2s.84 2 2 2c.5 0 .98-.17 1.33-.45.36.47.78.77 1.33.77 1.16 0 2-.84 2-2s-.84-2-2-2c-.28 0-.55.07-.78.18-.23-1.73-1.78-3.05-3.55-3.05-1.95 0-3.54 1.53-3.54 3.42 0 1.22.59 2.33 1.55 3.03-.04.23-.07.47-.07.72 0 .08 0 .16.01.24.15.84.64 1.56 1.3 2.12-.04.02-.08.05-.12.07-1.13.67-1.69 1.68-1.69 2.8 0 .45.1.9.3 1.31.37.78 1.11 1.26 1.95 1.26.45 0 .89-.12 1.28-.35.33.66.8 1.15 1.33 1.49.54.34 1.2.5 1.89.5h.5c.28 0 .55-.04.81-.12.33.52.73.87 1.19 1.06.46.2 1.01.31 1.65.31.75 0 1.45-.16 2.08-.47.52-.26.93-.61 1.21-1.06.22.06.46.09.7.09h.5c.92 0 1.74-.27 2.38-.78.52-.4.89-.94 1.09-1.57.11-.36.17-.73.17-1.11 0-.78-.25-1.51-.7-2.08.46-.57.7-1.3.7-2.08 0-1.75-1.34-3.18-3-3.18h-4z"/>
                                        </svg>
                                    </div>
                                    <div class="payment-info">
                                        <div class="payment-name">微信支付</div>
                                        <div class="payment-desc">使用微信扫码支付</div>
                                    </div>
                                </div>
                            </label>
                        </div>
                        <div class="col-md-6">
                            <label class="payment-method-card">
                                <input type="radio" name="payMethod" value="alipay">
                                <div class="payment-method">
                                    <div class="payment-icon alipay">
                                        <svg viewBox="0 0 24 24" fill="currentColor" width="32" height="32">
                                            <path d="M13.37 6.18c-.94-1.07-2.47-1.5-3.87-1.5-.85 0-1.8.17-2.67.5-.5.19-.94.43-1.37.7l.5 2.07c.5.1 1 .18 1.6.18 1.67 0 3.1-.64 4.04-1.79l-.23-.16zm-2.3 4.16c-.93-.73-2.37-1.14-3.9-1.14-.94 0-1.94.16-2.83.5l.73 2.86c.5.07 1.1.1 1.7.1 1.9 0 3.3-.66 4.37-1.7l-.07-.62zm4.96-4.24c-.4-.27-.84-.5-1.33-.67-.77-.26-1.6-.4-2.44-.4-1.5 0-2.93.4-4 1.17l.27 2.4c.27.1.57.17.9.17 1.17 0 2.17-.5 2.84-1.35l-.24-.32zm-2.1 4.14c-.84-.63-2.07-1-3.53-1-.64 0-1.3.07-1.93.2l.93 3.56c.3.03.64.06.97.06 2.07 0 3.6-.73 4.7-1.9l-.14-.92z"/>
                                        </svg>
                                    </div>
                                    <div class="payment-info">
                                        <div class="payment-name">支付宝</div>
                                        <div class="payment-desc">使用支付宝扫码支付</div>
                                    </div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <div class="mt-4 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/owner/water?action=detail&id=${bill.billId}" class="btn btn-secondary">返回</a>
                        <button type="submit" class="btn btn-primary btn-lg">确认支付 ${bill.amount} 元</button>
                    </div>
                </form>
            </div>
        </c:if>
        <c:if test="${empty bill}">
            <div class="card-body text-center text-muted p-5">
                未找到账单信息
            </div>
        </c:if>
    </div>
</div>

<style>
.payment-method-card input {
    display: none;
}
.payment-method-card input:checked + .payment-method {
    border-color: #0d6efd;
    background-color: #f0f7ff;
}
.payment-method {
    border: 2px solid #dee2e6;
    border-radius: 8px;
    padding: 16px;
    cursor: pointer;
    transition: all 0.2s;
}
.payment-method:hover {
    border-color: #0d6efd;
}
.payment-method {
    display: flex;
    align-items: center;
    gap: 16px;
}
.payment-icon {
    width: 48px;
    height: 48px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
}
.payment-icon.wechat {
    background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
    color: white;
}
.payment-icon.alipay {
    background: linear-gradient(135deg, #1677ff 0%, #0958d9 100%);
    color: white;
}
.payment-name {
    font-weight: 600;
    font-size: 16px;
}
.payment-desc {
    color: #6c757d;
    font-size: 14px;
}
</style>

<%@ include file="/pages/common/footer.jsp" %>
