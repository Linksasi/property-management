<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.ElectronicVoucher" %>
<%
    ElectronicVoucher voucher = (ElectronicVoucher) request.getAttribute("voucher");
    if (voucher == null) {
        voucher = new ElectronicVoucher();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>电子凭证 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 顶部栏 -->
    <div class="top-bar">
        <h4>小区物业管理系统</h4>
        <div>当前用户：<%= session.getAttribute("currentUser") != null ? session.getAttribute("currentUser") : "业主" %></div>
    </div>
    
    <!-- 主容器 -->
    <div class="main-container">
        <!-- 侧边栏 -->
        <jsp:include page="/pages/common/owner-sidebar.jsp" />
        
        <!-- 内容区 -->
        <div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/owner/property?action=list">我的账单</a>
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list">申诉记录</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">电子凭证</h2>
            
            <!-- 成功提示 -->
            <div class="card mb-3" style="background:#e8f5e9;border-left:4px solid #198754">
                <div style="padding:16px;text-align:center">
                    <div style="font-size:48px;margin-bottom:8px">✓</div>
                    <div style="font-size:20px;font-weight:bold;color:#198754">支付成功</div>
                    <div style="color:var(--text-secondary);margin-top:8px">您的物业费已支付成功，凭证信息如下</div>
                </div>
            </div>
            
            <!-- 凭证卡片 -->
            <div class="voucher-card">
                <div class="voucher-header">
                    <div class="voucher-title">物业费缴费凭证</div>
                    <div class="voucher-status">已支付</div>
                </div>
                
                <div class="voucher-body">
                    <div class="voucher-row">
                        <span class="voucher-label">交易流水号</span>
                        <span class="voucher-value"><%= voucher.getTransactionNo() != null ? voucher.getTransactionNo() : "" %></span>
                    </div>
                    <div class="voucher-row">
                        <span class="voucher-label">缴费时间</span>
                        <span class="voucher-value"><%= voucher.getPaymentDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(voucher.getPaymentDate()) : "" %></span>
                    </div>
                    <div class="voucher-row">
                        <span class="voucher-label">住户姓名</span>
                        <span class="voucher-value"><%= voucher.getResidentName() != null ? voucher.getResidentName() : "" %></span>
                    </div>
                    <div class="voucher-row">
                        <span class="voucher-label">住房地址</span>
                        <span class="voucher-value"><%= voucher.getHousingAddress() != null ? voucher.getHousingAddress() : "" %></span>
                    </div>
                    <div class="voucher-divider"></div>
                    <div class="voucher-row voucher-amount">
                        <span class="voucher-label">缴费金额</span>
                        <span class="voucher-value">¥<%= voucher.getAmount() != null ? voucher.getAmount().setScale(2) : "0.00" %></span>
                    </div>
                </div>
                
                <div class="voucher-footer">
                    <div class="voucher-qr">
                        <div style="width:100px;height:100px;background:#f5f5f5;display:flex;align-items:center;justify-content:center;border-radius:8px">
                            <span style="font-size:12px;color:var(--text-secondary)">二维码</span>
                        </div>
                    </div>
                    <div class="voucher-info">
                        <p style="margin:0;font-size:12px;color:var(--text-secondary)">本凭证仅作为缴费证明</p>
                        <p style="margin:8px 0 0;font-size:12px;color:var(--text-secondary)">如有疑问请联系物业管理部门</p>
                    </div>
                </div>
            </div>
            
            <!-- 操作按钮 -->
            <div class="d-flex gap-12 mt-3">
                <a href="${pageContext.request.contextPath}/owner/property?action=list" class="btn btn-primary">
                    返回我的账单
                </a>
                <button onclick="window.print()" class="btn btn-secondary">
                    打印凭证
                </button>
            </div>
        </div>
    </div>
</body>
</html>

<style>
.property-nav {
    display: flex;
    gap: 4px;
    margin-bottom: 16px;
    border-bottom: 1px solid var(--border);
    padding-bottom: 12px;
}
.property-nav a {
    padding: 8px 16px;
    color: var(--text-secondary);
    text-decoration: none;
    border-radius: var(--radius-btn);
    font-size: 14px;
    transition: all 0.2s;
}
.property-nav a:hover {
    background-color: var(--bg-page);
    color: var(--primary);
}
.property-nav a.active {
    background-color: var(--primary);
    color: white;
}
.voucher-card {
    background: white;
    border: 1px solid var(--border);
    border-radius: var(--radius);
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.voucher-header {
    background: var(--primary);
    color: white;
    padding: 16px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.voucher-title {
    font-size: 18px;
    font-weight: bold;
}
.voucher-status {
    background: #198754;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 14px;
}
.voucher-body {
    padding: 20px;
}
.voucher-row {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
}
.voucher-label {
    color: var(--text-secondary);
}
.voucher-value {
    font-weight: 500;
}
.voucher-divider {
    border-top: 1px dashed var(--border);
    margin: 12px 0;
}
.voucher-amount {
    padding-top: 12px;
}
.voucher-amount .voucher-value {
    font-size: 24px;
    font-weight: bold;
    color: var(--primary);
}
.voucher-footer {
    background: #f9f9f9;
    padding: 16px 20px;
    display: flex;
    align-items: center;
    gap: 16px;
}
.voucher-qr {
    flex-shrink: 0;
}
.voucher-info {
    flex: 1;
}
@media print {
    .top-bar, .sidebar, .property-nav, .d-flex, .btn {
        display: none !important;
    }
    .content-area {
        margin: 0 !important;
        padding: 0 !important;
    }
    .voucher-card {
        box-shadow: none;
        border: none;
    }
}
</style>