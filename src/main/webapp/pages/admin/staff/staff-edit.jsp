<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% request.setAttribute("pageTitle", "员工编辑"); %>
<% request.setAttribute("module", "staff"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">${not empty entity.staffId ? '编辑员工' : '新增员工'}</h1>
    
    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/staff?action=save" method="post">
            <c:if test="${not empty entity.staffId}">
            <div class="form-group">
                <label class="form-label">员工ID</label>
                <input type="text" class="form-control" value="${entity.staffId}" readonly style="background-color: #eee;">
            </div>
            </c:if>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>姓名</label>
                <input type="text" class="form-control" name="name" value="${entity.name}" required>
            </div>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>联系电话</label>
                <input type="text" class="form-control" name="phone" value="${entity.phone}" required>
            </div>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>身份证号</label>
                <input type="text" class="form-control" name="idCard" value="${entity.idCard}" required>
            </div>
            
            <div class="form-group">
                <label class="form-label"><span class="required">*</span>工种</label>
                <select class="form-control" name="worktypeId" required>
                    <option value="">请选择工种</option>
                    <c:forEach items="${workTypes}" var="wt">
                        <option value="${wt.worktypeId}" ${entity.worktypeId == wt.worktypeId ? 'selected' : ''}>${wt.worktypeName}</option>
                    </c:forEach>
                </select>
            </div>
            
            <c:if test="${empty entity.staffId}">
            <div class="card" style="background:#f9f9f9;margin-bottom:14px;">
                <div class="card-header" style="font-size:14px;">登录账号设置</div>
                <div class="card-body">
                    <div class="form-row" style="display:flex;gap:12px;">
                        <div class="form-group" style="flex:1;">
                            <label class="form-label">登录用户名 <span class="required">*</span></label>
                            <input type="text" class="form-control" name="username" placeholder="用于登录系统" required>
                        </div>
                        <div class="form-group" style="flex:1;">
                            <label class="form-label">登录密码 <span class="required">*</span></label>
                            <input type="text" class="form-control" name="password" value="123456" required>
                            <small class="text-muted">默认密码 123456</small>
                        </div>
                    </div>
                </div>
            </div>
            </c:if>

            <div class="d-flex gap-12 mt-3">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/staff?action=list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>