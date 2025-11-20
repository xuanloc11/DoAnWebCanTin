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
    <link rel="shortcut icon" href="assets/img/Hcmute-Logo-Vector.svg-.png">
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
                <c:choose>
                  <c:when test="${empty food.trangThaiMon or food.trangThaiMon eq 'con_hang'}">
                    <span class="badge bg-success text-uppercase">Còn hàng</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-secondary text-uppercase">Tạm ngừng</span>
                  </c:otherwise>
                </c:choose>
              </div>
              <c:choose>
                <c:when test="${empty food.moTa}">
                  <p class="fs-16 mb-4">Hiện chưa có mô tả chi tiết cho món ăn này.</p>
                </c:when>
                <c:otherwise>
                  <div class="fs-16 mb-4">
                    ${food.moTa}
                  </div>
                </c:otherwise>
              </c:choose>

              <c:choose>
                <c:when test="${empty food.trangThaiMon or food.trangThaiMon eq 'con_hang'}">
                  <form method="post" action="${pageContext.request.contextPath}/cart/add" class="d-flex align-items-center gap-3 mb-4 add-to-cart-form">
                    <input type="hidden" name="mon_an_id" value="${food.monAnId}" />
                    <div class="d-flex align-items-center gap-2">
                      <label for="qty" class="mb-0">Số lượng:</label>
                      <input type="number" id="qty" name="qty" value="1" min="1" class="form-control" style="width: 100px;" />
                    </div>
                    <button type="submit" class="theme-btn heading-font rounded-pill py-2 px-4">
                      Thêm vào giỏ hàng
                    </button>
                  </form>
                </c:when>
                <c:otherwise>
                  <p class="text-danger mb-4">Món ăn này hiện đang tạm ngừng phục vụ hoặc đã hết hàng, vui lòng chọn món khác.</p>
                </c:otherwise>
              </c:choose>

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

<script>
// Dùng chung handler submit /cart/add từ index (toast + cập nhật badge)
(function(){
  function showToast(msg, type){
    let t = document.getElementById('toast');
    if(!t){
      t = document.createElement('div');
      t.id = 'toast';
      t.style.cssText = 'position:fixed;bottom:24px;right:24px;background:#1f2937;color:#fff;padding:14px 18px;border-radius:12px;display:none;z-index:2000;box-shadow:0 8px 24px rgba(0,0,0,.25);font-size:14px;line-height:1.4;max-width:320px;';
      t.innerHTML = '<div style="display:flex;align-items:center;gap:8px;"><span id="toastIcon" style="font-size:18px;">✅</span><span id="toastMsg"></span></div>';
      document.body.appendChild(t);
    }
    const m = document.getElementById('toastMsg');
    const ic = document.getElementById('toastIcon');
    m.textContent = msg;
    if(type==='error'){ t.style.background='#b91c1c'; ic.textContent='⚠️'; }
    else if(type==='info'){ t.style.background='#1e3a8a'; ic.textContent='ℹ️'; }
    else if(type==='warn'){ t.style.background='#92400e'; ic.textContent='⚠️'; }
    else { t.style.background='#065f46'; ic.textContent='✅'; }
    t.style.display='block';
    t.style.opacity='1';
    t.style.transform='translateY(0)';
    setTimeout(()=>{
      t.style.opacity='0';
      t.style.transform='translateY(10px)';
      setTimeout(()=>{ t.style.display='none'; },400);
    },3000);
  }
  function updateHeaderBadges(totalQty){
    const badges = document.querySelectorAll('.count-quan,[data-cart-total-qty]');
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
    const form = e.target;
    if (!(form instanceof HTMLFormElement)) return;
    if (!form.action) return;
    const targetPath = (new URL(form.action, location.origin)).pathname;
    if (!targetPath.endsWith('/cart/add')) return;

    e.preventDefault();
    const monId = (form.querySelector('input[name="mon_an_id"]')||{}).value || (form.querySelector('button[data-mon-id]')||{}).getAttribute?.('data-mon-id') || '';
    const qty = (form.querySelector('input[name="qty"]')||{}).value || '1';
    const payload = new URLSearchParams();
    if(monId) payload.append('mon_an_id', monId);
    payload.append('qty', qty);
    payload.append('ajax','1');

    fetch(form.action, {
      method:'POST',
      body: payload,
      headers:{
        'X-Requested-With':'XMLHttpRequest',
        'Accept':'application/json',
        'Content-Type':'application/x-www-form-urlencoded'
      }
    })
      .then(async r=>{ let j; try{ j = await r.json(); }catch(_){ j = {status:'error', message:'Phản hồi không hợp lệ'}; } return { ok:r.ok, status:r.status, json:j }; })
      .then(out=>{
        const json = out.json || {};
        if(out.ok && (json.status==='ok' || json.success===true)){
          const totals = extractTotals(json);
          if(totals){
            const qtyNum = Math.max(0, parseInt(totals.qty||0,10));
            updateHeaderBadges(qtyNum);
          }
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
