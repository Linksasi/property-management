<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "个人信息"); %>
<% request.setAttribute("module", "resident"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">个人信息</h1>

    <!-- 个人信息卡片 -->
    <div class="card mb-4">
        <div class="card-body p-4">
            <div class="profile-header">
                <div class="avatar-circle">
                    ${requestScope.resident != null && requestScope.resident.name != null ? requestScope.resident.name.substring(0,1) : '?'}
                </div>
                <div class="profile-info">
                    <h4 class="mb-1">${requestScope.resident != null ? requestScope.resident.name : '未登记'}</h4>
                    <span class="text-muted">住户编号：${requestScope.resident != null ? requestScope.resident.residentId : '-'}</span>
                </div>
            </div>
            <hr class="my-4">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="info-item">
                        <label class="info-label">联系电话</label>
                        <div class="info-value">${requestScope.resident != null ? requestScope.resident.phone : '未登记'}</div>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="info-item">
                        <label class="info-label">身份证号</label>
                        <div class="info-value">${requestScope.resident != null ? requestScope.resident.idCard : '未登记'}</div>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="info-item">
                        <label class="info-label">入住时间</label>
                        <div class="info-value">${requestScope.resident != null ? requestScope.resident.checkInDate : '未登记'}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 住房信息卡片 -->
    <div class="card">
        <h5 class="card-header">关联住房</h5>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty housingWithRelationList}">
                    <table class="table-custom mb-0">
                        <thead>
                            <tr>
                                <th>住房地址</th>
                                <th>面积</th>
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
                                    <td>${hwr.housing.area}m²</td>
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
                    <p class="text-center text-muted p-4 mb-0">暂无关联住房</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<style>
.profile-header {
    display: flex;
    align-items: center;
    gap: 20px;
}
.avatar-circle {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background: linear-gradient(135deg, #2E7D32, #4CAF50);
    color: white;
    font-size: 28px;
    font-weight: bold;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}
.profile-info h4 {
    color: #333;
    font-weight: 600;
}
.info-label {
    font-size: 13px;
    color: #888;
    margin-bottom: 4px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
.info-value {
    font-size: 16px;
    color: #222;
    font-weight: 500;
}
</style>

<%@ include file="/pages/common/footer.jsp" %>
