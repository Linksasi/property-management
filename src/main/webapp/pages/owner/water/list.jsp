<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "我的水费"); %>
<% request.setAttribute("module", "water"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">我的水费</h1>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">水费账单</h5>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty billList}">
                    <table class="table-custom mb-0">
                        <thead>
                            <tr>
                                <th>账单ID</th>
                                <th>计费月份</th>
                                <th>用水量(吨)</th>
                                <th>应缴金额(元)</th>
                                <th>实缴金额(元)</th>
                                <th>截止日期</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${billList}" var="bill">
                                <tr>
                                    <td>${bill.billId}</td>
                                    <td>${bill.billMonth}</td>
                                    <td>${bill.usage}</td>
                                    <td>${bill.amount}</td>
                                    <td>${bill.paidAmount != null ? bill.paidAmount : '-'}</td>
                                    <td>${bill.dueDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${bill.status == '已缴'}">
                                                <span class="badge bg-success">已缴</span>
                                            </c:when>
                                            <c:when test="${bill.status == '逾期'}">
                                                <span class="badge" style="background-color: #fd7e14;">逾期</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">未缴</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/owner/water?action=detail&id=${bill.billId}" class="btn btn-secondary btn-sm">详情</a>
                                        <c:if test="${bill.status != '已缴'}">
                                            <a href="${pageContext.request.contextPath}/owner/waterPay?action=pay&id=${bill.billId}" class="btn btn-primary btn-sm">立即缴费</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-muted p-5">
                        暂无水费账单
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
