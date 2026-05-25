<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.property.entity.ParkingStandard" %>
<%
    List<ParkingStandard> standards = (List<ParkingStandard>) request.getAttribute("standards");
    String msg = (String) request.getAttribute("msg");
    Map<String, Double> priceMap = new HashMap<>();
    priceMap.put("地下一层A区", 0.0);
    priceMap.put("地下一层B区", 0.0);
    priceMap.put("地下一层C区", 0.0);
    priceMap.put("户外停车场", 0.0);
    if (standards != null) {
        for (ParkingStandard ps : standards) {
            priceMap.put(ps.getParkingType(), ps.getPrice());
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设定月费标准 - 小区物业管理系统</title>
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("module", "parking"); %>
    <jsp:include page="/pages/common/header.jsp" />
    <div class="main-container">
        <jsp:include page="/pages/common/admin-sidebar.jsp" />
        <div class="content-area">
            <h2 class="page-title">设定月费标准</h2>

            <% if (msg != null) { %>
            <div class="status-tag status-success mb-3"><%= msg %></div>
            <% } %>

            <div class="card" style="max-width:500px;">
                <form action="${pageContext.request.contextPath}/admin/parking?action=saveStandardPrices" method="post">
                    <div class="form-group">
                        <label class="form-label">地下一层A区</label>
                        <div class="d-flex gap-12 align-items-center">
                            <input type="number" name="price_A" class="form-control" style="max-width:200px;" value="<%= String.format("%.0f", priceMap.get("地下一层A区")) %>" min="0" step="1" required>
                            <span>元/月</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">地下一层B区</label>
                        <div class="d-flex gap-12 align-items-center">
                            <input type="number" name="price_B" class="form-control" style="max-width:200px;" value="<%= String.format("%.0f", priceMap.get("地下一层B区")) %>" min="0" step="1" required>
                            <span>元/月</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">地下一层C区</label>
                        <div class="d-flex gap-12 align-items-center">
                            <input type="number" name="price_C" class="form-control" style="max-width:200px;" value="<%= String.format("%.0f", priceMap.get("地下一层C区")) %>" min="0" step="1" required>
                            <span>元/月</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">户外停车场</label>
                        <div class="d-flex gap-12 align-items-center">
                            <input type="number" name="price_outdoor" class="form-control" style="max-width:200px;" value="<%= String.format("%.0f", priceMap.get("户外停车场")) %>" min="0" step="1" required>
                            <span>元/月</span>
                        </div>
                    </div>
                    <div class="d-flex gap-12">
                        <button type="submit" class="btn btn-primary">保存并生效</button>
                        <a href="${pageContext.request.contextPath}/admin/parking?action=list" class="btn btn-secondary">返回车位列表</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>