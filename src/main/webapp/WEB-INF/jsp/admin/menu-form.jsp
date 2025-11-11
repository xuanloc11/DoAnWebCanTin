<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin - <c:out value="${mode eq 'edit' ? 'Sửa menu' : 'Thêm menu'}"/></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
  <style>
    .form-card{ background:#fff; border:1px solid var(--border); border-radius: 14px; padding:16px; box-shadow: var(--shadow); max-width:960px; }
    .form-grid{ display:grid; gap:12px; grid-template-columns: 1fr 1fr; }
    .form-grid .full{ grid-column:1 / -1; }
    .field{ display:grid; gap:6px; }
    .field input, .field select, .field textarea{ padding:10px 12px; border:1px solid var(--border); border-radius:10px; font:inherit; }
    .actions{ display:flex; gap:8px; margin-top:12px; }
    .foods-wrap{ border:1px dashed var(--border); border-radius:12px; padding:12px; max-height:360px; overflow:auto; }
    .foods-grid{ display:grid; grid-template-columns: repeat(3, 1fr); gap:8px 16px; }
    .food-item{ display:flex; align-items:center; gap:8px; padding:6px 8px; border-radius:8px; }
    .food-item img{ width:36px; height:36px; object-fit:cover; border-radius:6px; border:1px solid var(--border); }
    .food-item label{ display:flex; align-items:center; gap:8px; cursor:pointer; width:100%; }
    .food-title{ font-weight:500; }
    .muted{ color:var(--muted); }
  </style>
</head>
<body>
<div class="admin-shell" id="adminShell">
  <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
  <div class="admin-main">
    <div class="admin-topbar">
      <div class="crumbs">Admin / Menu / <c:out value="${mode eq 'edit' ? 'Sửa' : 'Thêm'}"/></div>
      <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/menu" class="btn btn-ghost btn-icon">↩ Danh sách</a>
      </div>
    </div>
    <div class="admin-content">
      <c:set var="formAction" value="${pageContext.request.contextPath}${mode eq 'edit' ? '/admin/menu/edit' : '/admin/menu/add'}"/>
      <form class="form-card" action="${formAction}" method="post">
        <c:if test="${mode eq 'edit'}">
          <input type="hidden" name="menu_id" value="${menu.menuId}" />
        </c:if>
        <c:set var="auth" value="${sessionScope.authUser}"/>
        <div class="form-grid">
          <div class="field">
            <label for="quay_hang_id">Quầy hàng ID</label>
            <c:choose>
              <c:when test="${auth != null && auth.role eq 'truong_quay' && auth.quayHangId != null}">
                <input id="quay_hang_id_text" value="${auth.quayHangId}" disabled />
                <input type="hidden" name="quay_hang_id" value="${auth.quayHangId}" />
              </c:when>
              <c:otherwise>
                <input id="quay_hang_id" name="quay_hang_id" type="number" min="1" value="${mode eq 'edit' ? menu.quayHangId : ''}" required />
              </c:otherwise>
            </c:choose>
          </div>
          <div class="field">
            <label for="ngay_ap_dung">Ngày áp dụng</label>
            <input id="ngay_ap_dung" name="ngay_ap_dung" type="date" value="${mode eq 'edit' ? menu.ngayApDung : ''}" required />
          </div>
          <div class="field full">
            <label for="ten_thuc_don">Tên thực đơn</label>
            <input id="ten_thuc_don" name="ten_thuc_don" value="${mode eq 'edit' ? menu.tenThucDon : ''}" required />
          </div>
        </div>

        <div class="field full">
          <label>Món ăn trong menu</label>
          <div class="foods-wrap">
            <c:choose>
              <c:when test="${not empty foods}">
                <div class="foods-grid">
                  <c:forEach var="f" items="${foods}">
                    <div class="food-item">
                      <label>
                        <input type="checkbox" name="mon_an_ids" value="${f.monAnId}"
                               <c:if test="${not empty selectedMap && selectedMap[f.monAnId]}">checked</c:if> />
                        <c:if test="${not empty f.hinhAnhUrl}">
                          <c:choose>
                            <c:when test="${fn:startsWith(f.hinhAnhUrl, 'http')}">
                              <img src="${f.hinhAnhUrl}" alt="${f.tenMonAn}" />
                            </c:when>
                            <c:otherwise>
                              <img src="${pageContext.request.contextPath}${f.hinhAnhUrl}" alt="${f.tenMonAn}" />
                            </c:otherwise>
                          </c:choose>
                        </c:if>
                        <span class="food-title"><c:out value="${f.tenMonAn}"/></span>
                        <span class="muted">#${f.monAnId}</span>
                      </label>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <div class="muted">Chưa có món ăn nào.</div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="actions">
          <button class="btn btn-primary" type="submit">${mode eq 'edit' ? 'Lưu thay đổi' : 'Tạo mới'}</button>
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/menu">Hủy</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
