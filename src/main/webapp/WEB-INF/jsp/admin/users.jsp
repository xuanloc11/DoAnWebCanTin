<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
                                                <c:when test="${u.role eq 'bgh_admin'}">BGH Admin</c:when>
                                                <c:when test="${u.role eq 'truong_quay'}">Trưởng quầy</c:when>
                                                <c:when test="${u.role eq 'nhan_vien_quay'}">Nhân viên quầy</c:when>
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
