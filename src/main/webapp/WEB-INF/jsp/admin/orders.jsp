<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý đơn hàng</title>
    <link rel="shortcut icon" href="<c:url value='/assets/img/Hcmute-Logo-Vector.svg-.png' />" />

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
</head>
<body class="bg-light">
<div class="admin-shell d-flex" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main flex-grow-1 container-fluid py-3">
        <div class="dashboard-header mb-3 d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div class="d-flex flex-column gap-1">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">Bảng điều khiển</span>
                    <span class="text-muted small">Admin / Đơn hàng</span>
                </div>
                <h1 class="dashboard-title mb-0">Quản lý đơn hàng</h1>
                <p class="dashboard-subtitle mb-0">Theo dõi và cập nhật trạng thái các đơn đặt món.</p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm rounded-pill">↩ Về trang chủ</a>
            </div>
        </div>

        <div class="admin-content">
            <!-- Search / filter bar for orders -->
            <form method="get" class="row g-2 align-items-end mb-3">
                <div class="col-sm-4 col-md-3">
                    <label for="q" class="form-label mb-1 small text-muted">Tìm kiếm đơn hàng</label>
                    <input type="text" id="q" name="q" value="${fn:escapeXml(param.q)}" class="form-control form-control-sm" placeholder="ID đơn hàng, ghi chú..." />
                </div>
                <div class="col-sm-3 col-md-2">
                    <label for="status" class="form-label mb-1 small text-muted">Trạng thái</label>
                    <select id="status" name="status" class="form-select form-select-sm">
                        <option value="">Tất cả trạng thái</option>
                        <option value="MOI_DAT" ${param.status eq 'MOI_DAT' ? 'selected' : ''}>Mới đặt</option>
                        <option value="DA_XAC_NHAN" ${param.status eq 'DA_XAC_NHAN' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="DANG_GIAO" ${param.status eq 'DANG_GIAO' ? 'selected' : ''}>Đang giao</option>
                        <option value="DA_GIAO" ${param.status eq 'DA_GIAO' ? 'selected' : ''}>Đã giao</option>
                        <option value="DA_HUY" ${param.status eq 'DA_HUY' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </div>
                <div class="col-sm-3 col-md-2">
                    <label for="from" class="form-label mb-1 small text-muted">Từ ngày</label>
                    <input type="date" id="from" name="from" value="${param.from}" class="form-control form-control-sm" />
                </div>
                <div class="col-sm-3 col-md-2">
                    <label for="to" class="form-label mb-1 small text-muted">Đến ngày</label>
                    <input type="date" id="to" name="to" value="${param.to}" class="form-control form-control-sm" />
                </div>
                <div class="col-sm-4 col-md-3 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-light btn-sm rounded-pill px-3">Lọc</button>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary btn-sm rounded-pill">Xóa bộ lọc</a>
                </div>
                <div class="col-12 small text-muted mt-1">
                    <c:if test="${not empty param.q || not empty param.status || not empty param.from || not empty param.to}">
                        <span>Filter: </span>
                        <c:if test="${not empty param.q}">tìm kiếm "<strong><c:out value="${param.q}"/></strong>"</c:if>
                        <c:if test="${not empty param.status}">, trạng thái = <strong><c:out value="${param.status}"/></strong></c:if>
                        <c:if test="${not empty param.from}">, từ ngày <strong><c:out value="${param.from}"/></strong></c:if>
                        <c:if test="${not empty param.to}">, đến ngày <strong><c:out value="${param.to}"/></strong></c:if>
                    </c:if>
                    <c:if test="${page ne null}">
                        <span class="ms-2">Tổng đơn: <strong>${page.totalElements}</strong></span>
                    </c:if>
                </div>
            </form>

            <c:choose>
                <c:when test="${not empty orders}">
                    <div class="table-wrap-soft bg-white mb-3 border rounded-3">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th scope="col">ID đơn hàng</th>
                                    <th scope="col">Tổng tiền</th>
                                    <th scope="col">Thời gian đặt</th>
                                    <th scope="col">Trạng thái</th>
                                    <th scope="col">Ghi chú</th>
                                    <th scope="col" style="width:260px">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td class="fw-semibold">${o.orderId}</td>
                                        <td><fmt:formatNumber value="${o.tongTien}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ</td>
                                        <td><fmt:formatDate value="${o.thoiGianDat}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o.trangThaiOrder eq 'MOI_DAT'}">Mới đặt</c:when>
                                                <c:when test="${o.trangThaiOrder eq 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
                                                <c:when test="${o.trangThaiOrder eq 'DANG_GIAO'}">Đang giao</c:when>
                                                <c:when test="${o.trangThaiOrder eq 'DA_GIAO'}">Đã giao</c:when>
                                                <c:when test="${o.trangThaiOrder eq 'DA_HUY' || o.trangThaiOrder eq 'CANCELLED'}">Đã hủy</c:when>
                                                <c:otherwise><c:out value="${o.trangThaiOrder}"/></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:out value="${o.ghiChu}"/></td>
                                        <td>
                                            <div class="d-flex flex-wrap gap-2 align-items-center">
                                                <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.orderId}">Xem</a>
                                                <form action="${pageContext.request.contextPath}/admin/orders/status" method="post" class="d-flex flex-wrap gap-2 align-items-center">
                                                    <input type="hidden" name="order_id" value="${o.orderId}" />
                                                    <select name="status" class="form-select form-select-sm" style="min-width:160px">
                                                        <option value="MOI_DAT" ${o.trangThaiOrder eq 'MOI_DAT' ? 'selected' : ''}>Mới đặt</option>
                                                        <option value="DA_XAC_NHAN" ${o.trangThaiOrder eq 'DA_XAC_NHAN' ? 'selected' : ''}>Đã xác nhận</option>
                                                        <option value="DANG_GIAO" ${o.trangThaiOrder eq 'DANG_GIAO' ? 'selected' : ''}>Đang giao</option>
                                                        <option value="DA_GIAO" ${o.trangThaiOrder eq 'DA_GIAO' ? 'selected' : ''}>Đã giao</option>
                                                        <option value="DA_HUY" ${o.trangThaiOrder eq 'DA_HUY' || o.trangThaiOrder eq 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                                    </select>
                                                    <button class="btn btn-outline-primary btn-sm" type="submit">Cập nhật</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <c:if test="${page ne null && page.totalPages > 1}">
                        <nav aria-label="Phân trang đơn hàng" class="d-flex justify-content-between align-items-center px-2 pb-2">
                            <div class="small text-muted">
                                Trang <strong>${page.pageNumber}</strong> / ${page.totalPages}
                            </div>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${page.first ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/orders?page=${page.pageNumber - 1}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&status=${param.status}&from=${param.from}&to=${param.to}">«</a>
                                </li>
                                <c:forEach var="i" begin="1" end="${page.totalPages}">
                                    <li class="page-item ${i == page.pageNumber ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/orders?page=${i}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&status=${param.status}&from=${param.from}&to=${param.to}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${page.last ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/orders?page=${page.pageNumber + 1}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&status=${param.status}&from=${param.from}&to=${param.to}">»</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info shadow-sm">Chưa có dữ liệu đơn hàng.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
