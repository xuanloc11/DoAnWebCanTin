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
  <title>Giỏ hàng</title>
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
<body class="body-bg">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<!-- breadcrumb -->
<section class="breadcrumb-section position-relative fix bg-cover" style="background-image: url(assets/img/hero/breadcrumb-banner.jpg);">
  <div class="container">
    <div class="breadcrumb-content">
      <h2 class="white-clr fw-semibold text-center heading-font mb-2">Giỏ hàng</h2>
      <ul class="breadcrumb align-items-center justify-content-center flex-wrap gap-3">
        <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
        <li><i class="fa-solid fa-angle-right"></i></li>
        <li>Giỏ hàng</li>
      </ul>
    </div>
  </div>
  <img src="assets/img/home-1/home-shape-start.png" alt="img" class="bread-shape-start position-absolute">
  <img src="assets/img/home-1/home-shape-end.png" alt="img" class="bread-shape-end position-absolute d-sm-block d-none">
</section>

<section class="shop-section position-relative z-1 fix section-padding">
  <div class="container">
    <c:choose>
      <c:when test="${cartEmpty}">
        <div class="row justify-content-center">
          <div class="col-lg-8">
            <div class="p-4 bg-white rounded-3 border text-center">
              <h4 class="mb-2">Giỏ hàng trống</h4>
              <p class="mb-3 text-muted">Hiện chưa có món nào trong giỏ của bạn.</p>
              <a href="${pageContext.request.contextPath}/" class="theme-btn">Tiếp tục mua sắm</a>
            </div>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="row g-4">
          <div class="col-lg-9">
            <div class="table-cart-inner p-xxl-4 p-xl-4 p-3 bg-white rounded-3 border">
              <form method="post" action="${pageContext.request.contextPath}/cart">
                <input type="hidden" name="action" value="update" />
                <div class="table-responsive">
                  <table class="table m-0 align-middle table-borderless">
                    <thead>
                      <tr>
                        <th class="pb-lg-4 pb-3"><div class="fs-18 fw-semibold text-black m-0">Món</div></th>
                        <th class="pb-lg-4 pb-3"><div class="fs-18 fw-semibold text-black m-0">Giá</div></th>
                        <th class="pb-lg-4 pb-3"><div class="fs-18 fw-semibold text-black m-0">Số lượng</div></th>
                        <th class="pb-lg-4 pb-3"><div class="fs-18 fw-semibold text-black m-0">Tạm tính</div></th>
                        <th class="pb-lg-4 pb-3 text-center"><div class="fs-18 fw-semibold text-black m-0">Xóa</div></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="it" items="${cart.items.values()}">
                        <tr class="border overflow-hidden rounded">
                          <td class="p-3">
                            <div class="d-flex align-items-center gap-3">
                              <c:set var="imgUrl" value="${it.monAn.hinhAnhUrl}" />
                              <c:choose>
                                <c:when test="${not empty imgUrl}">
                                  <c:choose>
                                    <c:when test="${fn:startsWith(imgUrl, 'http')}">
                                      <img src="${imgUrl}" alt="${it.monAn.tenMonAn}" class="border rounded-2" style="width:72px;height:72px;object-fit:cover;" />
                                    </c:when>
                                    <c:otherwise>
                                      <img src="${pageContext.request.contextPath}${imgUrl}" alt="${it.monAn.tenMonAn}" class="border rounded-2" style="width:72px;height:72px;object-fit:cover;" />
                                    </c:otherwise>
                                  </c:choose>
                                </c:when>
                                <c:otherwise>
                                  <img src="assets/img/inner/shop-cart.jpg" alt="img" class="border rounded-2" style="width:72px;height:72px;object-fit:cover;" />
                                </c:otherwise>
                              </c:choose>
                              <div>
                                <h6 class="text-black fw-500 mb-1"><c:out value="${it.monAn.tenMonAn}"/></h6>
                                <div class="text-muted fs-14">Mã: ${it.monAn.monAnId}</div>
                              </div>
                            </div>
                          </td>
                          <td class="p-3">
                            <h6 class="theme-clr fw-500 m-0"><fmt:formatNumber value="${it.monAn.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</h6>
                          </td>
                          <td class="p-3">
                            <div class="quantity-wrapper d-inline-flex align-items-center">
                              <button type="button" class="quantityDecrement">-</button>
                              <input type="number" name="qty_${it.monAn.monAnId}" value="${it.soLuong}" min="0" />
                              <button type="button" class="quantityIncrement">+</button>
                            </div>
                          </td>
                          <td class="p-3">
                            <h6 class="theme-clr fw-500 m-0"><fmt:formatNumber value="${it.tongGia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</h6>
                          </td>
                          <td class="text-center">
                            <button type="submit" class="btn p-0 border-0" name="remove" value="${it.monAn.monAnId}" title="Xóa">
                              <i class="fa-solid fa-xmark"></i>
                            </button>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mt-3">
                  <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/" class="theme-btn btn-outline-blak">Tiếp tục mua sắm</a>
                  </div>
                  <div class="d-flex gap-2">
                    <button class="theme-btn btn-outline-blak" type="submit">Cập nhật giỏ</button>
                    <button class="theme-btn" type="submit" name="action" value="clear" onclick="return confirm('Xóa toàn bộ giỏ hàng?');">Xóa giỏ</button>
                  </div>
                </div>
              </form>
            </div>
          </div>
          <div class="col-lg-3">
            <div class="p-xxl-4 p-xl-4 p-3 bg-white rounded-3 border">
              <h5 class="text-black fw-600 mb-3">Tổng thanh toán</h5>
              <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                <span class="text-muted">Tạm tính</span>
                <span class="text-black fw-500"><fmt:formatNumber value="${cart.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</span>
              </div>
              <div class="d-flex justify-content-between align-items-center py-2">
                <span class="text-muted">Tổng</span>
                <span class="text-black fw-600"><fmt:formatNumber value="${cart.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</span>
              </div>
              <a href="${pageContext.request.contextPath}/checkout" class="theme-btn w-100 mt-3">Tiến hành thanh toán</a>
            </div>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<script src="assets/js/jquery-3.7.1.min.js"></script>
<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/jquery.nice-select.min.js"></script>
<script src="assets/js/jquery.waypoints.js"></script>
<script src="assets/js/jquery.counterup.min.js"></script>
<script src="assets/js/swiper-bundle.min.js"></script>
<script src="assets/js/jquery.meanmenu.min.js"></script>
<script src="assets/js/jquery.magnific-popup.min.js"></script>
<script src="assets/js/wow.min.js"></script>
<script src="assets/js/main.js"></script>
<script>
  // Basic quantity increment/decrement binding
  document.addEventListener('click', function(e){
    if(e.target.closest('.quantityIncrement')){
      const input = e.target.closest('.quantity-wrapper').querySelector('input[type="number"]');
      const val = parseInt(input.value||'0',10)+1; input.value = val; input.dispatchEvent(new Event('change'));}
    if(e.target.closest('.quantityDecrement')){
      const input = e.target.closest('.quantity-wrapper').querySelector('input[type="number"]');
      const cur = parseInt(input.value||'0',10); const val = Math.max(0, cur-1); input.value = val; input.dispatchEvent(new Event('change'));}
  });
</script>
</body>
</html>
