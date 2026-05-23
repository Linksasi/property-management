<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingSpace" %>
<%
    List<ParkingSpace> list = (List<ParkingSpace>) request.getAttribute("list");
    String sortOrder = (String) request.getAttribute("sortOrder");
    String filterStatus = (String) request.getAttribute("filterStatus");
    String filterLocation = (String) request.getAttribute("filterLocation");
    String filterOverdue = (String) request.getAttribute("filterOverdue");
    if (filterStatus == null) filterStatus = "";
    if (filterLocation == null) filterLocation = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>车位管理</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .filter-bar { display: flex; gap: 10px; margin-bottom: 15px; flex-wrap: wrap; align-items: center; }
        .filter-bar select, .filter-bar input { padding: 5px 10px; border: 1px solid #ccc; border-radius: 4px; }
        .filter-bar .btn { cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; font-size: 14px; }
        th { background-color: #f2f2f2; white-space: nowrap; }
        .badge { padding: 3px 10px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-success { background-color: #28a745; }
        .badge-secondary { background-color: #6c757d; }
        .badge-danger { background-color: #dc3545; }
        .btn { padding: 5px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 12px; display: inline-block; }
        .btn-info { background-color: #17a2b8; }
        .btn-warning { background-color: #ffc107; color: #000; }
        .btn-primary { background-color: #007bff; }
        .btn-danger { background-color: #dc3545; }
        .stats { margin-bottom: 15px; }
        .stats span { margin-right: 20px; font-size: 14px; color: #666; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "parking");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>车位管理</h2>
        <div class="stats">
            <span>共 <strong><%=list != null ? list.size() : 0%></strong> 个车位</span>
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
            <label style="display:flex; align-items:center; gap:4px; cursor:pointer;">
                <input type="checkbox" name="overdue" value="true" <%="true".equals(filterOverdue) ? "checked" : ""%> onchange="applyFilter()"> 仅看欠费车位
            </label>
            <a href="${pageContext.request.contextPath}/admin/parking?action=standardList" class="btn btn-primary">设定月费标准</a>
            <a href="${pageContext.request.contextPath}/admin/parking?action=applyList" class="btn btn-warning" style="margin-left:auto;">绑定申请列表</a>
        </div>
        <% if (list == null || list.isEmpty()) { %>
            <p style="color:#999;">暂无匹配的车位数据。</p>
        <% } else { %>
        <table>
            <tr>
                <th>车位编号</th><th>位置</th><th>类型</th><th>状态</th><th>绑定住户</th><th>缴费状态</th><th>操作</th>
            </tr>
            <% for (ParkingSpace sp : list) {
                String feeBadge = "badge-secondary";
                if ("欠费".equals(sp.getFeeStatus())) feeBadge = "badge-danger";
                else if ("正常".equals(sp.getFeeStatus())) feeBadge = "badge-success";
            %>
            <tr>
                <td><%=sp.getSpaceNo()%></td>
                <td><%=sp.getLocation()%></td>
                <td><%=sp.getType()%></td>
                <td><span class="badge <%= "已绑定".equals(sp.getStatus()) ? "badge-success" : "badge-secondary" %>"><%=sp.getStatus()%></span></td>
                <td><%=sp.getResidentName() != null ? sp.getResidentName() : "--"%></td>
                <td><span class="badge <%=feeBadge%>"><%=sp.getFeeStatus() != null ? sp.getFeeStatus() : "正常"%></span></td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/parking?action=detail&spaceId=<%=sp.getSpaceId()%>" class="btn btn-info">查看详情</a>
                    <% if ("已绑定".equals(sp.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/admin/parking?action=unbind&spaceId=<%=sp.getSpaceId()%>" class="btn btn-danger" onclick="return confirm('确定要移除该车位的绑定吗？')">移除绑定</a>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
        <jsp:include page="/pages/common/footer.jsp" />
    </div>
</div>
<script>
function applyFilter() {
    var params = [];
    var sort = document.querySelector('[name=sortOrder]').value;
    var st = document.querySelector('[name=status]').value;
    var loc = document.querySelector('[name=location]').value;
    var ov = document.querySelector('[name=overdue]').checked;
    params.push('action=list');
    params.push('sortOrder=' + sort);
    if (st) params.push('status=' + encodeURIComponent(st));
    if (loc) params.push('location=' + encodeURIComponent(loc));
    if (ov) params.push('overdue=true');
    window.location.href = '${pageContext.request.contextPath}/admin/parking?' + params.join('&');
}
</script>
</body>
</html>