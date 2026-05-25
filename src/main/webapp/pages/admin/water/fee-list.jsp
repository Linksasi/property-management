<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "水费管理"); %>
<% request.setAttribute("module", "water"); %>
<% request.setAttribute("activeTab", "fee"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">水费管理</h1>

    <%@ include file="/pages/common/water-tabs.jsp" %>

    <h2 class="h5 mb-3">水费账单</h2>

    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <form method="get" action="${pageContext.request.contextPath}/admin/waterFee" class="d-flex gap-2">
                <input type="hidden" name="action" value="list">
                <input type="month" name="billMonth" class="form-control" style="width: 180px;"
                       value="${selectedMonth}">
                <button type="submit" class="btn btn-secondary">筛选月份</button>
                <c:if test="${not empty selectedMonth}">
                    <a href="${pageContext.request.contextPath}/admin/waterFee?action=list" class="btn btn-outline-secondary">清除筛选</a>
                </c:if>
            </form>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th>账单ID</th>
                    <th>计费月份</th>
                    <th>住房地址</th>
                    <th>住户姓名</th>
                    <th>用水量(吨)</th>
                    <th>单价(元)</th>
                    <th>应缴金额(元)</th>
                    <th>实缴金额(元)</th>
                    <th>截止日期</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.billId}</td>
                                <td>${item.billMonth}</td>
                                <td>${item.housingAddress}</td>
                                <td>${item.residentName}</td>
                                <td>${item.usage}</td>
                                <td>${item.unitPrice}</td>
                                <td>${item.amount}</td>
                                <td>${item.paidAmount != null ? item.paidAmount : '-'}</td>
                                <td>${item.dueDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status == '已缴'}">
                                            <span class="badge bg-success">已缴</span>
                                        </c:when>
                                        <c:when test="${item.status == '逾期'}">
                                            <span class="badge" style="background-color: #fd7e14;">逾期</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">未缴</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/waterFee?action=detail&id=${item.billId}" class="btn btn-secondary btn-sm">详情</a>
                                    <c:if test="${item.status != '已缴'}">
                                        <a href="${pageContext.request.contextPath}/admin/waterFee?action=confirmPayment&id=${item.billId}" class="btn btn-primary btn-sm" onclick="return confirm('确认该用户已缴费？')">确认缴费</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="11" class="text-center">暂无账单数据</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
