<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>物业管理系统 - 登录</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 380px; }
        .login-box h2 { text-align: center; color: #2E7D32; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 6px; color: #555; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .form-group input:focus { outline: none; border-color: #2E7D32; }
        .btn-login { width: 100%; padding: 12px; background: #2E7D32; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .btn-login:hover { background: #1B5E20; }
        .error-msg { color: #d32f2f; text-align: center; margin-bottom: 15px; }
        .test-accounts { margin-top: 20px; padding: 15px; background: #f5f5f5; border-radius: 4px; font-size: 12px; color: #666; }
        .test-accounts p { margin: 3px 0; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>物业管理系统</h2>
        <p style="text-align:center;color:#666;margin-bottom:20px;">请访问 <a href="${pageContext.request.contextPath}/index.jsp" style="color:#2E7D32;">测试入口</a> 选择账号免密登入</p>
    </div>
</body>
</html>