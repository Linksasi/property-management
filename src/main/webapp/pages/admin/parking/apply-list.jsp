<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.property.entity.ParkingApply" %>
<%
    List<ParkingApply> applyList = (List<ParkingApply>) request.getAttribute("applyList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>车位绑定申请管理</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; font-size: 14px; }
        th { background-color: #f2f2f2; }
        .badge { padding: 3px 10px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-warning { background-color: #ffc107; color: #000; }
        .badge-success { background-color: #28a745; }
        .badge-danger { background-color: #dc3545; }
        .btn { padding: 5px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 12px; }
        .btn-success { background-color: #28a745; }
        .btn-danger { background-color: #dc3545; }
        .btn-secondary { background-color: #6c757d; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "admin_parking");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>车位绑定申请管理</h2>
        <div style="margin-bottom:15px;">
            <a href="${pageContext.request.contextPath}/admin/parking?action=list" class="btn btn-secondary">返回车位列表</a>
        </div>
        <% if (applyList == null || applyList.isEmpty()) { %>
            <p style="color:#999;">暂无绑定申请。</p>
        <% } else { %>
        <table>
            <tr>
                <th>申请ID</th><th>车位编号</th><th>申请人</th><th>月数</th><th>申请时间</th><th>状态</th><th>操作</th>
            </tr>
            <% for (ParkingApply pa : applyList) {
                String badgeClass = "badge-warning";
                if ("审核通过".equals(pa.getStatus())) badgeClass = "badge-success";
                else if ("审核不通过".equals(pa.getStatus())) badgeClass = "badge-danger";
            %>
            <tr>
                <td><%=pa.getApplyId()%></td>
                <td><%=pa.getSpaceNo()%></td>
                <td><%=pa.getResidentName()%></td>
                <td><%=pa.getMonths()%>个月</td>
                <td><%=pa.getApplyTime() != null ? pa.getApplyTime().substring(0,16) : ""%></td>
                <td><span class="badge <%=badgeClass%>"><%=pa.getStatus()%></span></td>
                <td>
                    <% if ("待审核".equals(pa.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/admin/parking?action=auditApply&applyId=<%=pa.getApplyId()%>&approved=1" class="btn btn-success" onclick="return confirm('确定审核通过该申请？')">审核通过</a>
                        <a href="${pageContext.request.contextPath}/admin/parking?action=auditApply&applyId=<%=pa.getApplyId()%>&approved=0" class="btn btn-danger" onclick="return confirm('确定驳回该申请？')">审核不通过</a>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
        </div>
    </div>
</div>
<jsp:include page="/pages/common/footer.jsp" />
</body>
</html>