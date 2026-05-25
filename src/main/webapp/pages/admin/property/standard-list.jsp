<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.property.model.PropertyStandard" %>
<%
    List<PropertyStandard> list = (List<PropertyStandard>) request.getAttribute("list");
    if (list == null) list = new java.util.ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>收费标准管理 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
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
                <a href="${pageContext.request.contextPath}/admin/property/standard?action=list" class="active">收费标准</a>
                <a href="${pageContext.request.contextPath}/admin/property/batch?action=add">生成账单</a>
                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list">申诉管理</a>
                <a href="${pageContext.request.contextPath}/admin/property/report?action=list">统计报表</a>
            </div>
            
            <!-- 页面标题 & 新增按钮 -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="page-title" style="margin-bottom:0">收费标准管理</h2>
                <a href="${pageContext.request.contextPath}/admin/property/standard?action=add" class="btn btn-primary">新增标准</a>
            </div>
            
            <!-- 数据表格 -->
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>标准ID</th>
                            <th>收费类型</th>
                            <th>单价（元/m²/月）</th>
                            <th>生效日期</th>
                            <th>状态</th>
                            <th>创建时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (list.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="7" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无数据，请点击"新增标准"添加
                            </td>
                        </tr>
                        <%
                        } else {
                            for (PropertyStandard standard : list) {
                                String statusClass = "生效".equals(standard.getStatus()) ? "status-success" : "status-error";
                        %>
                        <tr>
                            <td><%= standard.getStandardId() != null ? standard.getStandardId() : "" %></td>
                            <td><%= standard.getFeeType() != null ? standard.getFeeType() : "" %></td>
                            <td><%= standard.getUnitPrice() != null ? "¥" + standard.getUnitPrice().setScale(2) : "¥0.00" %></td>
                            <td><%= standard.getEffectiveDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(standard.getEffectiveDate()) : "" %></td>
                            <td><span class="status-tag <%= statusClass %>"><%= standard.getStatus() != null ? standard.getStatus() : "" %></span></td>
                            <td><%= standard.getCreatedAt() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(standard.getCreatedAt()) : "" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/property/standard?action=edit&standardId=<%= standard.getStandardId() %>" 
                                   class="btn btn-secondary btn-sm">编辑</a>
                                <% if ("生效".equals(standard.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/admin/property/standard?action=disable&standardId=<%= standard.getStandardId() %>" 
                                   class="btn btn-warning btn-sm"
                                   onclick="return confirm('确定停用该标准？')">停用</a>
                                <% } else { %>
                                <a href="${pageContext.request.contextPath}/admin/property/standard?action=enable&standardId=<%= standard.getStandardId() %>" 
                                   class="btn btn-primary btn-sm"
                                   onclick="return confirm('确定启用该标准？')">启用</a>
                                <% } %>
                                <a href="${pageContext.request.contextPath}/admin/property/standard?action=delete&standardId=<%= standard.getStandardId() %>" 
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('确定删除该标准？删除后不可恢复！')">删除</a>
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