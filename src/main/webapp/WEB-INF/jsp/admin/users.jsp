<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý người dùng</title>
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
                    <span class="text-muted small">Admin / Người dùng</span>
                </div>
                <h1 class="dashboard-title mb-0">Quản lý người dùng</h1>
                <p class="dashboard-subtitle mb-0">Quản lý tài khoản và phân quyền người dùng trong hệ thống.</p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm rounded-pill">↩ Về trang chủ</a>
                <a class="btn btn-primary btn-sm rounded-pill" href="${pageContext.request.contextPath}/admin/users/add">＋ Thêm người dùng</a>
            </div>
        </div>

        <div class="admin-content">
            <!-- Search bar for users -->
            <form method="get" class="row g-2 align-items-center mb-3">
                <div class="col-sm-4 col-md-3">
                    <label for="q" class="form-label mb-1 small text-muted">Tìm kiếm</label>
                    <input type="text" id="q" name="q" value="${fn:escapeXml(param.q)}" class="form-control form-control-sm" placeholder="Nhập tên, email, ID..." />
                </div>
                <div class="col-sm-3 col-md-2">
                    <label for="role" class="form-label mb-1 small text-muted">Vai trò</label>
                    <select id="role" name="role" class="form-select form-select-sm">
                        <option value="">Tất cả</option>
                        <option value="bgh_admin" ${param.role eq 'bgh_admin' ? 'selected' : ''}>Quản Trị</option>
                        <option value="truong_quay" ${param.role eq 'truong_quay' ? 'selected' : ''}>Trưởng quầy</option>
                        <option value="hoc_sinh" ${param.role eq 'hoc_sinh' ? 'selected' : ''}>Sinh viên</option>
                    </select>
                </div>
                <div class="col-sm-3 col-md-2 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill">Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm rounded-pill">Xóa</a>
                </div>
                <div class="col-12 col-md-auto ms-md-auto text-md-end small text-muted">
                    <c:if test="${not empty param.q || not empty param.role}">
                        <span>Bộ lọc: </span>
                        <c:if test="${not empty param.q}">tên/email chứa "<strong><c:out value="${param.q}"/></strong>"</c:if>
                        <c:if test="${not empty param.role}">, vai trò = <strong><c:out value="${param.role}"/></strong></c:if>
                    </c:if>
                    <c:if test="${page ne null}">
                        <span class="ms-2">Tổng số: <strong>${page.totalElements}</strong></span>
                    </c:if>
                </div>
            </form>

            <c:choose>
                <c:when test="${not empty users}">
                    <div class="table-wrap-soft bg-white mb-3 border rounded-3">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th scope="col" style="width:80px;">ID</th>
                                    <th scope="col">Họ tên</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Vai trò</th>
                                    <th scope="col" style="width:180px">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td class="fw-semibold">${u.userId}</td>
                                        <td><c:out value="${u.hoTen}"/></td>
                                        <td><c:out value="${u.email}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.role eq 'bgh_admin'}">Quản Trị</c:when>
                                                <c:when test="${u.role eq 'truong_quay'}">Trưởng quầy</c:when>
                                                <c:when test="${u.role eq 'hoc_sinh'}">Sinh viên</c:when>
                                                <c:otherwise><c:out value="${u.role}"/></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/users/edit?id=${u.userId}">✏️ Sửa</a>
                                                <form action="${pageContext.request.contextPath}/admin/users/delete" method="post" onsubmit="return confirm('Xóa người dùng #${u.userId}?');" class="d-inline">
                                                    <input type="hidden" name="user_id" value="${u.userId}" />
                                                    <button class="btn btn-outline-danger" type="submit">🗑️ Xóa</button>
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
                        <nav aria-label="Phân trang người dùng" class="d-flex justify-content-between align-items-center px-2 pb-2">
                            <div class="small text-muted">
                                Trang <strong>${page.pageNumber}</strong> / ${page.totalPages}
                            </div>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${page.first ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${page.pageNumber - 1}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&role=${param.role}">«</a>
                                </li>
                                <c:forEach var="i" begin="1" end="${page.totalPages}">
                                    <li class="page-item ${i == page.pageNumber ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&role=${param.role}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${page.last ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${page.pageNumber + 1}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&role=${param.role}">»</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info shadow-sm">Chưa có dữ liệu người dùng.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
