<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "关联住房管理"); %>
<% request.setAttribute("module", "resident"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">关联住房管理</h1>

    <div class="card">
        <div class="mb-3">
            <strong>住户：</strong>${resident.name} (${resident.residentId})
            <a href="${pageContext.request.contextPath}/admin/resident?action=list" class="btn btn-secondary btn-sm ms-3">返回住户列表</a>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <span>住房关联列表</span>
            <a href="${pageContext.request.contextPath}/admin/resident?action=housingAdd&residentId=${residentId}" class="btn btn-primary">添加关联</a>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th>住房地址</th>
                    <th>面积</th>
                    <th>楼层</th>
                    <th>关系</th>
                    <th>入住日期</th>
                    <th>退租日期</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty rhList}">
                        <c:forEach items="${rhList}" var="rh">
                            <c:forEach items="${housingList}" var="h">
                                <c:if test="${rh.housingId == h.housingId}">
                                    <tr>
                                        <td>${h.building}栋${h.unit}单元${h.roomNo}室</td>
                                        <td>${h.area}m²</td>
                                        <td>${h.floor}楼</td>
                                        <td>${rh.owner ? '业主' : '租客'}</td>
                                        <td>${rh.startDate}</td>
                                        <td>${rh.endDate != null ? rh.endDate : '在住'}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/resident?action=housingDelete&residentId=${residentId}&housingId=${h.housingId}"
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('确定解除该关联吗？')">解除关联</a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center">暂无关联住房，请点击"添加关联"</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
