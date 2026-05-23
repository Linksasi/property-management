<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingSpace" %>
<%
    List<ParkingSpace> available = (List<ParkingSpace>) request.getAttribute("available");
    String sortOrder = (String) request.getAttribute("sortOrder");
    String filterStatus = (String) request.getAttribute("filterStatus");
    String filterLocation = (String) request.getAttribute("filterLocation");
    if (filterStatus == null) filterStatus = "";
    if (filterLocation == null) filterLocation = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>查询空闲车位</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .filter-bar { display: flex; gap: 10px; margin-bottom: 15px; flex-wrap: wrap; align-items: center; }
        .filter-bar select { padding: 5px 10px; border: 1px solid #ccc; border-radius: 4px; }
        .stats { margin-bottom: 10px; font-size: 14px; color: #666; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; font-size: 14px; }
        th { background-color: #f2f2f2; white-space: nowrap; }
        .badge { padding: 3px 10px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-success { background-color: #28a745; }
        .badge-secondary { background-color: #6c757d; }
        .btn { padding: 5px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 12px; display: inline-block; }
        .btn-primary { background-color: #007bff; }
        .btn-secondary { background-color: #6c757d; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "parking");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>空闲车位列表</h2>
        <div class="stats">
            <span>共 <strong><%=available != null ? available.size() : 0%></strong> 个车位</span>
        </div>
        <div class="filter-bar">
            <span>编号排序：</span>
            <select name="sortOrder" onchange="applyFilter()" style="width:100px;">
                <option value="asc" <%=!"desc".equals(sortOrder) ? "selected" : ""%>>升序(小→大)</option>
                <option value="desc" <%="desc".equals(sortOrder) ? "selected" : ""%>>降序(大→小)</option>
            </select>
            <span>状态：</span>
            <select name="status" onchange="applyFilter()" style="width:120px;">
                <option value="">全部</option>
                <option value="空闲" <%="空闲".equals(filterStatus) ? "selected" : ""%>>空闲</option>
                <option value="已绑定" <%="已绑定".equals(filterStatus) ? "selected" : ""%>>已绑定</option>
            </select>
            <span>位置：</span>
            <select name="location" onchange="applyFilter()" style="width:140px;">
                <option value="">全部</option>
                <option value="地下一层A区" <%="地下一层A区".equals(filterLocation) ? "selected" : ""%>>地下一层A区</option>
                <option value="地下一层B区" <%="地下一层B区".equals(filterLocation) ? "selected" : ""%>>地下一层B区</option>
                <option value="地下一层C区" <%="地下一层C区".equals(filterLocation) ? "selected" : ""%>>地下一层C区</option>
                <option value="户外停车场" <%="户外停车场".equals(filterLocation) ? "selected" : ""%>>户外停车场</option>
            </select>
        </div>

        <% if (available == null || available.isEmpty()) { %>
            <p style="color:#999;">没有匹配的车位。</p>
        <% } else { %>
        <table>
            <tr>
                <th>车位编号</th><th>位置</th><th>类型</th><th>状态</th><th>操作</th>
            </tr>
            <% for (ParkingSpace sp : available) { %>
            <tr>
                <td><%=sp.getSpaceNo()%></td>
                <td><%=sp.getLocation()%></td>
                <td><%=sp.getType()%></td>
                <td><span class="badge <%= "已绑定".equals(sp.getStatus()) ? "badge-success" : "badge-secondary" %>"><%=sp.getStatus()%></span></td>
                <td>
                    <% if ("空闲".equals(sp.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/owner/parking?action=apply&spaceId=<%=sp.getSpaceId()%>" class="btn btn-primary">申请绑定</a>
                    <% } else { %>
                        <span style="color:#999;">已绑定</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
        <div style="margin-top:15px;">
            <a href="${pageContext.request.contextPath}/owner/parking?action=list" class="btn btn-secondary">返回我的车位</a>
        </div>
        <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>