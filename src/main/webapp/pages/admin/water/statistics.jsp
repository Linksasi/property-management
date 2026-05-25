<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "水费管理"); %>
<% request.setAttribute("module", "water"); %>
<% request.setAttribute("activeTab", "stat"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">水费管理</h1>

    <%@ include file="/pages/common/water-tabs.jsp" %>

    <h2 class="h5 mb-3">用水统计</h2>

    <div class="card mb-4">
        <div class="card-header">
            <h5 class="mb-0">筛选条件</h5>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/waterStat" class="row g-3">
                <input type="hidden" name="action" value="list">
                <div class="col-md-3">
                    <label class="form-label">开始月份</label>
                    <input type="month" name="startMonth" class="form-control" value="${startMonth}">
                </div>
                <div class="col-md-3">
                    <label class="form-label">结束月份</label>
                    <input type="month" name="endMonth" class="form-control" value="${endMonth}">
                </div>
                <div class="col-md-3">
                    <label class="form-label">楼栋</label>
                    <input type="text" name="building" class="form-control" value="${selectedBuilding}" placeholder="如：A">
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary me-2">查询</button>
                    <a href="${pageContext.request.contextPath}/admin/waterStat?action=list" class="btn btn-secondary">重置</a>
                </div>
            </form>
        </div>
    </div>

    <!-- 按月份统计 -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="mb-0">按月份统计</h5>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty monthlyList}">
                    <table class="table-custom mb-0">
                        <thead>
                            <tr>
                                <th>月份</th>
                                <th>账单数量</th>
                                <th>总用水量(吨)</th>
                                <th>总金额(元)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${monthlyList}" var="stat">
                                <tr>
                                    <td>${stat.month}</td>
                                    <td>${stat.billCount}</td>
                                    <td><strong>${stat.totalUsage}</strong></td>
                                    <td>${stat.totalAmount}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-muted p-5">暂无统计数据</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 按楼栋统计 -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">按楼栋统计</h5>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty buildingList}">
                    <table class="table-custom mb-0">
                        <thead>
                            <tr>
                                <th>楼栋</th>
                                <th>住户数</th>
                                <th>总用水量(吨)</th>
                                <th>总金额(元)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${buildingList}" var="stat">
                                <tr>
                                    <td><strong>${stat.building}栋</strong></td>
                                    <td>${stat.residentCount}</td>
                                    <td><strong>${stat.totalUsage}</strong></td>
                                    <td>${stat.totalAmount}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-muted p-5">暂无楼栋统计数据</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
