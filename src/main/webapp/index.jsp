<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="service.MonAnService,java.util.List,models.MonAn" %>
<%@ page import="service.QuayHangService,models.QuayHang,java.util.Map,java.util.HashMap" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Căn Tin DHSPKT</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251021" />
</head>
<body data-context="${pageContext.request.contextPath}">
<%@ include file="/WEB-INF/jsp/partials/header.jspf" %>

<%
    // Fetch latest foods from DB (limit 9) and expose to JSTL as request attribute
    MonAnService monAnService = new MonAnService();
    List<MonAn> foods = monAnService.latest(9);
    request.setAttribute("foods", foods);
    // Build quầy map id -> name for display
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
%>

<main id="home">
    <!-- Hero -->
    <section class="hero">
        <div class="container hero-inner">
            <div class="hero-copy">
                <h1>Bữa ăn lành mạnh mọi học sinh</h1>
                <p>Cân bằng, giá cả phải chăng và phục vụ nhanh chóng giữa các lớp học. Được đội ngũ căng tin của chúng tôi chuẩn bị tươi ngon mỗi ngày.</p>
                <div class="cta-row">
                    <a class="btn btn-primary" href="#menu">Xem menu</a>
                    <!-- Add login CTA linking to /login -->

                </div>
                <ul class="hero-highlights">
                    <li>✔️ Ưu đãi đặc biệt hàng ngày</li>
                    <li>✔️ Các lựa chọn dành cho người ăn chay và người bị dị ứng</li>
                    <li>✔️ Giá cả phù hợp với sinh viên</li>
                </ul>
            </div>
            <div class="hero-art" aria-hidden="true">
                <div class="plate">
                    <div class="food food-1">🥗</div>
                    <div class="food food-2">🥪</div>
                    <div class="food food-3">🧃</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories replaced by Stall list -->
    <section id="menu" class="section">
        <div class="container">
            <div class="section-head">
                <h2>Danh sách quầy hàng</h2>
            </div>
            <c:choose>
              <c:when test="${not empty quays}">
                <div class="grid cards-4">
                  <c:forEach var="q" items="${quays}">
                    <article class="card stall-card ${selectedQuay == q.quayHangId ? 'active' : ''}">
                      <div class="card-icon" aria-hidden="true">🏪</div>
                      <h3><c:out value="${q.tenQuayHang}"/></h3>
                      <div class="stall-meta">
                        <span class="loc">📍 <c:out value="${empty q.viTri ? 'Chưa rõ' : q.viTri}"/></span>
                        <span class="stall-status">
                          <c:choose>
                            <c:when test="${empty q.trangThai}"><span class="badge status-on">Đang hoạt động</span></c:when>
                            <c:when test="${fn:toLowerCase(q.trangThai) eq 'hoat_dong' || fn:toLowerCase(q.trangThai) eq 'on'}"><span class="badge status-on">Đang hoạt động</span></c:when>
                            <c:when test="${fn:toLowerCase(q.trangThai) eq 'tam_ngung' || fn:toLowerCase(q.trangThai) eq 'off'}"><span class="badge status-off">Tạm ngưng</span></c:when>
                            <c:otherwise><span class="badge status-other"><c:out value="${q.trangThai}"/></span></c:otherwise>
                          </c:choose>
                        </span>
                      </div>
                      <a class="btn btn-primary" href="${pageContext.request.contextPath}/?quay=${q.quayHangId}#foods">Xem món của quầy</a>
                    </article>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <p class="muted">Không có quầy hàng nào để hiển thị.</p>
              </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Pricing -->
    <section id="pricing" class="section alt" aria-labelledby="pricing-title">
        <div class="container">
            <div class="section-head">
                <h2 id="pricing-title">Combo món ăn</h2>

            </div>
            <div class="grid cards-3 pricing-grid">
                <article class="card plan">
                    <header class="plan-head">
                        <h3>Combo bữa sáng</h3>
                        <span class="badge">Most Popular</span>
                    </header>
                    <p class="muted">1 bữa ăn chính + 1 nước uống</p>
                    <div class="price-tag"><span class="amount">40.000</span><span class="currency">VND</span></div>
                    <ul class="features">
                        <li>Bún bò / Hủ Tiếu / Cơm Tấm</li>
                        <li>Nước suối / Cà Phê / Trà Sữa</li>
                    </ul>
                    <button class="btn btn-primary" type="button">Chọn combo</button>
                </article>
                <article class="card plan">
                    <header class="plan-head">
                        <h3>Combo bữa trưa</h3>
                    </header>
                    <p class="muted">1 món chính + 1 nước uống </p>
                    <div class="price-tag"><span class="amount">45.000</span><span class="currency">VND</span></div>
                    <ul class="features">
                        <li>Bún bò / Hủ Tiếu / Cơm Phần(Tự chọn)</li>
                        <li>Nước suối / Cà Phê / Trà Sữa</li>
                    </ul>
                    <button class="btn btn-primary" type="button">Chọn combo</button>
                </article>
                <article class="card plan">
                    <header class="plan-head">
                        <h3>Combo ăn vặt</h3>
                    </header>
                    <p class="muted">1 Bánh + 1 Nước</p>
                    <div class="price-tag"><span class="amount">20.000</span><span class="currency">VND</span></div>
                    <ul class="features">
                        <li>Bánh Ngọt / Bánh Snack / Kẹo</li>
                        <li>Nước trái cây</li>
                    </ul>
                    <button class="btn btn-primary" type="button">Chọn combo</button>
                </article>
            </div>
        </div>
    </section>

    <!-- Latest foods from DB -->
    <section id="foods" class="section alt" aria-labelledby="foods-title">
        <div class="container">
            <div class="section-head">
                <h2 id="foods-title">Món ăn mới nhất</h2>

            </div>

            <c:choose>
                <c:when test="${not empty foods}">
                    <div class="grid cards-3">
                        <c:forEach var="f" items="${foods}">
                            <article class="menu-item">
                                <div class="menu-media" aria-hidden="true">
                                    <c:choose>
                                        <c:when test="${not empty f.hinhAnhUrl}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(f.hinhAnhUrl, 'http')}">
                                                    <img src="${f.hinhAnhUrl}" alt="${f.tenMonAn}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 12px;" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}${f.hinhAnhUrl}" alt="${f.tenMonAn}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 12px;" />
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>🍽️</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="menu-body">
                                    <header class="menu-header">
                                        <h3>${f.tenMonAn}</h3>
                                        <span class="price">
                                            <fmt:formatNumber value="${f.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                        </span>
                                    </header>
                                    <p><c:out value="${empty f.moTa ? 'Không có mô tả' : f.moTa}"/></p>
                                    <ul class="tags">
                                        <li><c:out value="${empty quayMap ? f.quayHangId : (quayMap[f.quayHangId] != null ? quayMap[f.quayHangId] : f.quayHangId)}"/></li>
                                        <li>
                                          <c:choose>
                                            <c:when test="${empty f.trangThaiMon}">Còn hàng</c:when>
                                            <c:when test="${f.trangThaiMon eq 'con_hang' || f.trangThaiMon eq 'on' || f.trangThaiMon eq 'Đang bán' || f.trangThaiMon eq 'dang_ban'}">Còn hàng</c:when>
                                            <c:when test="${f.trangThaiMon eq 'het_hang' || f.trangThaiMon eq 'off' || f.trangThaiMon eq 'Ngừng bán' || f.trangThaiMon eq 'ngung_ban'}">Hết hàng</c:when>
                                            <c:otherwise><c:out value="${f.trangThaiMon}"/></c:otherwise>
                                          </c:choose>
                                        </li>
                                    </ul>
                                    <form method="post" action="${pageContext.request.contextPath}/cart/add">
                                      <input type="hidden" name="mon_an_id" value="${f.monAnId}" />
                                      <input type="hidden" name="qty" value="1" />
                                      <button class="btn btn-primary" type="submit" data-mon-id="${f.monAnId}">Thêm vào giỏ</button>
                                    </form>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="muted">Chưa có món ăn nào để hiển thị.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- About / Hours -->
    <section id="about" class="section alt">
        <div class="container about">
            <div class="about-copy">
                <h2>Thông tin căn tin</h2>
                <p>Chúng tôi luôn đặt dinh dưỡng, giá cả phải chăng và hương vị lên hàng đầu trong thực đơn để học sinh có thể tập trung vào việc học..</p>
                <ul class="bullets">
                    <li>Giờ mở cửa: 6:30 – 17:00 (Từ thứ 2 - thứ 7)</li>
                    <li>Địa chỉ: Bên phải tòa nhà A</li>

                </ul>
            </div>
            <div class="about-board" aria-label="Hours and contact">
                <div class="board">
                    <h3>Giờ mở bán:</h3>
                    <div class="rows">
                        <div class="row"><span>Đồ ăn sáng</span><span>7:00–9:00</span></div>
                        <div class="row"><span>Đồ ăn trưa</span><span>11:00–13:30</span></div>
                    </div>
                </div>
                <div class="board">
                    <h3>Liên Hệ</h3>
                    <div class="rows">
                        <div class="row"><span>Số điện thoại</span><span>(+84) 123-456-789</span></div>
                        <div class="row"><span>Email</span><span>cantin@hcmute.edu.vn</span></div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<div id="toast" class="toast" style="position:fixed;bottom:24px;right:24px;background:#1f2937;color:#fff;padding:14px 18px;border-radius:12px;display:none;z-index:200;box-shadow:0 8px 24px rgba(0,0,0,.25);font-size:14px;line-height:1.4;max-width:320px;">
  <div style="display:flex;align-items:center;gap:8px;">
    <span id="toastIcon" style="font-size:18px;">✅</span>
    <span id="toastMsg"></span>
  </div>
