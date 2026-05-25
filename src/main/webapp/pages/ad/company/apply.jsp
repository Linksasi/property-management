<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% request.setAttribute("pageTitle", "提交广告申请"); %>
<% request.setAttribute("module", "apply"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/ad-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">提交广告申请</h1>

    <div class="card">
        <form action="${pageContext.request.contextPath}/ad/company?action=submitApply" method="post">
            <input type="hidden" name="companyId" value="${companyId}">

            <div class="form-group">
                <label class="form-label">公司名称</label>
                <div class="form-control" style="border: none;">${company.companyName}</div>
            </div>

            <div class="form-group">
                <label class="form-label">联系人</label>
                <div class="form-control" style="border: none;">${company.contact}</div>
            </div>

            <div class="form-group">
                <label class="form-label">联系电话</label>
                <div class="form-control" style="border: none;">${company.phone}</div>
            </div>

            <div class="form-group">
                <label class="form-label"><span class="required">*</span>广告内容描述</label>
                <textarea class="form-control" name="adContent" rows="4" required></textarea>
            </div>

            <div class="form-group">
                <label class="form-label"><span class="required">*</span>期望广告位</label>
                <select class="form-control" name="expectSlot" required>
                    <option value="">请选择广告位</option>
                    <c:forEach items="${slots}" var="slot">
                        <option value="${slot.slotId}">${slot.slotId} - ${slot.location}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label"><span class="required">*</span>开始日期</label>
                <input type="date" class="form-control" name="startDate" required>
            </div>

            <div class="form-group">
                <label class="form-label"><span class="required">*</span>结束日期</label>
                <input type="date" class="form-control" name="endDate" required>
            </div>

            <div class="d-flex gap-12 mt-3">
                <button type="submit" class="btn btn-primary">提交申请</button>
                <a href="${pageContext.request.contextPath}/ad/company?action=myList" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>