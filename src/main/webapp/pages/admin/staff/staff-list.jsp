<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "工作人员管理"); %>
<% request.setAttribute("module", "staff"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">工作人员管理</h1>
    
    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <span>员工列表</span>
            <a href="${pageContext.request.contextPath}/admin/staff?action=add" class="btn btn-primary">新增员工</a>
        </div>
        
        <table class="table-custom">
            <thead>
                <tr>
                    <th>员工ID</th>
                    <th>姓名</th>
                    <th>电话</th>
                    <th>身份证</th>
                    <th>工种</th>
                    <th>是否管理员</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.staffId}</td>
                                <td>${item.name}</td>
                                <td>${item.phone}</td>
                                <td>${item.idCard}</td>
                                <td>${item.worktypeName != null ? item.worktypeName : '-'}</td>
                                <td>${item.admin ? '是' : '否'}</td>
                                <td>${item.status}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/staff?action=edit&id=${item.staffId}" class="btn btn-secondary btn-sm">编辑</a>
                                    <a href="${pageContext.request.contextPath}/admin/staff?action=delete&id=${item.staffId}" class="btn btn-danger btn-sm" onclick="return confirm('确定删除吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="8" class="text-center">暂无数据</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>