</div>
<script>
(function(){
  const CTX = document.body.getAttribute('data-context') || '';
  function formatPrice(num){
    try { const n = parseFloat(num); if(isNaN(n)) return num; return n.toLocaleString('vi-VN'); } catch(e){ return num; }
  }
  function showToast(msg, type){
    var t = document.getElementById('toast');
    var m = document.getElementById('toastMsg');
    var ic = document.getElementById('toastIcon');
    m.textContent = msg;
    if(type==='error'){ t.style.background='#b91c1c'; ic.textContent='⚠️'; }
    else if(type==='info'){ t.style.background='#1e3a8a'; ic.textContent='ℹ️'; }
    else if(type==='warn'){ t.style.background='#92400e'; ic.textContent='⚠️'; }
    else { t.style.background='#065f46'; ic.textContent='✅'; }
    t.style.display='block';
    t.style.opacity='1';
    t.style.transform='translateY(0)';
    setTimeout(()=>{ t.style.opacity='0'; t.style.transform='translateY(10px)'; setTimeout(()=>{ t.style.display='none'; },400); },3000);
  }
  function updateCartLink(data){
    var container = document.querySelector('.header-actions') || document.querySelector('nav.nav');
    if(!container) return;
    var link = container.querySelector('a.cart-link');
    if(!link){
      link = document.createElement('a');
      link.className='nav-link cart-link';
      link.href= CTX + '/cart';
      link.title='Giỏ hàng';
      link.setAttribute('aria-label','Giỏ hàng');
      container.prepend(link);
    } else {
      link.href = CTX + '/cart';
    }
    var totalQty = (data.cartTotals && typeof data.cartTotals.totalQuantity !== 'undefined') ? data.cartTotals.totalQuantity : (data.cart ? data.cart.totalQuantity : 0);
    var totalPrice = (data.cartTotals && data.cartTotals.totalPrice) ? data.cartTotals.totalPrice : (data.cart ? data.cart.totalPrice : 0);
    link.innerHTML = '<span class="icon" aria-hidden="true">🛒</span>'+
                     '<span class="qty" style="margin-left:4px;">'+ totalQty +' món</span>'+
                     '<span class="total" style="margin-left:6px;font-weight:600;">'+ formatPrice(totalPrice) +' VND</span>';
  }
  // Intercept submit events
  document.addEventListener('submit', function(e){
    var form = e.target;
    if (!(form instanceof HTMLFormElement)) return;
    if (!form.action || !form.action.endsWith('/cart/add')) return;
    e.preventDefault();
    var monIdInput = form.querySelector('input[name="mon_an_id"]');
    var qtyInput = form.querySelector('input[name="qty"]');
    var btnNode = form.querySelector('button[data-mon-id]');
    var dataId = btnNode ? btnNode.getAttribute('data-mon-id') : '';
    var monId = monIdInput ? monIdInput.value : (dataId || '');
    var qty = qtyInput ? qtyInput.value : '1';
    var payload = new URLSearchParams();
    if(monId) payload.append('mon_an_id', monId);
    payload.append('qty', qty);
    payload.append('ajax','1');
    fetch(form.action, { method:'POST', body: payload, headers:{'X-Requested-With':'XMLHttpRequest','Accept':'application/json','Content-Type':'application/x-www-form-urlencoded'} })
      .then(async r=>{ let j; try{ j = await r.json(); }catch(_){ j = {status:'error', message:'Phản hồi không hợp lệ'}; } return { ok:r.ok, status:r.status, json:j }; })
      .then(out=>{
        const json = out.json || {};
        if(out.ok && json.status==='ok'){
          updateCartLink(json);
          showToast((json.message||'Đã thêm vào giỏ hàng') + ' (+'+(json.quantityAdded||1)+')', 'success');
        } else {
          const msg = json.message || ('Lỗi ('+out.status+') khi thêm vào giỏ');
          showToast(msg, 'error');
        }
      })
      .catch(()=> showToast('Không thể thêm vào giỏ hàng', 'error'));
  });

  // Legacy click handler kept for safety
  document.addEventListener('click', function(e){
    var btn = e.target.closest('form[action$="/cart/add"] button');
    if(!btn) return;
    var form = btn.closest('form');
    if(!form) return;
    // Submit handler above will catch and do ajax
  });
})();
</script>
<%@ include file="/WEB-INF/jsp/partials/footer.jspf" %>
</body>
</html>
