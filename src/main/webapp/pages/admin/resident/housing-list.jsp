<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "住房管理"); %>
<% request.setAttribute("module", "housing"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">住房管理</h1>

    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <form method="get" action="${pageContext.request.contextPath}/admin/housing" class="d-flex gap-2">
                    <input type="hidden" name="action" value="list">
                    <select name="building" class="form-select" style="width: 150px;">
                        <option value="">全部楼栋</option>
                        <c:forEach items="${buildings}" var="b">
                            <option value="${b}" ${b == selectedBuilding ? 'selected' : ''}>${b}栋</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-secondary">筛选</button>
                    <c:if test="${not empty selectedBuilding}">
                        <a href="${pageContext.request.contextPath}/admin/housing?action=list" class="btn btn-outline-secondary">清除筛选</a>
                    </c:if>
                </form>
            </div>
            <a href="${pageContext.request.contextPath}/admin/housing?action=add" class="btn btn-primary">新增住房</a>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th>住房ID</th>
                    <th>楼栋</th>
                    <th>单元</th>
                    <th>房号</th>
                    <th>面积(m²)</th>
                    <th>楼层</th>
                    <th>户型</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.housingId}</td>
                                <td>${item.building}栋</td>
                                <td>${item.unit}单元</td>
                                <td>${item.roomNo}室</td>
                                <td>${item.area}</td>
                                <td>${item.floor}楼</td>
                                <td>${item.houseType}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/housing?action=edit&id=${item.housingId}" class="btn btn-secondary btn-sm">编辑</a>
                                    <a href="${pageContext.request.contextPath}/admin/housing?action=delete&id=${item.housingId}" class="btn btn-danger btn-sm" onclick="return confirm('确定删除该住房吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="text-center">暂无数据，请先添加住房</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
