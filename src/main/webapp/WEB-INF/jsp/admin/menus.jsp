<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý Menu</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
    <style>
      body.admin-page, .admin-shell { background-color: #f5f7fb; }
      .admin-main { min-height: 100vh; }
      .dashboard-header { backdrop-filter: blur(10px); background: linear-gradient(135deg,#ffffff 0%,#f6f8ff 100%); border-radius: 16px; box-shadow: 0 18px 45px rgba(15,23,42,0.08); padding: 18px 20px; }
      .dashboard-title { font-size: 1.4rem; font-weight: 700; }
      .dashboard-subtitle { font-size: .9rem; color:#6b7280; }
      .table-wrap-soft { border-radius: 14px; overflow: hidden; border:1px solid rgba(148,163,184,.35); background:#fff; }
      .item-chip{ display:inline-block; background:#f6f7f8; border:1px solid rgba(148,163,184,.4); padding:2px 6px; border-radius:999px; margin:1px 4px 1px 0; font-size:12px; }
      .muted{ color:#6b7280; }
      .col-id{ width:70px; }
    </style>
</head>
<body class="admin-page bg-light">
<div class="admin-shell d-flex" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main flex-grow-1 container-fluid py-3">
        <div class="dashboard-header mb-3 d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div class="d-flex flex-column gap-1">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">Bảng điều khiển</span>
                    <span class="text-muted small">Admin / Menu</span>
                </div>
                <h1 class="dashboard-title mb-0">Quản lý Menu</h1>
                <p class="dashboard-subtitle mb-0">Quản lý các thực đơn theo ngày và món ăn đi kèm.</p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm rounded-pill">
                    ↩ Về trang chủ
                </a>
                <a class="btn btn-primary btn-sm rounded-pill" href="${pageContext.request.contextPath}/admin/menu/add">
                    ＋ Thêm menu
                </a>
            </div>
        </div>

        <div class="admin-content">
            <c:choose>
                <c:when test="${not empty menus}">
                    <div class="table-wrap-soft mb-3">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped table-bordered align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th class="col-id" scope="col">ID</th>
                                    <th scope="col">Ngày áp dụng</th>
                                    <th scope="col">Tên thực đơn</th>
                                    <th scope="col">Món</th>
                                    <th scope="col" style="width:220px">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="m" items="${menus}">
                                    <c:set var="items" value="${menuItemsMap[m.menuId]}"/>
                                    <tr>
                                        <td class="fw-semibold">${m.menuId}</td>
                                        <td><fmt:formatDate value="${m.ngayApDung}" pattern="dd/MM/yyyy"/></td>
                                        <td><c:out value="${m.tenThucDon}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty items}">
                                                    <c:forEach var="it" items="${items}" varStatus="st">
                                                        <c:if test="${st.index < 3}">
                                                            <span class="item-chip"><c:out value="${it.tenMonAn}"/></span>
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${fn:length(items) > 3}">
                                                        <span class="muted">+${fn:length(items) - 3} nữa</span>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="muted">(Chưa chọn món)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/menu/edit?id=${m.menuId}">✏️ Sửa</a>
                                                <form action="${pageContext.request.contextPath}/admin/menu/delete" method="post" onsubmit="return confirm('Xóa menu này?');" class="d-inline">
                                                    <input type="hidden" name="menu_id" value="${m.menuId}" />
                                                    <button type="submit" class="btn btn-outline-danger">🗑️ Xóa</button>
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
                    <div class="alert alert-info shadow-sm">Chưa có dữ liệu menu.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
