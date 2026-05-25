<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", request.getAttribute("resident") != null ? "编辑住户" : "新增住户"); %>
<% request.setAttribute("module", "resident"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">${resident != null ? '编辑住户' : '新增住户'}</h1>

    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/resident" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="save">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">住户ID <span class="text-danger">*</span></label>
                    <input type="text" name="residentId" class="form-control"
                           value="${resident != null ? resident.residentId : nextId}"
                           ${resident != null ? 'readonly' : ''} required>
                    <c:if test="${resident == null}">
                        <small class="text-muted">系统自动生成</small>
                    </c:if>
                </div>
                <div class="col-md-6">
                    <label class="form-label">联系电话 <span class="text-danger">*</span></label>
                    <input type="text" name="phone" class="form-control"
                           value="${resident != null ? resident.phone : ''}" placeholder="请输入手机号" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">姓名 <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control"
                           value="${resident != null ? resident.name : ''}" placeholder="请输入姓名" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">身份证号 <span class="text-danger">*</span></label>
                    <input type="text" name="idCard" class="form-control"
                           value="${resident != null ? resident.idCard : ''}" placeholder="请输入18位身份证号"
                           maxlength="18" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">入住时间</label>
                    <input type="date" name="checkInDate" class="form-control"
                           value="${resident != null ? resident.checkInDate : ''}">
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/resident?action=list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
