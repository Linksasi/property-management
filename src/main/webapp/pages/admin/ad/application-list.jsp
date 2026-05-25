<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<% request.setAttribute("pageTitle", "广告申请审批"); %>
<% request.setAttribute("module", "ad_app"); %>
<% request.setAttribute("activeTab", "ad_app"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <jsp:include page="/pages/common/ad-tabs.jsp" />
    <h1 class="page-title">广告申请审批</h1>

    <div class="card">
        <table class="table-custom">
            <thead>
                <tr>
                    <th>申请ID</th>
                    <th>公司名称</th>
                    <th>广告内容</th>
                    <th>期望位置</th>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>申请时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.appId}</td>
                                <td>${item.companyName != null ? item.companyName : '-'}</td>
                                <td>${item.adContent}</td>
                                <td>${item.expectSlotName != null ? item.expectSlotName : '-'}</td>
                                <td><fmt:formatDate value="${item.startDate}" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatDate value="${item.endDate}" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatDate value="${item.applyDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>${item.status}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/ad?action=appDetail&id=${item.appId}" class="btn btn-secondary btn-sm">详情</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="9" class="text-center">暂无数据</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>