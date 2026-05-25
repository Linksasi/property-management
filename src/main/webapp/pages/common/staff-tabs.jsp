<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%-- 工作人员管理顶部标签导航片段 --%>
<div class="property-nav">
    <a href="${pageContext.request.contextPath}/admin/staff?action=list" class="${activeTab == 'staff' ? 'active' : ''}">
        员工列表
    </a>
    <a href="${pageContext.request.contextPath}/admin/worktype?action=list" class="${activeTab == 'worktype' ? 'active' : ''}">
        工种管理
    </a>
    <a href="${pageContext.request.contextPath}/admin/shift?action=list" class="${activeTab == 'shift' ? 'active' : ''}">
        排班管理
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