<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.ParkingSpace" %>
<%
    ParkingSpace sp = (ParkingSpace) request.getAttribute("space");
    if (sp == null) { response.sendRedirect(request.getContextPath() + "/owner/parking?action=query"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>申请绑定车位</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .info-box h4 { margin-top: 0; border-bottom: 1px solid #ddd; padding-bottom: 8px; }
        .info-box p { margin: 6px 0; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; border: none; cursor: pointer; font-size: 14px; }
        .btn-primary { background-color: #007bff; }
        .btn-secondary { background-color: #6c757d; }
        .badge { padding: 2px 8px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-secondary { background-color: #6c757d; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>申请绑定车位</h2>
            <div class="info-box">
                <h4>车位信息</h4>
                <p><strong>车位编号：</strong><%=sp.getSpaceNo()%></p>
                <p><strong>位置：</strong><%=sp.getLocation()%></p>
                <p><strong>类型：</strong><%=sp.getType()%></p>
                <p><strong>状态：</strong><span class="badge badge-secondary"><%=sp.getStatus()%></span></p>
            </div>
            <form action="${pageContext.request.contextPath}/owner/parking?action=submitApply" method="post">
                <input type="hidden" name="spaceId" value="<%=sp.getSpaceId()%>">
                <div style="margin:15px 0;">
                    <label><strong>绑定月数：</strong></label>
                    <select name="months" style="padding:5px; width:120px;">
                        <option value="1">1个月</option>
                        <option value="3">3个月</option>
                        <option value="6">6个月</option>
                        <option value="12">12个月</option>
                    </select>
                </div>
                <p>确认申请绑定此车位？</p>
                <input type="submit" class="btn btn-primary" value="确认申请">
                <a href="${pageContext.request.contextPath}/owner/parking?action=query" class="btn btn-secondary">取消</a>
            </form>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>