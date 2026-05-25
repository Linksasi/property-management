<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% request.setAttribute("pageTitle", "工种管理"); %>
<% request.setAttribute("module", "staff"); %>
<% request.setAttribute("activeTab", "worktype"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <jsp:include page="/pages/common/staff-tabs.jsp" />
    <h1 class="page-title">工种管理</h1>
    
    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <span>工种列表</span>
            <a href="${pageContext.request.contextPath}/admin/worktype?action=add" class="btn btn-primary">新增工种</a>
        </div>
        
        <table class="table-custom">
            <thead>
                <tr>
                    <th>工种ID</th>
                    <th>工种名称</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.worktypeId}</td>
                                <td>${item.worktypeName}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/worktype?action=edit&id=${item.worktypeId}" class="btn btn-secondary btn-sm">编辑</a>
                                    <a href="${pageContext.request.contextPath}/admin/worktype?action=delete&id=${item.worktypeId}" class="btn btn-danger btn-sm" onclick="return confirm('确定删除吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="3" class="text-center">暂无数据</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>