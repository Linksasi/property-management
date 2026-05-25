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
    <meta charset="UTF-8">
    <title>车位管理 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <style>
        body { overflow-x: hidden; }
        .main-container { max-width: 100%; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/admin-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">车位管理</h2>

            <!-- 统计信息 -->
            <div class="statistics-row" style="margin-bottom:16px;">
                <div class="stat-card">
                    <div class="stat-value"><%= list != null ? list.size() : 0 %></div>
                    <div class="stat-label">总车位数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <%
                        int freeCount = 0;
                        if (list != null) {
                            for (ParkingSpace sp : list) {
                                if ("空闲".equals(sp.getStatus())) freeCount++;
                            }
                        }
                        out.print(freeCount);
                        %>
                    </div>
                    <div class="stat-label">空闲车位</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <%
                        int boundCount = 0;
                        if (list != null) {
                            for (ParkingSpace sp : list) {
                                if ("已绑定".equals(sp.getStatus())) boundCount++;
                            }
                        }
                        out.print(boundCount);
                        %>
                    </div>
                    <div class="stat-label">已绑定车位</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <%
                        int overdueCount = 0;
                        if (list != null) {
                            for (ParkingSpace sp : list) {
                                if ("欠费".equals(sp.getFeeStatus())) overdueCount++;
                            }
                        }
                        out.print(overdueCount);
                        %>
                    </div>
                    <div class="stat-label">欠费车位</div>
                </div>
            </div>

            <!-- 筛选栏 -->
            <div class="card mb-3">
                <form method="get" action="${pageContext.request.contextPath}/admin/parking" class="d-flex gap-12 flex-wrap align-items-center">
                    <input type="hidden" name="action" value="list">
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
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">仅看欠费</label>
                        <input type="checkbox" name="overdue" value="true" <%= "true".equals(filterOverdue) ? "checked" : "" %>>
                    </div>
                    <div class="form-group" style="margin-bottom:0; align-self:flex-end">
                        <button type="submit" class="btn btn-primary btn-sm">筛选</button>
                        <a href="${pageContext.request.contextPath}/admin/parking?action=standardList" class="btn btn-secondary btn-sm">设定月费标准</a>
                        <a href="${pageContext.request.contextPath}/admin/parking?action=applyList" class="btn btn-warning btn-sm">绑定申请列表</a>
                    </div>
                </form>
            </div>

            <!-- 数据表格 -->
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>车位编号</th>
                            <th>位置</th>
                            <th>类型</th>
                            <th>状态</th>
                            <th>绑定住户</th>
                            <th>缴费状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (list == null || list.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无匹配的车位数据
                            </td>
                        </tr>
                        <% } else {
                            for (ParkingSpace sp : list) {
                                String badgeClass = "已绑定".equals(sp.getStatus()) ? "status-success" : "status-info";
                                String feeBadge = "欠费".equals(sp.getFeeStatus()) ? "status-error" : "status-success";
                        %>
                        <tr>
                            <td><%= sp.getSpaceNo() %></td>
                            <td><%= sp.getLocation() %></td>
                            <td><%= sp.getType() %></td>
                            <td><span class="status-tag <%= badgeClass %>"><%= sp.getStatus() %></span></td>
                            <td><%= sp.getResidentName() != null ? sp.getResidentName() : "--" %></td>
                            <td><span class="status-tag <%= feeBadge %>"><%= sp.getFeeStatus() != null ? sp.getFeeStatus() : "正常" %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/parking?action=detail&spaceId=<%= sp.getSpaceId() %>" class="btn btn-secondary btn-sm">查看详情</a>
                                <% if ("已绑定".equals(sp.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/admin/parking?action=unbind&spaceId=<%= sp.getSpaceId() %>" class="btn btn-danger btn-sm" onclick="return confirm('确定要移除该车位的绑定吗？')">移除绑定</a>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>