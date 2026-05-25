<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "水费管理"); %>
<% request.setAttribute("module", "water"); %>
<% request.setAttribute("activeTab", "fee"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">水费管理</h1>

    <%@ include file="/pages/common/water-tabs.jsp" %>

    <h2 class="h5 mb-3">账单详情</h2>

    <div class="card">
        <c:if test="${not empty bill}">
            <div class="row mb-3">
                <div class="col-md-6">
                    <h5 class="mb-3">基本信息</h5>
                    <table class="table table-borderless">
                        <tr>
                            <td class="text-muted" style="width: 120px;">账单ID：</td>
                            <td>${bill.billId}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">计费月份：</td>
                            <td>${bill.billMonth}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">住房地址：</td>
                            <td>${bill.housingAddress}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">住户姓名：</td>
                            <td>${bill.residentName}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">水表编号：</td>
                            <td>${bill.meterNo}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">截止日期：</td>
                            <td>${bill.dueDate}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">状态：</td>
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
                        </tr>
                    </table>
                </div>
                <div class="col-md-6">
                    <h5 class="mb-3">用水量明细</h5>
                    <table class="table table-borderless">
                        <tr>
                            <td class="text-muted" style="width: 120px;">上次读数：</td>
                            <td>${bill.lastRead} 吨</td>
                        </tr>
                        <tr>
                            <td class="text-muted">本次读数：</td>
                            <td>${bill.currentRead} 吨</td>
                        </tr>
                        <tr>
                            <td class="text-muted">用水量：</td>
                            <td><strong>${bill.usage} 吨</strong></td>
                        </tr>
                    </table>

                    <h5 class="mb-3 mt-4">费用明细</h5>
                    <table class="table table-borderless">
                        <tr>
                            <td class="text-muted" style="width: 120px;">单价：</td>
                            <td>${bill.unitPrice} 元/吨</td>
                        </tr>
                        <tr>
                            <td class="text-muted">应缴金额：</td>
                            <td><strong class="text-danger">${bill.amount} 元</strong></td>
                        </tr>
                        <tr>
                            <td class="text-muted">实缴金额：</td>
                            <td>${bill.paidAmount != null ? bill.paidAmount : '-'} 元</td>
                        </tr>
                        <tr>
                            <td class="text-muted">缴费时间：</td>
                            <td>${bill.paidDate != null ? bill.paidDate : '-'}</td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/admin/waterFee?action=list" class="btn btn-secondary">返回列表</a>
                <c:if test="${bill.status != '已缴'}">
                    <a href="${pageContext.request.contextPath}/admin/waterFee?action=confirmPayment&id=${bill.billId}" class="btn btn-primary" onclick="return confirm('确认该用户已缴费？')">确认缴费</a>
                </c:if>
            </div>
        </c:if>
        <c:if test="${empty bill}">
            <div class="text-center text-muted p-5">
                未找到账单信息
            </div>
            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/admin/waterFee?action=list" class="btn btn-secondary">返回列表</a>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
