<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    PropertyFeeDetail detail = (PropertyFeeDetail) request.getAttribute("entity");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物业费明细详情 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 顶部栏 -->
    <div class="top-bar">
        <h4>小区物业管理系统</h4>
        <div>当前用户：<%= session.getAttribute("currentUser") != null ? session.getAttribute("currentUser") : "管理员" %></div>
    </div>
    
    <!-- 主容器 -->
    <div class="main-container">
        <!-- 侧边栏 -->
        <jsp:include page="/pages/common/admin-sidebar.jsp" />
        
        <!-- 内容区 -->
        <div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/admin/property?action=list">物业费明细</a>
                <a href="${pageContext.request.contextPath}/admin/property/standard?action=list">收费标准</a>
                <a href="${pageContext.request.contextPath}/admin/property/batch?action=add">生成账单</a>
                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list">申诉管理</a>
                <a href="${pageContext.request.contextPath}/admin/property/report?action=list">统计报表</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">物业费明细详情</h2>
            
            <%
            if (detail == null) {
            %>
            <div class="card">
                <p style="color:var(--text-secondary);text-align:center;padding:40px">未找到该记录</p>
                <div style="text-align:center">
                    <a href="${pageContext.request.contextPath}/admin/property?action=list" class="btn btn-secondary">返回列表</a>
                </div>
            </div>
            <%
            } else {
                String statusClass = "";
                if ("已缴".equals(detail.getStatus())) {
                    statusClass = "status-success";
                } else if ("未缴".equals(detail.getStatus())) {
                    statusClass = "status-error";
                } else if ("申诉中".equals(detail.getStatus())) {
                    statusClass = "status-warning";
                } else if ("逾期".equals(detail.getStatus())) {
                    statusClass = "status-pending";
                }
            %>
            
            <!-- 基本信息 -->
            <div class="card mb-3">
                <h4 style="margin-bottom:16px;color:var(--primary)">账单信息</h4>
                <div class="d-flex" style="gap:40px">
                    <div>
                        <p class="form-label">账单ID</p>
                        <p><%= detail.getDetailId() != null ? detail.getDetailId() : "" %></p>
                    </div>
                    <div>
                        <p class="form-label">计费月份</p>
                        <p><%= detail.getBillMonth() != null ? detail.getBillMonth() : "" %></p>
                    </div>
                    <div>
                        <p class="form-label">状态</p>
                        <p><span class="status-tag <%= statusClass %>"><%= detail.getStatus() != null ? detail.getStatus() : "" %></span></p>
                    </div>
                </div>
            </div>
            
            <!-- 住户信息 -->
            <div class="card mb-3">
                <h4 style="margin-bottom:16px;color:var(--primary)">住户信息</h4>
                <div class="d-flex" style="gap:40px">
                    <div>
                        <p class="form-label">住户姓名</p>
                        <p><%= detail.getResidentName() != null ? detail.getResidentName() : "" %></p>
                    </div>
                    <div>
                        <p class="form-label">住房地址</p>
                        <p><%= detail.getHousingAddress() != null ? detail.getHousingAddress() : "" %></p>
                    </div>
                </div>
            </div>
            
            <!-- 费用信息 -->
            <div class="card mb-3">
                <h4 style="margin-bottom:16px;color:var(--primary)">费用信息</h4>
                <div class="d-flex" style="gap:40px">
                    <div>
                        <p class="form-label">收费面积</p>
                        <p><%= detail.getArea() != null ? detail.getArea().setScale(2) + " m²" : "" %></p>
                    </div>
                    <div>
                        <p class="form-label">应缴金额</p>
                        <p style="font-size:20px;font-weight:bold;color:var(--primary)">
                            <%= detail.getAmount() != null ? "¥" + detail.getAmount().setScale(2) : "¥0.00" %>
                        </p>
                    </div>
                    <div>
                        <p class="form-label">实缴金额</p>
                        <p style="font-size:20px;font-weight:bold;color:var(--success)">
                            <%= detail.getPaidAmount() != null ? "¥" + detail.getPaidAmount().setScale(2) : "¥0.00" %>
                        </p>
                    </div>
                </div>
            </div>
            
            <!-- 时间信息 -->
            <div class="card mb-3">
                <h4 style="margin-bottom:16px;color:var(--primary)">时间信息</h4>
                <div class="d-flex" style="gap:40px">
                    <div>
                        <p class="form-label">截止日期</p>
                        <p><%= detail.getDueDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(detail.getDueDate()) : "" %></p>
                    </div>
                    <div>
                        <p class="form-label">创建时间</p>
                        <p><%= detail.getCreateDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(detail.getCreateDate()) : "" %></p>
                    </div>
                    <div>
                        <p class="form-label">缴费时间</p>
                        <p><%= detail.getPaidDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(detail.getPaidDate()) : "" %></p>
                    </div>
                </div>
            </div>
            
            <!-- 操作按钮 -->
            <div class="card">
                <div class="d-flex" style="gap:12px">
                    <a href="${pageContext.request.contextPath}/admin/property?action=list" class="btn btn-secondary">返回列表</a>
                    <% if (!"已缴".equals(detail.getStatus())) { %>
                    <a href="${pageContext.request.contextPath}/admin/property?action=confirm&id=<%= detail.getDetailId() %>" 
                       class="btn btn-primary"
                       onclick="return confirm('确认该用户已缴费？')">确认缴费</a>
                    <% } %>
                </div>
            </div>
            <%
            }
            %>
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
</style>