<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% request.setAttribute("pageTitle", "选择身份"); %>
<% request.setAttribute("module", "apply"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/ad-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">选择身份</h1>

    <div class="card">
        <p class="mb-3">请选择您的广告公司身份：</p>
        <div class="list-group">
            <c:choose>
                <c:when test="${not empty allCompanies}">
                    <c:forEach items="${allCompanies}" var="c">
                        <a href="${pageContext.request.contextPath}/ad/company?action=apply&companyId=${c.companyId}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                            <div>
                                <strong>${c.companyName}</strong>
                                <span class="text-secondary ms-2">${c.contact} ${c.phone}</span>
                            </div>
                            <span class="badge bg-success rounded-pill">进入</span>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-secondary py-3">暂无广告公司数据</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>