<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.math.BigDecimal, service.ThongKeService, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Thống kê & Báo cáo</title>
    <link rel="shortcut icon" href="<c:url value='/assets/img/Hcmute-Logo-Vector.svg-.png' />" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
    <style>
        .stats-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
        }
        .chart-container {
            position: relative;
            height: 350px;
            margin: 1rem 0;
        }
        .stat-badge {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
        }
        .revenue-trend {
            font-size: 0.875rem;
            font-weight: 500;
        }
        .revenue-trend.up {
            color: #10b981;
        }
        .revenue-trend.down {
            color: #ef4444;
        }
    </style>
</head>
<body class="bg-light">
<div class="admin-shell d-flex" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main flex-grow-1 container-fluid py-3">
        <div class="dashboard-header mb-4 d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">📊 Thống kê</span>
                    <span class="text-muted small">Admin / Báo cáo chi tiết</span>
                </div>
                <h1 class="dashboard-title mb-0">Báo cáo & Thống kê</h1>
                <p class="dashboard-subtitle mb-0">Phân tích chi tiết về đơn hàng, doanh thu và hiệu suất bán hàng.</p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm rounded-pill">← Về Dashboard</a>
                <button id="adminThemeToggle" type="button" class="btn btn-outline-secondary btn-sm rounded-pill" aria-label="Đổi giao diện">🌓</button>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="card shadow-sm mb-4 border-0">
            <div class="card-body">
                <form method="get" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label for="daysSel" class="form-label mb-1 small fw-semibold">📅 Khoảng thời gian</label>
                        <select id="daysSel" name="days" class="form-select form-select-sm">
                            <option value="7" ${days==7? 'selected' : ''}>7 ngày gần đây</option>
                            <option value="30" ${days==30? 'selected' : ''}>30 ngày gần đây</option>
                            <option value="90" ${days==90? 'selected' : ''}>90 ngày gần đây</option>
                            <option value="180" ${days==180? 'selected' : ''}>180 ngày gần đây</option>
                            <option value="365" ${days==365? 'selected' : ''}>1 năm gần đây</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="topSel" class="form-label mb-1 small fw-semibold">🏆 Top món bán chạy</label>
                        <select id="topSel" name="top" class="form-select form-select-sm">
                            <option value="5" ${top==5? 'selected' : ''}>Top 5</option>
                            <option value="10" ${top==10? 'selected' : ''}>Top 10</option>
                            <option value="20" ${top==20? 'selected' : ''}>Top 20</option>
                            <option value="50" ${top==50? 'selected' : ''}>Top 50</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex align-items-end gap-2">
                        <button class="btn btn-primary btn-sm rounded-pill px-4" type="submit">🔄 Áp dụng</button>
                        <a href="${pageContext.request.contextPath}/admin/stats" class="btn btn-outline-secondary btn-sm rounded-pill">🔄 Mặc định</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Summary Cards -->
        <%
            int totalOrders = 0;
            BigDecimal totalRevenue = BigDecimal.ZERO;
            if (request.getAttribute("daily") != null) {
                java.util.List<ThongKeService.DailyCount> dailyList = (java.util.List<ThongKeService.DailyCount>) request.getAttribute("daily");
                for (ThongKeService.DailyCount d : dailyList) {
                    totalOrders += d.getCount();
                }
            }
            if (request.getAttribute("stallRev") != null) {
                java.util.List<ThongKeService.StallRevenue> stallRevList = (java.util.List<ThongKeService.StallRevenue>) request.getAttribute("stallRev");
                for (ThongKeService.StallRevenue s : stallRevList) {
                    if (s.getRevenue() != null) {
                        totalRevenue = totalRevenue.add(s.getRevenue());
                    }
                }
            }
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
        %>
        <div class="row g-3 mb-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 stats-card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div class="text-muted small text-uppercase fw-semibold">Tổng đơn hàng</div>
                            <span class="badge bg-primary-subtle text-primary-emphasis stat-badge">📦</span>
                        </div>
                        <h2 class="mb-0 fw-bold">${totalOrders}</h2>
                        <div class="text-muted small mt-1">Trong ${days} ngày</div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 stats-card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div class="text-muted small text-uppercase fw-semibold">Tổng doanh thu</div>
                            <span class="badge bg-success-subtle text-success-emphasis stat-badge">💰</span>
                        </div>
                        <h2 class="mb-0 fw-bold text-success">
                            <fmt:formatNumber value="${totalRevenue}" pattern="#,#00"/>
                        </h2>
                        <div class="text-muted small mt-1">VNĐ</div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 stats-card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div class="text-muted small text-uppercase fw-semibold">Số quầy</div>
                            <span class="badge bg-info-subtle text-info-emphasis stat-badge">🏪</span>
                        </div>
                        <h2 class="mb-0 fw-bold text-info">
                            <c:out value="${stallRev != null ? fn:length(stallRev) : 0}"/>
                        </h2>
                        <div class="text-muted small mt-1">Có doanh thu</div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 stats-card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div class="text-muted small text-uppercase fw-semibold">Đơn TB/ngày</div>
                            <span class="badge bg-warning-subtle text-warning-emphasis stat-badge">📈</span>
                        </div>
                        <h2 class="mb-0 fw-bold text-warning">
                            <fmt:formatNumber value="${days > 0 ? totalOrders / days : 0}" pattern="#,##0.0" maxFractionDigits="1"/>
                        </h2>
                        <div class="text-muted small mt-1">Trung bình</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row g-3 mb-4">
            <div class="col-12 col-lg-8">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white border-0 pb-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-semibold">📊 Biểu đồ đơn hàng theo ngày</h5>
                            <span class="badge bg-primary-subtle text-primary-emphasis">${days} ngày</span>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty daily}">
                                <div class="chart-container">
                                    <canvas id="ordersByDayChart"></canvas>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">Chưa có dữ liệu đơn hàng.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <div class="col-12 col-lg-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white border-0 pb-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-semibold">🥧 Doanh thu theo quầy</h5>
                            <span class="badge bg-success-subtle text-success-emphasis">${days} ngày</span>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty stallRev}">
                                <div class="chart-container">
                                    <canvas id="revenueByStallChart"></canvas>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">Chưa có dữ liệu doanh thu.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Revenue by Stall Table -->
        <div class="row g-3 mb-4">
            <div class="col-12 col-lg-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-semibold">💵 Doanh thu theo quầy hàng</h5>
                        <span class="badge bg-success-subtle text-success-emphasis">${days} ngày</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty stallRev}">
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm align-middle mb-0">
                                        <thead class="table-light">
                                        <tr>
                                            <th>Quầy hàng</th>
                                            <th class="text-end">Doanh thu</th>
                                            <th class="text-end">Tỷ lệ</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="s" items="${stallRev}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <span class="badge bg-primary-subtle text-primary-emphasis">🏪</span>
                                                        <c:out value="${empty s.tenQuay ? ('Quầy #' + s.quayHangId) : s.tenQuay}"/>
                                                    </div>
                                                </td>
                                                <td class="text-end fw-semibold">
                                                    <fmt:formatNumber value="${s.revenue}" pattern="#,##0"/> VNĐ
                                                </td>
                                                <td class="text-end">
                                                    <c:set var="sRev" value="${s.revenue != null ? s.revenue : 0}" />
                                                    <c:set var="pct" value="0" />
                                                    <c:if test="${totalRevenue > 0}">
                                                        <c:set var="pct" value="${(sRev / totalRevenue) * 100}" />
                                                    </c:if>
                                                    <span class="badge bg-info-subtle text-info-emphasis">
                              <fmt:formatNumber value="${pct}" pattern="#,##0.0" maxFractionDigits="1"/>%
                            </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">Chưa có dữ liệu doanh thu theo quầy.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="col-12 col-lg-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-semibold">📅 Đơn hàng theo ngày</h5>
                        <span class="badge bg-primary-subtle text-primary-emphasis">${days} ngày</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty daily}">
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm align-middle mb-0">
                                        <thead class="table-light">
                                        <tr>
                                            <th>Ngày</th>
                                            <th class="text-end">Số đơn</th>
                                            <th class="text-end">Xu hướng</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="d" items="${daily}" varStatus="loop">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <span class="badge bg-secondary-subtle text-secondary-emphasis">📅</span>
                                                        <fmt:formatDate value="${d.dateSql}" pattern="dd/MM/yyyy"/>
                                                    </div>
                                                </td>
                                                <td class="text-end fw-semibold">${d.count}</td>
                                                <td class="text-end">
                                                    <c:if test="${loop.index > 0}">
                                                        <c:set var="prevIdx" value="${loop.index - 1}" />
                                                        <c:set var="prevCount" value="0" />
                                                        <c:forEach var="dailyItem" items="${daily}" varStatus="dailyLoop">
                                                            <c:if test="${dailyLoop.index == prevIdx}">
                                                                <c:set var="prevCount" value="${dailyItem.count}" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:set var="currentCount" value="${d.count}" />
                                                        <c:set var="isUp" value="${currentCount > prevCount}" />
                                                        <c:set var="diff" value="${currentCount - prevCount}" />
                                                        <c:if test="${diff < 0}">
                                                            <c:set var="diff" value="${-diff}" />
                                                        </c:if>
                                                        <span class="revenue-trend ${isUp ? 'up' : 'down'}">
                                ${isUp ? '📈' : '📉'} ${isUp ? '+' : ''}${diff}
                              </span>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">Chưa có dữ liệu đơn hàng theo ngày.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Dishes -->
        <div class="row g-3">
            <div class="col-12">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-semibold">🏆 Top ${top} món bán chạy nhất</h5>
                        <span class="badge bg-warning-subtle text-warning-emphasis">${days} ngày</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty topDishes}">
                                <div class="table-responsive">
                                    <table class="table table-hover table-sm align-middle mb-0">
                                        <thead class="table-light">
                                        <tr>
                                            <th style="width: 50px">#</th>
                                            <th>Món ăn</th>
                                            <th class="text-end">Số lượng bán</th>
                                            <th class="text-end">Doanh thu</th>
                                            <th class="text-end" style="width: 150px">Tỷ lệ</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="t" items="${topDishes}" varStatus="loop">
                                            <tr>
                                                <td>
                            <span class="badge ${loop.index < 3 ? 'bg-warning text-dark' : 'bg-secondary'} rounded-pill">
                              #${loop.index + 1}
                            </span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <span class="badge bg-primary-subtle text-primary-emphasis">🍽️</span>
                                                        <strong><c:out value="${t.tenMon}"/></strong>
                                                    </div>
                                                </td>
                                                <td class="text-end fw-semibold">${t.soLuong}</td>
                                                <td class="text-end fw-semibold text-success">
                                                    <fmt:formatNumber value="${t.doanhThu}" pattern="#,##0"/> VNĐ
                                                </td>
                                                <td class="text-end">
                                                    <c:set var="tRev" value="${t.doanhThu != null ? t.doanhThu : 0}" />
                                                    <c:set var="tPct" value="0" />
                                                    <c:if test="${totalRevenue > 0}">
                                                        <c:set var="tPct" value="${(tRev / totalRevenue) * 100}" />
                                                    </c:if>
                                                    <div class="progress" style="height: 20px;">
                                                        <div class="progress-bar bg-success" role="progressbar"
                                                             style="width: ${tPct}%"
                                                             aria-valuenow="${tPct}"
                                                             aria-valuemin="0"
                                                             aria-valuemax="100">
                                                            <small><fmt:formatNumber value="${tPct}" pattern="#,##0.0" maxFractionDigits="1"/>%</small>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">Chưa có dữ liệu món bán chạy.</div>
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
</script>

