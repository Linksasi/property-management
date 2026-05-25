<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<% request.setAttribute("pageTitle", "申请详情"); %>
<% request.setAttribute("module", "ad_app"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">广告申请详情</h1>

    <div class="card">
        <div class="form-group">
            <label class="form-label">申请ID</label>
            <div class="form-control" style="border: none;">${entity.appId}</div>
        </div>

        <div class="form-group">
            <label class="form-label">公司名称</label>
            <div class="form-control" style="border: none;">${entity.companyName}</div>
        </div>

        <div class="form-group">
            <label class="form-label">广告内容</label>
            <div class="form-control" style="border: none;">${entity.adContent}</div>
        </div>

        <div class="form-group">
            <label class="form-label">期望位置</label>
            <div class="form-control" style="border: none;">${not empty entity.expectSlotName ? entity.expectSlotName : entity.expectSlot}</div>
        </div>

        <div class="form-group">
            <label class="form-label">投放日期</label>
            <div class="form-control" style="border: none;">
                <fmt:formatDate value="${entity.startDate}" pattern="yyyy-MM-dd"/> 至 <fmt:formatDate value="${entity.endDate}" pattern="yyyy-MM-dd"/>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">申请时间</label>
            <div class="form-control" style="border: none;">
                <fmt:formatDate value="${entity.applyDate}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">当前状态</label>
            <div class="form-control" style="border: none;">${entity.status}</div>
        </div>

        <c:if test="${not empty errorMsg}">
            <div style="background:#f8d7da; color:#842029; padding:10px 16px; border-radius:6px; margin-bottom:12px;">${errorMsg}</div>
        </c:if>

        <c:if test="${entity.status == '待审核'}">
            <div class="mt-3">
                <h4>审批操作</h4>

                <div class="card" style="margin-top: 12px;">
                    <form action="${pageContext.request.contextPath}/admin/ad?action=appApprove" method="post">
                        <input type="hidden" name="applicationId" value="${entity.appId}">

                        <div class="form-group">
                            <label class="form-label">分配广告位</label>
                            <select class="form-control" name="slotId">
                                <option value="">请选择广告位</option>
                                <c:forEach items="${slots}" var="slot">
                                    <option value="${slot.slotId}">${slot.slotId} - ${slot.location}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary" style="margin-right: 12px;">通过</button>
                    </form>

                    <form action="${pageContext.request.contextPath}/admin/ad?action=appReject" method="post" style="margin-top: 12px;">
                        <input type="hidden" name="applicationId" value="${entity.appId}">

                        <div class="form-group">
                            <label class="form-label">拒绝原因</label>
                            <textarea class="form-control" name="comments" rows="3"></textarea>
                        </div>

                        <button type="submit" class="btn btn-danger">驳回</button>
                    </form>
                </div>
            </div>
        </c:if>

        <div class="d-flex gap-12 mt-3">
            <a href="${pageContext.request.contextPath}/admin/ad?action=appList" class="btn btn-secondary">返回列表</a>
        </div>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>