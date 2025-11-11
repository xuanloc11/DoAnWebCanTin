<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý quầy hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
</head>
<body>
<div class="admin-shell" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main">
        <div class="admin-topbar">
            <div class="crumbs">Admin / Quầy hàng</div>
            <div class="admin-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-ghost btn-icon">↩ Về trang chủ</a>
                <a class="btn btn-primary btn-icon" href="${pageContext.request.contextPath}/admin/quayhang/add">＋ Thêm quầy hàng</a>
            </div>
        </div>
        <div class="admin-content">
            <div class="admin-head">
                <h1 class="admin-title">Quản lý quầy hàng</h1>
            </div>
            <c:choose>
                <c:when test="${not empty stalls}">
                    <div class="table-wrap">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="col-id">ID</th>
                                    <th>Tên quầy</th>
                                    <th>Vị trí</th>
                                    <th>Trạng thái</th>
                                    <th style="width:160px">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${stalls}">
                                    <tr>
                                        <td class="col-id">${s.quayHangId}</td>
                                        <td><c:out value="${s.tenQuayHang}"/></td>
                                        <td><c:out value="${s.viTri}"/></td>
                                        <td>
                                             <c:choose>
                                                <c:when test="${s.trangThai eq 'active'}"><span class="chip ok">Hoạt động</span></c:when>
                                                <c:otherwise><span class="chip off">Đóng cửa</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="table-actions" style="display:flex; gap:6px;">
                                                <a class="btn btn-small" href="${pageContext.request.contextPath}/admin/quayhang/edit?id=${s.quayHangId}">Sửa</a>
                                                <form action="${pageContext.request.contextPath}/admin/quayhang/delete" method="post" onsubmit="return confirm('Xóa quầy hàng này?');">
                                                    <input type="hidden" name="quay_hang_id" value="${s.quayHangId}" />
                                                    <button type="submit" class="btn btn-small btn-danger">Xóa</button>
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
                    <p class="muted">Chưa có dữ liệu quầy hàng.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
