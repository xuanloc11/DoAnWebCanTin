<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Chi tiết đơn hàng</title>
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
    .order-wrap{ max-width:900px; margin:28px auto; padding:0 16px; font-size:14px; }
    .card{ background:#fff; border:1px solid var(--border); border-radius:16px; padding:18px; margin-bottom:20px; font-size:14px; }
    .card h1{ margin:0 0 10px; font-size:22px; }
    .card h2{ margin:0 0 10px; font-size:18px; }
    table{ width:100%; border-collapse:collapse; font-size:13px; }
    th, td{ padding:8px 10px; border-bottom:1px solid #e5e7eb; text-align:left; }
    th{ background:#f9fafb; font-weight:600; }
    .status-chip{ display:inline-block; padding:2px 8px; border-radius:999px; font-size:11px; font-weight:500; }
    .st-MOI_DAT{ background:#fef3c7; color:#92400e; }
    .st-DA_XAC_NHAN{ background:#d1fae5; color:#065f46; }
    .st-DANG_GIAO{ background:#bfdbfe; color:#1e3a8a; }
    .st-DA_GIAO{ background:#e0f2fe; color:#0369a1; }
    .st-CANCELLED{ background:#fee2e2; color:#b91c1c; }
    .st-MIXED{ background:#ede9fe; color:#5b21b6; }
    .muted{ color:var(--muted); font-size:12px; }
    .actions{ margin-top:10px; font-size:13px; }
    .actions .btn{ font-size:13px; padding:8px 14px; }
  </style>
</head>
<body class="body-bg" data-context="${pageContext.request.contextPath}">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>
<div class="order-wrap">
  <c:choose>
    <c:when test="${isGrouped}">
      <div class="card">
        <h1>Đơn gộp (nhiều quầy) - ${order.thoiGianDat}</h1>
        <p><strong>Quầy liên quan:</strong> <c:out value="${mergedStallsDisplay}"/></p>
        <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${mergedTotal}" type="number" groupingUsed="true" maxFractionDigits="0" /> VNĐ</p>
        <p><strong>Đơn con:</strong>
          <c:forEach var="o" items="${groupOrders}" varStatus="st">
            <a href="${pageContext.request.contextPath}/profile/order?id=${o.orderId}">#${o.orderId}</a><c:if test="${!st.last}">, </c:if>
          </c:forEach>
        </p>
      </div>

      <div class="card">
        <h2>Các món đã đặt</h2>
        <c:choose>
          <c:when test="${not empty mergedItems}">
            <table>
              <thead>
                <tr>
                  <th style="width:60px">ID</th>
                  <th>Món</th>
                  <th>Số lượng</th>
                  <th>Đơn giá</th>
                  <th>Thành tiền</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="it" items="${mergedItems}">
                  <tr>
                    <td>${it.monAnId}</td>
                    <td><c:out value="${mergedMonMap[it.monAnId].tenMonAn}"/></td>
                    <td>${it.soLuong}</td>
                    <td><fmt:formatNumber value="${it.donGiaMonAnLucDat}" type="number" groupingUsed="true" maxFractionDigits="0" /> VNĐ</td>
                    <td><fmt:formatNumber value="${it.donGiaMonAnLucDat * it.soLuong}" type="number" groupingUsed="true" maxFractionDigits="0" /> VNĐ</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:when>
          <c:otherwise>
            <p class="muted">Không có món ăn nào.</p>
          </c:otherwise>
        </c:choose>
        <div class="actions">
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/profile#orders">← Quay lại danh sách đơn</a>
        </div>
      </div>
    </c:when>
    <c:otherwise>
      <div class="card">
        <h1>Đơn hàng #${order.orderId}</h1>
        <p><strong>Quầy:</strong>
          <c:choose>
            <c:when test="${not empty stallName}"><c:out value="${stallName}"/></c:when>
            <c:otherwise>#${order.quayHangId}</c:otherwise>
          </c:choose>
        </p>
        <p><strong>Thời gian đặt:</strong> <fmt:formatDate value="${order.thoiGianDat}" pattern="dd/MM/yyyy HH:mm"/></p>
        <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${order.tongTien}" type="number" groupingUsed="true" maxFractionDigits="0" /> VNĐ</p>
        <p><strong>Trạng thái:</strong>
          <span class="status-chip st-${order.trangThaiOrder}">
            <c:choose>
              <c:when test="${order.trangThaiOrder eq 'MOI_DAT'}">Mới đặt</c:when>
              <c:when test="${order.trangThaiOrder eq 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
              <c:when test="${order.trangThaiOrder eq 'DANG_GIAO'}">Đang giao</c:when>
              <c:when test="${order.trangThaiOrder eq 'DA_GIAO'}">Đã giao</c:when>
              <c:when test="${order.trangThaiOrder eq 'CANCELLED'}">Đã hủy</c:when>
              <c:otherwise><c:out value="${order.trangThaiOrder}"/></c:otherwise>
            </c:choose>
          </span>
        </p>
        <c:if test="${not empty order.ghiChu}">
          <p><strong>Ghi chú:</strong> <c:out value="${order.ghiChu}"/></p>
        </c:if>
      </div>

      <div class="card">
        <h2>Danh sách món ăn</h2>
        <c:choose>
          <c:when test="${not empty items}">
            <table>
              <thead>
                <tr>
                  <th style="width:60px">ID</th>
                  <th>Món</th>
                  <th>Số lượng</th>
                  <th>Đơn giá</th>
                  <th>Thành tiền</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="it" items="${items}">
                  <tr>
                    <td>${it.monAnId}</td>
                    <td><c:out value="${monMap[it.monAnId].tenMonAn}"/></td>
                    <td>${it.soLuong}</td>
                    <td><fmt:formatNumber value="${it.donGiaMonAnLucDat}" type="number" groupingUsed="true" maxFractionDigits="0" /> VNĐ</td>
                    <td><fmt:formatNumber value="${it.donGiaMonAnLucDat * it.soLuong}" type="number" groupingUsed="true" maxFractionDigits="0" /> VNĐ</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:when>
          <c:otherwise>
            <p class="muted">Không có món ăn nào trong đơn hàng này.</p>
          </c:otherwise>
        </c:choose>
        <div class="actions">
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/profile#orders">← Quay lại danh sách đơn</a>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</div>
<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>
</body>
</html>
