<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Đăng nhập</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251021" />
  <style>
    .login-wrap{ min-height: 100vh; display:grid; place-items:center; background: var(--alt,#f6f8fb); padding: 24px; }
    .login-card{ width:min(420px,100%); background:#fff; border:1px solid var(--border); border-radius: 16px; box-shadow: var(--shadow); padding: 20px; }
    .login-card h1{ margin:0 0 8px; font-size: 20px; }
    .field{ display:grid; gap:6px; margin:10px 0; }
    .field input{ padding: 12px 14px; border:1px solid var(--border); border-radius: 10px; }
    .field input:focus{ outline:none; border-color:#bfdbfe; box-shadow:0 0 0 3px rgba(59,130,246,.2); }
    .actions{ display:flex; gap:8px; align-items:center; justify-content:space-between; margin-top: 10px; }
    .error{ color:#b91c1c; background:#fee2e2; border:1px solid #fecaca; padding:8px 10px; border-radius:8px; margin:8px 0; }
    .success{ color:#065f46; background:#d1fae5; border:1px solid #a7f3d0; padding:8px 10px; border-radius:8px; margin:8px 0; }
    .muted{ color: var(--muted); }
    .brand{ display:flex; align-items:center; gap:10px; margin-bottom: 8px; }
  </style>
</head>
<body>
  <div class="login-wrap">
    <div class="login-card">
      <div class="brand">
        <img class="brand-logo" src="${pageContext.request.contextPath}/assets/img/Hcmute-Logo-Vector.svg-.png" alt="HCMUTE" style="width:36px;height:36px" />
        <strong>Căn tin - Đăng nhập</strong>
      </div>
      <c:if test="${not empty error}"><div class="error">${error}</div></c:if>
      <c:if test="${param.type eq 'success' && not empty param.msg}"><div class="success">${param.msg}</div></c:if>
      <form action="${pageContext.request.contextPath}/login" method="post">
        <c:if test="${not empty param.next || not empty next}"><input type="hidden" name="next" value="${not empty next ? next : param.next}"/></c:if>
        <c:set var="emailVal" value="${not empty email ? email : param.email}"/>
        <div class="field">
          <label for="email">Email</label>
          <input id="email" name="email" type="email" value="${emailVal}" required placeholder="you@student.hcmute.edu.vn" />
        </div>
        <div class="field">
          <label for="password">Mật khẩu</label>
          <input id="password" name="password" type="password" required />
        </div>
        <div class="actions">
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/register">Đăng ký</a>
          <button class="btn btn-primary" type="submit">Đăng nhập</button>
        </div>
      </form>
      <p class="muted" style="margin-top:8px">Chỉ chấp nhận email @student.hcmute.edu.vn khi đăng ký tài khoản.</p>
    </div>
  </div>
</body>
</html>