<script>
    // Chart.js với dữ liệu thực
    (function(){
        const ordersCtx = document.getElementById('ordersByDayChart');
        const revenueCtx = document.getElementById('revenueByStallChart');

        // Biểu đồ đơn theo ngày (Line Chart)
        if (ordersCtx) {
            var ordersLabels = [];
            var ordersData = [];
            <%
              java.util.List<ThongKeService.DailyCount> dailyList = (java.util.List<ThongKeService.DailyCount>) request.getAttribute("daily");
              if (dailyList != null && !dailyList.isEmpty()) {
                for (ThongKeService.DailyCount d : dailyList) {
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
                type: 'line',
                data: {
                    labels: ordersLabels,
                    datasets: [{
                        label: 'Số đơn hàng',
                        data: ordersData,
                        borderColor: 'rgb(59, 130, 246)',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        pointBackgroundColor: 'rgb(59, 130, 246)',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top',
                            labels: {
                                font: { size: 12, weight: 'bold' },
                                padding: 15
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            callbacks: {
                                label: function(context) {
                                    return 'Số đơn: ' + context.parsed.y;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1,
                                precision: 0,
                                font: { size: 11 }
                            },
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            ticks: {
                                font: { size: 11 }
                            },
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        }

        // Biểu đồ doanh thu theo quầy (Doughnut Chart)
        if (revenueCtx) {
            var revenueLabels = [];
            var revenueData = [];
            var revenueColors = [
                'rgba(239, 68, 68, 0.8)',   // Red
                'rgba(59, 130, 246, 0.8)',  // Blue
                'rgba(245, 158, 11, 0.8)',  // Amber
                'rgba(16, 185, 129, 0.8)',  // Green
                'rgba(139, 92, 246, 0.8)',  // Purple
                'rgba(236, 72, 153, 0.8)',  // Pink
                'rgba(20, 184, 166, 0.8)',  // Teal
                'rgba(251, 146, 60, 0.8)'   // Orange
            ];
            <%
              java.util.List<ThongKeService.StallRevenue> stallRevList = (java.util.List<ThongKeService.StallRevenue>) request.getAttribute("stallRev");
              if (stallRevList != null && !stallRevList.isEmpty()) {
                for (ThongKeService.StallRevenue r : stallRevList) {
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
                type: 'doughnut',
                data: {
                    labels: revenueLabels,
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: revenueData,
                        backgroundColor: revenueColors.slice(0, revenueLabels.length),
                        borderWidth: 2,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'right',
                            labels: {
                                font: { size: 11 },
                                padding: 12,
                                boxWidth: 15
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.parsed || 0;
                                    const formatted = new Intl.NumberFormat('vi-VN').format(value);
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((value / total) * 100).toFixed(1);
                                    return label + ': ' + formatted + ' VNĐ (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }
    })();
</script>
</body>
</html>
