<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<% request.setAttribute("pageTitle", "排班管理"); %>
<% request.setAttribute("module", "staff"); %>
<% request.setAttribute("activeTab", "shift"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <jsp:include page="/pages/common/staff-tabs.jsp" />
    <h1 class="page-title">排班管理</h1>
    
    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <span>排班列表</span>
            <a href="${pageContext.request.contextPath}/admin/shift?action=add" class="btn btn-primary">新增排班</a>
        </div>
        
        <table class="table-custom">
            <thead>
                <tr>
                    <th>排班ID</th>
                    <th>员工姓名</th>
                    <th>工种</th>
                    <th>工作地点</th>
                    <th>排班日期</th>
                    <th>班次</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.shiftId}</td>
                                <td>${item.staffName}</td>
                                <td>${item.workTypeName != null ? item.workTypeName : '-'}</td>
                                <td>${item.locationName != null ? item.locationName : '-'}</td>
                                <td><fmt:formatDate value="${item.shiftDate}" pattern="yyyy-MM-dd"/></td>
                                <td>${item.shiftPeriod}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/shift?action=edit&id=${item.shiftId}" class="btn btn-secondary btn-sm">编辑</a>
                                    <a href="${pageContext.request.contextPath}/admin/shift?action=delete&id=${item.shiftId}" class="btn btn-danger btn-sm" onclick="return confirm('确定删除吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="7" class="text-center">暂无数据</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>