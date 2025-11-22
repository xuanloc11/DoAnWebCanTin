<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Hồ sơ cá nhân</title>
    <!-- Make all relative asset links resolve under the webapp context path -->
    <base href="${pageContext.request.contextPath}/" />
    <!-- Favicons & CSS from main template -->
    <link rel="shortcut icon" href="assets/img/Hcmute-Logo-Vector.svg-.png">
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/all.min.css">
    <link rel="stylesheet" href="assets/css/animate.css">
    <link rel="stylesheet" href="assets/css/magnific-popup.css">
    <link rel="stylesheet" href="assets/css/meanmenu.css">
    <link rel="stylesheet" href="assets/css/swiper-bundle.min.css">
    <link rel="stylesheet" href="assets/css/nice-select.css">
    <link rel="stylesheet" href="assets/css/expose.css">
    <link rel="stylesheet" href="assets/css/main.css">
    <!-- Page-specific minimal styles -->
    <link rel="stylesheet" href="assets/css/home.css?v=20251022" />
    <style>
        .profile-shell{ max-width:1100px; margin:24px auto; display:grid; grid-template-columns: 260px 1fr; gap:24px; font-size:14px; }
        .profile-nav{ background:#fff; border:1px solid var(--border); border-radius:14px; padding:12px; display:grid; gap:6px; position:sticky; top:16px; height:fit-content; font-size:13px; }
        .profile-nav a{ padding:8px 10px; border-radius:10px; text-decoration:none; color:#111827; display:flex; align-items:center; gap:6px; font-weight:500; font-size:13px; }
        .profile-nav a.active{ background:#2563eb; color:#fff; }
        .profile-card{ background:#fff; border:1px solid var(--border); border-radius:16px; padding:16px 18px; font-size:14px; }
        h1{ margin:0 0 12px; font-size:22px; }
        .muted{ color:var(--muted); font-size:12px; }
        table{ width:100%; border-collapse:collapse; font-size:13px; }
        th, td{ padding:8px 10px; border-bottom:1px solid #e5e7eb; text-align:left; }
        th{ background:#f9fafb; font-weight:600; }
        .status-chip{ display:inline-block; padding:2px 8px; border-radius:999px; font-size:11px; font-weight:500; }
        .st-MOI_DAT{ background:#fef3c7; color:#92400e; }
        .st-DA_XAC_NHAN{ background:#d1fae5; color:#065f46; }
        .st-DANG_GIAO{ background:#bfdbfe; color:#1e3a8a; }
        .st-DA_GIAO{ background:#e0f2fe; color:#0369a1; }
        .st-DA_HUY{ background:#fee2e2; color:#b91c1c; }
        .st-CANCELLED{ background:#fee2e2; color:#b91c1c; }
        .st-MIXED{ background:#ede9fe; color:#5b21b6; }
        .note{ font-size:12px; }
    </style>
</head>
<body class="body-bg" data-context="${pageContext.request.contextPath}">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>
<div class="profile-shell">
    <nav class="profile-nav" aria-label="Profile sections">
        <a href="#info" class="active">🧑 Thông tin cá nhân</a>
    </nav>
    <div class="profile-main">
        <section id="info" class="profile-card" aria-labelledby="info-title">
            <h1 id="info-title">Thông tin cá nhân</h1>
            <c:if test="${not empty me}">
                <p><strong>Họ tên:</strong> <c:out value="${me.hoTen}"/></p>
                <p><strong>Email:</strong> <c:out value="${me.email}"/></p>
                <p><strong>Lớp:</strong> <c:out value="${empty me.donVi ? '(Chưa cập nhật)' : me.donVi}"/></p>
                <c:if test="${not empty me.quayHangId}">
                    <p><strong>Quầy hàng:</strong> <c:out value="${me.quayHangId}"/></p>
                </c:if>
                <p class="note muted">Nếu thông tin chưa đúng, liên hệ quản trị để cập nhật.</p>
                <p>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/profile/edit">Chỉnh sửa thông tin</a>
                </p>
            </c:if>
        </section>

        <section id="orders" class="profile-card" aria-labelledby="orders-title" style="margin-top:28px;">
            <h1 id="orders-title">Đơn hàng của tôi</h1>
            <c:choose>
                <c:when test="${not empty groupedOrders}">
                    <table>
                        <thead>
                        <tr>
                            <th style="width:90px">#Đơn</th>
                            <th>Quầy liên quan</th>
                            <th>Thời gian</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="g" items="${groupedOrders}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/profile/order?id=${g.primaryOrderId}">
                                        <c:out value="${g.orderIds}"/>
                                    </a>
                                </td>
                                <td><c:out value="${g.stallsDisplay}"/></td>
                                <td><fmt:formatDate value="${g.thoiGianDat}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatNumber value="${g.tongTien}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ</td>
                                <td>
                    <span class="status-chip st-${g.trangThaiTong}">
                      <c:choose>
                          <c:when test="${g.trangThaiTong eq 'MOI_DAT'}">Mới đặt</c:when>
                          <c:when test="${g.trangThaiTong eq 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
                          <c:when test="${g.trangThaiTong eq 'DANG_GIAO'}">Đang giao</c:when>
                          <c:when test="${g.trangThaiTong eq 'DA_GIAO'}">Đã giao</c:when>
                          <c:when test="${g.trangThaiTong eq 'DA_HUY' || g.trangThaiTong eq 'CANCELLED'}">Đã hủy</c:when>
                          <c:when test="${g.trangThaiTong eq 'MIXED'}">Nhiều trạng thái</c:when>
                          <c:otherwise><c:out value="${g.trangThaiTong}"/></c:otherwise>
                      </c:choose>
                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <p class="note muted" style="margin-top:8px;">Gợi ý: Nhấp vào mã đơn để xem chi tiết; nếu đơn gồm nhiều quầy, trang chi tiết sẽ hiển thị theo từng quầy.</p>
                </c:when>
                <c:otherwise>
                    <p class="muted">Bạn chưa có đơn hàng nào.</p>
                </c:otherwise>
            </c:choose>

            <c:if test="false">
                <table>
                    <thead>
                    <tr>
                        <th style="width:90px">#ID</th>
                        <th>Quầy</th>
                        <th>Thời gian</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/profile/order?id=${o.orderId}">${o.orderId}</a>
                            </td>
                            <td><c:out value="${empty quayMap ? o.quayHangId : (quayMap[o.quayHangId] != null ? quayMap[o.quayHangId] : o.quayHangId)}"/></td>
                            <td><fmt:formatDate value="${o.thoiGianDat}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td><fmt:formatNumber value="${o.tongTien}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ</td>
                            <td>
                  <span class="status-chip st-${o.trangThaiOrder}">
                    <c:choose>
                        <c:when test="${o.trangThaiOrder eq 'MOI_DAT'}">Mới đặt</c:when>
                        <c:when test="${o.trangThaiOrder eq 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
                        <c:when test="${o.trangThaiOrder eq 'DANG_GIAO'}">Đang giao</c:when>
                        <c:when test="${o.trangThaiOrder eq 'DA_GIAO'}">Đã giao</c:when>
                        <c:when test="${o.trangThaiOrder eq 'DA_HUY' || o.trangThaiOrder eq 'CANCELLED'}">Đã hủy</c:when>
                        <c:otherwise><c:out value="${o.trangThaiOrder}"/></c:otherwise>
                    </c:choose>
                  </span>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </section>
    </div>
</div>
<script>
    (function(){
        const links = document.querySelectorAll('.profile-nav a');
        links.forEach(a=>a.addEventListener('click', function(){
            links.forEach(l=>l.classList.remove('active')); this.classList.add('active');
        }));
    })();
</script>
<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>
</body>
</html>
