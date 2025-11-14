<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Thanh toán</title>
  <!-- Use context-aware URLs for assets -->
  <link rel="shortcut icon" href="<c:url value='/assets/img/logo/favicon.png' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/all.min.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/animate.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/magnific-popup.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/meanmenu.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/swiper-bundle.min.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/nice-select.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/expose.css' />" />
  <link rel="stylesheet" href="<c:url value='/assets/css/main.css' />" />
</head>
<body class="body-bg">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<c:set var="isEmpty" value="${empty cart || cart.totalQuantity == 0}" />
<div id="preloader" class="preloader">
    <div class="animation-preloader">
        <div class="spinner">
        </div>
        <div class="txt-loading">
                <span data-text-preloader="H" class="letters-loading">
                    H
                </span>
            <span data-text-preloader="C" class="letters-loading">
                    C
                </span>
            <span data-text-preloader="M" class="letters-loading">
                    M
                </span>
            <span data-text-preloader="U" class="letters-loading">
                    U
                </span>
            <span data-text-preloader="T" class="letters-loading">
                    T
                </span>
            <span data-text-preloader="E" class="letters-loading">
                    E
                </span>
        </div>
        <p class="text-center">Loading...</p>
    </div>
    <div class="loader">
        <div class="row">
            <div class="col-3 loader-section section-left">
                <div class="bg"></div>
            </div>
            <div class="col-3 loader-section section-left">
                <div class="bg"></div>
            </div>
            <div class="col-3 loader-section section-right">
                <div class="bg"></div>
            </div>
            <div class="col-3 loader-section section-right">
                <div class="bg"></div>
            </div>
        </div>
    </div>
</div>
<!-- breadcrumb -->
<section class="breadcrumb-section position-relative fix bg-cover" style="background-image: url('<c:url value='/assets/img/hero/breadcrumb-banner.jpg' />');">
  <div class="container">
    <div class="breadcrumb-content">
      <h2 class="white-clr fw-semibold text-center heading-font mb-2">Thanh toán</h2>
      <ul class="breadcrumb align-items-center justify-content-center flex-wrap gap-3">
        <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
        <li><i class="fa-solid fa-angle-right"></i></li>
        <li>Thanh toán</li>
      </ul>
    </div>
  </div>
  <img src="<c:url value='/assets/img/home-1/home-shape-start.png' />" alt="img" class="bread-shape-start position-absolute">
  <img src="<c:url value='/assets/img/home-1/home-shape-end.png' />" alt="img" class="bread-shape-end position-absolute d-sm-block d-none">
</section>

