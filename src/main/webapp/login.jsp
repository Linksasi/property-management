<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    String username = (String) request.getAttribute("username");
    if (error == null) error = "";
    if (username == null) username = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>物业管理系统 - 登录</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", Arial, sans-serif; background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 400px; }
        .login-box h2 { text-align: center; color: #2E7D32; margin-bottom: 8px; font-size: 22px; }
        .login-box .subtitle { text-align: center; color: #999; font-size: 13px; margin-bottom: 24px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 6px; color: #555; font-size: 14px; }
        .form-group input { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; transition: border-color 0.2s; }
        .form-group input:focus { outline: none; border-color: #2E7D32; }
        .btn-login { width: 100%; padding: 12px; background: #2E7D32; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; transition: background 0.2s; }
        .btn-login:hover { background: #1B5E20; }
        .error-msg { background: #FFEBEE; color: #C62828; border: 1px solid #EF9A9A; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 13px; text-align: center; }
        .links { text-align: center; margin-top: 18px; font-size: 13px; color: #999; }
        .links a { color: #2E7D32; text-decoration: none; }
        .links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>物业管理系统</h2>
        <p class="subtitle">请输入用户名和密码登录</p>

        <% if (!error.isEmpty()) { %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" name="username" value="<%= username %>" placeholder="请输入用户名" autocomplete="off">
            </div>
            <div class="form-group">
                <label>密码</label>
                <input type="password" name="password" placeholder="请输入密码">
            </div>
            <button type="submit" class="btn-login">登 录</button>
        </form>

        <div class="links">
            <a href="${pageContext.request.contextPath}/register">还没有账号？立即注册</a>
        </div>
    </div>
</body>
</html>
