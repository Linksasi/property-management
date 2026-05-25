<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    PropertyFeeDetail detail = (PropertyFeeDetail) request.getAttribute("entity");
    if (detail == null) {
        detail = new PropertyFeeDetail();
    }
    String error = (String) request.getAttribute("error");
    if (error == null) error = "";
%>

<% request.setAttribute("pageTitle", "在线支付"); %>
<% request.setAttribute("module", "property"); %>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/owner/property?action=list">我的账单</a>
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list">申诉记录</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">在线支付</h2>
            
            <!-- 返回按钮 -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/owner/property?action=list" class="btn btn-secondary">
                    &larr; 返回列表
                </a>
            </div>
            
            <% if (!error.isEmpty()) { %>
            <div class="card" style="border-left:4px solid var(--error);margin-bottom:16px">
                <p style="color:var(--error);margin:0;padding:12px"><%= error %></p>
            </div>
            <% } %>
            
            <!-- 费用明细 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">应付金额</h5>
                <div style="padding:24px;text-align:center">
                    <div style="font-size:48px;font-weight:bold;color:var(--primary)">
                        ¥<%= detail.getAmount() != null ? detail.getAmount().setScale(2) : "0.00" %>
                    </div>
                    <div style="color:var(--text-secondary);margin-top:8px">
                        <%= detail.getBillMonth() != null ? detail.getBillMonth() : "" %> · 
                        <%= detail.getStandardType() != null ? detail.getStandardType() : "物业费" %> · 
                        <%= detail.getHousingAddress() != null ? detail.getHousingAddress() : "" %>
                    </div>
                </div>
            </div>
            
            <!-- 支付方式选择 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">选择支付方式</h5>
                <div style="padding:16px">
                    <form method="post" action="${pageContext.request.contextPath}/owner/property/pay">
                        <input type="hidden" name="action" value="save">
                        <input type="hidden" name="detailId" value="<%= detail.getDetailId() %>">
                        <input type="hidden" name="amount" value="<%= detail.getAmount() %>">
                        
                        <div class="payment-methods">
                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="微信支付" required checked>
                                <div class="payment-method-content">
                                    <div class="payment-icon" style="background:#07C160">
                                        <svg viewBox="0 0 24 24" fill="white" width="32" height="32">
                                            <path d="M8.5 11.5c-.5.5-1 .5-1.5.5-.5 0-1-.2-1.5-.5-.5-.3-.5-1-.5-1.5s0-1.2.5-1.5c.5-.3 1-.5 1.5-.5s1 .2 1.5.5c.5.3.5 1 .5 1.5s-.2 1-.5 1.5z"/>
                                            <path d="M15.5 11.5c.5.5 1 .5 1.5.5.5 0 1-.2 1.5-.5.5-.3.5-1 .5-1.5s0-1.2-.5-1.5c-.5-.3-1-.5-1.5-.5s-1 .2-1.5.5c-.5.3-.5 1-.5 1.5s.2 1 .5 1.5z"/>
                                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/>
                                        </svg>
                                    </div>
                                    <div>
                                        <div style="font-weight:bold">微信支付</div>
                                        <div style="font-size:12px;color:var(--text-secondary)">使用微信支付</div>
                                    </div>
                                </div>
                            </label>
                            
                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="支付宝">
                                <div class="payment-method-content">
                                    <div class="payment-icon" style="background:#1677FF">
                                        <svg viewBox="0 0 24 24" fill="white" width="32" height="32">
                                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/>
                                            <text x="7" y="15" font-size="10" fill="white">¥</text>
                                        </svg>
                                    </div>
                                    <div>
                                        <div style="font-weight:bold">支付宝</div>
                                        <div style="font-size:12px;color:var(--text-secondary)">使用支付宝支付</div>
                                    </div>
                                </div>
                            </label>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-lg btn-block mt-3" onclick="return confirm('确认支付 ¥<%= detail.getAmount() != null ? detail.getAmount().setScale(2) : "0.00" %>？')">
                            确认支付
                        </button>
                    </form>
                </div>
            </div>
            
            <!-- 提示 -->
            <div class="card" style="background:#fff3e0;border-left:4px solid #ff9800">
                <div style="padding:12px">
                    <strong>支付说明：</strong>
                    <ul style="margin-bottom:0;padding-left:20px;margin-top:8px">
                        <li>本系统为模拟支付，无需真实付款</li>
                        <li>点击确认支付后，系统将模拟支付成功</li>
                        <li>支付成功后可查看电子凭证</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.payment-methods {
    display: flex;
    gap: 12px;
}
.payment-method {
    flex: 1;
    cursor: pointer;
}
.payment-method input[type="radio"] {
    display: none;
}
.payment-method-content {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 16px;
    border: 2px solid var(--border);
    border-radius: var(--radius);
    transition: all 0.2s;
}
.payment-method input[type="radio"]:checked + .payment-method-content {
    border-color: var(--primary);
    background-color: rgba(46, 125, 50, 0.05);
}
.payment-icon {
    width: 48px;
    height: 48px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
}
.btn-block {
    width: 100%;
}
</style>

<%@ include file="/pages/common/footer.jsp" %>