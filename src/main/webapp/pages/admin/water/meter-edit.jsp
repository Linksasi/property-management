<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", request.getAttribute("meter") != null ? "编辑水表" : "新增水表"); %>
<% request.setAttribute("module", "water"); %>
<% request.setAttribute("activeTab", "meter"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">${meter != null ? '编辑水表' : '新增水表'}</h1>

    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/waterMeter" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="save">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">水表编号 <span class="text-danger">*</span></label>
                    <input type="text" name="meterId" class="form-control"
                           value="${meter != null ? meter.meterId : nextId}"
                           ${meter != null ? 'readonly' : ''} required>
                    <c:if test="${meter == null}">
                        <small class="text-muted">系统自动生成</small>
                    </c:if>
                </div>
                <div class="col-md-6">
                    <label class="form-label">住房地址 <span class="text-danger">*</span></label>
                    <select name="housingId" class="form-select" required>
                        <option value="">请选择住房</option>
                        <c:forEach items="${houses}" var="h">
                            <option value="${h.housingId}" ${meter != null && meter.housingId == h.housingId ? 'selected' : ''}>
                                ${h.building}栋${h.unit}单元${h.roomNo}室
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">安装日期</label>
                    <input type="date" name="installDate" class="form-control"
                           value="${meter != null ? meter.installDate : ''}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">状态</label>
                    <select name="status" class="form-select">
                        <option value="正常" ${meter != null && meter.status == '正常' ? 'selected' : ''}>正常</option>
                        <option value="异常" ${meter != null && meter.status == '异常' ? 'selected' : ''}>异常</option>
                        <option value="停用" ${meter != null && meter.status == '停用' ? 'selected' : ''}>停用</option>
                    </select>
                </div>
            </div>

            <hr class="my-4">
            <h5 class="mb-3">抄表信息</h5>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">初始读数（吨）</label>
                    <input type="number" name="initialRead" class="form-control" step="0.01" min="0"
                           value="${meter != null && meter.initialRead != null ? meter.initialRead : '0'}">
                    <small class="text-muted">水表安装时的起始读数</small>
                </div>
                <div class="col-md-4">
                    <label class="form-label">当前读数（吨）</label>
                    <input type="number" name="currentRead" class="form-control" step="0.01" min="0"
                           value="${meter != null && meter.currentRead != null ? meter.currentRead : '0'}">
                    <small class="text-muted">最近一次抄表的读数</small>
                </div>
                <div class="col-md-4">
                    <label class="form-label">上次读数（吨）</label>
                    <input type="number" name="lastRead" class="form-control" step="0.01" min="0"
                           value="${meter != null && meter.lastRead != null ? meter.lastRead : ''}">
                    <small class="text-muted">上次抄表时的读数</small>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">上次抄表日期</label>
                    <input type="date" name="lastReadDate" class="form-control"
                           value="${meter != null && meter.lastReadDate != null ? meter.lastReadDate : ''}">
                    <small class="text-muted">上次进行抄表的日期</small>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/waterMeter?action=list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
