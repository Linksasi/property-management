<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.Housing" %>
<%
    List<Housing> housings = (List<Housing>) request.getAttribute("housings");
    String residentPhone = (String) request.getAttribute("residentPhone");
    if (residentPhone == null) residentPhone = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>提交维修申请</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .form-box { max-width: 600px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .form-group textarea { height: 100px; resize: vertical; }
        .btn { padding: 8px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; color: white; }
        .btn-primary { background-color: #007bff; }
        .btn-secondary { background-color: #6c757d; text-decoration: none; display: inline-block; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "repair");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>提交维修申请</h2>
        <div class="form-box">
            <form action="${pageContext.request.contextPath}/owner/repair?action=submit" method="post">
                <div class="form-group">
                    <label>维修房屋</label>
                    <select name="housingId" required>
                        <% if (housings != null) for (Housing h : housings) { %>
                            <option value="<%=h.getHousingId()%>"><%=h.getFullAddress()%></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>维修类型</label>
                    <select name="repairType" required>
                        <option value="">请选择</option>
                        <option value="水电维修">水电维修</option>
                        <option value="家电维修">家电维修</option>
                        <option value="墙面维修">墙面维修</option>
                        <option value="管道疏通">管道疏通</option>
                        <option value="门窗维修">门窗维修</option>
                        <option value="其他">其他</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>紧急程度</label>
                    <select name="urgency" required>
                        <option value="普通">普通</option>
                        <option value="紧急">紧急</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>问题描述</label>
                    <textarea name="description" required placeholder="请详细描述您遇到的问题"></textarea>
                </div>
                <div class="form-group">
                    <label>联系电话</label>
                    <input type="text" name="contactPhone" value="<%=residentPhone%>" readonly placeholder="联系电话（来自您的账户信息）">
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">提交申请</button>
                    <a href="${pageContext.request.contextPath}/owner/repair?action=list" class="btn btn-secondary">取消</a>
                </div>
            </form>
        </div>
        <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>