<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thực đơn hôm nay - Căn tin</title>
    <base href="${pageContext.request.contextPath}/" />
    <link rel="shortcut icon" href="assets/img/Hcmute-Logo-Vector.svg-.png">
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/animate.css" />
    <link rel="stylesheet" href="assets/css/magnific-popup.css" />
    <link rel="stylesheet" href="assets/css/meanmenu.css" />
    <link rel="stylesheet" href="assets/css/swiper-bundle.min.css" />
    <link rel="stylesheet" href="assets/css/nice-select.css" />
    <link rel="stylesheet" href="assets/css/expose.css" />
</head>
<body class="body-bg">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>
<section class="breadcrumb-section position-relative fix bg-cover" style="background-image: url(assets/img/hero/breadcrumb-banner.jpg);">
    <div class="container">
        <div class="breadcrumb-content">
            <h2 class="white-clr fw-semibold text-center heading-font mb-2">Thực đơn căn tin</h2>
            <ul class="breadcrumb align-items-center justify-content-center flex-wrap gap-3">
                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li><i class="fa-solid fa-angle-right"></i></li>
                <li>Menu</li>
            </ul>
        </div>
    </div>
    <img src="assets/img/home-1/home-shape-start.png" alt="img" class="bread-shape-start position-absolute">
    <img src="assets/img/home-1/home-shape-end.png" alt="img" class="bread-shape-end position-absolute d-sm-block d-none">
</section>
<div class="container pt-80 pb-80">
    <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <h2 class="fs-30 fw-semibold mb-1">Thực đơn hôm nay</h2>
            <p class="mb-0 text-muted">
                <c:choose>
                    <c:when test="${not empty todayLabel}">Thực đơn ngày ${todayLabel}.</c:when>
                    <c:otherwise>Danh sách các món được phục vụ trong ngày hôm nay.</c:otherwise>
                </c:choose>
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/" class="theme-btn btn-outline-blak">Về trang chủ</a>
    </div>

    <c:choose>
        <c:when test="${not empty quays}">
            <div class="row g-4">
                <c:forEach var="q" items="${quays}">
                    <c:set var="foods" value="${todayFoodsByStall[q.quayHangId]}" />
                    <c:if test="${not empty foods}">
                        <div class="col-md-6 col-lg-3">
                            <div class="border rounded-12 p-3 h-100 d-flex flex-column">
                                <div class="d-flex flex-column mb-2">
                                    <h5 class="mb-1 fw-semibold text-black">
                                        <c:out value="${q.tenQuayHang}" />
                                    </h5>
                                    <span class="fs-13 text-muted">
                                        Vị trí: <c:out value="${empty q.viTri ? 'Chưa rõ' : q.viTri}" />
                                    </span>
                                </div>

                                <div class="d-flex flex-column gap-2 flex-grow-1">
                                    <c:forEach var="f" items="${foods}">
                                        <div class="most-popular-card card-effect smooth d-flex align-items-center justify-content-between gap-2 border rounded-12 p-2">
                                            <div class="cont me-1">
                                                <h6 class="mb-1 fs-15">
                                                    <a href="${pageContext.request.contextPath}/mon-an?id=${f.monAnId}" class="link-effect text-black">
                                                        <c:out value="${f.tenMonAn}"/>
                                                    </a>
                                                </h6>
                                                <h6 class="theme3-clr fs-14 fw-bold mb-0">
                                                    <fmt:formatNumber value="${f.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                                </h6>
                                            </div>
                                            <div class="thumb rounded-2 position-relative w-60px h-60px">
                                                <c:choose>
                                                    <c:when test="${not empty f.hinhAnhUrl}">
                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(f.hinhAnhUrl, 'http')}">
                                                                <img width="60" height="60" src="${f.hinhAnhUrl}" alt="${f.tenMonAn}" class="rounded-2">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img width="60" height="60" src="${pageContext.request.contextPath}${f.hinhAnhUrl}" alt="${f.tenMonAn}" class="rounded-2">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img width="60" height="60" src="assets/img/home-1/popular-items1.jpg" alt="img" class="rounded-2">
                                                    </c:otherwise>
                                                </c:choose>
                                                <form method="post" action="${pageContext.request.contextPath}/cart/add" class="z-1 position-absolute bottom-0 end-0 m-1 add-to-cart-form">
                                                    <input type="hidden" name="mon_an_id" value="${f.monAnId}" />
                                                    <input type="hidden" name="qty" value="1" />
                                                    <button type="submit" class="w-22px h-22px bg-white rounded d-center theme3-clr fs-12" title="Thêm vào giỏ" aria-label="Thêm vào giỏ" data-mon-id="${f.monAnId}">
                                                        <i class="fa-solid fa-plus"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <c:if test="${empty todayFoodsByStall}">
                <p class="fs-16 text-clr mt-4">Hôm nay chưa có món nào được cấu hình trong thực đơn.</p>
            </c:if>
        </c:when>
        <c:otherwise>
            <p class="fs-16 text-clr">Chưa có quầy hàng nào để hiển thị.</p>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/jquery-3.7.1.min.js"></script>
<script src="assets/js/viewport.jquery.js"></script>
<script src="assets/js/jquery.nice-select.min.js"></script>
<script src="assets/js/jquery.waypoints.js"></script>
<script src="assets/js/jquery.counterup.min.js"></script>
<script src="assets/js/swiper-bundle.min.js"></script>
<script src="assets/js/jquery.meanmenu.min.js"></script>
<script src="assets/js/jquery.magnific-popup.min.js"></script>
<script src="assets/js/wow.min.js"></script>
<script src="assets/js/main.js"></script>
<script>
  // Gửi thêm vào giỏ bằng AJAX cho nút dấu "+" trong thực đơn hôm nay
  $(function () {
    $(document).on('submit', '.add-to-cart-form', function (e) {
      e.preventDefault();
      var $form = $(this);
      var url = $form.attr('action');
      var data = $form.serialize();

      $.ajax({
        url: url,
        type: 'POST',
        data: data,
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        dataType: 'json',
        success: function (resp) {
          if (resp && resp.status === 'ok') {
            if (resp.cartTotals && typeof resp.cartTotals.totalQuantity !== 'undefined') {
              var $badge = $('[data-cart-total-qty]');
              if ($badge.length) {
                $badge.text(resp.cartTotals.totalQuantity);
              }
            }
          } else {
            alert((resp && resp.message) || 'Không thể thêm món vào giỏ.');
          }
        },
        error: function () {
          alert('Có lỗi xảy ra khi thêm vào giỏ, vui lòng thử lại.');
        }
      });
    });
  });
</script>
</body>
</html>
