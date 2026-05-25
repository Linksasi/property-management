<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    PropertyFeeDetail detail = (PropertyFeeDetail) request.getAttribute("detail");
    if (detail == null) {
        detail = new PropertyFeeDetail();
    }
    String error = (String) request.getAttribute("error");
    if (error == null) error = "";
%>

<% request.setAttribute("pageTitle", "费用申诉"); %>
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
            <h2 class="page-title">费用申诉</h2>
            
            <!-- 返回按钮 -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/owner/property?action=list" class="btn btn-secondary">
                    &larr; 返回列表
                </a>
            </div>
            
            <% if (!error.isEmpty()) { %>
            <div class="card" style="border-left:4px solid var(--error);margin-bottom:16px">
                <p style="color:var(--error);margin:0;padding:12px"><%= error %></p>
            </div>
            <% } %>
            
            <!-- 账单信息 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">关联账单</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">账单ID</label>
                            <p style="margin:0"><%= detail.getDetailId() != null ? detail.getDetailId() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">计费月份</label>
                            <p style="margin:0"><%= detail.getBillMonth() != null ? detail.getBillMonth() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">收费类型</label>
                            <p style="margin:0"><%= detail.getStandardType() != null ? detail.getStandardType() : "物业费" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:0">
                            <label class="form-label">应缴金额</label>
                            <p style="margin:0;color:var(--primary);font-weight:bold">
                                ¥<%= detail.getAmount() != null ? detail.getAmount().setScale(2) : "0.00" %>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 申诉表单 -->
            <div class="card">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">填写申诉信息</h5>
                <div style="padding:16px">
                    <form method="post" action="${pageContext.request.contextPath}/owner/property/appeal">
                        <input type="hidden" name="action" value="save">
                        <input type="hidden" name="detailId" value="<%= detail.getDetailId() %>">
                        
                        <div class="form-group">
                            <label class="form-label">申诉原因 <span class="required">*</span></label>
                            <textarea name="reason" class="form-control" rows="5" required
                                      placeholder="请详细描述您的申诉原因，例如：&#10;- 面积计算错误，实际面积为XX平方米&#10;- 对收费标准有异议&#10;- 其他原因说明"></textarea>
                            <small style="color:var(--text-secondary)">请详细描述问题，以便物业管理部门核实处理</small>
                        </div>
                        
                        <div class="d-flex gap-12">
                            <button type="submit" class="btn btn-primary">提交申诉</button>
                            <a href="${pageContext.request.contextPath}/owner/property?action=list" class="btn btn-secondary">取消</a>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- 提示 -->
            <div class="card" style="background:#fff3e0;border-left:4px solid #ff9800;margin-top:16px">
                <div style="padding:12px">
                    <strong>申诉说明：</strong>
                    <ul style="margin-bottom:0;padding-left:20px;margin-top:8px">
                        <li>提交申诉后，账单状态将变为"申诉中"</li>
                        <li>管理员将在1-3个工作日内处理您的申诉</li>
                        <li>申诉结果可在"申诉记录"中查看</li>
                        <li>已缴费账单不支持申诉</li>
                    </ul>
                </div>
            </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>