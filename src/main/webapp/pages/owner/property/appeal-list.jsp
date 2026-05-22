<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.property.model.PropertyFeeAppeal" %>
<%
    List<PropertyFeeAppeal> list = (List<PropertyFeeAppeal>) request.getAttribute("list");
    if (list == null) list = new java.util.ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>申诉记录 - 小区物业管理系统</title>
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
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list" class="active">申诉记录</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">费用申诉记录</h2>
            
            <!-- 数据表格 -->
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>申诉ID</th>
                            <th>计费月份</th>
                            <th>收费类型</th>
                            <th>申诉原因</th>
                            <th>申诉时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (list.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="7" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无申诉记录
                            </td>
                        </tr>
                        <%
                        } else {
                            for (PropertyFeeAppeal appeal : list) {
                                String statusClass = "";
                                String statusColor = "";
                                if ("待审核".equals(appeal.getStatus())) {
                                    statusClass = "status-warning";
                                    statusColor = "#ffc107";
                                } else if ("通过".equals(appeal.getStatus())) {
                                    statusClass = "status-success";
                                    statusColor = "#198754";
                                } else if ("驳回".equals(appeal.getStatus())) {
                                    statusClass = "status-error";
                                    statusColor = "#dc3545";
                                }
                        %>
                        <tr>
                            <td><%= appeal.getAppealId() != null ? appeal.getAppealId() : "" %></td>
                            <td><%= appeal.getBillMonth() != null ? appeal.getBillMonth() : "" %></td>
                            <td><%= appeal.getStandardType() != null ? appeal.getStandardType() : "物业费" %></td>
                            <td title="<%= appeal.getReason() != null ? appeal.getReason() : "" %>">
                                <%= appeal.getReason() != null && appeal.getReason().length() > 15 ? appeal.getReason().substring(0, 15) + "..." : appeal.getReason() %>
                            </td>
                            <td><%= appeal.getCreateTime() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(appeal.getCreateTime()) : "" %></td>
                            <td><span class="status-tag <%= statusClass %>" style="color:<%= statusColor %>"><%= appeal.getStatus() != null ? appeal.getStatus() : "" %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=detail&appealId=<%= appeal.getAppealId() %>" 
                                   class="btn btn-secondary btn-sm">查看详情</a>
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