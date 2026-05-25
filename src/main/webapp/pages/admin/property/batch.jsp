<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.property.model.PropertyStandard" %>
<%@ page import="com.property.service.PropertyFeeDetailService" %>
<%
    String billMonth = (String) request.getAttribute("billMonth");
    if (billMonth == null) billMonth = "";
    Integer residentCount = (Integer) request.getAttribute("residentCount");
    if (residentCount == null) residentCount = 0;
    String error = (String) request.getAttribute("error");
    if (error == null) error = "";
    List<PropertyStandard> standardList = (List<PropertyStandard>) request.getAttribute("standardList");
    if (standardList == null) standardList = new java.util.ArrayList<>();
    List<PropertyFeeDetailService.BatchPreviewItem> previewList = 
        (List<PropertyFeeDetailService.BatchPreviewItem>) request.getAttribute("previewList");
    if (previewList == null) previewList = new java.util.ArrayList<>();
    
    // 计算预览总金额
    java.math.BigDecimal previewTotal = java.math.BigDecimal.ZERO;
    for (PropertyFeeDetailService.BatchPreviewItem item : previewList) {
        if (item.getTotalAmount() != null) {
            previewTotal = previewTotal.add(item.getTotalAmount());
        }
    }
%>

<% request.setAttribute("pageTitle", "生成物业费账单"); %>
<% request.setAttribute("module", "property"); %>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/admin/property?action=list">物业费明细</a>
                <a href="${pageContext.request.contextPath}/admin/property/standard?action=list">收费标准</a>
                <a href="${pageContext.request.contextPath}/admin/property/batch?action=add" class="active">生成账单</a>
                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list">申诉管理</a>
                <a href="${pageContext.request.contextPath}/admin/property/report?action=list">统计报表</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title">生成物业费账单</h2>
            
            <!-- 错误提示 -->
            <% if (!error.isEmpty()) { %>
            <div class="card" style="border-left:4px solid var(--error);margin-bottom:16px">
                <p style="color:var(--error);margin:0;padding:12px"><%= error %></p>
            </div>
            <% } %>
            
            <!-- 步骤提示 -->
            <div class="card mb-3" style="background:#E8F5E9;border-left:4px solid var(--primary)">
                <div style="padding:12px">
                    <strong>操作说明：</strong>
                    <ol style="margin-bottom:0;padding-left:20px">
                        <li>选择计费月份</li>
                        <li>点击"预览账单"查看生成结果</li>
                        <li>确认无误后点击"确认生成"写入数据库</li>
                    </ol>
                </div>
            </div>
            
            <!-- 计费月份选择表单 -->
            <div class="card mb-3">
                <form method="get" action="${pageContext.request.contextPath}/admin/property/batch" class="d-flex gap-12 align-items-end flex-wrap">
                    <input type="hidden" name="action" value="preview">
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">计费月份 <span class="required">*</span></label>
                        <input type="month" name="billMonth" class="form-control" required value="<%= billMonth %>">
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">住户数量</label>
                        <input type="text" class="form-control" readonly value="<%= residentCount %> 户" style="background:#f5f5f5">
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <button type="submit" class="btn btn-primary">预览账单</button>
                    </div>
                </form>
            </div>
            
            <!-- 生效收费标准提示 -->
            <% if (!standardList.isEmpty()) { %>
            <div class="card mb-3">
                <div style="padding:12px">
                    <strong>当前生效的收费标准：</strong>
                    <div class="d-flex gap-12 flex-wrap" style="margin-top:8px">
                        <% for (PropertyStandard standard : standardList) { %>
                        <span class="status-tag status-success">
                            <%= standard.getFeeType() %>：¥<%= standard.getUnitPrice() != null ? standard.getUnitPrice().setScale(2) : "0.00" %>/m²/月
                        </span>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="card mb-3" style="border-left:4px solid var(--warning)">
                <div style="padding:12px;color:var(--warning)">
                    <strong>注意：</strong>当前没有生效的收费标准，请先到 <a href="${pageContext.request.contextPath}/admin/property/standard?action=add">收费标准管理</a> 添加。
                </div>
            </div>
            <% } %>
            
            <!-- 预览表格 -->
            <% if (!previewList.isEmpty()) { %>
            <div class="card mb-3">
                <div class="d-flex justify-content-between align-items-center" style="padding:16px 16px 8px">
                    <h5 style="margin:0">账单预览（共 <%= previewList.size() %> 条记录）</h5>
                    <div>
                        <span style="font-size:14px;color:var(--text-secondary)">预计总金额：</span>
                        <span style="font-size:18px;color:var(--primary);font-weight:bold">¥<%= previewTotal.setScale(2) %></span>
                    </div>
                </div>
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>住房地址</th>
                            <th>住户姓名</th>
                            <th>面积(m²)</th>
                            <% if (!standardList.isEmpty()) { %>
                                <% for (PropertyStandard s : standardList) { %>
                                <th><%= s.getFeeType() %>(元)</th>
                                <% } %>
                            <% } %>
                            <th>合计(元)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (PropertyFeeDetailService.BatchPreviewItem item : previewList) { %>
                        <tr>
                            <td><%= item.getHousingAddress() != null ? item.getHousingAddress() : "" %></td>
                            <td><%= item.getResidentName() != null ? item.getResidentName() : "" %></td>
                            <td><%= item.getArea() != null ? item.getArea().setScale(2) : "0.00" %></td>
                            <% for (PropertyFeeDetailService.BatchFeeItem feeItem : item.getFeeItems()) { %>
                            <td><%= feeItem.getAmount() != null ? "¥" + feeItem.getAmount().setScale(2) : "¥0.00" %></td>
                            <% } %>
                            <td style="color:var(--primary);font-weight:bold">
                                <%= item.getTotalAmount() != null ? "¥" + item.getTotalAmount().setScale(2) : "¥0.00" %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- 确认生成表单 -->
            <div class="card">
                <div style="padding:16px">
                    <form method="post" action="${pageContext.request.contextPath}/admin/property/batch">
                        <input type="hidden" name="action" value="save">
                        <input type="hidden" name="billMonth" value="<%= billMonth %>">
                        <div class="d-flex gap-12 align-items-center">
                            <button type="submit" class="btn btn-primary" 
                                    onclick="return confirm('确认生成 <%= billMonth %> 月的物业费账单？\n生成后将无法撤销！')">
                                确认生成账单
                            </button>
                            <span style="color:var(--text-secondary);font-size:14px">
                                将为 <%= previewList.size() %> 户住户生成账单记录
                            </span>
                        </div>
                    </form>
                </div>
            </div>
            <% } else if (!billMonth.isEmpty() && error.isEmpty()) { %>
            <div class="card" style="text-align:center;padding:40px;color:var(--text-secondary)">
                <p>没有找到住户数据，请先在住户管理中添加住户信息。</p>
            </div>
            <% } %>
</div>

<%@ include file="/pages/common/footer.jsp" %>