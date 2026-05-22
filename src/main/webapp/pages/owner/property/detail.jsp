<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    PropertyFeeDetail detail = (PropertyFeeDetail) request.getAttribute("entity");
    if (detail == null) {
        detail = new PropertyFeeDetail();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>账单详情 - 小区物业管理系统</title>
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
        <div class="sidebar">
            <div class="sidebar-title">业主菜单</div>
            <a href="${pageContext.request.contextPath}/owner/personal?action=info" class="sidebar-item">个人信息</a>
            <a href="${pageContext.request.contextPath}/owner/property?action=list" class="sidebar-item active">物业费</a>
            <a href="${pageContext.request.contextPath}/owner/water?action=list" class="sidebar-item">水费</a>
            <a href="${pageContext.request.contextPath}/owner/repair?action=list" class="sidebar-item">维修申请</a>
            <div class="sidebar-divider"></div>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-item">退出登录</a>
        </div>
        
        <!-- 内容区 -->
        <div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/owner/property?action=list">我的账单</a>
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list">申诉记录</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">账单详情</h2>
            
            <!-- 返回按钮 -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/owner/property?action=list" class="btn btn-secondary">
                    &larr; 返回列表
                </a>
            </div>
            
            <!-- 账单信息 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">账单信息</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">账单ID</label>
                            <p style="margin:0"><%= detail.getDetailId() != null ? detail.getDetailId() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">计费月份</label>
                            <p style="margin:0"><%= detail.getBillMonth() != null ? detail.getBillMonth() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">收费类型</label>
                            <p style="margin:0"><%= detail.getStandardType() != null ? detail.getStandardType() : "物业费" %></p>
                        </div>
                    </div>
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">住房地址</label>
                            <p style="margin:0"><%= detail.getHousingAddress() != null ? detail.getHousingAddress() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">收费面积</label>
                            <p style="margin:0"><%= detail.getArea() != null ? detail.getArea().setScale(2) + " m²" : "0.00 m²" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">截止日期</label>
                            <p style="margin:0"><%= detail.getDueDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(detail.getDueDate()) : "" %></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 费用明细 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">费用明细</h5>
                <div style="padding:16px">
                    <div class="d-flex justify-content-between mb-2" style="border-bottom:1px solid var(--border);padding-bottom:8px">
                        <span>应缴金额</span>
                        <span style="font-weight:bold">¥<%= detail.getAmount() != null ? detail.getAmount().setScale(2) : "0.00" %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2" style="border-bottom:1px solid var(--border);padding-bottom:8px">
                        <span>实缴金额</span>
                        <span style="font-weight:bold;color:#198754">¥<%= detail.getPaidAmount() != null ? detail.getPaidAmount().setScale(2) : "0.00" %></span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span>待缴金额</span>
                        <span style="font-weight:bold;color:#dc3545">
                            <%
                                java.math.BigDecimal unpaid = java.math.BigDecimal.ZERO;
                                if (detail.getAmount() != null && detail.getPaidAmount() != null) {
                                    unpaid = detail.getAmount().subtract(detail.getPaidAmount());
                                }
                            %>
                            ¥<%= unpaid.setScale(2) %>
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- 状态 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">状态信息</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">当前状态</label>
                            <p style="margin:0">
                                <%
                                    String statusClass = "";
                                    if ("已缴".equals(detail.getStatus())) statusClass = "status-success";
                                    else if ("未缴".equals(detail.getStatus())) statusClass = "status-error";
                                    else if ("申诉中".equals(detail.getStatus())) statusClass = "status-warning";
                                    else if ("逾期".equals(detail.getStatus())) statusClass = "status-pending";
                                %>
                                <span class="status-tag <%= statusClass %>"><%= detail.getStatus() != null ? detail.getStatus() : "" %></span>
                            </p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">缴费时间</label>
                            <p style="margin:0"><%= detail.getPaidDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(detail.getPaidDate()) : "-" %></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 操作按钮 -->
            <% if (!"已缴".equals(detail.getStatus())) { %>
            <div class="card">
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <a href="${pageContext.request.contextPath}/owner/property?action=pay&detailId=<%= detail.getDetailId() %>" 
                           class="btn btn-primary btn-lg">立即缴费</a>
                        <a href="${pageContext.request.contextPath}/owner/property/appeal?action=add&detailId=<%= detail.getDetailId() %>" 
                           class="btn btn-secondary">费用申诉</a>
                    </div>
                </div>
            </div>
            <% } %>
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
</style>