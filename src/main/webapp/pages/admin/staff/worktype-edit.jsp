<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "工种编辑"); %>
<% request.setAttribute("module", "staff"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">${entity == null ? '新增工种' : '编辑工种'}</h1>
    
    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/worktype?action=save" method="post">
            <input type="hidden" name="workTypeId" value="${entity.workTypeId}">
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>工种ID</label>
                <input type="text" class="form-control" name="workTypeId" value="${entity.workTypeId}" ${entity == null ? 'required' : 'readonly'} ${entity == null ? '' : 'style="background-color: #eee;"'}>
            </div>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>工种名称</label>
                <input type="text" class="form-control" name="workTypeName" value="${entity.workTypeName}" required>
            </div>
            
            <div class="d-flex gap-12 mt-3">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/worktype?action=list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>