<section class="shop-section position-relative z-1 fix section-padding">
  <div class="container">
    <c:choose>
      <c:when test="${isEmpty}">
        <div class="row justify-content-center">
          <div class="col-lg-8">
            <div class="p-4 bg-white rounded-3 border text-center">
              <h4 class="mb-2">Giỏ hàng trống</h4>
              <p class="mb-3 text-muted">Bạn chưa có món nào để thanh toán.</p>
              <a href="${pageContext.request.contextPath}/" class="theme-btn">Tiếp tục mua sắm</a>
            </div>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="row g-4">
          <div class="col-lg-8">
            <div class="checkout-billing-details h-100">
              <h4 class="text-black mb-lg-4 mb-3">Thông tin đơn hàng</h4>
              <form id="checkoutForm" method="post" action="${pageContext.request.contextPath}/checkout" class="billing-form">
                <div class="row g-3">
                  <div class="col-12">
                    <label for="ghi_chu" class="form-label">Ghi chú (tuỳ chọn)</label>
                    <textarea id="ghi_chu" name="ghi_chu" class="form-control" placeholder="Ví dụ: Ít cay, thêm hành..." rows="4"></textarea>
                  </div>
                </div>
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-3">
                  <a class="theme-btn btn-outline-blak" href="${pageContext.request.contextPath}/cart">↩ Quay lại giỏ</a>
                  <button class="theme-btn" type="submit">Đặt hàng</button>
                </div>
              </form>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="shadow-cus d-flex flex-column justify-content-between coupon-group position-relative h-100 p-xl-4 p-3 rounded-3 bg-white">
              <div>
                <h5 class="border-bottom pb-2 mb-3">Tóm tắt đơn hàng</h5>
                <div class="d-flex flex-column gap-3 align-items-center pb-3">
                  <c:forEach var="it" items="${cart.items.values()}">
                    <div class="order-summary d-flex justify-content-between w-100 gap-2">
                      <div class="d-flex align-items-center gap-3">
                        <c:set var="imgUrl" value="${it.monAn.hinhAnhUrl}" />
                        <c:choose>
                          <c:when test="${not empty imgUrl}">
                            <c:choose>
                              <c:when test="${fn:startsWith(imgUrl, 'http')}">
                                <img width="40" height="40" src="${imgUrl}" alt="${it.monAn.tenMonAn}" class="border rounded-2" />
                              </c:when>
                              <c:otherwise>
                                <img width="40" height="40" src="${pageContext.request.contextPath}${imgUrl}" alt="${it.monAn.tenMonAn}" class="border rounded-2" />
                              </c:otherwise>
                            </c:choose>
                          </c:when>
                          <c:otherwise>
                            <img width="40" height="40" src="<c:url value='/assets/img/inner/shop-cart.jpg' />" alt="img" class="border rounded-2" />
                          </c:otherwise>
                        </c:choose>
                        <div>
                          <h6 class="text-black fs-12 lh-1 max-w-180 fw-500 m-0"><c:out value="${it.monAn.tenMonAn}"/></h6>
                          <span class="fw-semibold theme-clr fs-12">
                            <fmt:formatNumber value="${it.monAn.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                          </span>
                        </div>
                      </div>
                      <div class="fs-12 text-muted">x${it.soLuong}</div>
                    </div>
                  </c:forEach>
                </div>
              </div>
              <div class="order-summary-footer">
                <div class="d-flex flex-column">
                  <div class="d-flex align-items-center justify-content-between border-top pt-2 pb-1">
                    <span class="fs-12 text-black fw-medium">Số món</span>
                    <span class="fs-12 text-black fw-medium">${cart.totalQuantity}</span>
                  </div>
                  <div class="d-flex align-items-center justify-content-between pb-2">
                    <span class="fs-12 text-black fw-medium">Tạm tính</span>
                    <span class="fs-12 text-black fw-medium"><fmt:formatNumber value="${cart.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</span>
                  </div>
                  <div class="d-flex align-items-center justify-content-between border-top pt-2 pb-3">
                    <span class="fs-12 text-black fw-medium">Tổng</span>
                    <span class="fs-12 text-black fw-medium"><fmt:formatNumber value="${cart.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</span>
                  </div>
                </div>
                <button id="confirmOrderBtn" type="button" class="theme-btn text-center justify-content-center w-100">Xác nhận đặt hàng</button>
              </div>
            </div>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
  <img src="<c:url value='/assets/img/inner-global-pasta.png' />" alt="img" class="position-absolute bottom-0 end-0 float-bob-y mt-4 z-n1 d-sm-block d-none">
</section>

<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<script src="<c:url value='/assets/js/jquery-3.7.1.min.js' />"></script>
<script src="<c:url value='/assets/js/viewport.jquery.js' />"></script>
<script src="<c:url value='/assets/js/bootstrap.bundle.min.js' />"></script>
<script src="<c:url value='/assets/js/jquery.nice-select.min.js' />"></script>
<script src="<c:url value='/assets/js/jquery.waypoints.js' />"></script>
<script src="<c:url value='/assets/js/jquery.counterup.min.js' />"></script>
<script src="<c:url value='/assets/js/swiper-bundle.min.js' />"></script>
<script src="<c:url value='/assets/js/jquery.meanmenu.min.js' />"></script>
<script src="<c:url value='/assets/js/jquery.magnific-popup.min.js' />"></script>
<script src="<c:url value='/assets/js/wow.min.js' />"></script>
<script src="<c:url value='/assets/js/main.js' />"></script>
<script>
  // Submit main form when clicking the right-side confirm button
  document.getElementById('confirmOrderBtn')?.addEventListener('click', function(){
    document.getElementById('checkoutForm')?.submit();
  });
</script>
</body>
</html>
