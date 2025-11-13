<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="service.MonAnService,service.QuayHangService,java.util.List,java.util.ArrayList,models.MonAn,models.QuayHang,java.math.BigDecimal" %>
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
    <title>Tất cả món ăn</title>
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

<%
    MonAnService monSvc = new MonAnService();
    QuayHangService qSvc = new QuayHangService();
    List<MonAn> all = monSvc.all();
    List<QuayHang> quays = qSvc.getAll();

    String q = (request.getParameter("q") != null) ? request.getParameter("q").trim().toLowerCase() : null;
    String quayParam = request.getParameter("quay");
    Integer quayId = null;
    try { if(quayParam != null && !quayParam.isBlank()) quayId = Integer.parseInt(quayParam); } catch(Exception ignored) {}
    String status = request.getParameter("status");
    String minP = request.getParameter("minPrice");
    String maxP = request.getParameter("maxPrice");
    BigDecimal minPrice = null, maxPrice = null;
    try { if(minP != null && !minP.isBlank()) minPrice = new BigDecimal(minP); } catch(Exception ignored) {}
    try { if(maxP != null && !maxP.isBlank()) maxPrice = new BigDecimal(maxP); } catch(Exception ignored) {}

    List<MonAn> filtered = new ArrayList<>();
    if(all != null){
        for(MonAn m : all){
            boolean ok = true;
            if(q != null && !q.isEmpty()){
                String hay = (m.getTenMonAn()==null?"":m.getTenMonAn()).toLowerCase() + " " +
                             (m.getMoTa()==null?"":m.getMoTa()).toLowerCase();
                if(m.getQuayHangId()!=0){
                    for(QuayHang qq : quays){ if(qq.getQuayHangId()==m.getQuayHangId()){ hay += " "+(qq.getTenQuayHang()==null?"":qq.getTenQuayHang().toLowerCase()); break; } }
                }
                if(!hay.contains(q)) ok = false;
            }
            if(ok && quayId != null){ if(m.getQuayHangId() != quayId) ok = false; }
            if(ok && status != null && !status.isBlank()){ String s = (m.getTrangThaiMon()==null?"":m.getTrangThaiMon()).toLowerCase(); if(!s.contains(status.toLowerCase())) ok = false; }
            BigDecimal price = m.getGia();
            if(ok && minPrice != null){ if(price == null || price.compareTo(minPrice) < 0) ok = false; }
            if(ok && maxPrice != null){ if(price == null || price.compareTo(maxPrice) > 0) ok = false; }
            if(ok) filtered.add(m);
        }
    }
    request.setAttribute("foods", filtered);
    request.setAttribute("quays", quays);
%>

<!-- breadcrumb -->
<section class="breadcrumb-section position-relative fix bg-cover" style="background-image: url(assets/img/hero/breadcrumb-banner.jpg);">
    <div class="container">
        <div class="breadcrumb-content">
            <h2 class="white-clr fw-semibold text-center heading-font mb-2">Tất cả món ăn</h2>
            <ul class="breadcrumb align-items-center justify-content-center flex-wrap gap-3">
                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li><i class="fa-solid fa-angle-right"></i></li>
                <li>Món ăn</li>
            </ul>
        </div>
    </div>
    <img src="assets/img/home-1/home-shape-start.png" alt="img" class="bread-shape-start position-absolute">
    <img src="assets/img/home-1/home-shape-end.png" alt="img" class="bread-shape-end position-absolute d-sm-block d-none">
</section>

