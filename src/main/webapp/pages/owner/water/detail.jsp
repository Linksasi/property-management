<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "账单详情"); %>
<% request.setAttribute("module", "water"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">账单详情</h1>

    <div class="card">
        <c:if test="${not empty bill}">
            <div class="card-header">
                <h5 class="mb-0">水费账单详情</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6 class="text-muted mb-3">基本信息</h6>
                        <table class="table table-borderless">
                            <tr>
                                <td style="width: 120px;">账单编号：</td>
                                <td><strong>${bill.billId}</strong></td>
                            </tr>
                            <tr>
                                <td>计费月份：</td>
                                <td>${bill.billMonth}</td>
                            </tr>
                            <tr>
                                <td>住房地址：</td>
                                <td>${bill.housingAddress}</td>
                            </tr>
                            <tr>
                                <td>截止日期：</td>
                                <td>${bill.dueDate}</td>
                            </tr>
                            <tr>
                                <td>状态：</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${bill.status == '已缴'}">
                                            <span class="badge bg-success">已缴费</span>
                                        </c:when>
                                        <c:when test="${bill.status == '逾期'}">
                                            <span class="badge" style="background-color: #fd7e14;">已逾期</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">待缴费</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-muted mb-3">用水量明细</h6>
                        <table class="table table-borderless">
                            <tr>
                                <td style="width: 120px;">上次读数：</td>
                                <td>${bill.lastRead} 吨</td>
                            </tr>
                            <tr>
                                <td>本次读数：</td>
                                <td>${bill.currentRead} 吨</td>
                            </tr>
                            <tr>
                                <td>用水量：</td>
                                <td><strong class="text-primary">${bill.usage} 吨</strong></td>
                            </tr>
                        </table>

                        <h6 class="text-muted mb-3 mt-4">费用明细</h6>
                        <table class="table table-borderless">
                            <tr>
                                <td style="width: 120px;">单价：</td>
                                <td>${bill.unitPrice} 元/吨</td>
                            </tr>
                            <tr>
                                <td>应缴金额：</td>
                                <td><strong class="text-danger fs-5">${bill.amount} 元</strong></td>
                            </tr>
                            <c:if test="${bill.status == '已缴'}">
                                <tr>
                                    <td>实缴金额：</td>
                                    <td><strong>${bill.paidAmount} 元</strong></td>
                                </tr>
                                <tr>
                                    <td>缴费时间：</td>
                                    <td>${bill.paidDate}</td>
                                </tr>
                            </c:if>
                        </table>
                    </div>
                </div>

                <div class="mt-4 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/owner/water?action=list" class="btn btn-secondary">返回列表</a>
                    <c:if test="${bill.status != '已缴'}">
                        <a href="${pageContext.request.contextPath}/owner/waterPay?action=pay&id=${bill.billId}" class="btn btn-primary">立即缴费</a>
                    </c:if>
                </div>
            </div>
        </c:if>
        <c:if test="${empty bill}">
            <div class="card-body text-center text-muted p-5">
                未找到账单信息
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/owner/water?action=list" class="btn btn-secondary">返回列表</a>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
