<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin - <c:out value="${mode eq 'edit' ? 'Sửa đơn hàng' : 'Thêm đơn hàng'}"/></title>
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
      <div class="crumbs">Admin / Đơn hàng / <c:out value="${mode eq 'edit' ? 'Sửa' : 'Thêm'}"/></div>
      <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-ghost btn-icon">↩ Danh sách</a>
      </div>
    </div>
    <div class="admin-content">
      <c:set var="formAction" value="${pageContext.request.contextPath}${mode eq 'edit' ? '/admin/orders/edit' : '/admin/orders/add'}"/>
      <form class="form-card" action="${formAction}" method="post">
        <c:if test="${mode eq 'edit'}">
          <input type="hidden" name="order_id" value="${order.orderId}" />
        </c:if>
        <div class="form-grid">
          <div class="field">
            <label for="user_id">ID Người dùng</label>
            <input id="user_id" name="user_id" type="number" min="1" value="${mode eq 'edit' ? order.userId : ''}" required />
          </div>
          <div class="field">
            <label for="quay_hang_id">Quầy hàng ID</label>
            <input id="quay_hang_id" name="quay_hang_id" type="number" min="1" value="${mode eq 'edit' ? order.quayHangId : ''}" required />
          </div>
          <div class="field">
            <label for="tong_tien">Tổng tiền (VND)</label>
            <input id="tong_tien" name="tong_tien" type="number" step="0.01" min="0" value="${mode eq 'edit' ? order.tongTien : ''}" required />
          </div>
          <div class="field">
            <label for="thoi_gian_dat">Thời gian đặt</label>
            <c:if test="${mode eq 'edit' && order.thoiGianDat ne null}">
              <fmt:formatDate value="${order.thoiGianDat}" pattern="yyyy-MM-dd'T'HH:mm" var="tsVal"/>
            </c:if>
            <input id="thoi_gian_dat" name="thoi_gian_dat" type="datetime-local"
                   value="${mode eq 'edit' ? (tsVal != null ? tsVal : '') : ''}" />
          </div>
          <div class="field">
            <label for="trang_thai_order">Trạng thái</label>
            <select id="trang_thai_order" name="trang_thai_order">
              <c:set var="st" value="${mode eq 'edit' ? order.trangThaiOrder : 'MOI_DAT'}"/>
              <option value="MOI_DAT" ${st eq 'MOI_DAT' ? 'selected' : ''}>Mới đặt</option>
              <option value="DA_XAC_NHAN" ${st eq 'DA_XAC_NHAN' ? 'selected' : ''}>Đã xác nhận</option>
              <option value="DANG_GIAO" ${st eq 'DANG_GIAO' ? 'selected' : ''}>Đang giao</option>
              <option value="DA_GIAO" ${st eq 'DA_GIAO' ? 'selected' : ''}>Đã giao</option>
            </select>
          </div>
          <div class="field full">
            <label for="ghi_chu">Ghi chú</label>
            <input id="ghi_chu" name="ghi_chu" value="${mode eq 'edit' ? order.ghiChu : ''}" />
          </div>
        </div>
        <div class="actions">
          <button class="btn btn-primary" type="submit">${mode eq 'edit' ? 'Lưu thay đổi' : 'Tạo mới'}</button>
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/orders">Hủy</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
