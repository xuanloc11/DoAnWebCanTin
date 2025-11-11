<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin - <c:out value="${mode eq 'edit' ? 'Sửa quầy hàng' : 'Thêm quầy hàng'}"/></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
  <style>
    .form-card{ background:#fff; border:1px solid var(--border); border-radius: 14px; padding:16px; box-shadow: var(--shadow); max-width:720px; }
    .form-grid{ display:grid; gap:12px; grid-template-columns: 1fr 1fr; }
    .form-grid .full{ grid-column:1 / -1; }
    .field{ display:grid; gap:6px; }
    .field input, .field select, .field textarea{ padding:10px 12px; border:1px solid var(--border); border-radius:10px; font:inherit; }
    .actions{ display:flex; gap:8px; margin-top:12px; }
  </style>
</head>
<body>
<div class="admin-shell" id="adminShell">
  <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
  <div class="admin-main">
    <div class="admin-topbar">
      <div class="crumbs">Admin / Quầy hàng / <c:out value="${mode eq 'edit' ? 'Sửa' : 'Thêm'}"/></div>
      <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/quayhang" class="btn btn-ghost btn-icon">↩ Danh sách</a>
      </div>
    </div>
    <div class="admin-content">
      <c:set var="formAction" value="${pageContext.request.contextPath}${mode eq 'edit' ? '/admin/quayhang/edit' : '/admin/quayhang/add'}"/>
      <form class="form-card" action="${formAction}" method="post">
        <c:if test="${mode eq 'edit'}">
          <input type="hidden" name="quay_hang_id" value="${quay.quayHangId}" />
        </c:if>
        <div class="form-grid">
          <div class="field">
            <label for="ten_quay_hang">Tên quầy</label>
            <input id="ten_quay_hang" name="ten_quay_hang" value="${mode eq 'edit' ? quay.tenQuayHang : ''}" required />
          </div>
          <div class="field">
            <label for="vi_tri">Vị trí</label>
            <input id="vi_tri" name="vi_tri" value="${mode eq 'edit' ? quay.viTri : ''}" />
          </div>
          <div class="field">
            <label for="trang_thai">Trạng thái</label>
            <select id="trang_thai" name="trang_thai">
              <c:set var="st" value="${mode eq 'edit' ? quay.trangThai : 'active'}"/>
              <option value="active" ${st eq 'active' ? 'selected' : ''}>Hoạt động</option>
              <option value="inactive" ${st eq 'inactive' ? 'selected' : ''}>Đóng cửa</option>
            </select>
          </div>
        </div>
        <div class="actions">
          <button class="btn btn-primary" type="submit">${mode eq 'edit' ? 'Lưu thay đổi' : 'Tạo mới'}</button>
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/quayhang">Hủy</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
