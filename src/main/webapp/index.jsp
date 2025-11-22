<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="service.MonAnService,java.util.List,models.MonAn" %>
<%@ page import="service.QuayHangService,models.QuayHang,java.util.Map,java.util.HashMap" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <!-- ========== Meta Tags ========== -->
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="Xuan Loc">
    <meta name="description" content="Căn tin - HCMUTE.">
    <!-- ======== Page title ============ -->
    <title>Trang chủ - Căn Tin</title>
    <!-- Make all relative asset links resolve under the webapp context path -->
    <base href="${pageContext.request.contextPath}/" />
    <!--<< Favcion >>-->
    <link rel="shortcut icon" href="assets/img/Hcmute-Logo-Vector.svg-.png">
    <!--<< Bootstrap min.css >>-->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <!--<< All Min Css >>-->
    <link rel="stylesheet" href="assets/css/all.min.css">
    <!--<< Animate.css >>-->
    <link rel="stylesheet" href="assets/css/animate.css">
    <!--<< Magnific Popup.css >>-->
    <link rel="stylesheet" href="assets/css/magnific-popup.css">
    <!--<< MeanMenu.css >>-->
    <link rel="stylesheet" href="assets/css/meanmenu.css">
    <!--<< Swiper Bundle.css >>-->
    <link rel="stylesheet" href="assets/css/swiper-bundle.min.css">
    <!--<< Nice Select.css >>-->
    <link rel="stylesheet" href="assets/css/nice-select.css">
    <!--<< Expose Font.css >>-->
    <link rel="stylesheet" href="assets/css/expose.css">
    <!--<< Main.css >>-->
    <link rel="stylesheet" href="assets/css/main.css">
</head>
<body class="body-bg" data-context="${pageContext.request.contextPath}">

<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<%
    MonAnService monAnService = new MonAnService();
    List<MonAn> foods = monAnService.latest(9);
    request.setAttribute("foods", foods);

    QuayHangService qService = new QuayHangService();
    java.util.List<QuayHang> quays = qService.getAll();
    Map<Integer, String> quayMap = new HashMap<>();
    if (quays != null) {
        for (QuayHang q : quays) { quayMap.put(q.getQuayHangId(), q.getTenQuayHang()); }
    }
    request.setAttribute("quays", quays);
    request.setAttribute("quayMap", quayMap);

    String quayParam = request.getParameter("quay");
    if (quayParam != null && !quayParam.isBlank()) {
        try {
            int quayId = Integer.parseInt(quayParam);
            foods = monAnService.byStall(quayId, 9);
            request.setAttribute("selectedQuay", quayId);
        } catch(NumberFormatException ignored) {}
    }
    request.setAttribute("foods", foods);

    // --- Thực đơn hôm nay cho trang chủ ---
    service.MenuService menuService = new service.MenuService();
    service.MenuMonAnService menuMonAnService = new service.MenuMonAnService();

    java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
    String todayStr = today.toString(); // yyyy-MM-dd
    request.setAttribute("todayLabel", todayStr);

    java.util.Map<Integer, java.util.List<models.MonAn>> todayFoodsByStall = new java.util.HashMap<>();

    java.util.List<QuayHang> _allQuays = quays;
    if (_allQuays != null && !_allQuays.isEmpty()) {
        java.util.List<models.Menu> allMenus = menuService.all();
        java.util.Map<Integer, java.util.List<models.Menu>> menusByQuay = new java.util.HashMap<>();
        for (models.Menu m : allMenus) {
            if (m.getNgayApDung() == null) continue;
            String menuDateStr = m.getNgayApDung().toString();
            if (!todayStr.equals(menuDateStr)) continue;
            menusByQuay.computeIfAbsent(m.getQuayHangId(), k -> new java.util.ArrayList<>()).add(m);
        }

        int count = 0;
        for (QuayHang q : _allQuays) {
            if (count >= 4) break; // chỉ hiển thị tối đa 4 quầy trên trang chủ
            int qid = q.getQuayHangId();

            java.util.List<models.Menu> todayMenus = menusByQuay.get(qid);
            if (todayMenus == null || todayMenus.isEmpty()) {
                count++;
                continue;
            }

            java.util.Set<Integer> monAnIds = new java.util.LinkedHashSet<>();
            for (models.Menu m : todayMenus) {
                java.util.List<Integer> ids = menuMonAnService.monAnIds(m.getMenuId());
                if (ids != null) {
                    monAnIds.addAll(ids);
                }
            }

            java.util.List<models.MonAn> foodsToday = new java.util.ArrayList<>();
            for (Integer monId : monAnIds) {
                models.MonAn f = monAnService.get(monId);
                if (f != null) {
                    foodsToday.add(f);
                }
            }

            if (!foodsToday.isEmpty()) {
                todayFoodsByStall.put(qid, foodsToday);
            }
            count++;
        }
    }
    request.setAttribute("todayFoodsByStall", todayFoodsByStall);
