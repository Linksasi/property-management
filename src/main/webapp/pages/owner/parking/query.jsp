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
    <meta charset="UTF-8">
    <title>查询空闲车位 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/owner-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">空闲车位列表</h2>

            <div class="card mb-3">
                <form method="get" action="${pageContext.request.contextPath}/owner/parking" class="d-flex gap-12 flex-wrap align-items-center">
                    <input type="hidden" name="action" value="query">
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">编号排序</label>
                        <select name="sortOrder" class="form-control" style="width:130px;">
                            <option value="asc" <%= !"desc".equals(sortOrder) ? "selected" : "" %>>升序（小→大）</option>
                            <option value="desc" <%= "desc".equals(sortOrder) ? "selected" : "" %>>降序（大→小）</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">状态</label>
                        <select name="status" class="form-control" style="width:120px;">
                            <option value="">全部</option>
                            <option value="空闲" <%= "空闲".equals(filterStatus) ? "selected" : "" %>>空闲</option>
                            <option value="已绑定" <%= "已绑定".equals(filterStatus) ? "selected" : "" %>>已绑定</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">位置</label>
                        <select name="location" class="form-control" style="width:150px;">
                            <option value="">全部</option>
                            <option value="地下一层A区" <%= "地下一层A区".equals(filterLocation) ? "selected" : "" %>>地下一层A区</option>
                            <option value="地下一层B区" <%= "地下一层B区".equals(filterLocation) ? "selected" : "" %>>地下一层B区</option>
                            <option value="地下一层C区" <%= "地下一层C区".equals(filterLocation) ? "selected" : "" %>>地下一层C区</option>
                            <option value="户外停车场" <%= "户外停车场".equals(filterLocation) ? "selected" : "" %>>户外停车场</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom:0; align-self:flex-end">
                        <button type="submit" class="btn btn-primary btn-sm">筛选</button>
                    </div>
                </form>
            </div>

            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>车位编号</th>
                            <th>位置</th>
                            <th>类型</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (available == null || available.isEmpty()) { %>
                        <tr>
                            <td colspan="5" class="text-center" style="color:var(--text-secondary);padding:40px">没有匹配的车位</td>
                        </tr>
                        <% } else {
                            for (ParkingSpace sp : available) { %>
                        <tr>
                            <td><%= sp.getSpaceNo() %></td>
                            <td><%= sp.getLocation() %></td>
                            <td><%= sp.getType() %></td>
                            <td><span class="status-tag <%= "已绑定".equals(sp.getStatus()) ? "status-success" : "status-info" %>"><%= sp.getStatus() %></span></td>
                            <td>
                                <% if ("空闲".equals(sp.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/owner/parking?action=apply&spaceId=<%= sp.getSpaceId() %>" class="btn btn-primary btn-sm">申请绑定</a>
                                <% } else { %>
                                <span style="color:var(--text-disabled);">已绑定</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/owner/parking?action=list" class="btn btn-secondary">返回我的车位</a>
            </div>
        </div>
    </div>
</body>
</html>