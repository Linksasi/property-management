<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", request.getAttribute("housing") != null ? "编辑住房" : "新增住房"); %>
<% request.setAttribute("module", "housing"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">${housing != null ? '编辑住房' : '新增住房'}</h1>

    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/housing" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="save">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">住房ID <span class="text-danger">*</span></label>
                    <input type="text" name="housingId" class="form-control"
                           value="${housing != null ? housing.housingId : nextId}"
                           ${housing != null ? 'readonly' : ''} required>
                    <c:if test="${housing == null}">
                        <small class="text-muted">系统自动生成</small>
                    </c:if>
                </div>
                <div class="col-md-6">
                    <label class="form-label">户型 <span class="text-danger">*</span></label>
                    <select name="houseType" class="form-select" required>
                        <option value="">请选择户型</option>
                        <option value="一室一厅" ${housing != null && housing.houseType == '一室一厅' ? 'selected' : ''}>一室一厅</option>
                        <option value="两室一厅" ${housing != null && housing.houseType == '两室一厅' ? 'selected' : ''}>两室一厅</option>
                        <option value="两室两厅" ${housing != null && housing.houseType == '两室两厅' ? 'selected' : ''}>两室两厅</option>
                        <option value="三室一厅" ${housing != null && housing.houseType == '三室一厅' ? 'selected' : ''}>三室一厅</option>
                        <option value="三室两厅" ${housing != null && housing.houseType == '三室两厅' ? 'selected' : ''}>三室两厅</option>
                        <option value="四室两厅" ${housing != null && housing.houseType == '四室两厅' ? 'selected' : ''}>四室两厅</option>
                        <option value="复式" ${housing != null && housing.houseType == '复式' ? 'selected' : ''}>复式</option>
                        <option value="别墅" ${housing != null && housing.houseType == '别墅' ? 'selected' : ''}>别墅</option>
                    </select>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">楼栋 <span class="text-danger">*</span></label>
                    <input type="text" name="building" class="form-control"
                           value="${housing != null ? housing.building : ''}" placeholder="如：A" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">单元 <span class="text-danger">*</span></label>
                    <input type="text" name="unit" class="form-control"
                           value="${housing != null ? housing.unit : ''}" placeholder="如：1" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">房号 <span class="text-danger">*</span></label>
                    <input type="text" name="roomNo" class="form-control"
                           value="${housing != null ? housing.roomNo : ''}" placeholder="如：101" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">建筑面积(m²) <span class="text-danger">*</span></label>
                    <input type="number" name="area" class="form-control" step="0.01" min="0"
                           value="${housing != null ? housing.area : ''}" placeholder="如：89.5" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">楼层 <span class="text-danger">*</span></label>
                    <input type="number" name="floor" class="form-control" min="1"
                           value="${housing != null ? housing.floor : ''}" placeholder="如：5" required>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/housing?action=list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
