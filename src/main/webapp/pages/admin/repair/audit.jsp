<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.property.entity.RepairRequest, com.property.entity.Staff, java.util.List" %>
<%
    RepairRequest detail = (RepairRequest) request.getAttribute("detail");
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    if (detail == null) { response.sendRedirect(request.getContextPath() + "/admin/repair?action=list"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>审核维修申请</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 120px; font-weight: bold; }
        .btn { padding: 8px 20px; text-decoration: none; border-radius: 4px; color: white; border: none; cursor: pointer; font-size: 14px; }
        .btn-primary { background-color: #007bff; }
        .btn-danger { background-color: #dc3545; }
        .btn-secondary { background-color: #6c757d; }
        textarea { width: 100%; max-width: 400px; height: 80px; padding: 6px; border: 1px solid #ccc; border-radius: 4px; }
        select { padding: 6px; border: 1px solid #ccc; border-radius: 4px; min-width: 200px; }
        .info-box { margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .info-box p { margin: 6px 0; }
        .badge { padding: 2px 8px; border-radius: 3px; color: white; font-size: 12px; }
        .badge-warning { background-color: #ffc107; color: #000; }
    </style>
</head>
<body>
    <% request.setAttribute("module", "repair"); %>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>审核维修申请</h2>

            <div class="info-box">
                <h4>申请信息</h4>
                <p><strong>申请ID：</strong><%=detail.getRequestId()%></p>
                <p><strong>住户姓名：</strong><%=detail.getResidentName() != null ? detail.getResidentName() : "未知"%></p>
                <p><strong>房屋地址：</strong><%=detail.getHousingAddress() != null ? detail.getHousingAddress() : "未知"%></p>
                <p><strong>维修类型：</strong><%=detail.getRepairType()%></p>
                <p><strong>紧急程度：</strong><span class="badge badge-warning"><%=detail.getUrgency()%></span></p>
                <p><strong>问题描述：</strong><%=detail.getDescription()%></p>
                <p><strong>申请时间：</strong><%=detail.getApplyTime() != null ? detail.getApplyTime().substring(0,16) : ""%></p>
            </div>

            <form action="${pageContext.request.contextPath}/admin/repair?action=doAudit" method="post" onsubmit="return checkApprove()">
                <input type="hidden" name="requestId" value="<%=detail.getRequestId()%>">
                <input type="hidden" name="approved" value="1">
                <div class="form-group">
                    <label>选择维修人员：</label>
                    <select name="staffId" id="staffSelect">
                        <option value="">请选择</option>
                        <% if (staffList != null && !staffList.isEmpty()) {
                            for (Staff s : staffList) { %>
                                <option value="<%=s.getStaffId()%>"><%=s.getName()%> - <%=s.getWorktypeName() != null ? s.getWorktypeName() : "维修员"%></option>
                        <%  }
                        } else { %>
                            <option value="" disabled>暂无可用维修人员</option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">通过并派工</button>
                    <button type="button" class="btn btn-danger" onclick="showRejectForm()">审核不通过</button>
                    <a href="${pageContext.request.contextPath}/admin/repair?action=list" class="btn btn-secondary">返回</a>
                </div>
            </form>

            <div id="rejectForm" style="display: none; margin-top: 20px; padding: 15px; border: 1px solid #dc3545; border-radius: 4px;">
                <h4>审核不通过</h4>
                <form action="${pageContext.request.contextPath}/admin/repair?action=doAudit" method="post">
                    <input type="hidden" name="requestId" value="<%=detail.getRequestId()%>">
                    <input type="hidden" name="approved" value="0">
                    <div class="form-group">
                        <label>驳回原因：</label>
                        <textarea name="reason" placeholder="请填写驳回原因"></textarea>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-danger">确认驳回</button>
                        <button type="button" class="btn btn-secondary" onclick="hideRejectForm()">取消</button>
                    </div>
                </form>
            </div>

            <script>
                function checkApprove() {
                    var sel = document.getElementById('staffSelect');
                    if (!sel.value) {
                        alert('请选择维修人员');
                        return false;
                    }
                    return true;
                }
                function showRejectForm() {
                    document.getElementById('rejectForm').style.display = 'block';
                }
                function hideRejectForm() {
                    document.getElementById('rejectForm').style.display = 'none';
                }
            </script>
            <jsp:include page="/pages/common/footer.jsp" />
        </div>
    </div>
</div>
</body>
</html>