<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thực đơn hôm nay - <c:out value="${stall.tenQuayHang}" /></title>
    <base href="${pageContext.request.contextPath}/" />
    <link rel="shortcut icon" href="assets/img/Hcmute-Logo-Vector.svg-.png">

    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/main.css">
</head>
<body class="body-bg">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<div class="container pt-80 pb-80">
    <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <h2 class="fs-30 fw-semibold mb-1">
                Thực đơn hôm nay - Quầy: <c:out value="${stall.tenQuayHang}" />
            </h2>
            <p class="mb-0 text-muted">
                Vị trí: <c:out value="${empty stall.viTri ? 'Chưa rõ' : stall.viTri}" />
                <br/>
                <small>
                    <c:choose>
                        <c:when test="${not empty todayLabel}">Thực đơn ngày ${todayLabel}.</c:when>
                        <c:otherwise>Các món được phục vụ trong ngày hôm nay.</c:otherwise>
                    </c:choose>
                </small>
            </p>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/menu/today" class="theme-btn btn-outline-blak">Xem thực đơn tất cả quầy</a>
            <a href="${pageContext.request.contextPath}/" class="theme-btn btn-outline-blak">Về trang chủ</a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty todayFoods}">
            <div class="row g-3">
                <c:forEach var="f" items="${todayFoods}">
                    <div class="col-md-6 col-lg-4">
                        <div class="most-popular-card card-effect smooth d-flex flex-column gap-2 border rounded-12 p-3 h-100">
                            <div class="d-flex gap-3">
                                <div class="thumb rounded-2 position-relative w-90px h-90px flex-shrink-0">
                                    <c:choose>
                                        <c:when test="${not empty f.hinhAnhUrl}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(f.hinhAnhUrl, 'http')}">
                                                    <img width="90" height="90" src="${f.hinhAnhUrl}" alt="${f.tenMonAn}" class="rounded-2">
                                                </c:when>
                                                <c:otherwise>
                                                    <img width="90" height="90" src="${pageContext.request.contextPath}${f.hinhAnhUrl}" alt="${f.tenMonAn}" class="rounded-2">
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <img width="90" height="90" src="assets/img/home-1/popular-items1.jpg" alt="img" class="rounded-2">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="cont flex-grow-1">
                                    <h6 class="mb-1 fs-18">
                                        <a href="${pageContext.request.contextPath}/mon-an?id=${f.monAnId}" class="link-effect text-black">
                                            <c:out value="${f.tenMonAn}"/>
                                        </a>
                                    </h6>
                                    <p class="fs-13 mb-2 lh-base" data-desc-raw>
                                        <c:out value="${empty f.moTa ? 'Không có mô tả' : f.moTa}" escapeXml="false"/>
                                    </p>
                                    <h6 class="theme3-clr fs-16 fw-bold mb-0">
                                        <fmt:formatNumber value="${f.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                    </h6>
                                </div>
                            </div>
                            <div class="mt-auto d-flex justify-content-between align-items-center">
                                <form method="post" action="${pageContext.request.contextPath}/cart/add" class="m-0 add-to-cart-form">
                                    <input type="hidden" name="mon_an_id" value="${f.monAnId}" />
                                    <input type="hidden" name="qty" value="1" />
                                    <button type="submit" class="theme-btn theme3-btn fs-14 px-3 py-1" title="Thêm vào giỏ" aria-label="Thêm vào giỏ" data-mon-id="${f.monAnId}">
                                        Thêm vào giỏ
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <p class="fs-16 text-clr">Quầy này hôm nay chưa có món ăn nào trong thực đơn.</p>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<script src="assets/js/jquery-3.7.1.min.js"></script>
<script src="assets/js/bootstrap.bundle.min.js"></script>
<script>
  // Rút gọn mô tả (bỏ tag HTML, cắt ~100 ký tự) giống trang all-foods
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('[data-desc-raw]').forEach(function (p) {
      var rawHtml = p.innerHTML || '';
      var tmp = document.createElement('div');
      tmp.innerHTML = rawHtml;
      var text = tmp.textContent || tmp.innerText || '';
      text = text.trim();
      if (!text) {
        p.textContent = 'Không có mô tả';
        return;
      }
      if (text.length > 100) {
        text = text.substring(0, 100) + '...';
      }
      p.textContent = text;
    });
  });

  // Thêm vào giỏ bằng AJAX
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
