<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Menu quầy - Căn tin</title>
    <base href="${pageContext.request.contextPath}/" />
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/main.css">
</head>
<body class="body-bg">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<div class="container pt-80 pb-80">
    <div class="mb-4">
        <h2 class="fs-30 fw-semibold mb-1">Menu quầy: <c:out value="${stall.tenQuayHang}" /></h2>
        <p class="mb-0 text-muted">Vị trí: <c:out value="${empty stall.viTri ? 'Chưa rõ' : stall.viTri}" /></p>
    </div>

    <c:choose>
        <c:when test="${not empty foods}">
            <div class="row g-3">
                <c:forEach var="f" items="${foods}">
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
                                    <h6 class="mb-1 fs-18"><c:out value="${f.tenMonAn}"/></h6>
                                    <p class="fs-15 mb-2 lh-base"><c:out value="${empty f.moTa ? 'Không có mô tả' : f.moTa}"/></p>
                                    <h6 class="theme3-clr fs-16 fw-bold mb-0">
                                        <fmt:formatNumber value="${f.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                    </h6>
                                </div>
                            </div>
                            <div class="mt-auto d-flex justify-content-between align-items-center">
                                <form method="post" action="${pageContext.request.contextPath}/cart/add" class="m-0">
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
            <p class="fs-16 text-clr">Quầy này hiện chưa có món ăn nào.</p>
        </c:otherwise>
    </c:choose>

    <div class="mt-4">
        <a href="${pageContext.request.contextPath}/menu/stalls" class="theme-btn btn-outline-blak">Xem menu 4 quầy</a>
        <a href="${pageContext.request.contextPath}/" class="theme-btn btn-outline-blak ms-2">Về trang chủ</a>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>

