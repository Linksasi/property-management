<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% request.setAttribute("pageTitle", "排班编辑"); %>
<% request.setAttribute("module", "shift"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">${entity == null ? '新增排班' : '编辑排班'}</h1>
    
    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/shift?action=save" method="post">
            <c:if test="${not empty entity.shiftId}">
                <input type="hidden" name="shiftId" value="${entity.shiftId}">
                <div class="form-group">
                    <label class="form-label">排班ID</label>
                    <input type="text" class="form-control" value="${entity.shiftId}" readonly style="background-color: #eee;">
                </div>
            </c:if>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>员工</label>
                <select class="form-control" name="staffId" required>
                    <option value="">请选择员工</option>
                    <c:forEach items="${staffs}" var="s">
                        <option value="${s.staffId}" ${not empty entity.staffId and entity.staffId == s.staffId ? 'selected' : ''}>${s.name}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>工作地点</label>
                <select class="form-control" name="locationId" required>
                    <option value="">请选择地点</option>
                    <c:forEach items="${locations}" var="loc">
                        <option value="${loc.locationId}" ${entity.locationId == loc.locationId ? 'selected' : ''}>${loc.locationName}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>排班日期</label>
                <input type="date" class="form-control" name="shiftDate" value="<fmt:formatDate value='${entity.shiftDate}' pattern='yyyy-MM-dd'/>" required>
            </div>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>班次</label>
                <select class="form-control" name="shiftPeriod" required>
                    <option value="">请选择班次</option>
                    <option value="早班" ${entity.shiftPeriod == '早班' ? 'selected' : ''}>早班</option>
                    <option value="中班" ${entity.shiftPeriod == '中班' ? 'selected' : ''}>中班</option>
                    <option value="晚班" ${entity.shiftPeriod == '晚班' ? 'selected' : ''}>晚班</option>
                </select>
            </div>
            
            <div class="d-flex gap-12 mt-3">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/shift?action=list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>