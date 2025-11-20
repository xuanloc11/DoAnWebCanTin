<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Dashboard trưởng quầy</title>
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
          <span class="text-muted small">Trưởng quầy / Tổng quan</span>
        </div>
        <h1 class="dashboard-title mb-0">Tổng quan quầy của bạn</h1>
        <p class="dashboard-subtitle mb-0">
          Chỉ số về số lượng đơn, doanh thu và các món bán chạy trong quầy của bạn.
        </p>
      </div>
      <div class="d-flex flex-wrap align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm rounded-pill">Về trang chủ</a>
      </div>
    </div>

    <c:set var="stallDashboard" value="${dashboard}" />

    <div class="row g-3 mb-3">
      <div class="col-12 col-sm-6 col-lg-4">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-body">
            <div class="text-muted small text-uppercase mb-1">
              Tổng đơn hàng (${stallDashboard.days} ngày)
            </div>
            <h3 class="mb-0">
              <c:out value="${stallDashboard.totalOrders != null ? stallDashboard.totalOrders : 0}"/>
            </h3>
          </div>
        </div>
      </div>
      <div class="col-12 col-sm-6 col-lg-4">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-body">
            <div class="text-muted small text-uppercase mb-1">
              Doanh thu (${stallDashboard.days} ngày)
            </div>
            <h3 class="mb-0">
              <fmt:formatNumber value="${stallDashboard.revenue7d != null ? stallDashboard.revenue7d : 0}" pattern="#,#00"/>
              VNĐ
            </h3>
          </div>
        </div>
      </div>
      <div class="col-12 col-sm-6 col-lg-4">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-body">
            <div class="text-muted small text-uppercase mb-1">Món bán chạy (Top)</div>
            <h3 class="mb-0">
              <c:out value="${stallDashboard.topDishes != null ? fn:length(stallDashboard.topDishes) : 0}" /> món
            </h3>
          </div>
        </div>
      </div>
    </div>

    <div class="row g-3">
      <div class="col-12 col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-white">
            <h5 class="mb-0">Số đơn theo ngày (${stallDashboard.days} ngày)</h5>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty stallDashboard.daily}">
                <div class="table-responsive">
                  <table class="table table-sm table-striped align-middle mb-0">
                    <thead class="table-light">
                      <tr>
                        <th>Ngày</th>
                        <th class="text-end">Số đơn</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="d" items="${stallDashboard.daily}">
                        <tr>
                          <td><fmt:formatDate value="${d.dateSql}" pattern="dd/MM/yyyy"/></td>
                          <td class="text-end">${d.count}</td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info mb-0">Chưa có dữ liệu.</div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <div class="col-12 col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-white">
            <h5 class="mb-0">Top món bán chạy</h5>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty stallDashboard.topDishes}">
                <div class="table-responsive">
                  <table class="table table-sm table-striped align-middle mb-0">
                    <thead class="table-light">
                      <tr>
                        <th>Món</th>
                        <th class="text-end">Số lượng</th>
                        <th class="text-end">Doanh thu</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="t" items="${stallDashboard.topDishes}">
                        <tr>
                          <td><c:out value="${t.tenMon}"/></td>
                          <td class="text-end">${t.soLuong}</td>
                          <td class="text-end">
                            <fmt:formatNumber value="${t.doanhThu}" pattern="#,#00"/>
                          </td>
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
</body>
</html>
