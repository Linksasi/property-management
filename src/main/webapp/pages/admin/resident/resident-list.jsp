<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "住户管理"); %>
<% request.setAttribute("module", "resident"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">住户管理</h1>

    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <form method="get" action="${pageContext.request.contextPath}/admin/resident" class="d-flex gap-2">
                    <input type="hidden" name="action" value="list">
                    <input type="text" name="keyword" class="form-control" placeholder="搜索姓名/身份证号/楼栋"
                           value="${keyword}" style="width: 200px;">
                    <button type="submit" class="btn btn-secondary">搜索</button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/resident?action=list" class="btn btn-outline-secondary">清除</a>
                    </c:if>
                </form>
            </div>
            <a href="${pageContext.request.contextPath}/admin/resident?action=add" class="btn btn-primary">新增住户</a>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th>住户ID</th>
                    <th>姓名</th>
                    <th>电话</th>
                    <th>身份证号</th>
                    <th>入住时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.residentId}</td>
                                <td>${item.name}</td>
                                <td>${item.phone}</td>
                                <td>${item.idCard}</td>
                                <td>${item.checkInDate}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/resident?action=edit&id=${item.residentId}" class="btn btn-secondary btn-sm">编辑</a>
                                    <a href="${pageContext.request.contextPath}/admin/resident?action=housingList&residentId=${item.residentId}" class="btn btn-secondary btn-sm">关联住房</a>
                                    <a href="${pageContext.request.contextPath}/admin/resident?action=delete&id=${item.residentId}" class="btn btn-danger btn-sm" onclick="return confirm('确定删除该住户吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center">暂无数据</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
