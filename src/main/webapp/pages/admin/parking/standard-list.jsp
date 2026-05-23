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
    <title>设定月费标准</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .content-area { flex: 1; padding: 20px; }
        .form-box { max-width: 500px; margin: 0 auto; padding: 25px; border: 1px solid #ddd; border-radius: 8px; background-color: #f9f9f9; }
        .form-group { margin-bottom: 18px; display: flex; align-items: center; }
        .form-group label { width: 140px; font-weight: bold; }
        .form-group input { padding: 8px 12px; width: 200px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        .form-group .unit { margin-left: 8px; color: #666; }
        .btn { padding: 10px 30px; text-decoration: none; border-radius: 4px; color: white; border: none; cursor: pointer; font-size: 14px; }
        .btn-primary { background-color: #007bff; }
        .btn-secondary { background-color: #6c757d; }
        .msg { padding: 10px 15px; border-radius: 4px; margin-bottom: 15px; }
        .msg-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    </style>
</head>
<body>
<%
    request.setAttribute("module", "admin_parking");
%>
<jsp:include page="/pages/common/header.jsp" />
<div class="main-container">
    <jsp:include page="/pages/common/admin-sidebar.jsp" />
    <div class="content-area">
        <h2>设定月费标准</h2>
        <% if (msg != null) { %>
            <div class="msg msg-success"><%=msg%></div>
        <% } %>
        <div class="form-box">
            <form action="${pageContext.request.contextPath}/admin/parking?action=saveStandardPrices" method="post">
                <div class="form-group">
                    <label>地下一层A区：</label>
                    <input type="number" name="price_A" value="<%=String.format("%.0f", priceMap.get("地下一层A区"))%>" min="0" step="1" required>
                    <span class="unit">元/月</span>
                </div>
                <div class="form-group">
                    <label>地下一层B区：</label>
                    <input type="number" name="price_B" value="<%=String.format("%.0f", priceMap.get("地下一层B区"))%>" min="0" step="1" required>
                    <span class="unit">元/月</span>
                </div>
                <div class="form-group">
                    <label>地下一层C区：</label>
                    <input type="number" name="price_C" value="<%=String.format("%.0f", priceMap.get("地下一层C区"))%>" min="0" step="1" required>
                    <span class="unit">元/月</span>
                </div>
                <div class="form-group">
                    <label>户外停车场：</label>
                    <input type="number" name="price_outdoor" value="<%=String.format("%.0f", priceMap.get("户外停车场"))%>" min="0" step="1" required>
                    <span class="unit">元/月</span>
                </div>
                <div style="margin-top:25px; text-align:center;">
                    <input type="submit" class="btn btn-primary" value="保存并生效">
                    <a href="${pageContext.request.contextPath}/admin/parking?action=list" class="btn btn-secondary" style="margin-left:10px;">返回车位列表</a>
                </div>
            </form>
        </div>
    </div>
</div>
<jsp:include page="/pages/common/footer.jsp" />
</body>
</html>