<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "我的住房"); %>
<% request.setAttribute("module", "resident"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">我的住房</h1>

    <div class="card">
        <h5 class="card-header">住房列表</h5>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty housingWithRelationList}">
                    <table class="table-custom mb-0">
                        <thead>
                            <tr>
                                <th>住房地址</th>
                                <th>面积(m²)</th>
                                <th>楼层</th>
                                <th>户型</th>
                                <th>身份</th>
                                <th>入住日期</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${housingWithRelationList}" var="hwr">
                                <tr>
                                    <td>${hwr.housing.building}栋${hwr.housing.unit}单元${hwr.housing.roomNo}室</td>
                                    <td>${hwr.housing.area}</td>
                                    <td>${hwr.housing.floor}楼</td>
                                    <td>${hwr.housing.houseType}</td>
                                    <td><span class="badge ${hwr.isOwner ? 'bg-success' : 'bg-info'}">${hwr.isOwner ? '业主' : '租客'}</span></td>
                                    <td>${hwr.startDate}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="text-center text-muted p-4 mb-0">暂无关联住房记录</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
