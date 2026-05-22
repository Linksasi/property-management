<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.PropertyFeeAppeal" %>
<%
    PropertyFeeAppeal appeal = (PropertyFeeAppeal) request.getAttribute("entity");
    if (appeal == null) {
        appeal = new PropertyFeeAppeal();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>申诉详情 - 小区物业管理系统</title>
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
            <h2 class="page-title">申诉详情</h2>
            
            <!-- 返回按钮 -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list" class="btn btn-secondary">
                    &larr; 返回列表
                </a>
            </div>
            
            <!-- 申诉信息 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">申诉信息</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">申诉ID</label>
                            <p style="margin:0"><%= appeal.getAppealId() != null ? appeal.getAppealId() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">计费月份</label>
                            <p style="margin:0"><%= appeal.getBillMonth() != null ? appeal.getBillMonth() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">收费类型</label>
                            <p style="margin:0"><%= appeal.getStandardType() != null ? appeal.getStandardType() : "物业费" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">状态</label>
                            <p style="margin:0">
                                <%
                                    String statusClass = "";
                                    if ("待审核".equals(appeal.getStatus())) statusClass = "status-warning";
                                    else if ("通过".equals(appeal.getStatus())) statusClass = "status-success";
                                    else if ("驳回".equals(appeal.getStatus())) statusClass = "status-error";
                                %>
                                <span class="status-tag <%= statusClass %>"><%= appeal.getStatus() != null ? appeal.getStatus() : "" %></span>
                            </p>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">申诉原因</label>
                        <div style="background:#f5f5f5;padding:12px;border-radius:var(--radius);margin-top:4px">
                            <%= appeal.getReason() != null ? appeal.getReason() : "" %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 申诉时间 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">申诉时间</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">提交时间</label>
                            <p style="margin:0"><%= appeal.getCreateTime() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(appeal.getCreateTime()) : "" %></p>
                        </div>
                        <% if (appeal.getHandleTime() != null) { %>
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">处理时间</label>
                            <p style="margin:0"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(appeal.getHandleTime()) %></p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <!-- 审核结果 -->
            <% if (appeal.getHandleTime() != null) { %>
            <div class="card">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0;background:#f5f5f5">审核结果</h5>
                <div style="padding:16px">
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">处理结果</label>
                        <p style="margin:0">
                            <%
                                if ("通过".equals(appeal.getStatus())) {
                                    out.print("您的申诉已通过，账单已标记为已缴费");
                                } else if ("驳回".equals(appeal.getStatus())) {
                                    out.print("您的申诉已被驳回，请查看审核意见");
                                }
                            %>
                        </p>
                    </div>
                    <% if (appeal.getAdminReason() != null && !appeal.getAdminReason().isEmpty()) { %>
                    <div class="form-group" style="margin-top:12px;margin-bottom:0">
                        <label class="form-label">审核意见</label>
                        <div style="background:#f5f5f5;padding:12px;border-radius:var(--radius);margin-top:4px">
                            <%= appeal.getAdminReason() %>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } else { %>
            <div class="card" style="background:#fff3e0;border-left:4px solid #ff9800">
                <div style="padding:16px">
                    <strong>处理中</strong>
                    <p style="margin:8px 0 0;color:var(--text-secondary)">
                        您的申诉正在等待管理员审核处理，请耐心等待。
                    </p>
                </div>
            </div>
            <% } %>
            
            <!-- 操作按钮 -->
            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/owner/property?action=list" class="btn btn-primary">
                    返回我的账单
                </a>
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