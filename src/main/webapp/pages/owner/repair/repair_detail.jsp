<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.RepairRequest, com.property.entity.MaintenanceWorkOrder" %>
<%
    RepairRequest detail = (RepairRequest) request.getAttribute("detail");
    if (detail == null) { response.sendRedirect(request.getContextPath() + "/owner/repair?action=list"); return; }
    MaintenanceWorkOrder wo = detail.getWorkOrder();
%>
<!DOCTYPE html>
<html>
<head>
    <title>维修申请详情</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .info-box h4 { margin-top: 0; color: #2E7D32; }
        .info-box p { margin: 6px 0; }
        .badge { padding: 3px 10px; border-radius: 4px; color: white; font-size: 12px; }
        .badge-warning { background-color: #ffc107; color: #000; }
        .badge-danger { background-color: #dc3545; }
        .badge-primary { background-color: #007bff; }
        .badge-info { background-color: #17a2b8; }
        .badge-success { background-color: #28a745; }
        .badge-dark { background-color: #343a40; }
        .badge-secondary { background-color: #6c757d; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; border: none; cursor: pointer; font-size: 13px; }
        .btn-secondary { background-color: #6c757d; }
        .btn-success { background-color: #28a745; }
        .btn-danger { background-color: #dc3545; }
        .timeline { margin-left: 20px; }
        .timeline-item { position: relative; padding-left: 30px; margin-bottom: 12px; }
        .timeline-item::before { content: ''; position: absolute; left: 0; top: 3px; width: 12px; height: 12px; border-radius: 50%; background-color: #007bff; }
        .timeline-item::after { content: ''; position: absolute; left: 5px; top: 18px; width: 2px; height: calc(100% + 10px); background-color: #ddd; }
        .timeline-item:last-child::after { display: none; }
        .stars { font-size: 28px; cursor: pointer; user-select: none; }
        .stars span { color: #ddd; transition: color 0.15s; }
        .stars span.active { color: #ffc107; }
        .form-group { margin-bottom: 12px; }
        .form-group label { display: inline-block; width: 90px; }
        textarea { width: 350px; height: 80px; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "repair");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/owner-sidebar.jsp" />
    <div class="content-area">
        <h2>维修申请详情</h2>

        <div class="info-box">
            <h4>申请信息</h4>
            <p><strong>申请ID：</strong><%=detail.getRequestId()%></p>
            <p><strong>房屋地址：</strong><%=detail.getHousingAddress()%></p>
            <p><strong>维修类型：</strong><%=detail.getRepairType()%></p>
            <p><strong>紧急程度：</strong><%=detail.getUrgency()%></p>
            <p><strong>申请时间：</strong><%=detail.getApplyTime() != null ? detail.getApplyTime().substring(0,16) : ""%></p>
            <p><strong>联系电话：</strong><%=detail.getResidentPhone()%></p>
            <p><strong>当前状态：</strong><span class="badge <%= "待审核".equals(detail.getStatus()) ? "badge-warning" : "已派工".equals(detail.getStatus()) ? "badge-primary" : "已完成".equals(detail.getStatus()) ? "badge-success" : "审核不通过".equals(detail.getStatus()) ? "badge-danger" : "badge-info" %>"><%=detail.getStatus()%></span></p>
        </div>

        <div class="info-box">
            <h4>问题描述</h4>
            <p><%=detail.getDescription()%></p>
        </div>

        <% if ("审核不通过".equals(detail.getStatus())) { %>
        <div class="info-box" style="border-left: 3px solid #dc3545;">
            <h4 style="color:#dc3545;">审核结果：不通过</h4>
            <p><strong>驳回原因：</strong><%=detail.getRejectReason() != null ? detail.getRejectReason() : "未填写"%></p>
            <% if (detail.getAdminName() != null) { %>
                <p><strong>审核人：</strong><%=detail.getAdminName()%></p>
                <p><strong>联系电话：</strong><%=detail.getAdminPhone() != null ? detail.getAdminPhone() : "暂无"%></p>
            <% } %>
        </div>
        <% } %>

        <% if (wo != null) { %>
        <div class="info-box">
            <h4>工单信息</h4>
            <p><strong>工单ID：</strong><%=wo.getWorkOrderId()%></p>
            <p><strong>维修人员：</strong><%=wo.getStaffName() != null ? wo.getStaffName() : "待指派"%></p>
            <% if (wo.getRepairContent() != null) { %>
                <p><strong>维修内容：</strong><%=wo.getRepairContent()%></p>
            <% } %>
            <% if (wo.getMaterialsUsed() != null) { %>
                <p><strong>使用材料：</strong><%=wo.getMaterialsUsed()%></p>
            <% } %>
            <% if (wo.getWorkHours() > 0) { %>
                <p><strong>工时：</strong><%=wo.getWorkHours()%> 小时</p>
            <% } %>
            <p><strong>工单状态：</strong><span class="badge badge-primary"><%=wo.getStatus()%></span></p>
        </div>

        <div class="info-box">
            <h4>进度时间线</h4>
            <div class="timeline">
                <div class="timeline-item">提交维修申请 — <%=detail.getApplyTime() != null ? detail.getApplyTime().substring(0,16) : ""%></div>
                <% if (wo.getReceiveTime() != null) { %>
                <div class="timeline-item">维修人员已接单 — <%=wo.getReceiveTime().substring(0,16)%></div>
                <% } %>
                <% if (wo.getStartTime() != null) { %>
                <div class="timeline-item">开始维修 — <%=wo.getStartTime().substring(0,16)%></div>
                <% } %>
                <% if (wo.getCompleteTime() != null) { %>
                <div class="timeline-item">维修人员提交结果 — <%=wo.getCompleteTime().substring(0,16)%></div>
                <% } %>
                <% if (wo.getConfirmTime() != null) { %>
                <div class="timeline-item">业主确认并评价 — <%=wo.getConfirmTime().substring(0,16)%></div>
                <% } %>
            </div>
        </div>

        <% if ("待确认".equals(wo.getStatus())) { %>
        <div class="info-box" style="border: 2px solid #28a745;">
            <h4>确认维修结果并评价</h4>
            <form action="${pageContext.request.contextPath}/owner/repair?action=confirm" method="post" id="confirmForm">
                <input type="hidden" name="workOrderId" value="<%=wo.getWorkOrderId()%>">
                <input type="hidden" name="rating" id="ratingInput" value="5">
                <div class="form-group">
                    <label>评分：</label>
                    <div class="stars" id="starRating">
                        <span data-value="1">★</span>
                        <span data-value="2">★</span>
                        <span data-value="3">★</span>
                        <span data-value="4">★</span>
                        <span data-value="5">★</span>
                    </div>
                </div>
                <div class="form-group">
                    <label>评价内容：</label>
                    <textarea name="comment" placeholder="请输入您的评价（选填）"></textarea>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-success">确认并提交评价</button>
                </div>
            </form>
            <script>
            (function() {
                var stars = document.querySelectorAll('#starRating span');
                var input = document.getElementById('ratingInput');
                var current = 5;
                function highlight(n) {
                    stars.forEach(function(s, i) {
                        s.classList.toggle('active', i < n);
                        s.textContent = i < n ? '★' : '☆';
                    });
                }
                highlight(current);
                stars.forEach(function(s) {
                    s.addEventListener('click', function() {
                        current = parseInt(this.getAttribute('data-value'));
                        highlight(current);
                        input.value = current;
                    });
                    s.addEventListener('mouseenter', function() {
                        highlight(parseInt(this.getAttribute('data-value')));
                    });
                });
                document.getElementById('starRating').addEventListener('mouseleave', function() {
                    highlight(current);
                });
            })();
            </script>
        </div>
        <% } %>

        <% if ("已完成".equals(wo.getStatus()) && wo.getRating() > 0) { %>
        <div class="info-box">
            <h4>我的评价</h4>
            <p><strong>评分：</strong>
                <span class="stars">
                    <% for (int i = 0; i < wo.getRating(); i++) { %>★<% } %>
                    <% for (int i = wo.getRating(); i < 5; i++) { %>☆<% } %>
                </span>
            </p>
            <% if (wo.getComment() != null && !wo.getComment().isEmpty()) { %>
                <p><strong>评价内容：</strong><%=wo.getComment()%></p>
            <% } %>
        </div>
        <% } %>
        <% } %>

        <div style="margin-top: 20px;">
            <% if ("待审核".equals(detail.getStatus())) { %>
                <a href="${pageContext.request.contextPath}/owner/repair?action=cancel&requestId=<%=detail.getRequestId()%>" class="btn btn-danger">取消申请</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/owner/repair?action=list" class="btn btn-secondary">返回列表</a>
        </div>
        <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>