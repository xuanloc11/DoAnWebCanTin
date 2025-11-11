<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Thanh toán</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
  <style>
    .wrap{ max-width:820px; margin:32px auto; padding:16px; }
    .summary{ border:1px solid #e5e7eb; border-radius:12px; padding:16px; margin-bottom:16px; }
    .row{ display:flex; justify-content:space-between; padding:6px 0; }
    .total{ font-weight:700; }
    textarea{ width:100%; min-height:100px; padding:10px; border:1px solid #e5e7eb; border-radius:10px; }
    .actions{ display:flex; gap:8px; margin-top:12px; }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>
<div class="wrap">
  <h1>Thanh toán</h1>
  <div class="summary">
    <div class="row"><span>Số món:</span><span>${cart.totalQuantity}</span></div>
    <div class="row total"><span>Tổng tiền:</span><span><fmt:formatNumber value="${total}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</span></div>
  </div>
  <form method="post" action="${pageContext.request.contextPath}/checkout">
    <label for="ghi_chu">Ghi chú đơn hàng (tuỳ chọn)</label>
    <textarea id="ghi_chu" name="ghi_chu" placeholder="Ví dụ: Ít cay, thêm hành..."></textarea>
    <div class="actions">
      <a class="btn btn-ghost" href="${pageContext.request.contextPath}/cart">Quay lại giỏ</a>
      <button class="btn btn-primary" type="submit">Đặt hàng</button>
    </div>
  </form>
</div>
</body>
</html>
