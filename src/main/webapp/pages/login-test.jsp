<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    if (error == null) error = "";
    String selectedRole = (String) request.getAttribute("selectedRole");
    if (selectedRole == null) selectedRole = "admin";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物业管理系统 - 测试登录</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background: linear-gradient(135deg, #2E7D32 0%, #4CAF50 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center;">
    
    <div class="card" style="width: 400px; padding: 32px;">
        <div style="text-align: center; margin-bottom: 32px;">
            <div style="font-size: 48px; margin-bottom: 16px;">🏢</div>
            <h2 style="margin: 0; color: #2E7D32;">小区物业管理系统</h2>
            <p style="color: var(--text-secondary); margin-top: 8px;">测试登录界面</p>
        </div>
        
        <% if (!error.isEmpty()) { %>
        <div class="alert alert-danger" style="margin-bottom: 16px;">
            <%= error %>
        </div>
        <% } %>
        
        <form method="post" action="${pageContext.request.contextPath}/login">
            <input type="hidden" name="action" value="testLogin">
            
            <div class="form-group">
                <label class="form-label">选择角色</label>
                <select name="role" class="form-control" required>
                    <option value="admin" <%= "admin".equals(selectedRole) ? "selected" : "" %>>管理员</option>
                    <option value="owner" <%= "owner".equals(selectedRole) ? "selected" : "" %>>业主</option>
                </select>
            </div>
            
            <div class="form-group">
                <label class="form-label">选择用户</label>
                <select name="userId" class="form-control" required>
                    <optgroup label="管理员">
                        <option value="ADMIN001">系统管理员 (ADMIN001)</option>
                    </optgroup>
                    <optgroup label="业主">
                        <option value="R001">张三 (R001)</option>
                        <option value="R002">李四 (R002)</option>
                        <option value="R003">王五 (R003)</option>
                        <option value="R004">赵六 (R004)</option>
                        <option value="R005">钱七 (R005)</option>
                        <option value="R006">孙八 (R006)</option>
                        <option value="R007">周九 (R007)</option>
                        <option value="R008">吴十 (R008)</option>
                    </optgroup>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary btn-block" style="width: 100%;">
                登录
            </button>
        </form>
        
        <div style="margin-top: 24px; padding: 12px; background: #f5f5f5; border-radius: 8px; font-size: 12px; color: var(--text-secondary);">
            <strong>说明：</strong>此登录页面仅用于测试。正式上线时请使用真实的登录系统。
        </div>
    </div>
    
</body>
</html>

<style>
.btn-block {
    width: 100%;
    padding: 12px;
    font-size: 16px;
}
</style>