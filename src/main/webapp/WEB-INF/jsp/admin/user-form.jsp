<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin - <c:out value="${mode eq 'edit' ? 'Sửa người dùng' : 'Thêm người dùng'}"/></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
  <style>
    .form-card{ background:#fff; border:1px solid var(--border); border-radius: 14px; padding:16px; box-shadow: var(--shadow); max-width:720px; }
    .form-grid{ display:grid; gap:12px; grid-template-columns: 1fr 1fr; }
    .form-grid .full{ grid-column:1 / -1; }
    .field{ display:grid; gap:6px; }
    .field input, .field select, .field textarea{ padding:10px 12px; border:1px solid var(--border); border-radius:10px; font:inherit; }
    .hint{ font-size:12px; color:var(--muted); }
    .actions{ display:flex; gap:8px; margin-top:12px; }
  </style>
</head>
<body>
<div class="admin-shell" id="adminShell">
  <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
  <div class="admin-main">
    <div class="admin-topbar">
      <div class="crumbs">Admin / Người dùng / <c:out value="${mode eq 'edit' ? 'Sửa' : 'Thêm'}"/></div>
      <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost btn-icon">↩ Danh sách</a>
      </div>
    </div>
    <div class="admin-content">
      <c:set var="formAction" value="${pageContext.request.contextPath}${mode eq 'edit' ? '/admin/users/edit' : '/admin/users/add'}"/>
      <form class="form-card" action="${formAction}" method="post">
        <c:if test="${mode eq 'edit'}">
          <input type="hidden" name="user_id" value="${user.userId}" />
        </c:if>
        <c:set var="auth" value="${sessionScope.authUser}"/>
        <div class="form-grid">
          <div class="field">
            <label for="ho_ten">Họ tên</label>
            <input id="ho_ten" name="ho_ten" value="${mode eq 'edit' ? user.hoTen : ''}" required />
          </div>
          <div class="field">
            <label for="email">Email</label>
            <input id="email" type="email" name="email" value="${mode eq 'edit' ? user.email : ''}" required />
          </div>
          <div class="field">
            <label for="password">Mật khẩu</label>
            <input id="password" type="password" name="password" ${mode eq 'edit' ? '' : 'required'} />
            <c:if test="${mode eq 'edit'}"><div class="hint">Để trống nếu không đổi mật khẩu</div></c:if>
          </div>
          <div class="field">
            <label for="role">Vai trò</label>
            <c:choose>
              <c:when test="${auth != null && auth.role eq 'truong_quay'}">
                <input type="text" id="role_text" value="Nhân viên quầy" disabled />
                <input type="hidden" name="role" value="nhan_vien_quay" />
                <div class="hint">Trưởng quầy chỉ tạo/sửa được tài khoản Nhân viên quầy.</div>
              </c:when>
              <c:otherwise>
                <c:set var="currentRole" value="${mode eq 'edit' ? user.role : 'hoc_sinh'}"/>
                <select id="role" name="role">
                  <option value="bgh_admin" ${currentRole eq 'bgh_admin' ? 'selected' : ''}>BGH Admin</option>
                  <option value="truong_quay" ${currentRole eq 'truong_quay' ? 'selected' : ''}>Trưởng quầy</option>
                  <option value="nhan_vien_quay" ${currentRole eq 'nhan_vien_quay' ? 'selected' : ''}>Nhân viên quầy</option>
                  <option value="hoc_sinh" ${currentRole eq 'hoc_sinh' ? 'selected' : ''}>Học sinh</option>
                </select>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="field full">
            <label for="don_vi">Đơn vị</label>
            <input id="don_vi" name="don_vi" value="${mode eq 'edit' ? user.donVi : ''}" />
          </div>
          <div class="field">
            <label for="quay_hang_id">Quầy hàng ID (tùy chọn)</label>
            <c:choose>
              <c:when test="${auth != null && auth.role eq 'truong_quay' && auth.quayHangId != null}">
                <input id="quay_hang_id_text" value="${auth.quayHangId}" disabled />
                <input type="hidden" name="quay_hang_id" value="${auth.quayHangId}" />
                <div class="hint">Tự động gán vào quầy của bạn.</div>
              </c:when>
              <c:otherwise>
                <input id="quay_hang_id" name="quay_hang_id" type="number" step="1" min="1" value="${mode eq 'edit' ? user.quayHangId : ''}" />
              </c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="actions">
          <button class="btn btn-primary" type="submit">${mode eq 'edit' ? 'Lưu thay đổi' : 'Tạo mới'}</button>
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/users">Hủy</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
