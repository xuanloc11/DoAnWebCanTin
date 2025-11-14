<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Đặt hàng thành công</title>
  <link rel="shortcut icon" href="<c:url value='/assets/img/logo/favicon.png' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/all.min.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/main.css' />" />
  <style>
    .success-hero{ background:#f6fff7; border-bottom:1px solid #e5f5e7; }
    .order-chip{ display:inline-flex; gap:6px; align-items:center; padding:6px 10px; border-radius:999px; background:#ecfdf5; color:#065f46; font-weight:600; }
  </style>
</head>
<body class="body-bg">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<c:set var="ids" value="${sessionScope.orderSuccessIds}" />
<c:set var="total" value="${sessionScope.orderSuccessTotal}" />
<c:remove var="orderSuccessIds" scope="session" />
<c:remove var="orderSuccessTotal" scope="session" />

<section class="success-hero py-5">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-8 text-center">
        <div class="d-inline-flex align-items-center justify-content-center rounded-circle bg-success-subtle text-success mb-3" style="width:70px;height:70px;">
          <i class="fa-solid fa-check fs-2"></i>
        </div>
        <h2 class="mb-2">Đặt hàng thành công</h2>
        <p class="text-muted">Cảm ơn bạn đã đặt hàng. Chúng tôi đang xử lý đơn của bạn.</p>
        <c:if test="${not empty ids}">
          <div class="mt-3">
            <span class="me-2">Mã đơn:</span>
            <c:forEach var="oid" items="${ids}" varStatus="st">
              <span class="order-chip">#<c:out value="${oid}"/></span>
            </c:forEach>
          </div>
        </c:if>
        <c:if test="${not empty total}">
          <p class="mt-3">Tổng thanh toán: <strong><fmt:formatNumber value="${total}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</strong></p>
        </c:if>
        <div class="d-flex justify-content-center gap-2 mt-4">
          <a class="theme-btn" href="${pageContext.request.contextPath}/">Về trang chủ</a>
          <a class="theme-btn btn-outline-blak" href="${pageContext.request.contextPath}/profile#orders">Xem đơn hàng</a>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="py-4">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-8">
        <div class="p-3 bg-white border rounded-3">
          <h5 class="mb-2">Lưu ý</h5>
          <ul class="mb-0 text-muted">
            <li>Đơn có thể tách theo từng quầy. Bạn sẽ thấy nhiều mã đơn nếu đặt từ nhiều quầy.</li>
            <li>Vui lòng có mặt tại quầy khi đơn được xác nhận để nhận món nhanh chóng.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<script src="<c:url value='/assets/js/jquery-3.7.1.min.js' />"></script>
<script src="<c:url value='/assets/js/bootstrap.bundle.min.js' />"></script>
<script src="<c:url value='/assets/js/main.js' />"></script>
</body>
</html>
