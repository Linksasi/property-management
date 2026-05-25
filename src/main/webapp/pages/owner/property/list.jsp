<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    List<PropertyFeeDetail> list = (List<PropertyFeeDetail>) request.getAttribute("list");
    if (list == null) list = new java.util.ArrayList<>();
%>

<% request.setAttribute("pageTitle", "我的账单"); %>
<% request.setAttribute("module", "property"); %>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/owner/property?action=list" class="active">我的账单</a>
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list">申诉记录</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">我的账单</h2>
            
            <!-- 数据表格 -->
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>账单ID</th>
                            <th>计费月份</th>
                            <th>收费类型</th>
                            <th>应缴金额</th>
                            <th>实缴金额</th>
                            <th>截止日期</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (list.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="8" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无账单记录
                            </td>
                        </tr>
                        <%
                        } else {
                            for (PropertyFeeDetail detail : list) {
                                String statusClass = "";
                                String statusColor = "";
                                if ("已缴".equals(detail.getStatus())) {
                                    statusClass = "status-success";
                                    statusColor = "#198754";
                                } else if ("未缴".equals(detail.getStatus())) {
                                    statusClass = "status-error";
                                    statusColor = "#dc3545";
                                } else if ("申诉中".equals(detail.getStatus())) {
                                    statusClass = "status-warning";
                                    statusColor = "#ffc107";
                                } else if ("逾期".equals(detail.getStatus())) {
                                    statusClass = "status-pending";
                                    statusColor = "#fd7e14";
                                }
                        %>
                        <tr>
                            <td><%= detail.getDetailId() != null ? detail.getDetailId() : "" %></td>
                            <td><%= detail.getBillMonth() != null ? detail.getBillMonth() : "" %></td>
                            <td><%= detail.getStandardType() != null ? detail.getStandardType() : "物业费" %></td>
                            <td><%= detail.getAmount() != null ? "¥" + detail.getAmount().setScale(2) : "¥0.00" %></td>
                            <td><%= detail.getPaidAmount() != null ? "¥" + detail.getPaidAmount().setScale(2) : "¥0.00" %></td>
                            <td><%= detail.getDueDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(detail.getDueDate()) : "" %></td>
                            <td><span class="status-tag <%= statusClass %>" style="color:<%= statusColor %>"><%= detail.getStatus() != null ? detail.getStatus() : "" %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/owner/property?action=detail&detailId=<%= detail.getDetailId() %>" 
                                   class="btn btn-secondary btn-sm">查看详情</a>
                                <% if (!"已缴".equals(detail.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/owner/property?action=pay&detailId=<%= detail.getDetailId() %>" 
                                   class="btn btn-primary btn-sm">立即缴费</a>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>