%>

<!-- Compute cart total quantity from session for header counters -->
<c:set var="totalQty" value="${0}" />
<c:choose>
  <c:when test="${not empty sessionScope.cart}">
    <c:set var="totalQty" value="${sessionScope.cart.totalQuantity}" />
  </c:when>
  <c:when test="${not empty sessionScope.cartMap}">
    <c:set var="_sum" value="${0}" />
    <c:forEach var="e" items="${sessionScope.cartMap}">
      <c:set var="_sum" value="${_sum + e.value.totalQuantity}" />
    </c:forEach>
    <c:set var="totalQty" value="${_sum}" />
  </c:when>
</c:choose>

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

<section class="hero-section position-relative fix hero-style1 hero-style5 hero-bg5">
    <div class="container">
        <div class="hero-content1 z-1 position-relative text-center">
            <p class="fs-18 mb-lg-3 mb-2 text-dark fw-500 lh-sm wow fadeInUp" data-wow-delay="0.5s">Bữa ăn ngon - Giá sinh viên - Phục vụ nhanh</p>
            <h2 class="mb-30 black-clr wow fadeInUp" data-wow-delay="0.7s">Căn tin HCMUTE</h2>
            <div class="form-wrapper-five wow fadeInUp" data-wow-delay="0.8s">
                <form action="all-foods.jsp" class="search-adjust1 style2 w-auto bg-white rounded-2 d-flex align-items-center justify-content-between gap-2 mb-3">
                    <div class="bg-white rounded-2 d-flex align-items-center justify-content-between gap-2 border w-100 pe-3">
                        <input class="fs-14 w-100 py-2 px-2 border-0" name="q" type="text" placeholder="Tìm món ăn...">
                    </div>
                    <button type="submit" class="theme-btn theme3-btn text-nowrap px-4 h-44px fw-500 d-center gap-2 rounded-2">
                        <i class="fa-solid fa-magnifying-glass fs-14"></i> <span class="d-sm-block d-none fs-16 fw-semibold text-white">Tìm kiếm</span>
                    </button>
                </form>
                <div class="d-flex align-items-center gap-2 fs-16 text-dark wow fadeInUp" data-wow-delay="0.9s">
                    <c:choose>
                      <c:when test="${empty auth}">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/login" class="fs-18 fw-semibold theme3-clr">Đăng nhập</a></c:when>
                      <c:otherwise>Vào <a href="${pageContext.request.contextPath}/profile" class="fs-18 fw-semibold theme3-clr">hồ sơ cá nhân</a></c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    <img src="assets/img/home-1/hero-burger-flower.png" alt="img" class="position-absolute hero-burger-flower">
    <img src="assets/img/home-1/hero-price25.png" alt="img"
         class="position-absolute hero-burger-price d-sm-block d-none">
    <img src="assets/img/home-1/hero-burger-tometo.png" alt="img"
         class="position-absolute bounce-x d-sm-block d-none" style="right: 300px; bottom: -40px;">
    <img src="assets/img/home-1/hero-egg.png" alt="img" class="position-absolute top-0 bounce-x d-sm-block d-none"
         style="left: 220px;">
    <img src="assets/img/home-1/chees-burger-hero.png" alt="img"
         class="position-absolute ms-40 ps-3 d-lg-block d-none" style="bottom: -30px;">
