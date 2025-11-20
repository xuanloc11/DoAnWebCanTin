<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin - Dashboard tổng quan</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
</head>
<body class="bg-light">
<div class="admin-shell d-flex" id="adminShell">
  <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
  <div class="admin-main flex-grow-1 container-fluid py-3">
    <div class="dashboard-header mb-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
      <div>
        <div class="d-flex align-items-center gap-2 mb-1">
          <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">Dashboard</span>
          <span class="text-muted small">Admin / Tổng quan</span>
        </div>
        <h1 class="dashboard-title mb-0">Tổng quan hệ thống</h1>
        <p class="dashboard-subtitle mb-0">Số liệu nhanh về món, đơn hàng, quầy và doanh thu.</p>
      </div>
      <div class="d-flex flex-wrap align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm rounded-pill">🏠 Về trang chủ</a>
        <button id="adminThemeToggle" type="button" class="btn btn-outline-secondary btn-sm rounded-pill" aria-label="Đổi giao diện" title="Đổi giao diện sáng/tối">🌓 Giao diện</button>
      </div>
    </div>

    <div class="row g-3 mb-3">
      <div class="col-12 col-sm-6 col-lg-3">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-body">
            <div class="text-muted small text-uppercase mb-1">Tổng số món</div>
            <h3 class="mb-0">
              <c:out value="${dashboard.totalFoods != null ? dashboard.totalFoods : 0}"/>
            </h3>
            <div class="text-muted small">Trong tất cả quầy</div>
          </div>
        </div>
      </div>
      <div class="col-12 col-sm-6 col-lg-3">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-body">
            <div class="text-muted small text-uppercase mb-1">Đơn hàng 7 ngày</div>
            <h3 class="mb-0">
              <c:out value="${dashboard.orders7d != null ? dashboard.orders7d : 0}"/>
            </h3>
            <div class="text-muted small">Tổng số đơn</div>
          </div>
        </div>
      </div>
      <div class="col-12 col-sm-6 col-lg-3">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-body">
            <div class="text-muted small text-uppercase mb-1">Doanh thu 7 ngày</div>
            <h3 class="mb-0">
              <fmt:formatNumber value="${dashboard.revenue7d != null ? dashboard.revenue7d : 0}" pattern="#,#00"/> VNĐ
            </h3>
            <div class="text-muted small">Tổng doanh thu</div>
          </div>
        </div>
      </div>
      <div class="col-12 col-sm-6 col-lg-3">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-body">
            <div class="text-muted small text-uppercase mb-1">Số quầy</div>
            <h3 class="mb-0">
              <c:out value="${dashboard.totalStalls != null ? dashboard.totalStalls : 0}"/>
            </h3>
            <div class="text-muted small">Đang được cấu hình</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Charts row -->
    <div class="row g-3 mb-3">
      <div class="col-12 col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Đơn theo ngày (7 ngày)</h5>
          </div>
          <div class="card-body">
            <canvas id="ordersByDayChart" height="200" aria-label="Biểu đồ đơn theo ngày" role="img"></canvas>
          </div>
        </div>
      </div>
      <div class="col-12 col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Doanh thu theo quầy (7 ngày)</h5>
          </div>
          <div class="card-body">
            <canvas id="revenueByStallChart" height="200" aria-label="Biểu đồ doanh thu theo quầy" role="img"></canvas>
          </div>
        </div>
      </div>
    </div>

    <div class="row g-3">
      <div class="col-12 col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Đơn gần đây</h5>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-link btn-sm">Xem tất cả</a>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty dashboard.recentOrders}">
                <div class="table-responsive">
                  <table class="table table-sm align-middle mb-0">
                    <thead class="table-light">
                      <tr>
                        <th>ID</th>
                        <th>Thời gian</th>
                        <th class="text-end">Tổng tiền</th>
                        <th>Trạng thái</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="o" items="${dashboard.recentOrders}">
                        <tr>
                          <td>${o.orderId}</td>
                          <td><fmt:formatDate value="${o.thoiGianDat}" pattern="dd/MM HH:mm"/></td>
                          <td class="text-end"><fmt:formatNumber value="${o.tongTien}" pattern="#,#00"/></td>
                          <td>
                            <c:choose>
                              <c:when test="${o.trangThaiOrder eq 'MOI_DAT'}">Mới đặt</c:when>
                              <c:when test="${o.trangThaiOrder eq 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
                              <c:when test="${o.trangThaiOrder eq 'DANG_GIAO'}">Đang giao</c:when>
                              <c:when test="${o.trangThaiOrder eq 'DA_GIAO'}">Đã giao</c:when>
                              <c:otherwise><c:out value="${o.trangThaiOrder}"/></c:otherwise>
                            </c:choose>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info mb-0">Chưa có đơn hàng nào gần đây.</div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <div class="col-12 col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Top món bán chạy (7 ngày)</h5>
            <a href="${pageContext.request.contextPath}/admin/stats" class="btn btn-link btn-sm">Chi tiết thống kê</a>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty dashboard.topDishes}">
                <div class="table-responsive">
                  <table class="table table-sm align-middle mb-0">
                    <thead class="table-light">
                      <tr>
                        <th>Món</th>
                        <th class="text-end">Số lượng</th>
                        <th class="text-end">Doanh thu</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="t" items="${dashboard.topDishes}">
                        <tr>
                          <td><c:out value="${t.tenMon}"/></td>
                          <td class="text-end">${t.soLuong}</td>
                          <td class="text-end"><fmt:formatNumber value="${t.doanhThu}" pattern="#,#00"/></td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info mb-0">Chưa có dữ liệu top món.</div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
(function(){
  const themeToggle = document.getElementById('adminThemeToggle');
  function applyTheme(theme){
    document.documentElement.setAttribute('data-bs-theme', theme);
    localStorage.setItem('adminTheme', theme);
  }
  const saved = localStorage.getItem('adminTheme') || 'light';
  applyTheme(saved);
  if (themeToggle) {
    themeToggle.addEventListener('click', function(){
      const current = document.documentElement.getAttribute('data-bs-theme') || 'light';
      applyTheme(current === 'light' ? 'dark' : 'light');
    });
  }
})();

// Chart.js placeholders; real data-driven charts are handled in stats.jsp
(function(){
  const ordersCtx = document.getElementById('ordersByDayChart');
  const revenueCtx = document.getElementById('revenueByStallChart');
  if (!ordersCtx || !revenueCtx) return;
  // Simple empty charts to avoid JSP/EL complexity on dashboard
  new Chart(ordersCtx, {
    type: 'bar',
    data: { labels: [], datasets: [{ label: 'Số đơn', data: [] }] },
    options: { responsive: true, maintainAspectRatio: false }
  });
  new Chart(revenueCtx, {
    type: 'pie',
    data: { labels: [], datasets: [{ data: [] }] },
    options: { responsive: true, maintainAspectRatio: false }
  });
})();
</script>
</body>
</html>
