<%@ page import="service.ThongKeService" %>
<%@ page import="java.math.BigDecimal" %>
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
            <div class="text-muted small">Tổng số quầy</div>
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
            <h5 class="mb-0">Doanh Thu Hôm Nay</h5>
          </div>
          <div class="card-body">
              <div class="d-flex flex-column align-items-center justify-content-center" style="min-height: 200px;">
                  <div class="text-muted small text-uppercase mb-2">Tổng doanh thu</div>
                  <h2 class="mb-0 text-primary">
                      <fmt:formatNumber value="${dashboard.revenueToday != null ? dashboard.revenueToday : 0}" pattern="#,#00"/> VNĐ
                  </h2>
                  <div class="text-muted small mt-2">
                      <%
                          java.util.Date now = new java.util.Date();
                          request.setAttribute("today", now);
                      %>
                      <fmt:formatDate value="${today}" pattern="dd/MM/yyyy"/>
                  </div>
                  <c:choose>
                      <c:when test="${dashboard.revenueToday != null && dashboard.revenueToday > 0}">
                          <div class="mt-3">
                              <span class="badge bg-success">Có doanh thu</span>
                          </div>
                      </c:when>
                      <c:otherwise>
                          <div class="mt-3">
                              <span class="badge bg-secondary">Chưa có doanh thu</span>
                          </div>
                      </c:otherwise>
                  </c:choose>
              </div>
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
    <%
      // Lấy dữ liệu từ dashboard
      java.util.Map<String, Object> dashboardMap = (java.util.Map<String, Object>) request.getAttribute("dashboard");
      java.util.List<ThongKeService.DailyCount> ordersByDay = dashboardMap != null ?
        (java.util.List<ThongKeService.DailyCount>) dashboardMap.get("ordersByDay") : null;
      java.util.List<ThongKeService.StallRevenue> revenueByStall = dashboardMap != null ?
        (java.util.List<ThongKeService.StallRevenue>) dashboardMap.get("revenueByStall") : null;
    %>

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
    var ordersLabels = [];
    var ordersData = [];
    <%
      if (ordersByDay != null && !ordersByDay.isEmpty()) {
        for (ThongKeService.DailyCount d : ordersByDay) {
          java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM");
          String dateStr = sdf.format(d.getDateSql()).replace("'", "\\'");
          int count = d.getCount();
    %>
    ordersLabels.push('<%= dateStr %>');
    ordersData.push(<%= count %>);
    <%
        }
      }
    %>
    new Chart(ordersCtx, {
    type: 'bar',
        data: {
            labels: ordersLabels,
            datasets: [{
                label: 'Số đơn',
                data: ordersData,
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        precision: 0
                    }
                }
            },
            plugins: {
                legend: {
                    display: true,
                    position: 'top'
                }
            }
        }
  });
    var revenueLabels = [];
    var revenueData = [];
    var revenueColors = [
        'rgba(255, 99, 132, 0.6)',
        'rgba(54, 162, 235, 0.6)',
        'rgba(255, 206, 86, 0.6)',
        'rgba(75, 192, 192, 0.6)',
        'rgba(153, 102, 255, 0.6)',
        'rgba(255, 159, 64, 0.6)'
    ];
    <%
      if (revenueByStall != null && !revenueByStall.isEmpty()) {
        for (ThongKeService.StallRevenue r : revenueByStall) {
          String tenQuay = r.getTenQuay() != null ? r.getTenQuay().replace("'", "\\'").replace("\"", "\\\"") : "";
          BigDecimal rev = r.getRevenue() != null ? r.getRevenue() : BigDecimal.ZERO;
          double revValue = rev.doubleValue();
    %>
    revenueLabels.push('<%= tenQuay %>');
    revenueData.push(<%= revValue %>);
    <%
        }
      }
    %>
  new Chart(revenueCtx, {
    type: 'pie',
      data: {
          labels: revenueLabels,
          datasets: [{
              label: 'Doanh thu (VNĐ)',
              data: revenueData,
              backgroundColor: revenueColors.slice(0, revenueLabels.length),
              borderWidth: 1
          }]
      },
      options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
              legend: {
                  display: true,
                  position: 'right'
              },
              tooltip: {
                  callbacks: {
                      label: function(context) {
                          const label = context.label || '';
                          const value = context.parsed || 0;
                          const formatted = new Intl.NumberFormat('vi-VN').format(value);
                          return label + ': ' + formatted + ' VNĐ';
                      }
                  }
              }
          }
      }
  });
})();
</script>
</body>
</html>
