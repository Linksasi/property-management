<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "添加住房关联"); %>
<% request.setAttribute("module", "resident"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">添加住房关联</h1>

    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/resident" method="post">
            <input type="hidden" name="action" value="housingSave">
            <input type="hidden" name="residentId" value="${residentId}">

            <div class="mb-3">
                <label class="form-label">选择住房 <span class="text-danger">*</span></label>
                <select name="housingId" class="form-select" required>
                    <option value="">请选择住房</option>
                    <c:forEach items="${housingList}" var="h">
                        <option value="${h.housingId}">${h.building}栋${h.unit}单元${h.roomNo}室 (${h.area}m²/${h.floor}楼)</option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">关系 <span class="text-danger">*</span></label>
                <div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="isOwner" id="owner1" value="1" checked>
                        <label class="form-check-label" for="owner1">业主</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="isOwner" id="owner0" value="0">
                        <label class="form-check-label" for="owner0">租客</label>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">入住日期 <span class="text-danger">*</span></label>
                <input type="date" name="startDate" class="form-control"
                       value="<%= java.time.LocalDate.now() %>" required>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/resident?action=housingList&residentId=${residentId}" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
