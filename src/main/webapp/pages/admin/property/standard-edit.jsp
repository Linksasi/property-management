<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.PropertyStandard" %>
<%
    PropertyStandard entity = (PropertyStandard) request.getAttribute("entity");
    Boolean isEdit = (Boolean) request.getAttribute("isEdit");
    if (isEdit == null) isEdit = false;
    String error = (String) request.getAttribute("error");
    if (error == null) error = "";
%>

<% request.setAttribute("pageTitle", isEdit ? "编辑收费标准" : "新增收费标准"); %>
<% request.setAttribute("module", "property"); %>
<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
            <!-- 内部导航 -->
            <div class="property-nav">
                <a href="${pageContext.request.contextPath}/admin/property?action=list">物业费明细</a>
                <a href="${pageContext.request.contextPath}/admin/property/standard?action=list" class="active">收费标准</a>
                <a href="${pageContext.request.contextPath}/admin/property/batch?action=add">生成账单</a>
                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list">申诉管理</a>
                <a href="${pageContext.request.contextPath}/admin/property/report?action=list">统计报表</a>
            </div>
            
            <!-- 页面标题 -->
            <h2 class="page-title"><%= isEdit ? "编辑" : "新增" %>收费标准</h2>
            
            <!-- 错误提示 -->
            <% if (!error.isEmpty()) { %>
            <div class="card" style="border-left:4px solid var(--error);margin-bottom:16px">
                <p style="color:var(--error);margin:0"><%= error %></p>
            </div>
            <% } %>
            
            <!-- 编辑表单 -->
            <div class="card">
                <form method="post" action="${pageContext.request.contextPath}/admin/property/standard?action=save">
                    <% if (isEdit && entity != null) { %>
                    <input type="hidden" name="standardId" value="<%= entity.getStandardId() %>">
                    <% } %>
                    
                    <div class="form-group">
                        <label class="form-label">收费类型 <span class="required">*</span></label>
                        <select name="feeType" class="form-control" required>
                            <option value="">请选择</option>
                            <option value="物业费" <%= "物业费".equals(entity != null ? entity.getFeeType() : "") ? "selected" : "" %>>物业费</option>
                            <option value="绿化费" <%= "绿化费".equals(entity != null ? entity.getFeeType() : "") ? "selected" : "" %>>绿化费</option>
                            <option value="电梯费" <%= "电梯费".equals(entity != null ? entity.getFeeType() : "") ? "selected" : "" %>>电梯费</option>
                            <option value="停车费" <%= "停车费".equals(entity != null ? entity.getFeeType() : "") ? "selected" : "" %>>停车费</option>
                            <option value="垃圾清运费" <%= "垃圾清运费".equals(entity != null ? entity.getFeeType() : "") ? "selected" : "" %>>垃圾清运费</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">单价（元/m²/月）<span class="required">*</span></label>
                        <input type="number" name="unitPrice" class="form-control" step="0.01" min="0" required
                               value="<%= entity != null && entity.getUnitPrice() != null ? entity.getUnitPrice() : "" %>"
                               placeholder="例如：2.50">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">生效日期 <span class="required">*</span></label>
                        <input type="date" name="effectiveDate" class="form-control" required
                               value="<%= entity != null && entity.getEffectiveDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(entity.getEffectiveDate()) : "" %>">
                    </div>
                    
                    <% if (isEdit && entity != null) { %>
                    <div class="form-group">
                        <label class="form-label">状态</label>
                        <select name="status" class="form-control">
                            <option value="生效" <%= "生效".equals(entity.getStatus()) ? "selected" : "" %>>生效</option>
                            <option value="失效" <%= "失效".equals(entity.getStatus()) ? "selected" : "" %>>失效</option>
                        </select>
                    </div>
                    <% } %>
                    
                    <div class="d-flex gap-12">
                        <button type="submit" class="btn btn-primary">保存</button>
                        <a href="${pageContext.request.contextPath}/admin/property/standard?action=list" class="btn btn-secondary">取消</a>
                    </div>
                </form>
            </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>