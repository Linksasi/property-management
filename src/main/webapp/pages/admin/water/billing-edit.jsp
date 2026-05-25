<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", request.getAttribute("rule") != null ? "编辑计费规则" : "新增计费规则"); %>
<% request.setAttribute("module", "water"); %>
<% request.setAttribute("activeTab", "billing"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">${rule != null ? '编辑计费规则' : '新增计费规则'}</h1>

    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/water" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="save">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">规则ID <span class="text-danger">*</span></label>
                    <input type="text" name="ruleId" class="form-control"
                           value="${rule != null ? rule.ruleId : nextId}"
                           ${rule != null ? 'readonly' : ''} required>
                    <c:if test="${rule == null}">
                        <small class="text-muted">系统自动生成</small>
                    </c:if>
                </div>
                <div class="col-md-6">
                    <label class="form-label">规则名称 <span class="text-danger">*</span></label>
                    <input type="text" name="ruleName" class="form-control"
                           value="${rule != null ? rule.ruleName : ''}" placeholder="如：2024年标准水价" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">基础单价（元/吨） <span class="text-danger">*</span></label>
                    <input type="number" name="basePrice" class="form-control" step="0.01" min="0"
                           value="${rule != null ? rule.basePrice : '3.50'}" placeholder="如：3.50" required>
                    <small class="text-muted">普通楼层适用的水价</small>
                </div>
                <div class="col-md-6">
                    <label class="form-label">加压单价（元/吨） <span class="text-danger">*</span></label>
                    <input type="number" name="pressurePrice" class="form-control" step="0.01" min="0"
                           value="${rule != null ? rule.pressurePrice : '4.50'}" placeholder="如：4.50" required>
                    <small class="text-muted">高楼层（超过加压起始楼层）适用的水价</small>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">加压起始楼层 <span class="text-danger">*</span></label>
                    <input type="number" name="pressureFloor" class="form-control" min="1"
                           value="${rule != null ? rule.pressureFloor : '7'}" placeholder="如：7" required>
                    <small class="text-muted">高于此楼层的住户适用加压单价</small>
                </div>
            </div>

            <hr class="my-4">
            <h5 class="mb-3">阶梯计费设置</h5>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">第一阶梯阈值（吨/月） <span class="text-danger">*</span></label>
                    <input type="number" name="tier1Threshold" class="form-control" step="0.01" min="0"
                           value="${rule != null ? rule.tier1Threshold : '10'}" placeholder="如：10" required>
                    <small class="text-muted">用水量不超过此值时适用基础单价</small>
                </div>
                <div class="col-md-6">
                    <label class="form-label">第一阶梯倍率 <span class="text-danger">*</span></label>
                    <input type="number" name="tier1Multiplier" class="form-control" step="0.01" min="0"
                           value="${rule != null ? rule.tier1Multiplier : '1.0'}" placeholder="如：1.0" required>
                    <small class="text-muted">通常为1.0（不涨价）</small>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">第二阶梯阈值（吨/月） <span class="text-danger">*</span></label>
                    <input type="number" name="tier2Threshold" class="form-control" step="0.01" min="0"
                           value="${rule != null ? rule.tier2Threshold : '20'}" placeholder="如：20" required>
                    <small class="text-muted">用水量超过此值时适用第三阶梯（超额水价）</small>
                </div>
                <div class="col-md-6">
                    <label class="form-label">第二阶梯倍率 <span class="text-danger">*</span></label>
                    <input type="number" name="tier2Multiplier" class="form-control" step="0.01" min="0"
                           value="${rule != null ? rule.tier2Multiplier : '2.0'}" placeholder="如：2.0" required>
                    <small class="text-muted">通常大于1.0（如：2.0表示涨价100%）</small>
                </div>
            </div>

            <hr class="my-4">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">生效日期 <span class="text-danger">*</span></label>
                    <input type="date" name="effectiveDate" class="form-control"
                           value="${rule != null ? rule.effectiveDate : ''}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">状态 <span class="text-danger">*</span></label>
                    <select name="status" class="form-select" required>
                        <option value="生效" ${rule != null && rule.status == '生效' ? 'selected' : ''}>生效</option>
                        <option value="失效" ${rule != null && rule.status == '失效' ? 'selected' : ''}>失效</option>
                    </select>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/admin/water?action=list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
