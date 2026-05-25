<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% request.setAttribute("pageTitle", "广告位编辑"); %>
<% request.setAttribute("module", "ad_slot"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">${entity == null ? '新增广告位' : '编辑广告位'}</h1>

    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/ad?action=slotSave" method="post">
            <input type="hidden" name="slotId" value="${entity.slotId}">

            <div class="form-group">
                <label class="form-label"><span class="required">*</span>位置描述</label>
                <textarea class="form-control" name="locationDescription" rows="3" required>${entity.location}</textarea>
            </div>

            <div class="d-flex gap-12 mt-3">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/ad?action=slotList" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>