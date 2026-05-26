<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "抄表录入"); %>
<% request.setAttribute("module", "water"); %>
<% request.setAttribute("activeTab", "read"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">水费管理</h1>

    <%@ include file="/pages/common/water-tabs.jsp" %>

    <h2 class="h5 mb-3">抄表录入</h2>

    <div class="card">
        <div class="alert alert-info mb-3">
            <i class="bi bi-info-circle"></i> 批量录入水表读数，系统将自动计算用水量。请确保本次读数大于上次读数。
        </div>

        <form action="${pageContext.request.contextPath}/admin/waterMeter" method="post" id="meterReadForm">
            <input type="hidden" name="action" value="saveReading">

            <table class="table-custom">
                <thead>
                    <tr>
                        <th>水表编号</th>
                        <th>住房地址</th>
                        <th>上次读数<br>(吨)</th>
                        <th>上次抄表日期</th>
                        <th>本次读数<br>(吨)</th>
                        <th>本次抄表日期</th>
                        <th>用水量<br>(吨)</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach items="${list}" var="item" varStatus="status">
                                <tr>
                                    <td>
                                        ${item.meterId}
                                        <input type="hidden" name="meterId" value="${item.meterId}">
                                    </td>
                                    <td>${item.fullAddress}</td>
                                    <td>
                                        ${item.currentRead != null ? item.currentRead : item.initialRead}
                                        <input type="hidden" name="lastRead" value="${item.currentRead != null ? item.currentRead : item.initialRead}">
                                    </td>
                                    <td>
                                        ${item.lastReadDate != null ? item.lastReadDate : item.installDate}
                                        <input type="hidden" name="lastReadDate" value="${item.lastReadDate != null ? item.lastReadDate : item.installDate}">
                                    </td>
                                    <td>
                                        <input type="number" name="currentRead" class="form-control form-control-sm" step="0.01" min="0"
                                               placeholder="请输入" onchange="calculateUsage(this)">
                                    </td>
                                    <td>
                                        <input type="date" name="readDate" class="form-control form-control-sm"
                                               value="${today}" max="${today}">
                                    </td>
                                    <td class="usage-cell">
                                        <span class="usage-value">-</span>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-primary btn-sm" onclick="submitRow(this)">录入</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center">暂无水表，请先添加水表</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="mt-3">
                <button type="submit" class="btn btn-primary">批量保存抄表记录</button>
            </div>
        </form>
    </div>
</div>

<script>
function calculateUsage(input) {
    var row = input.closest('tr');
    var lastRead = parseFloat(row.querySelector('input[name="lastRead"]').value) || 0;
    var currentRead = parseFloat(input.value) || 0;
    var usageCell = row.querySelector('.usage-value');

    if (currentRead > 0) {
        var usage = currentRead - lastRead;
        if (usage < 0) {
            usageCell.textContent = '读数错误';
            usageCell.className = 'usage-value text-danger';
            input.classList.add('is-invalid');
        } else {
            usageCell.textContent = usage.toFixed(2);
            usageCell.className = 'usage-value text-success';
            input.classList.remove('is-invalid');
        }
    } else {
        usageCell.textContent = '-';
        usageCell.className = 'usage-value';
    }
}

function submitRow(btn) {
    var row = btn.closest('tr');
    var currentReadInput = row.querySelector('input[name="currentRead"]');
    var readDateInput = row.querySelector('input[name="readDate"]');
    var today = readDateInput.max;

    if (!currentReadInput.value) {
        alert('请先输入本次读数');
        currentReadInput.focus();
        return;
    }

    var lastRead = parseFloat(row.querySelector('input[name="lastRead"]').value) || 0;
    var currentRead = parseFloat(currentReadInput.value) || 0;
    if (currentRead < lastRead) {
        alert('本次读数不能小于上次读数');
        currentReadInput.focus();
        return;
    }

    if (readDateInput.value && readDateInput.max && readDateInput.value > readDateInput.max) {
        alert('抄表日期不能超过今天');
        readDateInput.focus();
        return;
    }

    // 禁用按钮防止重复提交
    btn.disabled = true;
    btn.textContent = '提交中...';

    // 动态构建单行提交
    var form = document.createElement('form');
    form.method = 'post';
    form.action = '${pageContext.request.contextPath}/admin/waterMeter';

    var meterIdInput = row.querySelector('input[name="meterId"]');
    if (meterIdInput && meterIdInput.value) {
        var m = document.createElement('input');
        m.type = 'hidden';
        m.name = 'meterId';
        m.value = meterIdInput.value;
        form.appendChild(m);
    }

    var c = document.createElement('input');
    c.type = 'hidden';
    c.name = 'currentRead';
    c.value = currentReadInput.value;
    form.appendChild(c);

    var d = document.createElement('input');
    d.type = 'hidden';
    d.name = 'readDate';
    d.value = readDateInput.value;
    form.appendChild(d);

    var a = document.createElement('input');
    a.type = 'hidden';
    a.name = 'action';
    a.value = 'saveReading';
    form.appendChild(a);

    document.body.appendChild(form);
    form.submit();
}
</script>

<style>
.usage-cell .text-danger { color: #dc3545; font-weight: bold; }
.usage-cell .text-success { color: #198754; font-weight: bold; }
</style>

<%@ include file="/pages/common/footer.jsp" %>
