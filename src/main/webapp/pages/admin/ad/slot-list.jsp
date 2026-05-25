<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<% request.setAttribute("pageTitle", "广告位管理"); %>
<% request.setAttribute("module", "ad"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">广告位管理</h1>

    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <span>广告位列表</span>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th>广告位ID</th>
                    <th>位置</th>
                    <th>状态</th>
                    <th>已占用时段</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${list}" var="item">
                    <tr>
                        <td>${item.slotId}</td>
                        <td>${item.location}</td>
                        <td>
                            <c:set var="apps" value="${slotOccupancy[item.slotId]}" />
                            <c:choose>
                                <c:when test="${not empty apps}">
                                    <span style="color: #dc3545; font-weight: 600;">占用</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #198754;">空闲</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty apps}">
                                    <c:forEach items="${apps}" var="app" varStatus="loop">
                                        <span style="display:inline-block; background:#fff3cd; padding:2px 8px; border-radius:4px; margin:2px; font-size:12px;">
                                            <fmt:formatDate value="${app.startDate}" pattern="yyyy-MM-dd"/> ~ <fmt:formatDate value="${app.endDate}" pattern="yyyy-MM-dd"/> ${app.companyName}
                                        </span>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-secondary">无占用</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>