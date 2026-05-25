<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.property.model.PropertyFeeAppeal" %>
<%
    List<PropertyFeeAppeal> list = (List<PropertyFeeAppeal>) request.getAttribute("list");
    if (list == null) list = new java.util.ArrayList<>();
    String filterStatus = (String) request.getParameter("status");
%>

<% request.setAttribute("pageTitle", "申诉管理"); %>
<% request.setAttribute("module", "property"); %>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/admin/property?action=list">物业费明细</a>
                <a href="${pageContext.request.contextPath}/admin/property/standard?action=list">收费标准</a>
                <a href="${pageContext.request.contextPath}/admin/property/batch?action=add">生成账单</a>
                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list" class="active">申诉管理</a>
                <a href="${pageContext.request.contextPath}/admin/property/report?action=list">统计报表</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">物业费申诉管理</h2>
            
            <!-- 筛选表单 -->
            <div class="card mb-3">
                <form method="get" action="${pageContext.request.contextPath}/admin/property/appeal" class="d-flex gap-12 align-items-end flex-wrap">
                    <input type="hidden" name="action" value="list">
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">状态筛选</label>
                        <select name="status" class="form-control">
                            <option value="">全部</option>
                            <option value="待审核" <%= "待审核".equals(filterStatus) ? "selected" : "" %>>待审核</option>
                            <option value="通过" <%= "通过".equals(filterStatus) ? "selected" : "" %>>通过</option>
                            <option value="驳回" <%= "驳回".equals(filterStatus) ? "selected" : "" %>>驳回</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <button type="submit" class="btn btn-primary btn-sm">筛选</button>
                        <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list" class="btn btn-secondary btn-sm">重置</a>
                    </div>
                </form>
            </div>
            
            <!-- 统计卡片 -->
            <div class="d-flex gap-12 mb-3">
                <div class="card" style="flex:1;text-align:center;padding:16px">
                    <div style="font-size:24px;font-weight:bold;color:var(--primary)">
                        <%= list.stream().filter(a -> "待审核".equals(a.getStatus())).count() %>
                    </div>
                    <div style="color:var(--text-secondary);font-size:14px">待审核</div>
                </div>
                <div class="card" style="flex:1;text-align:center;padding:16px">
                    <div style="font-size:24px;font-weight:bold;color:#198754">
                        <%= list.stream().filter(a -> "通过".equals(a.getStatus())).count() %>
                    </div>
                    <div style="color:var(--text-secondary);font-size:14px">已通过</div>
                </div>
                <div class="card" style="flex:1;text-align:center;padding:16px">
                    <div style="font-size:24px;font-weight:bold;color:#dc3545">
                        <%= list.stream().filter(a -> "驳回".equals(a.getStatus())).count() %>
                    </div>
                    <div style="color:var(--text-secondary);font-size:14px">已驳回</div>
                </div>
            </div>
            
            <!-- 数据表格 -->
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>申诉ID</th>
                            <th>住户姓名</th>
                            <th>住房地址</th>
                            <th>账单月份</th>
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
                            <td colspan="8" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无申诉记录
                            </td>
                        </tr>
                        <%
                        } else {
                            for (PropertyFeeAppeal appeal : list) {
                                String statusClass = "";
                                if ("待审核".equals(appeal.getStatus())) {
                                    statusClass = "status-warning";
                                } else if ("通过".equals(appeal.getStatus())) {
                                    statusClass = "status-success";
                                } else if ("驳回".equals(appeal.getStatus())) {
                                    statusClass = "status-error";
                                }
                        %>
                        <tr>
                            <td><%= appeal.getAppealId() != null ? appeal.getAppealId() : "" %></td>
                            <td><%= appeal.getResidentName() != null ? appeal.getResidentName() : "" %></td>
                            <td><%= appeal.getHousingAddress() != null ? appeal.getHousingAddress() : "" %></td>
                            <td><%= appeal.getBillMonth() != null ? appeal.getBillMonth() : "" %></td>
                            <td title="<%= appeal.getReason() != null ? appeal.getReason() : "" %>">
                                <%= appeal.getReason() != null && appeal.getReason().length() > 20 ? appeal.getReason().substring(0, 20) + "..." : appeal.getReason() %>
                            </td>
                            <td><%= appeal.getCreateTime() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(appeal.getCreateTime()) : "" %></td>
                            <td><span class="status-tag <%= statusClass %>"><%= appeal.getStatus() != null ? appeal.getStatus() : "" %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=detail&appealId=<%= appeal.getAppealId() %>" 
                                   class="btn btn-secondary btn-sm">查看详情</a>
                                <% if ("待审核".equals(appeal.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=detail&appealId=<%= appeal.getAppealId() %>" 
                                   class="btn btn-primary btn-sm">审核</a>
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