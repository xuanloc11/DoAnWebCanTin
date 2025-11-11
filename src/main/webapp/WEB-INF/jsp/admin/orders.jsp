<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
</head>
<body>
<div class="admin-shell" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main">
        <div class="admin-topbar">
            <div class="crumbs">Admin / Đơn hàng</div>
            <div class="admin-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-ghost btn-icon">↩ Về trang chủ</a>
                <!-- Removed: Add new order button since only students create orders -->
            </div>
        </div>
        <div class="admin-content">
            <div class="admin-head">
                <h1 class="admin-title">Quản lý đơn hàng</h1>
            </div>
            <c:choose>
                <c:when test="${not empty orders}">
                    <div class="table-wrap">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="col-id">ID</th>
                                    <th>User ID</th>
                                    <th>Quầy hàng ID</th>
                                    <th>Tổng tiền</th>
                                    <th>Thời gian đặt</th>
                                    <th>Trạng thái</th>
                                    <th>Ghi chú</th>
                                    <th style="width:260px">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td class="col-id">${o.orderId}</td>
                                        <td>${o.userId}</td>
                                        <td>${o.quayHangId}</td>
                                        <td><fmt:formatNumber value="${o.tongTien}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ</td>
                                        <td><fmt:formatDate value="${o.thoiGianDat}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o.trangThaiOrder eq 'MOI_DAT'}">Mới đặt</c:when>
                                                <c:when test="${o.trangThaiOrder eq 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
                                                <c:when test="${o.trangThaiOrder eq 'DANG_GIAO'}">Đang giao</c:when>
                                                <c:when test="${o.trangThaiOrder eq 'DA_GIAO'}">Đã giao</c:when>
                                                <c:otherwise><c:out value="${o.trangThaiOrder}"/></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:out value="${o.ghiChu}"/></td>
                                        <td>
                                            <div class="table-actions" style="display:flex; gap:6px; align-items:center; flex-wrap:wrap;">
                                                <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.orderId}">Xem</a>
                                                <!-- Update status form -->
                                                <form action="${pageContext.request.contextPath}/admin/orders/status" method="post" style="display:flex; gap:6px; align-items:center;">
                                                    <input type="hidden" name="order_id" value="${o.orderId}" />
                                                    <select name="status" class="btn btn-ghost" style="min-width:160px">
                                                        <option value="MOI_DAT" ${o.trangThaiOrder eq 'MOI_DAT' ? 'selected' : ''}>Mới đặt</option>
                                                        <option value="DA_XAC_NHAN" ${o.trangThaiOrder eq 'DA_XAC_NHAN' ? 'selected' : ''}>Đã xác nhận</option>
                                                        <option value="DANG_GIAO" ${o.trangThaiOrder eq 'DANG_GIAO' ? 'selected' : ''}>Đang giao</option>
                                                        <option value="DA_GIAO" ${o.trangThaiOrder eq 'DA_GIAO' ? 'selected' : ''}>Đã giao</option>
                                                    </select>
                                                    <button class="btn btn-small" type="submit">Cập nhật</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="muted">Chưa có dữ liệu đơn hàng.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
