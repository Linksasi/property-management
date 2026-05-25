<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%-- 顶部标签导航片段 --%>
<div class="property-nav">
    <a href="${pageContext.request.contextPath}/admin/water?action=list" class="${activeTab == 'billing' ? 'active' : ''}">
        计费规则
    </a>
    <a href="${pageContext.request.contextPath}/admin/waterMeter?action=list" class="${activeTab == 'meter' ? 'active' : ''}">
        水表管理
    </a>
    <a href="${pageContext.request.contextPath}/admin/waterMeter?action=meterRead" class="${activeTab == 'read' ? 'active' : ''}">
        抄表录入
    </a>
    <a href="${pageContext.request.contextPath}/admin/waterFee?action=list" class="${activeTab == 'fee' ? 'active' : ''}">
        水费账单
    </a>
    <a href="${pageContext.request.contextPath}/admin/waterStat?action=list" class="${activeTab == 'stat' ? 'active' : ''}">
        用水统计
    </a>
</div>

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