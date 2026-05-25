<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<% request.setAttribute("pageTitle", "申请详情"); %>
<% request.setAttribute("module", "myapply"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/ad-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">申请详情</h1>

    <div class="card">
        <div class="form-group">
            <label class="form-label">申请ID</label>
            <div class="form-control" style="border: none;">${entity.appId}</div>
        </div>

        <div class="form-group">
            <label class="form-label">广告内容</label>
            <div class="form-control" style="border: none;">${entity.adContent}</div>
        </div>

        <div class="form-group">
            <label class="form-label">期望位置</label>
            <div class="form-control" style="border: none;">${entity.expectSlotName != null ? entity.expectSlotName : entity.expectSlot}</div>
        </div>

        <div class="form-group">
            <label class="form-label">投放日期</label>
            <div class="form-control" style="border: none;">
                <fmt:formatDate value="${entity.startDate}" pattern="yyyy-MM-dd"/> 至 <fmt:formatDate value="${entity.endDate}" pattern="yyyy-MM-dd"/>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">申请时间</label>
            <div class="form-control" style="border: none;">
                <fmt:formatDate value="${entity.applyDate}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">状态</label>
            <div class="form-control" style="border: none;">${entity.status}</div>
        </div>

        <div class="d-flex gap-12 mt-3">
            <a href="${pageContext.request.contextPath}/ad/company?action=myList&companyId=${companyId}" class="btn btn-secondary">返回列表</a>
        </div>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>