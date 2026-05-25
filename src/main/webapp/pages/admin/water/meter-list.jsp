<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% request.setAttribute("pageTitle", "水表管理"); %>
<% request.setAttribute("module", "water"); %>
<% request.setAttribute("activeTab", "meter"); %>

<%@ include file="/pages/common/header.jsp" %>
<%@ include file="/pages/common/admin-sidebar.jsp" %>

<div class="content-area">
    <h1 class="page-title">水费管理</h1>

    <%@ include file="/pages/common/water-tabs.jsp" %>

    <h2 class="h5 mb-3">水表管理</h2>

    <div class="card">
        <div class="d-flex justify-content-end mb-3">
            <a href="${pageContext.request.contextPath}/admin/waterMeter?action=add" class="btn btn-primary">新增水表</a>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th>水表编号</th>
                    <th>住房地址</th>
                    <th>当前读数<br>(吨)</th>
                    <th>上次读数<br>(吨)</th>
                    <th>上次抄表日期</th>
                    <th>安装日期</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.meterId}</td>
                                <td>${item.fullAddress}</td>
                                <td>${item.currentRead}</td>
                                <td>${item.lastRead != null ? item.lastRead : '-'}</td>
                                <td>${item.lastReadDate != null ? item.lastReadDate : '-'}</td>
                                <td>${item.installDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status == '正常'}">
                                            <span class="badge bg-success">正常</span>
                                        </c:when>
                                        <c:when test="${item.status == '异常'}">
                                            <span class="badge bg-danger">异常</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">停用</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/waterMeter?action=edit&id=${item.meterId}" class="btn btn-secondary btn-sm">编辑</a>
                                    <a href="${pageContext.request.contextPath}/admin/waterMeter?action=delete&id=${item.meterId}" class="btn btn-danger btn-sm" onclick="return confirm('确定删除该水表吗？')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="text-center">暂无数据，请先添加水表</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/pages/common/footer.jsp" %>