</section>

<!-- Thực đơn hôm nay trên trang chủ -->
<section class="pt-60 pb-40">
    <div class="container">
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
            <a href="${pageContext.request.contextPath}/menu/stalls" class="theme-btn btn-outline-blak">Xem chi tiết thực đơn</a>
        </div>

        <c:choose>
            <c:when test="${not empty quays}">
                <div class="row g-4">
                    <c:forEach var="q" items="${quays}">
                        <c:set var="foodsToday" value="${todayFoodsByStall[q.quayHangId]}" />
                        <c:if test="${not empty foodsToday}">
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
                                        <c:forEach var="f" items="${foodsToday}">
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
                                                    <form method="post" action="${pageContext.request.contextPath}/cart/add" class="z-1 position-absolute bottom-0 end-0 m-1">
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
                    <p class="fs-16 text-clr mt-4">Hôm nay chưa có món nào trong thực đơn.</p>
                </c:if>
            </c:when>
            <c:otherwise>
                <p class="fs-16 text-clr">Chưa có quầy hàng nào để hiển thị.</p>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- Popular Section start: replaced list with dynamic Foods -->
<section class="popular-section position-relative pt-80 pb-80 fix" id="foods">
    <div class="container">
        <div class="row g-4">
            <div class="col-xl-8 col-lg-8">
                <div class="d-flex align-items-end justify-content-between gap-3 flex-wrap mb-30 pb-xl-2 pb-2">
                    <div class="section-title-style1">
                        <div class="d-flex flex-column gap-2">
                            <h3 class="wow fadeInUp white-clr text-black fs-30 lh-1 fw-semibold"
                                data-wow-delay=".3s">
                                Món ăn mới nhất
                            </h3>
                            <span class="w-32px section-badge1 style5"></span>
                        </div>
                    </div>
                </div>
                <c:choose>
                    <c:when test="${not empty foods}">
                        <div class="row g-3">
                            <c:forEach var="f" items="${foods}">
                                <div class="col-lg-6 col-md-6">
                                    <div class="most-popular-card card-effect smooth d-flex align-items-xxl-center justify-content-between gap-2 border rounded-12 p-xl-4 p-3">
                                        <div class="cont">
                                            <h6 class="mb-lg-1 mb-1"><span class="link-effect"><c:out value="${f.tenMonAn}"/></span></h6>
                                            <p class="fs-15 mb-lg-2 mb-1 max-w-200 lh-base">
                                                <c:choose>
                                                    <c:when test="${empty f.moTa}">
                                                        Không có mô tả
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="_rawDesc" value="${f.moTa}" />
                                                        <c:set var="_noOpenP" value="${fn:replace(_rawDesc, '<p>', '')}" />
                                                        <c:set var="_cleanDesc" value="${fn:replace(_noOpenP, '</p>', '')}" />
                                                        <c:out value="${_cleanDesc}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <h6 class="theme3-clr fs-16 fw-bold">
                                                <fmt:formatNumber value="${f.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                            </h6>
                                        </div>
                                        <div class="thumb rounded-2 position-relative w-90px h-90px">
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
                                            <form method="post" action="${pageContext.request.contextPath}/cart/add" class="z-1 position-absolute bottom-0 end-0 m-2">
                                                <input type="hidden" name="mon_an_id" value="${f.monAnId}" />
                                                <input type="hidden" name="qty" value="1" />
                                                <button type="submit" class="w-28px h-28px bg-white rounded d-center theme3-clr fs-14" title="Thêm vào giỏ" aria-label="Thêm vào giỏ" data-mon-id="${f.monAnId}">
                                                    <i class="fa-solid fa-plus"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="fs-16 text-clr">Chưa có món ăn nào để hiển thị.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="col-xl-4 col-lg-4">
                <div class="popular-thumb-most position-relative rounded-20 overflow-hidden h-100 wow fadeInUp"
                     data-wow-delay="0.5s">
                    <img src="assets/img/home-1/popular-price5.jpg" alt="img" class="w-100">
                    <div class="price-badge position-absolute top-0 start-0 ms-2 mt-5 pt-5">
                        <img src="assets/img/home-1/price-badge-black.png" alt="img">
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Popular Section end -->

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">
                    <img src="assets/img/icons/f-chef2.png" alt="img">
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-4">
                <div class="row g-4 align-items-center">
                    <div class="col-md-6">
                        <div class="thumb w-100 rounded-4">
                            <img src="assets/img/inner/t-details-1.jpg" alt="img" class="w-100 rounded-4">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="quick-view-content">
                            <h3 class="mb-2 fw-semibold">Chess Mashala</h3>
                            <p class="fs-16 text-clr mb-lg-4 mb-3">
                                Reprehenderit quibusdam dignissimos assumenda, sapiente eos repudiandae quas tempora
                                voluptate totam corrupti deleniti ipsa iste quo impedit dolorem ullam temporibus
                                nisi eum.
                            </p>
                            <h5 class="fw-500 mb-1">Size</h5>
                            <div class="d-flex align-items-center gap-2 mb-lg-4 mb-3">
                                <div class="size_available active w-40px h-40px rounded-circle d-center">
                                    S
                                </div>
                                <div class="size_available w-40px h-40px rounded-circle d-center">
                                    S
                                </div>
                                <div class="size_available w-40px h-40px rounded-circle d-center">
                                    S
                                </div>
                            </div>
                            <div class="d-flex gap-lg-2 gap-1 mb-lg-4 mb-3">
                                <div
                                        class="view-new-cart d-flex flex-column align-items-center align-items-center gap-2 py-lg-3 py-2 px-1">
                                    <a href="javascript:void(0)" class="thumb card-effect w-80px h-80px rounded-2">
                                        <img src="assets/img/inner/shop-grilled1.jpg" alt="img"
                                             class="w-100 rounded-2">
                                    </a>
                                    <div class="content">
                                        <a href="javascript:void(0)"
                                           class="fs-14 mb-1 fw-semibold text-black lh-1 d-block">Grilled
                                            Platter</a>
                                        <div class="fs-16 theme3-clr fw-bold">$19.00</div>
                                    </div>
                                </div>
                                <div
                                        class="view-new-cart d-flex flex-column align-items-center align-items-center gap-2 py-lg-3 py-2 px-1">
                                    <a href="javascript:void(0)" class="thumb card-effect w-80px h-80px rounded-2">
                                        <img src="assets/img/inner/shop-grilled1.jpg" alt="img"
                                             class="w-100 rounded-2">
                                    </a>
                                    <div class="content">
                                        <a href="javascript:void(0)"
                                           class="fs-14 mb-1 fw-semibold text-black lh-1 d-block">Eggstasy
                                            Omelet</a>
                                        <div class="fs-16 theme3-clr fw-bold">$14.00</div>
                                    </div>
                                </div>
                                <div
                                        class="view-new-cart d-flex flex-column align-items-center align-items-center gap-2 py-lg-3 py-2 px-1">
                                    <a href="javascript:void(0)" class="thumb card-effect w-80px h-80px rounded-2">
                                        <img src="assets/img/inner/shop-grilled1.jpg" alt="img"
                                             class="w-100 rounded-2">
                                    </a>
                                    <div class="content">
                                        <a href="javascript:void(0)"
                                           class="fs-14 mb-1 fw-semibold text-black lh-1 d-block">Scramble
                                            Shine</a>
                                        <div class="fs-16 theme3-clr fw-bold">$36.00</div>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3 d-flex flex-wrap align-items-center gap-xxl-2 gap-1">
                                <div class="quantity-wrapper d-inline-flex align-items-center">
                                    <button type="button" class="quantityDecrement">-</button>
                                    <input type="text" value="1" readonly>
                                    <button type="button" class="quantityIncrement">+</button>
                                </div>
                                <a href="cart-page.html" class="theme-btn fs-14 px-3 text-nowrap">
                                    Buy Now
                                </a>
                                <h3 class="fw-semibold mt-2 text-end px-3">$541</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer section start -->
