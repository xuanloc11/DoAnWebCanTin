<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Chỉnh sửa thông tin cá nhân</title>
  <!-- Make all relative asset links resolve under the webapp context path -->
  <base href="${pageContext.request.contextPath}/" />
  <!-- Favicons & CSS from main template -->
  <link rel="shortcut icon" href="assets/img/logo/favicon.png">
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/all.min.css">
  <link rel="stylesheet" href="assets/css/animate.css">
  <link rel="stylesheet" href="assets/css/magnific-popup.css">
  <link rel="stylesheet" href="assets/css/meanmenu.css">
  <link rel="stylesheet" href="assets/css/swiper-bundle.min.css">
  <link rel="stylesheet" href="assets/css/nice-select.css">
  <link rel="stylesheet" href="assets/css/expose.css">
  <link rel="stylesheet" href="assets/css/main.css">
  <!-- Page-specific minimal styles -->
  <link rel="stylesheet" href="assets/css/home.css?v=20251022" />
  <style>
    .wrap{ max-width:720px; margin:32px auto; padding:0 16px; }
    .card{ background:#fff; border:1px solid var(--border); border-radius:16px; padding:20px; }
    .field{ display:grid; gap:6px; margin:10px 0; }
    .field input{ padding:10px 12px; border:1px solid #e5e7eb; border-radius:10px; }
    .actions{ display:flex; gap:8px; margin-top:12px; }
  </style>
</head>
<body class="body-bg" data-context="${pageContext.request.contextPath}">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>
<div class="wrap">
  <div class="card">
    <h4>Chỉnh sửa thông tin cá nhân</h4>
    <form method="post" action="${pageContext.request.contextPath}/profile/edit">
      <div class="field">
        <label for="ho_ten">Họ tên</label>
        <input id="ho_ten" name="ho_ten" value="${me.hoTen}"/>
      </div>
      <div class="field">
        <label for="don_vi">Đơn vị</label>
        <input id="don_vi" name="don_vi" value="${me.donVi}"/>
      </div>
      <div class="field">
        <label for="password">Mật khẩu mới (để trống nếu không đổi)</label>
        <input id="password" name="password" type="password" />
      </div>
      <div class="actions">
        <button class="btn btn-primary" type="submit">Lưu</button>
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/profile">Hủy</a>
      </div>
    </form>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>
</body>
</html>
