<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    List<PropertyFeeDetail> list = (List<PropertyFeeDetail>) request.getAttribute("list");
    if (list == null) list = new java.util.ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的账单 - 小区物业管理系统</title>
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
                <a href="${pageContext.request.contextPath}/owner/property?action=list" class="active">我的账单</a>
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list">申诉记录</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">我的账单</h2>
            
            <!-- 数据表格 -->
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>账单ID</th>
                            <th>计费月份</th>
                            <th>收费类型</th>
                            <th>应缴金额</th>
                            <th>实缴金额</th>
                            <th>截止日期</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (list.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="8" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无账单记录
                            </td>
                        </tr>
                        <%
                        } else {
                            for (PropertyFeeDetail detail : list) {
                                String statusClass = "";
                                String statusColor = "";
                                if ("已缴".equals(detail.getStatus())) {
                                    statusClass = "status-success";
                                    statusColor = "#198754";
                                } else if ("未缴".equals(detail.getStatus())) {
                                    statusClass = "status-error";
                                    statusColor = "#dc3545";
                                } else if ("申诉中".equals(detail.getStatus())) {
                                    statusClass = "status-warning";
                                    statusColor = "#ffc107";
                                } else if ("逾期".equals(detail.getStatus())) {
                                    statusClass = "status-pending";
                                    statusColor = "#fd7e14";
                                }
                        %>
                        <tr>
                            <td><%= detail.getDetailId() != null ? detail.getDetailId() : "" %></td>
                            <td><%= detail.getBillMonth() != null ? detail.getBillMonth() : "" %></td>
                            <td><%= detail.getStandardType() != null ? detail.getStandardType() : "物业费" %></td>
                            <td><%= detail.getAmount() != null ? "¥" + detail.getAmount().setScale(2) : "¥0.00" %></td>
                            <td><%= detail.getPaidAmount() != null ? "¥" + detail.getPaidAmount().setScale(2) : "¥0.00" %></td>
                            <td><%= detail.getDueDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(detail.getDueDate()) : "" %></td>
                            <td><span class="status-tag <%= statusClass %>" style="color:<%= statusColor %>"><%= detail.getStatus() != null ? detail.getStatus() : "" %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/owner/property?action=detail&detailId=<%= detail.getDetailId() %>" 
                                   class="btn btn-secondary btn-sm">查看详情</a>
                                <% if (!"已缴".equals(detail.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/owner/property?action=pay&detailId=<%= detail.getDetailId() %>" 
                                   class="btn btn-primary btn-sm">立即缴费</a>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
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
</style>