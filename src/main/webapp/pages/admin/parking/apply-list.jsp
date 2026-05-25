<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingApply" %>
<%
    List<ParkingApply> applyList = (List<ParkingApply>) request.getAttribute("applyList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>车位绑定申请管理 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/admin-sidebar.jsp" />
        <div class="content-area">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="page-title" style="margin-bottom:0">车位绑定申请管理</h2>
                <a href="${pageContext.request.contextPath}/admin/parking?action=list" class="btn btn-secondary btn-sm">返回车位列表</a>
            </div>

            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>申请ID</th>
                            <th>车位编号</th>
                            <th>申请人</th>
                            <th>月数</th>
                            <th>申请时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (applyList == null || applyList.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无绑定申请
                            </td>
                        </tr>
                        <% } else {
                            for (ParkingApply pa : applyList) {
                                String badgeClass = "status-warning";
                                if ("审核通过".equals(pa.getStatus())) badgeClass = "status-success";
                                else if ("审核不通过".equals(pa.getStatus())) badgeClass = "status-error";
                        %>
                        <tr>
                            <td><%= pa.getApplyId() %></td>
                            <td><%= pa.getSpaceNo() %></td>
                            <td><%= pa.getResidentName() %></td>
                            <td><%= pa.getMonths() %>个月</td>
                            <td><%= pa.getApplyTime() != null ? pa.getApplyTime().substring(0, 16) : "" %></td>
                            <td><span class="status-tag <%= badgeClass %>"><%= pa.getStatus() %></span></td>
                            <td>
                                <% if ("待审核".equals(pa.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/admin/parking?action=auditApply&applyId=<%= pa.getApplyId() %>&approved=1" class="btn btn-success btn-sm" onclick="return confirm('确定审核通过该申请？')">审核通过</a>
                                <a href="${pageContext.request.contextPath}/admin/parking?action=auditApply&applyId=<%= pa.getApplyId() %>&approved=0" class="btn btn-danger btn-sm" onclick="return confirm('确定驳回该申请？')">审核不通过</a>
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