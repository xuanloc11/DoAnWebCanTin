<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý người dùng</title>
    <link rel="shortcut icon" href="<c:url value='/assets/img/Hcmute-Logo-Vector.svg-.png' />" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
    <style>
        .user-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .user-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
        }
        .role-badge {
            font-size: 0.75rem;
            padding: 0.35rem 0.75rem;
            font-weight: 500;
        }
        .role-badge.admin {
            background-color: #dc3545;
            color: white;
        }
        .role-badge.truong-quay {
            background-color: #0d6efd;
            color: white;
        }
        .role-badge.hoc-sinh {
            background-color: #198754;
            color: white;
        }
        .table-user-row {
            transition: background-color 0.15s ease-in-out;
        }
        .table-user-row:hover {
            background-color: #f8f9fa !important;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.875rem;
            color: white;
        }
        .user-avatar.admin {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        }
        .user-avatar.truong-quay {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
        }
        .user-avatar.hoc-sinh {
            background: linear-gradient(135deg, #198754 0%, #146c43 100%);
        }
    </style>
</head>
<body class="bg-light">
<div class="admin-shell d-flex" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main flex-grow-1 container-fluid py-3">
        <div class="dashboard-header mb-4 d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">👥 Người dùng</span>
                    <span class="text-muted small">Admin / Quản lý người dùng</span>
                </div>
                <h1 class="dashboard-title mb-0">Quản lý người dùng</h1>
                <p class="dashboard-subtitle mb-0">Quản lý tài khoản, phân quyền và thông tin người dùng trong hệ thống.</p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm rounded-pill">🏠 Về trang chủ</a>
                <a class="btn btn-primary btn-sm rounded-pill" href="${pageContext.request.contextPath}/admin/users/add">
                    <span>＋</span> Thêm người dùng
                </a>
                <button id="adminThemeToggle" type="button" class="btn btn-outline-secondary btn-sm rounded-pill" aria-label="Đổi giao diện">🌓</button>
            </div>
        </div>

        <!-- Summary Cards -->
        <%
            int totalUsers = 0;
            int adminCount = 0;
            int truongQuayCount = 0;
            int hocSinhCount = 0;
            if (request.getAttribute("users") != null) {
                java.util.List<models.User> allUsers = (java.util.List<models.User>) request.getAttribute("users");
                totalUsers = allUsers.size();
                for (models.User u : allUsers) {
                    if ("bgh_admin".equals(u.getRole())) adminCount++;
                    else if ("truong_quay".equals(u.getRole())) truongQuayCount++;
                    else if ("hoc_sinh".equals(u.getRole())) hocSinhCount++;
                }
            }
            // Get total from page if available
            if (request.getAttribute("page") != null) {
                models.Page pageObj = (models.Page) request.getAttribute("page");
                totalUsers = (int) pageObj.getTotalElements();
            }
        %>
        <div class="row g-3 mb-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 h-100 user-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="text-muted small text-uppercase">Tổng người dùng</div>
                            <span class="badge bg-primary-subtle text-primary-emphasis">👥</span>
                        </div>
                        <h3 class="mb-0 fw-bold">
                            <c:out value="${page != null ? page.totalElements : totalUsers}"/>
                        </h3>
                        <div class="text-muted small mt-1">Tổng số tài khoản</div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 h-100 user-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="text-muted small text-uppercase">BGH Admin</div>
                            <span class="badge bg-danger-subtle text-danger-emphasis">👑</span>
                        </div>
                        <h3 class="mb-0 fw-bold text-danger">
                            <%= adminCount %>
                        </h3>
                        <div class="text-muted small mt-1">Quản trị viên</div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 h-100 user-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="text-muted small text-uppercase">Trưởng quầy</div>
                            <span class="badge bg-info-subtle text-info-emphasis">🏪</span>
                        </div>
                        <h3 class="mb-0 fw-bold text-info">
                            <%= truongQuayCount %>
                        </h3>
                        <div class="text-muted small mt-1">Quản lý quầy</div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 h-100 user-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="text-muted small text-uppercase">Sinh viên</div>
                            <span class="badge bg-success-subtle text-success-emphasis">🎓</span>
                        </div>
                        <h3 class="mb-0 fw-bold text-success">
                            <%= hocSinhCount %>
                        </h3>
                        <div class="text-muted small mt-1">Người dùng</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search and Filter -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body">
                <form method="get" class="row g-3 align-items-end">
                    <div class="col-12 col-md-4">
                        <label for="q" class="form-label mb-1 small text-muted fw-semibold">🔍 Tìm kiếm</label>
                        <input type="text" id="q" name="q" value="${fn:escapeXml(param.q)}"
                               class="form-control form-control-sm"
                               placeholder="Nhập tên, email, ID người dùng..." />
                    </div>
                    <div class="col-12 col-md-3">
                        <label for="role" class="form-label mb-1 small text-muted fw-semibold">🎭 Vai trò</label>
                        <select id="role" name="role" class="form-select form-select-sm">
                            <option value="">Tất cả vai trò</option>
                            <option value="bgh_admin" ${param.role eq 'bgh_admin' ? 'selected' : ''}>BGH Admin</option>
                            <option value="truong_quay" ${param.role eq 'truong_quay' ? 'selected' : ''}>Trưởng quầy</option>
                            <option value="hoc_sinh" ${param.role eq 'hoc_sinh' ? 'selected' : ''}>Sinh viên</option>
                        </select>
                    </div>
                    <div class="col-12 col-md-5 d-flex align-items-end gap-2">
                        <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">
                            <span>🔎</span> Tìm kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm rounded-pill">
                            <span>🔄</span> Xóa bộ lọc
                        </a>
                        <c:if test="${not empty param.q || not empty param.role}">
                            <div class="ms-auto small text-muted d-flex align-items-center">
                                <span class="badge bg-info-subtle text-info-emphasis">
                                    <c:if test="${not empty param.q}">Tìm: "<c:out value="${param.q}"/>"</c:if>
                                    <c:if test="${not empty param.role}">
                                        <c:if test="${not empty param.q}"> | </c:if>
                                        Vai trò: <c:out value="${param.role}"/>
                                    </c:if>
                                </span>
                            </div>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>

        <!-- Users Table -->
        <c:choose>
            <c:when test="${not empty users}">
                <div class="card shadow-sm border-0 mb-3">
                    <div class="card-header bg-white border-0 pb-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-semibold">📋 Danh sách người dùng</h5>
                            <c:if test="${page ne null}">
                                <span class="badge bg-primary-subtle text-primary-emphasis">
                                    Tổng: <strong>${page.totalElements}</strong> người dùng
                                </span>
                            </c:if>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th scope="col" style="width:60px;" class="text-center">Avatar</th>
                                    <th scope="col" style="width:80px;">ID</th>
                                    <th scope="col">Họ tên</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Vai trò</th>
                                    <th scope="col">Quầy hàng</th>
                                    <th scope="col">Ngày tạo</th>
                                    <th scope="col" style="width:200px" class="text-center">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr class="table-user-row">
                                        <td class="text-center">
                                            <div class="user-avatar ${u.role eq 'bgh_admin' ? 'admin' : (u.role eq 'truong_quay' ? 'truong-quay' : 'hoc-sinh')}">
                                                <c:choose>
                                                    <c:when test="${not empty u.hoTen}">
                                                        ${fn:substring(u.hoTen, 0, 1)}
                                                    </c:when>
                                                    <c:otherwise>U</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td class="fw-semibold">#${u.userId}</td>
                                        <td>
                                            <div class="d-flex flex-column">
                                                <strong><c:out value="${u.hoTen}"/></strong>
                                                <c:if test="${not empty u.donVi}">
                                                    <small class="text-muted"><c:out value="${u.donVi}"/></small>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <a href="mailto:${u.email}" class="text-decoration-none">
                                                <c:out value="${u.email}"/>
                                            </a>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.role eq 'bgh_admin'}">
                                                    <span class="badge role-badge admin">👑 Quản Trị</span>
                                                </c:when>
                                                <c:when test="${u.role eq 'truong_quay'}">
                                                    <span class="badge role-badge truong-quay">🏪 Trưởng quầy</span>
                                                </c:when>
                                                <c:when test="${u.role eq 'hoc_sinh'}">
                                                    <span class="badge role-badge hoc-sinh">🎓 Sinh viên</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary"><c:out value="${u.role}"/></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.quayHangId != null}">
                                                    <span class="badge bg-info-subtle text-info-emphasis">
                                                        Quầy #${u.quayHangId}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.createdAt != null}">
                                                    <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy" />
                                                    <br>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${u.createdAt}" pattern="HH:mm" />
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2 justify-content-center">
                                                <a class="btn btn-outline-primary btn-sm rounded-pill"
                                                   href="${pageContext.request.contextPath}/admin/users/edit?id=${u.userId}"
                                                   title="Sửa người dùng">
                                                    <span>✏️</span> Sửa
                                                </a>
                                                <form action="${pageContext.request.contextPath}/admin/users/delete"
                                                      method="post"
                                                      onsubmit="return confirm('Bạn có chắc muốn xóa người dùng #${u.userId} (${fn:escapeXml(u.hoTen)})?');"
                                                      class="d-inline">
                                                    <input type="hidden" name="user_id" value="${u.userId}" />
                                                    <button class="btn btn-outline-danger btn-sm rounded-pill" type="submit" title="Xóa người dùng">
                                                        <span>🗑️</span> Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <c:if test="${page ne null && page.totalPages > 1}">
                    <nav aria-label="Phân trang người dùng" class="d-flex justify-content-between align-items-center px-2 pb-2">
                        <div class="small text-muted">
                            Trang <strong>${page.pageNumber}</strong> / ${page.totalPages}
                            <span class="ms-2">(${page.totalElements} người dùng)</span>
                        </div>
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item ${page.first ? 'disabled' : ''}">
                                <a class="page-link rounded-pill me-1"
                                   href="${pageContext.request.contextPath}/admin/users?page=${page.pageNumber - 1}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&role=${param.role}">
                                    « Trước
                                </a>
                            </li>
                            <c:forEach var="i" begin="1" end="${page.totalPages}">
                                <li class="page-item ${i == page.pageNumber ? 'active' : ''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/admin/users?page=${i}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&role=${param.role}">
                                            ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page.last ? 'disabled' : ''}">
                                <a class="page-link rounded-pill ms-1"
                                   href="${pageContext.request.contextPath}/admin/users?page=${page.pageNumber + 1}&size=${page.pageSize}&q=${fn:escapeXml(param.q)}&role=${param.role}">
                                    Sau »
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center py-5">
                        <div class="mb-3">
                            <span style="font-size: 4rem;">👥</span>
                        </div>
                        <h5 class="text-muted">Chưa có dữ liệu người dùng</h5>
                        <p class="text-muted small mb-3">Hãy thêm người dùng mới vào hệ thống.</p>
                        <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-primary rounded-pill">
                            <span>＋</span> Thêm người dùng đầu tiên
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function(){
        const themeToggle = document.getElementById('adminThemeToggle');
        function applyTheme(theme){
            document.documentElement.setAttribute('data-bs-theme', theme);
            localStorage.setItem('adminTheme', theme);
        }
        const saved = localStorage.getItem('adminTheme') || 'light';
        applyTheme(saved);
        if (themeToggle) {
            themeToggle.addEventListener('click', function(){
                const current = document.documentElement.getAttribute('data-bs-theme') || 'light';
                applyTheme(current === 'light' ? 'dark' : 'light');
            });
        }
    })();
</script>
</body>
</html>
