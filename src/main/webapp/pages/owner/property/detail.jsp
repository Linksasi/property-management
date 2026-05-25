<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    PropertyFeeDetail detail = (PropertyFeeDetail) request.getAttribute("entity");
    if (detail == null) {
        detail = new PropertyFeeDetail();
    }
%>

<% request.setAttribute("pageTitle", "账单详情"); %>
<% request.setAttribute("module", "property"); %>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/owner/property?action=list">我的账单</a>
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list">申诉记录</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">账单详情</h2>
            
            <!-- 返回按钮 -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/owner/property?action=list" class="btn btn-secondary">
                    &larr; 返回列表
                </a>
            </div>
            
            <!-- 账单信息 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">账单信息</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">账单ID</label>
                            <p style="margin:0"><%= detail.getDetailId() != null ? detail.getDetailId() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">计费月份</label>
                            <p style="margin:0"><%= detail.getBillMonth() != null ? detail.getBillMonth() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">收费类型</label>
                            <p style="margin:0"><%= detail.getStandardType() != null ? detail.getStandardType() : "物业费" %></p>
                        </div>
                    </div>
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">住房地址</label>
                            <p style="margin:0"><%= detail.getHousingAddress() != null ? detail.getHousingAddress() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">收费面积</label>
                            <p style="margin:0"><%= detail.getArea() != null ? detail.getArea().setScale(2) + " m²" : "0.00 m²" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">截止日期</label>
                            <p style="margin:0"><%= detail.getDueDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(detail.getDueDate()) : "" %></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 费用明细 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">费用明细</h5>
                <div style="padding:16px">
                    <div class="d-flex justify-content-between mb-2" style="border-bottom:1px solid var(--border);padding-bottom:8px">
                        <span>应缴金额</span>
                        <span style="font-weight:bold">¥<%= detail.getAmount() != null ? detail.getAmount().setScale(2) : "0.00" %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2" style="border-bottom:1px solid var(--border);padding-bottom:8px">
                        <span>实缴金额</span>
                        <span style="font-weight:bold;color:#198754">¥<%= detail.getPaidAmount() != null ? detail.getPaidAmount().setScale(2) : "0.00" %></span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span>待缴金额</span>
                        <span style="font-weight:bold;color:#dc3545">
                            <%
                                java.math.BigDecimal unpaid = java.math.BigDecimal.ZERO;
                                if (detail.getAmount() != null && detail.getPaidAmount() != null) {
                                    unpaid = detail.getAmount().subtract(detail.getPaidAmount());
                                }
                            %>
                            ¥<%= unpaid.setScale(2) %>
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- 状态 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">状态信息</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">当前状态</label>
                            <p style="margin:0">
                                <%
                                    String statusClass = "";
                                    if ("已缴".equals(detail.getStatus())) statusClass = "status-success";
                                    else if ("未缴".equals(detail.getStatus())) statusClass = "status-error";
                                    else if ("申诉中".equals(detail.getStatus())) statusClass = "status-warning";
                                    else if ("逾期".equals(detail.getStatus())) statusClass = "status-pending";
                                %>
                                <span class="status-tag <%= statusClass %>"><%= detail.getStatus() != null ? detail.getStatus() : "" %></span>
                            </p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">缴费时间</label>
                            <p style="margin:0"><%= detail.getPaidDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(detail.getPaidDate()) : "-" %></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 操作按钮 -->
            <% if (!"已缴".equals(detail.getStatus())) { %>
            <div class="card">
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <a href="${pageContext.request.contextPath}/owner/property?action=pay&detailId=<%= detail.getDetailId() %>" 
                           class="btn btn-primary btn-lg">立即缴费</a>
                        <a href="${pageContext.request.contextPath}/owner/property/appeal?action=add&detailId=<%= detail.getDetailId() %>" 
                           class="btn btn-secondary">费用申诉</a>
                    </div>
                </div>
            </div>
            <% } %>
</div>

<%@ include file="/pages/common/footer.jsp" %>