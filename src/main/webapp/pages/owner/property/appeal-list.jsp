<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.property.model.PropertyFeeAppeal" %>
<%
    List<PropertyFeeAppeal> list = (List<PropertyFeeAppeal>) request.getAttribute("list");
    if (list == null) list = new java.util.ArrayList<>();
%>

<% request.setAttribute("pageTitle", "申诉记录"); %>
<% request.setAttribute("module", "property"); %>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/owner-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/owner/property?action=list">我的账单</a>
                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=list" class="active">申诉记录</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">费用申诉记录</h2>
            
            <!-- 数据表格 -->
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>申诉ID</th>
                            <th>计费月份</th>
                            <th>收费类型</th>
                            <th>申诉原因</th>
                            <th>申诉时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (list.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="7" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无申诉记录
                            </td>
                        </tr>
                        <%
                        } else {
                            for (PropertyFeeAppeal appeal : list) {
                                String statusClass = "";
                                String statusColor = "";
                                if ("待审核".equals(appeal.getStatus())) {
                                    statusClass = "status-warning";
                                    statusColor = "#ffc107";
                                } else if ("通过".equals(appeal.getStatus())) {
                                    statusClass = "status-success";
                                    statusColor = "#198754";
                                } else if ("驳回".equals(appeal.getStatus())) {
                                    statusClass = "status-error";
                                    statusColor = "#dc3545";
                                }
                        %>
                        <tr>
                            <td><%= appeal.getAppealId() != null ? appeal.getAppealId() : "" %></td>
                            <td><%= appeal.getBillMonth() != null ? appeal.getBillMonth() : "" %></td>
                            <td><%= appeal.getStandardType() != null ? appeal.getStandardType() : "物业费" %></td>
                            <td title="<%= appeal.getReason() != null ? appeal.getReason() : "" %>">
                                <%= appeal.getReason() != null && appeal.getReason().length() > 15 ? appeal.getReason().substring(0, 15) + "..." : appeal.getReason() %>
                            </td>
                            <td><%= appeal.getCreateTime() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(appeal.getCreateTime()) : "" %></td>
                            <td><span class="status-tag <%= statusClass %>" style="color:<%= statusColor %>"><%= appeal.getStatus() != null ? appeal.getStatus() : "" %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/owner/property/appeal?action=detail&appealId=<%= appeal.getAppealId() %>" 
                                   class="btn btn-secondary btn-sm">查看详情</a>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
</div>

<%@ include file="/pages/common/footer.jsp" %>