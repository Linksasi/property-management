<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<% request.setAttribute("pageTitle", "我的申请"); %>
<% request.setAttribute("module", "myapply"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/ad-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">我的申请</h1>

    <div class="card">
        <div class="d-flex justify-content-end mb-3">
            <a href="${pageContext.request.contextPath}/ad/company?action=apply&companyId=${companyId}" class="btn btn-primary">新增申请</a>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th>申请ID</th>
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
                                <td>${item.adContent}</td>
                                <td>${item.expectSlotName != null ? item.expectSlotName : '-'}</td>
                                <td><fmt:formatDate value="${item.startDate}" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatDate value="${item.endDate}" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatDate value="${item.applyDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>${item.status}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/ad/company?action=detail&id=${item.appId}&companyId=${companyId}" class="btn btn-secondary btn-sm">详情</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="text-center">暂无申请记录</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>