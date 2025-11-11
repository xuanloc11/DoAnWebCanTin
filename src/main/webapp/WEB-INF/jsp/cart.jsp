<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Giỏ hàng</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251108" />
  <style>
    .cart-wrap{ max-width:1000px; margin:32px auto; padding:0 16px; }
    .stall-block{ background:#fff; border:1px solid #e5e7eb; border-radius:16px; padding:18px; margin-bottom:28px; }
    h2.stall-title{ margin:0 0 12px; font-size:20px; }
    table{ width:100%; border-collapse:collapse; margin-bottom:12px; }
    th, td{ padding:10px 12px; border-bottom:1px solid #e5e7eb; text-align:left; }
    th{ background:#f9fafb; }
    input[type=number]{ width:80px; }
    .actions{ display:flex; flex-wrap:wrap; gap:10px; }
    .muted{ color:#6b7280; }
    .total-line{ font-weight:600; text-align:right; margin:8px 0 4px; }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>
<div class="cart-wrap">
  <h1>Giỏ hàng</h1>
  <c:choose>
    <c:when test="${cartEmpty}">
      <p class="muted">Chưa có món nào trong giỏ.</p>
    </c:when>
    <c:otherwise>
      <div class="stall-block">
        <form method="post" action="${pageContext.request.contextPath}/cart">
          <input type="hidden" name="action" value="update" />
          <table>
            <thead>
              <tr>
                <th style="width:60px">ID</th>
                <th>Món</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Tổng</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="it" items="${cart.items.values()}">
                <tr>
                  <td>${it.monAn.monAnId}</td>
                  <td><c:out value="${it.monAn.tenMonAn}"/></td>
                  <td><fmt:formatNumber value="${it.monAn.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</td>
                  <td>
                    <input type="number" min="0" name="qty_${it.monAn.monAnId}" value="${it.soLuong}" />
                  </td>
                  <td><fmt:formatNumber value="${it.tongGia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</td>
                  <td>
                    <button class="btn btn-small btn-danger" type="submit" name="remove" value="${it.monAn.monAnId}">Xóa</button>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
          <div class="total-line">Tổng tiền: <fmt:formatNumber value="${cart.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</div>
          <div class="actions">
            <button class="btn btn-primary" type="submit">Cập nhật giỏ</button>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/checkout">Thanh toán</a>
            <button class="btn btn-ghost" type="submit" name="action" value="clear" onclick="return confirm('Xóa toàn bộ giỏ hàng?');">Xóa giỏ</button>
          </div>
        </form>
      </div>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
