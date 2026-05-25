<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "计费规则管理"); %>
<% request.setAttribute("module", "water"); %>
<% request.setAttribute("activeTab", "billing"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">水费管理</h1>

    <%@ include file="/pages/common/water-tabs.jsp" %>

    <h2 class="h5 mb-3">计费规则</h2>

    <div class="card">
        <div class="d-flex justify-content-end mb-3">
            <a href="${pageContext.request.contextPath}/admin/water?action=add" class="btn btn-primary">新增规则</a>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th>规则ID</th>
                    <th>规则名称</th>
                    <th>基础单价<br>(元/吨)</th>
                    <th>加压单价<br>(元/吨)</th>
                    <th>加压起始<br>楼层</th>
                    <th>第一阶梯<br>阈值/倍率</th>
                    <th>第二阶梯<br>阈值/倍率</th>
                    <th>生效日期</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.ruleId}</td>
                                <td>${item.ruleName}</td>
                                <td>${item.basePrice}</td>
                                <td>${item.pressurePrice}</td>
                                <td>${item.pressureFloor}层</td>
                                <td>
                                    <small>
                                        &le;${item.tier1Threshold}吨<br>
                                        &times;${item.tier1Multiplier}
                                    </small>
                                </td>
                                <td>
                                    <small>
                                        &le;${item.tier2Threshold}吨<br>
                                        &times;${item.tier2Multiplier}
                                    </small>
                                </td>
                                <td>${item.effectiveDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status == '生效'}">
                                            <span class="badge bg-success">生效</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">失效</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/water?action=edit&id=${item.ruleId}" class="btn btn-secondary btn-sm">编辑</a>
                                    <a href="${pageContext.request.contextPath}/admin/water?action=toggleStatus&id=${item.ruleId}" class="btn btn-outline-primary btn-sm">
                                        ${item.status == '生效' ? '停用' : '启用'}
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/water?action=delete&id=${item.ruleId}" class="btn btn-danger btn-sm" onclick="return confirm('确定删除该规则吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="10" class="text-center">暂无数据，请先添加计费规则</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