<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<!--<< All JS Plugins >>-->
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

<script>
// Update header cart badge when adding items via AJAX
(function(){
  const CTX = document.body.getAttribute('data-context') || '';
  function formatPrice(num){ try { const n = parseFloat(num); if(isNaN(n)) return num; return n.toLocaleString('vi-VN'); } catch(e){ return num; } }
  function showToast(msg, type){
    let t = document.getElementById('toast');
    if(!t){ t = document.createElement('div'); t.id = 'toast'; t.style.cssText = 'position:fixed;bottom:24px;right:24px;background:#1f2937;color:#fff;padding:14px 18px;border-radius:12px;display:none;z-index:2000;box-shadow:0 8px 24px rgba(0,0,0,.25);font-size:14px;line-height:1.4;max-width:320px;'; t.innerHTML = '<div style="display:flex;align-items:center;gap:8px;"><span id="toastIcon" style="font-size:18px;">✅</span><span id="toastMsg"></span></div>'; document.body.appendChild(t); }
    const m = document.getElementById('toastMsg'); const ic = document.getElementById('toastIcon');
    m.textContent = msg; if(type==='error'){ t.style.background='#b91c1c'; ic.textContent='⚠️'; } else if(type==='info'){ t.style.background='#1e3a8a'; ic.textContent='ℹ️'; } else if(type==='warn'){ t.style.background='#92400e'; ic.textContent='⚠️'; } else { t.style.background='#065f46'; ic.textContent='✅'; }
    t.style.display='block'; t.style.opacity='1'; t.style.transform='translateY(0)';
    setTimeout(()=>{ t.style.opacity='0'; t.style.transform='translateY(10px)'; setTimeout(()=>{ t.style.display='none'; },400); },3000);
  }
  function updateHeaderBadges(totalQty){
    const badges = document.querySelectorAll('.count-quan');
    badges.forEach(b => { b.textContent = String(totalQty); });
  }
  function extractTotals(json){
    if(json && json.cartTotals){
      return { qty: json.cartTotals.totalQuantity ?? 0, price: json.cartTotals.totalPrice ?? 0 };
    }
    if(json && json.cart){
      return { qty: json.cart.totalQuantity ?? 0, price: json.cart.totalPrice ?? 0 };
    }
    return null;
  }
  document.addEventListener('submit', function(e){
    const form = e.target; if (!(form instanceof HTMLFormElement)) return; if (!form.action) return;
    const targetPath = (new URL(form.action, location.origin)).pathname;
    if (!targetPath.endsWith('/cart/add')) return; // not our add-to-cart form
    e.preventDefault();
    const monId = (form.querySelector('input[name="mon_an_id"]')||{}).value || (form.querySelector('button[data-mon-id]')||{}).getAttribute?.('data-mon-id') || '';
    const qty = (form.querySelector('input[name="qty"]')||{}).value || '1';
    const payload = new URLSearchParams(); if(monId) payload.append('mon_an_id', monId); payload.append('qty', qty); payload.append('ajax','1');
    fetch(form.action, { method:'POST', body: payload, headers:{'X-Requested-With':'XMLHttpRequest','Accept':'application/json','Content-Type':'application/x-www-form-urlencoded'} })
      .then(async r=>{ let j; try{ j = await r.json(); }catch(_){ j = {status:'error', message:'Phản hồi không hợp lệ'}; } return { ok:r.ok, status:r.status, json:j }; })
      .then(out=>{ const json = out.json || {}; if(out.ok && (json.status==='ok' || json.success===true)){
          const totals = extractTotals(json);
          if(totals){ updateHeaderBadges(Math.max(0, parseInt(totals.qty||0,10))); }
          showToast((json.message||'Đã thêm vào giỏ hàng') + ' (+'+(json.quantityAdded||qty)+')', 'success');
        } else {
          showToast(json.message || ('Lỗi ('+out.status+') khi thêm vào giỏ'), 'error');
        }
      })
      .catch(()=> showToast('Không thể thêm vào giỏ hàng', 'error'));
  });
})();
</script>
</body>
</html>