<section class="shop-section position-relative z-1 fix section-padding">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-3">
                <div class="shop-category cmn-shadow-shop mb-xxl-4 mb-3">
                    <h4 class="mb-3">Quầy hàng</h4>
                    <div class="d-flex flex-column gap-3">
                        <a href="${pageContext.request.contextPath}/all-foods.jsp" class="d-flex w-100 link-effect align-items-center justify-content-between border-bottom pb-3">
                            <span class="d-flex align-items-center gap-1 fs-15 text-clr">
                                <img src="assets/img/icons/shop-check.png" alt="img">Tất cả quầy
                            </span>
                        </a>
                        <c:forEach var="qq" items="${quays}">
                            <a href="${pageContext.request.contextPath}/all-foods.jsp?quay=${qq.quayHangId}" class="d-flex w-100 link-effect align-items-center justify-content-between border-bottom pb-3 ${param.quay == qq.quayHangId ? 'active' : ''}">
                                <span class="d-flex align-items-center gap-1 fs-15 text-clr">
                                    <img src="assets/img/icons/shop-check.png" alt="img">
                                    <c:out value="${qq.tenQuayHang}"/>
                                </span>
                            </a>
                        </c:forEach>
                    </div>
                </div>
                <div class="shop-category cmn-shadow-shop mb-xxl-4 mb-3">
                    <h4 class="mb-3">Bộ lọc</h4>
                    <form method="get" action="${pageContext.request.contextPath}/all-foods.jsp" class="d-flex flex-column gap-3">
                        <input type="search" class="form-control" name="q" placeholder="Tìm món..." value="${fn:escapeXml(param.q)}" />
                        <select class="form-select" name="status">
                            <option value="" ${empty param.status ? 'selected' : ''}>Tình trạng</option>
                            <option value="on" ${param.status=='on' ? 'selected' : ''}>Còn hàng / Đang bán</option>
                            <option value="off" ${param.status=='off' ? 'selected' : ''}>Hết hàng / Ngừng bán</option>
                        </select>
                        <div class="d-flex align-items-center gap-2">
                            <input type="number" class="form-control" name="minPrice" placeholder="Giá từ" value="${param.minPrice}" />
                            <input type="number" class="form-control" name="maxPrice" placeholder="Giá đến" value="${param.maxPrice}" />
                        </div>
                        <input type="hidden" name="quay" value="${param.quay}" />
                        <button class="theme-btn w-100" type="submit">Áp dụng</button>
                        <a class="theme-btn btn-outline-blak w-100" href="${pageContext.request.contextPath}/all-foods.jsp">Đặt lại</a>
                    </form>
                </div>
            </div>
            <div class="col-lg-9">
                <div class="shop-filter-area border rounded-2 py-3 px-3 d-flex align-items-center justify-content-between flex-wrap gap-3 mb-xxl-4 mb-3">
                    <span class="fs-15 text-clr">Hiển thị ${fn:length(foods)} kết quả</span>
                    <div class="d-flex align-items-center shop-filter-inner">
                        <select name="sorting">
                            <option value="0">Mặc định</option>
                        </select>
                        <ul class="nav d-flex flex-nowrap align-items-center gap-3 nav-tabs border-0" role="tablist">
                            <li class="nav-item" role="presentation"><button class="nav-link p-0 border-0 active" type="button" aria-selected="true">
                                <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M8 1H1V8H8V1Z" stroke="#353844" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round" />
                                    <path d="M19 1H12V8H19V1Z" stroke="#353844" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round" />
                                    <path d="M19 12H12V19H19V12Z" stroke="#353844" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round" />
                                    <path d="M8 12H1V19H8V12Z" stroke="#353844" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round" />
                                </svg>
                            </button></li>
                        </ul>
                    </div>
                </div>
                <c:choose>
                    <c:when test="${not empty foods}">
                        <div class="row g-xxl-4 g-xl-3 g-2">
                            <c:forEach var="f" items="${foods}">
                                <div class="col-sm-6 col-lg-4">
                                    <div class="restaurant-card rounded-4 overflow-hidden restaurant-card_text position-relative border card-scale h-100 rounded-12">
                                        <div class="thumb rounded-top-3 d-block position-relative">
                                            <c:choose>
                                                <c:when test="${not empty f.hinhAnhUrl}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(f.hinhAnhUrl, 'http')}">
                                                            <img src="${f.hinhAnhUrl}" alt="${f.tenMonAn}" class="w-100">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}${f.hinhAnhUrl}" alt="${f.tenMonAn}" class="w-100">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="assets/img/inner/shop-grid1.jpg" alt="img" class="w-100">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="cont py-3 px-xxl-4 px-3">
                                            <h6 class="mb-2">
                                                <span class="text-black link-effect"><c:out value="${f.tenMonAn}"/></span>
                                            </h6>
                                            <p class="fs-12 mb-3 lh-18"><c:out value="${empty f.moTa ? 'Không có mô tả' : f.moTa}"/></p>
                                            <div class="d-flex align-items-center gap-sm-3 gap-2 flex-wrap">
                                                <div class="d-flex align-items-center gap-1">
                                                    <span class="theme3-clr fw-semibold fs-16">
                                                        <fmt:formatNumber value="${f.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                                    </span>
                                                </div>
                                                <form method="post" action="${pageContext.request.contextPath}/cart/add">
                                                    <input type="hidden" name="mon_an_id" value="${f.monAnId}" />
                                                    <input type="hidden" name="qty" value="1" />
                                                    <button type="submit" class="theme-btn btn-outline-theme heading-font rounded-pill py-2 px-3" data-mon-id="${f.monAnId}">Thêm vào giỏ</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="fs-16 text-clr">Không tìm thấy món ăn phù hợp.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>

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
