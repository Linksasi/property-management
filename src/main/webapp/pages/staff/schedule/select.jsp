<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% request.setAttribute("pageTitle", "选择身份"); %>
<% request.setAttribute("module", "schedule"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/staff-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">选择身份</h1>

    <div class="card">
        <p class="mb-3">请选择您的身份以查看排班信息：</p>
        <div class="list-group">
            <c:choose>
                <c:when test="${not empty allStaff}">
                    <c:forEach items="${allStaff}" var="s">
                        <a href="${pageContext.request.contextPath}/staff/schedule?action=list&staffId=${s.staffId}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                            <div>
                                <strong>${s.name}</strong>
                                <span class="text-secondary ms-2">${s.worktypeName}</span>
                            </div>
                            <span class="badge bg-primary rounded-pill">进入</span>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-secondary py-3">暂无员工数据</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>