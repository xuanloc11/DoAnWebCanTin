<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
</head>
<body>
<div class="admin-shell" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main">
        <div class="admin-topbar">
            <div class="crumbs">Admin / Người dùng</div>
            <div class="admin-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-ghost btn-icon">↩ Về trang chủ</a>
                <a class="btn btn-primary btn-icon" href="${pageContext.request.contextPath}/admin/users/add">＋ Thêm người dùng</a>
            </div>
        </div>
        <div class="admin-content">
            <div class="admin-head">
                <h1 class="admin-title">Quản lý người dùng</h1>
            </div>
            <c:choose>
                <c:when test="${not empty users}">
                    <div class="table-wrap">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="col-id">ID</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th style="width:160px">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td class="col-id">${u.userId}</td>
                                        <td><c:out value="${u.hoTen}"/></td>
                                        <td><c:out value="${u.email}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.role eq 'bgh_admin'}">BGH Admin</c:when>
                                                <c:when test="${u.role eq 'truong_quay'}">Trưởng quầy</c:when>
                                                <c:when test="${u.role eq 'nhan_vien_quay'}">Nhân viên quầy</c:when>
                                                <c:when test="${u.role eq 'hoc_sinh'}">Học sinh</c:when>
                                                <c:otherwise><c:out value="${u.role}"/></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="table-actions" style="display:flex; gap:6px;">
                                                <a class="btn btn-small" href="${pageContext.request.contextPath}/admin/users/edit?id=${u.userId}">Sửa</a>
                                                <form action="${pageContext.request.contextPath}/admin/users/delete" method="post" onsubmit="return confirm('Xóa người dùng #${u.userId}?');">
                                                    <input type="hidden" name="user_id" value="${u.userId}" />
                                                    <button class="btn btn-small btn-danger" type="submit">Xóa</button>
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
                    <p class="muted">Chưa có dữ liệu người dùng.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
