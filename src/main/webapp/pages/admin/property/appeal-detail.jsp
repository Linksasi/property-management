<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.model.PropertyFeeAppeal" %>
<%@ page import="com.property.model.PropertyFeeDetail" %>
<%
    PropertyFeeAppeal appeal = (PropertyFeeAppeal) request.getAttribute("entity");
    PropertyFeeDetail detail = (PropertyFeeDetail) request.getAttribute("detail");
    if (appeal == null) {
        appeal = new PropertyFeeAppeal();
    }
    if (detail == null) {
        detail = new PropertyFeeDetail();
    }
    String error = (String) request.getAttribute("error");
    if (error == null) error = "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>申诉详情 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 顶部栏 -->
    <div class="top-bar">
        <h4>小区物业管理系统</h4>
        <div>当前用户：<%= session.getAttribute("currentUser") != null ? session.getAttribute("currentUser") : "管理员" %></div>
    </div>
    
    <!-- 主容器 -->
    <div class="main-container">
        <!-- 侧边栏 -->
        <div class="sidebar">
            <div class="sidebar-title">管理菜单</div>
            <a href="${pageContext.request.contextPath}/admin/staff?action=list" class="sidebar-item">工作人员管理</a>
            <a href="${pageContext.request.contextPath}/admin/resident?action=list" class="sidebar-item">住户管理</a>
            <a href="${pageContext.request.contextPath}/admin/property?action=list" class="sidebar-item active">物业费管理</a>
            <a href="${pageContext.request.contextPath}/admin/water?action=list" class="sidebar-item">水费管理</a>
            <a href="${pageContext.request.contextPath}/admin/parking?action=list" class="sidebar-item">车位费管理</a>
            <a href="${pageContext.request.contextPath}/admin/repair?action=list" class="sidebar-item">维修管理</a>
            <a href="${pageContext.request.contextPath}/admin/ad?action=list" class="sidebar-item">广告管理</a>
            <div class="sidebar-divider"></div>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-item">退出登录</a>
        </div>
        
        <!-- 内容区 -->
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
            <h2 class="page-title">申诉详情</h2>
            
            <!-- 返回按钮 -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list" class="btn btn-secondary">
                    &larr; 返回列表
                </a>
            </div>
            
            <% if (!error.isEmpty()) { %>
            <div class="card" style="border-left:4px solid var(--error);margin-bottom:16px">
                <p style="color:var(--error);margin:0;padding:12px"><%= error %></p>
            </div>
            <% } %>
            
            <!-- 申诉信息 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">申诉信息</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">申诉ID</label>
                            <p style="margin:0"><%= appeal.getAppealId() != null ? appeal.getAppealId() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">申诉时间</label>
                            <p style="margin:0"><%= appeal.getCreateTime() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(appeal.getCreateTime()) : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">状态</label>
                            <p style="margin:0">
                                <% 
                                    String statusClass = "";
                                    if ("待审核".equals(appeal.getStatus())) statusClass = "status-warning";
                                    else if ("通过".equals(appeal.getStatus())) statusClass = "status-success";
                                    else if ("驳回".equals(appeal.getStatus())) statusClass = "status-error";
                                %>
                                <span class="status-tag <%= statusClass %>"><%= appeal.getStatus() != null ? appeal.getStatus() : "" %></span>
                            </p>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">申诉原因</label>
                        <div style="background:#f5f5f5;padding:12px;border-radius:var(--radius);margin-top:4px">
                            <%= appeal.getReason() != null ? appeal.getReason() : "" %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 账单信息 -->
            <div class="card mb-3">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">关联账单信息</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">账单ID</label>
                            <p style="margin:0"><%= appeal.getDetailId() != null ? appeal.getDetailId() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">住户姓名</label>
                            <p style="margin:0"><%= appeal.getResidentName() != null ? appeal.getResidentName() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">住房地址</label>
                            <p style="margin:0"><%= appeal.getHousingAddress() != null ? appeal.getHousingAddress() : "" %></p>
                        </div>
                    </div>
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">计费月份</label>
                            <p style="margin:0"><%= appeal.getBillMonth() != null ? appeal.getBillMonth() : "" %></p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">应缴金额</label>
                            <p style="margin:0;color:var(--primary);font-weight:bold">
                                <%= detail.getAmount() != null ? "¥" + detail.getAmount().setScale(2) : "¥0.00" %>
                            </p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">收费面积</label>
                            <p style="margin:0"><%= detail.getArea() != null ? detail.getArea().setScale(2) + " m²" : "0.00 m²" %></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 审核表单 -->
            <% if ("待审核".equals(appeal.getStatus())) { %>
            <div class="card">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0;background:#fff3e0">审核操作</h5>
                <div style="padding:16px">
                    <form method="post" action="${pageContext.request.contextPath}/admin/property/appeal">
                        <input type="hidden" name="action" value="review">
                        <input type="hidden" name="appealId" value="<%= appeal.getAppealId() %>">
                        
                        <div class="form-group">
                            <label class="form-label">审核结果 <span class="required">*</span></label>
                            <select name="status" class="form-control" required id="reviewStatus">
                                <option value="">请选择</option>
                                <option value="通过">通过（调整费用金额）</option>
                                <option value="驳回">驳回（保持原状态）</option>
                            </select>
                        </div>
                        
                        <div class="form-group" id="amountGroup" style="display:none">
                            <label class="form-label">调整后金额</label>
                            <input type="number" name="adjustedAmount" id="adjustedAmount" class="form-control" 
                                   step="0.01" min="0" placeholder="请输入调整后的缴费金额">
                            <small style="color:var(--text-secondary)">
                                原金额：¥<%= detail.getAmount() != null ? detail.getAmount().setScale(2) : "0.00" %>
                            </small>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">审核意见</label>
                            <textarea name="adminReason" class="form-control" rows="3"
                                      placeholder="请输入审核意见（选填）"></textarea>
                            <small style="color:var(--text-secondary)">
                                • 通过：调整费用后状态改为"未缴"，住户需重新缴费<br>
                                • 驳回：申诉失败，账单恢复为"未缴"
                            </small>
                        </div>
                        
                        <div class="d-flex gap-12">
                            <button type="submit" class="btn btn-primary">提交审核</button>
                            <a href="${pageContext.request.contextPath}/admin/property/appeal?action=list" class="btn btn-secondary">取消</a>
                        </div>
                    </form>
                </div>
            </div>
            
            <script>
            document.getElementById('reviewStatus').addEventListener('change', function() {
                var amountGroup = document.getElementById('amountGroup');
                var adjustedAmount = document.getElementById('adjustedAmount');
                if (this.value === '通过') {
                    amountGroup.style.display = 'block';
                    adjustedAmount.required = true;
                } else {
                    amountGroup.style.display = 'none';
                    adjustedAmount.required = false;
                    adjustedAmount.value = '';
                }
            });
            </script>
            <% } else { %>
            
            <!-- 已审核结果 -->
            <div class="card">
                <h5 style="padding:12px 16px;border-bottom:1px solid var(--border);margin:0">审核结果</h5>
                <div style="padding:16px">
                    <div class="d-flex gap-12">
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">审核结果</label>
                            <p style="margin:0">
                                <span class="status-tag <%= statusClass %>"><%= appeal.getStatus() != null ? appeal.getStatus() : "" %></span>
                            </p>
                        </div>
                        <div class="form-group" style="flex:1;margin-bottom:12px">
                            <label class="form-label">处理时间</label>
                            <p style="margin:0"><%= appeal.getHandleTime() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(appeal.getHandleTime()) : "" %></p>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label">审核意见</label>
                        <div style="background:#f5f5f5;padding:12px;border-radius:var(--radius);margin-top:4px">
                            <%= appeal.getAdminReason() != null && !appeal.getAdminReason().isEmpty() ? appeal.getAdminReason() : "无" %>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>

<style>
.property-nav {
    display: flex;
    gap: 4px;
    margin-bottom: 16px;
    border-bottom: 1px solid var(--border);
    padding-bottom: 12px;
}
.property-nav a {
    padding: 8px 16px;
    color: var(--text-secondary);
    text-decoration: none;
    border-radius: var(--radius-btn);
    font-size: 14px;
    transition: all 0.2s;
}
.property-nav a:hover {
    background-color: var(--bg-page);
    color: var(--primary);
}
.property-nav a.active {
    background-color: var(--primary);
    color: white;
}
</style>