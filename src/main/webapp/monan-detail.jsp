<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết món ăn</title>
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
</head>
<body class="body-bg" data-context="${pageContext.request.contextPath}">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<c:set var="food" value="${requestScope.food}" />

<c:choose>
  <c:when test="${empty food}">
    <section class="section-padding">
      <div class="container text-center">
        <h3 class="mb-3">Không tìm thấy món ăn</h3>
        <p class="mb-4">Món ăn bạn yêu cầu không tồn tại hoặc đã bị xóa.</p>
        <a href="${pageContext.request.contextPath}/all-foods.jsp" class="theme-btn">Quay lại danh sách món</a>
      </div>
    </section>
  </c:when>
  <c:otherwise>
    <section class="breadcrumb-section position-relative fix bg-cover" style="background-image: url(assets/img/hero/breadcrumb-banner.jpg);">
      <div class="container">
        <div class="breadcrumb-content">
          <h2 class="white-clr fw-semibold text-center heading-font mb-2">
            <c:out value="${food.tenMonAn}" />
          </h2>
          <ul class="breadcrumb align-items-center justify-content-center flex-wrap gap-3">
            <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
            <li><i class="fa-solid fa-angle-right"></i></li>
            <li>Chi tiết món ăn</li>
          </ul>
        </div>
      </div>
      <img src="assets/img/home-1/home-shape-start.png" alt="img" class="bread-shape-start position-absolute" />
      <img src="assets/img/home-1/home-shape-end.png" alt="img" class="bread-shape-end position-absolute d-sm-block d-none" />
    </section>

    <section class="shop-section position-relative z-1 fix section-padding">
      <div class="container">
        <div class="row g-4">
          <div class="col-lg-5">
            <div class="rounded-4 overflow-hidden border">
              <c:choose>
                <c:when test="${not empty food.hinhAnhUrl}">
                  <c:choose>
                    <c:when test="${fn:startsWith(food.hinhAnhUrl, 'http')}">
                      <img src="${food.hinhAnhUrl}" alt="${food.tenMonAn}" class="w-100" />
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}${food.hinhAnhUrl}" alt="${food.tenMonAn}" class="w-100" />
                    </c:otherwise>
                  </c:choose>
                </c:when>
                <c:otherwise>
                  <img src="assets/img/inner/shop-grid1.jpg" alt="img" class="w-100" />
                </c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="col-lg-7">
            <div class="product-details ps-lg-4">
              <h3 class="mb-3"><c:out value="${food.tenMonAn}" /></h3>
              <div class="d-flex align-items-center gap-3 mb-3">
                <span class="theme3-clr fw-semibold fs-24">
                  <fmt:formatNumber value="${food.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                </span>
                <c:if test="${not empty food.trangThaiMon}">
                  <span class="badge bg-${food.trangThaiMon == 'on' ? 'success' : 'secondary'} text-uppercase">
                    <c:out value="${food.trangThaiMon == 'on' ? 'Đang bán' : 'Tạm ngừng'}" />
                  </span>
                </c:if>
              </div>
              <p class="fs-16 mb-4">
                <c:out value="${empty food.moTa ? 'Hiện chưa có mô tả chi tiết cho món ăn này.' : food.moTa}" />
              </p>

              <form method="post" action="${pageContext.request.contextPath}/cart/add" class="d-flex align-items-center gap-3 mb-4">
                <input type="hidden" name="mon_an_id" value="${food.monAnId}" />
                <div class="d-flex align-items-center gap-2">
                  <label for="qty" class="mb-0">Số lượng:</label>
                  <input type="number" id="qty" name="qty" value="1" min="1" class="form-control" style="width: 100px;" />
                </div>
                <button type="submit" class="theme-btn heading-font rounded-pill py-2 px-4">
                  Thêm vào giỏ hàng
                </button>
              </form>

              <div class="fs-14 text-clr">
                <p class="mb-1">Mã món: <strong>#${food.monAnId}</strong></p>
                <p class="mb-0">Quầy hàng: <c:out value="${requestScope.quayTen}" default="Không xác định" /></p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </c:otherwise>
</c:choose>

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
