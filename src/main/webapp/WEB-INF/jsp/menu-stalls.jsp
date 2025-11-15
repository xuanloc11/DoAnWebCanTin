<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Menu 4 quầy - Căn tin</title>
    <base href="${pageContext.request.contextPath}/" />
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/main.css">
</head>
<body class="body-bg">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<div class="container pt-80 pb-80">
    <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <h2 class="fs-30 fw-semibold mb-1">Menu 4 quầy</h2>
            <p class="mb-0 text-muted">Xem nhanh các món ăn tại 4 quầy đầu tiên.</p>
        </div>
        <a href="${pageContext.request.contextPath}/" class="theme-btn btn-outline-blak">Về trang chủ</a>
    </div>

    <c:choose>
        <c:when test="${not empty quays}">
            <div class="row g-4">
                <c:forEach var="q" items="${quays}" varStatus="st">
                    <c:if test="${st.index lt 4}">
                        <div class="col-md-6 col-lg-3">
                            <div class="border rounded-12 p-3 h-100 d-flex flex-column">
                                <div class="d-flex flex-column mb-2">
                                    <h5 class="mb-1 fw-semibold text-black">Quầy ${st.index + 1}</h5>
                                    <span class="fs-14 text-clr"><c:out value="${q.tenQuayHang}" /></span>
                                    <span class="fs-13 text-muted">
                                        Vị trí: <c:out value="${empty q.viTri ? 'Chưa rõ' : q.viTri}" />
                                    </span>
                                </div>

                                <div class="d-flex flex-column gap-2 flex-grow-1">
                                    <c:set var="foods" value="${foodsByStall[q.quayHangId]}" />
                                    <c:choose>
                                        <c:when test="${not empty foods}">
                                            <c:forEach var="f" items="${foods}">
                                                <div class="most-popular-card card-effect smooth d-flex align-items-center justify-content-between gap-2 border rounded-12 p-2">
                                                    <div class="cont me-1">
                                                        <h6 class="mb-1 fs-15">
                                                            <span class="link-effect"><c:out value="${f.tenMonAn}"/></span>
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
                                        </c:when>
                                        <c:otherwise>
                                            <p class="fs-14 text-clr mb-0">Quầy này hiện chưa có món.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <a class="theme-btn btn-outline-blak heading-font mt-3 w-100 text-center" href="${pageContext.request.contextPath}/menu/stall?quayId=${q.quayHangId}">
                                    Xem chi tiết quầy
                                </a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <p class="fs-16 text-clr">Chưa có quầy hàng nào để hiển thị.</p>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>

<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
