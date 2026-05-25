<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%-- 广告管理顶部标签导航片段 --%>
<div class="property-nav">
    <a href="${pageContext.request.contextPath}/admin/ad?action=slotList" class="${activeTab == 'ad_slot' ? 'active' : ''}">
        广告位管理
    </a>
    <a href="${pageContext.request.contextPath}/admin/ad?action=appList" class="${activeTab == 'ad_app' ? 'active' : ''}">
        申请审批
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