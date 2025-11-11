<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin - <c:out value="${mode eq 'edit' ? 'Sửa món ăn' : 'Thêm món ăn'}"/></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251021" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
  <style>
    .form-card{ background:#fff; border:1px solid var(--border); border-radius: 14px; padding:16px; box-shadow: var(--shadow); max-width:720px; }
    .form-grid{ display:grid; gap:12px; grid-template-columns: 1fr 1fr; }
    .form-grid .full{ grid-column:1 / -1; }
    .field{ display:grid; gap:6px; }
    .field input, .field select, .field textarea{ padding:10px 12px; border:1px solid var(--border); border-radius:10px; font:inherit; }
    .field textarea{ min-height: 110px; resize: vertical; }
    .actions{ display:flex; gap:8px; margin-top:12px; }
  </style>
</head>
<body>
<div class="admin-shell" id="adminShell">
  <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
  <div class="admin-main">
    <div class="admin-topbar">
      <div class="crumbs">Admin / Món ăn / <c:out value="${mode eq 'edit' ? 'Sửa' : 'Thêm'}"/></div>
      <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-ghost btn-icon">↩ Danh sách</a>
      </div>
    </div>
    <div class="admin-content">
      <c:set var="formAction" value="${pageContext.request.contextPath}${mode eq 'edit' ? '/admin/monan/edit' : '/admin/monan/add'}"/>
      <form class="form-card" action="${formAction}" method="post" enctype="multipart/form-data">
        <c:if test="${mode eq 'edit'}">
          <input type="hidden" name="mon_an_id" value="${monan.monAnId}" />
        </c:if>
        <c:set var="auth" value="${sessionScope.authUser}"/>
        <div class="form-grid">
          <div class="field">
            <label for="quay_hang_id">Quầy hàng</label>
            <c:choose>
              <c:when test="${auth != null && auth.role eq 'truong_quay' && auth.quayHangId != null}">
                <input id="quay_hang_id_text" value="${auth.quayHangId}" disabled />
                <input type="hidden" name="quay_hang_id" value="${auth.quayHangId}" />
              </c:when>
              <c:when test="${not empty quays}">
                <select id="quay_hang_id" name="quay_hang_id" required>
                  <c:forEach var="q" items="${quays}">
                    <option value="${q.quayHangId}" ${mode eq 'edit' && monan.quayHangId == q.quayHangId ? 'selected' : ''}>
                      <c:out value="${q.tenQuayHang}"/>
                    </option>
                  </c:forEach>
                </select>
              </c:when>
              <c:otherwise>
                <!-- Fallback when no quays in DB: allow typing ID -->
                <input id="quay_hang_id" name="quay_hang_id" type="number" min="0" value="${mode eq 'edit' ? monan.quayHangId : ''}" required />
              </c:otherwise>
            </c:choose>
          </div>
          <div class="field">
            <label for="ten_mon_an">Tên món ăn</label>
            <input id="ten_mon_an" name="ten_mon_an" value="${mode eq 'edit' ? monan.tenMonAn : ''}" required />
          </div>
          <div class="field full">
            <label for="mo_ta">Mô tả</label>
            <textarea id="mo_ta" name="mo_ta" placeholder="Mô tả ngắn...">${mode eq 'edit' ? monan.moTa : ''}</textarea>
          </div>
          <div class="field">
            <label for="gia">Giá (VND)</label>
            <input id="gia" name="gia" type="number" step="0.01" min="0" value="${mode eq 'edit' ? monan.gia : ''}" required />
          </div>
          <div class="field">
            <label for="hinh_anh">Ảnh (tải lên)</label>
            <input id="hinh_anh" name="hinh_anh" type="file" accept="image/*" />
          </div>
          <div class="field">
            <label for="hinh_anh_url">Ảnh (URL - tuỳ chọn)</label>
            <input id="hinh_anh_url" name="hinh_anh_url" value="${mode eq 'edit' ? monan.hinhAnhUrl : ''}" placeholder="https://..." />
          </div>
          <div class="field">
            <label for="trang_thai_mon">Trạng thái món</label>
            <select id="trang_thai_mon" name="trang_thai_mon">
              <option value="con_hang" ${mode eq 'edit' ? ((empty monan.trangThaiMon) || (monan.trangThaiMon eq 'con_hang' || monan.trangThaiMon eq 'on' || monan.trangThaiMon eq 'Đang bán' || monan.trangThaiMon eq 'dang_ban') ? 'selected' : '') : 'selected'}>Còn hàng</option>
              <option value="het_hang" ${mode eq 'edit' && (monan.trangThaiMon eq 'het_hang' || monan.trangThaiMon eq 'off' || monan.trangThaiMon eq 'Ngừng bán' || monan.trangThaiMon eq 'ngung_ban') ? 'selected' : ''}>Hết hàng</option>
            </select>
          </div>
        </div>
        <c:if test="${mode eq 'edit' && not empty monan.hinhAnhUrl}">
          <div class="field full" style="margin-top:8px;">
            <label>Ảnh hiện tại</label>
            <div>
              <c:choose>
                <c:when test="${fn:startsWith(monan.hinhAnhUrl, 'http')}">
                  <img alt="${monan.tenMonAn}" src="${monan.hinhAnhUrl}" style="width:120px;height:120px;object-fit:cover;border-radius:10px;border:1px solid var(--border);" />
                </c:when>
                <c:otherwise>
                  <img alt="${monan.tenMonAn}" src="${pageContext.request.contextPath}${monan.hinhAnhUrl}" style="width:120px;height:120px;object-fit:cover;border-radius:10px;border:1px solid var(--border);" />
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </c:if>
        <div class="actions">
          <button class="btn btn-primary" type="submit">${mode eq 'edit' ? 'Lưu thay đổi' : 'Tạo mới'}</button>
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin">Hủy</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
