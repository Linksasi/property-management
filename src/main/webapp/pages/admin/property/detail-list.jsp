<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    List<PropertyFeeDetail> list = (List<PropertyFeeDetail>) request.getAttribute("list");
    if (list == null) list = new java.util.ArrayList<>();
%>

<% request.setAttribute("pageTitle", "物业费明细管理"); %>
<% request.setAttribute("module", "property"); %>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/admin/property?action=list" class="active">物业费明细</a>
                <a href="${pageContext.request.contextPath}/admin/property/standard?action=list">收费标准</a>
                <a href="${pageContext.request.contextPath}/admin/property/batch?action=add">生成账单</a>
                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list">申诉管理</a>
                <a href="${pageContext.request.contextPath}/admin/property/report?action=list">统计报表</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">物业费明细管理</h2>
            
            <!-- 筛选表单 -->
            <div class="card mb-3">
                <form method="get" action="${pageContext.request.contextPath}/admin/property" class="d-flex gap-12 flex-wrap">
                    <input type="hidden" name="action" value="list">
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">计费月份</label>
                        <input type="month" name="billMonth" class="form-control" 
                               value="${param.billMonth}">
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">状态</label>
                        <select name="status" class="form-control">
                            <option value="">全部</option>
                            <option value="未缴" ${param.status == '未缴' ? 'selected' : ''}>未缴</option>
                            <option value="已缴" ${param.status == '已缴' ? 'selected' : ''}>已缴</option>
                            <option value="申诉中" ${param.status == '申诉中' ? 'selected' : ''}>申诉中</option>
                            <option value="逾期" ${param.status == '逾期' ? 'selected' : ''}>逾期</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom:0; align-self:flex-end">
                        <button type="submit" class="btn btn-primary btn-sm">筛选</button>
                        <a href="${pageContext.request.contextPath}/admin/property?action=list" class="btn btn-secondary btn-sm">重置</a>
                    </div>
                </form>
            </div>
            
            <!-- 数据表格 -->
            <div class="card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>账单ID</th>
                            <th>住房地址</th>
                            <th>住户姓名</th>
                            <th>计费月份</th>
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
                            <td colspan="9" class="text-center" style="color:var(--text-secondary);padding:40px">
                                暂无数据
                            </td>
                        </tr>
                        <%
                        } else {
                            for (PropertyFeeDetail detail : list) {
                                String statusClass = "";
                                if ("已缴".equals(detail.getStatus())) {
                                    statusClass = "status-success";
                                } else if ("未缴".equals(detail.getStatus())) {
                                    statusClass = "status-error";
                                } else if ("申诉中".equals(detail.getStatus())) {
                                    statusClass = "status-warning";
                                } else if ("逾期".equals(detail.getStatus())) {
                                    statusClass = "status-pending";
                                }
                        %>
                        <tr>
                            <td><%= detail.getDetailId() != null ? detail.getDetailId() : "" %></td>
                            <td><%= detail.getHousingAddress() != null ? detail.getHousingAddress() : "" %></td>
                            <td><%= detail.getResidentName() != null ? detail.getResidentName() : "" %></td>
                            <td><%= detail.getBillMonth() != null ? detail.getBillMonth() : "" %></td>
                            <td><%= detail.getAmount() != null ? "¥" + detail.getAmount().setScale(2) : "¥0.00" %></td>
                            <td><%= detail.getPaidAmount() != null ? "¥" + detail.getPaidAmount().setScale(2) : "¥0.00" %></td>
                            <td><%= detail.getDueDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(detail.getDueDate()) : "" %></td>
                            <td><span class="status-tag <%= statusClass %>"><%= detail.getStatus() != null ? detail.getStatus() : "" %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/property?action=detail&id=<%= detail.getDetailId() %>" 
                                   class="btn btn-secondary btn-sm">查看详情</a>
                                <% if (!"已缴".equals(detail.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/admin/property?action=confirm&id=<%= detail.getDetailId() %>" 
                                   class="btn btn-primary btn-sm"
                                   onclick="return confirm('确认该用户已缴费？')">确认缴费</a>
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