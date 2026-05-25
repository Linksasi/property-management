<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<% request.setAttribute("pageTitle", "我的排班"); %>
<% request.setAttribute("module", "schedule"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/staff-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">我的排班</h1>
    
    <div class="card">
        <c:if test="${not empty staff}">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <span>${staff.name} 的排班表</span>
            <span class="text-secondary">工种：${staff.worktypeName}</span>
        </div>
        </c:if>
        
        <table class="table-custom">
            <thead>
                <tr>
                    <th>排班日期</th>
                    <th>班次</th>
                    <th>工作地点</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td><fmt:formatDate value="${item.shiftDate}" pattern="yyyy年MM月dd日"/></td>
                                <td>${item.shiftPeriod}</td>
                                <td>${item.locationName != null ? item.locationName : '-'}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="3" class="text-center">暂无排班记录</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>