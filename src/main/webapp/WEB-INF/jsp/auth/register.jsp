<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Đăng ký</title>
  <base href="${pageContext.request.contextPath}/" />
  <link rel="shortcut icon" href="assets/img/logo/favicon.png" />
  <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
  <link rel="stylesheet" href="assets/css/all.min.css" />
  <link rel="stylesheet" href="assets/css/animate.css" />
  <link rel="stylesheet" href="assets/css/magnific-popup.css" />
  <link rel="stylesheet" href="assets/css/meanmenu.css" />
  <link rel="stylesheet" href="assets/css/swiper-bundle.min.css" />
  <link rel="stylesheet" href="assets/css/nice-select.css" />
  <link rel="stylesheet" href="assets/css/expose.css" />
  <link rel="stylesheet" href="assets/css/main.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251021" />
  <style>
    .wrap{ min-height: 100vh; display:grid; place-items:center; background: var(--alt,#f6f8fb); padding: 24px; }
    .card{ width:min(480px,100%); background:#fff; border:1px solid var(--border); border-radius: 16px; box-shadow: var(--shadow); padding: 20px; font-size: 14px; }
    .card h1{ margin:0 0 8px; font-size: 18px; }
    .field{ display:grid; gap:4px; margin:8px 0; font-size: 13px; }
    .field label{ font-size: 13px; }
    .field input{ padding: 10px 12px; border:1px solid var(--border); border-radius: 10px; font-size: 14px; }
    .field input:focus{ outline:none; border-color:#bfdbfe; box-shadow:0 0 0 3px rgba(59,130,246,.2); }
    .actions{ display:flex; gap:8px; align-items:center; justify-content:space-between; margin-top: 8px; font-size: 13px; }
    .actions .btn{ font-size: 13px; padding: 8px 14px; }
    .error{ color:#b91c1c; background:#fee2e2; border:1px solid #fecaca; padding:6px 8px; border-radius:8px; margin:6px 0; font-size: 13px; }
    .muted{ color: var(--muted); font-size: 12px; }
    .brand{ display:flex; align-items:center; gap:10px; margin-bottom: 6px; font-size: 16px; }
    small.hint{ color: var(--muted); font-size: 12px; }
  </style>
</head>
<body class="body-bg" data-context="${pageContext.request.contextPath}">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<div class="wrap">
  <div class="card">
    <div class="brand">
      <img class="brand-logo" src="${pageContext.request.contextPath}/assets/img/Hcmute-Logo-Vector.svg-.png" alt="HCMUTE" style="width:36px;height:36px" />
      <strong>Căng tin - Đăng ký</strong>
    </div>
    <c:if test="${not empty error}"><div class="error">${error}</div></c:if>
    <form action="${pageContext.request.contextPath}/register" method="post" autocomplete="off">
      <div class="field">
        <label for="ho_ten">Họ tên</label>
        <input id="ho_ten" name="ho_ten" value="${ho_ten}" required />
      </div>
      <div class="field">
        <label for="email">Email @student.hcmute.edu.vn</label>
        <input id="email" name="email" type="email" value="${email}" required
               placeholder="you@student.hcmute.edu.vn"
               pattern="^[A-Za-z0-9._%+-]+@student\\.hcmute\\.edu\\.vn$"
               title="Chỉ chấp nhận email có đuôi @student.hcmute.edu.vn" />
        <small class="hint">Chỉ chấp nhận email có đuôi @student.hcmute.edu.vn</small>
      </div>
      <div class="field">
        <label for="password">Mật khẩu</label>
        <input id="password" name="password" type="password" minlength="6" required />
      </div>
      <div class="field">
        <label for="confirm_password">Xác nhận mật khẩu</label>
        <input id="confirm_password" name="confirm_password" type="password" minlength="6" required />
      </div>
      <div class="actions">
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/login">↩ Đăng nhập</a>
        <button class="btn btn-primary" type="submit">Tạo tài khoản</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<script src="assets/js/jquery-3.7.1.min.js"></script>
<script src="assets/js/viewport.jquery.js"></script>
<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/jquery.nice-select.min.js"></script>
<script src="assets/js/jquery.waypoints.js"></script>
<script src="assets/js/jquery.counterup.min.js"></script>
<script src="assets/js/swiper-bundle.min.js"></script>
<script src="assets/js/jquery.meanmenu.min.js"></script>
<script src="assets/js/jquery.magnific-popup.min.js"></script>
<script src="assets/js/wow.min.js"></script>
<script src="assets/js/main.js"></script>
</body>
</html>
