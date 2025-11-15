<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin - Thống kê & Báo cáo</title>
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
          <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">Thống kê</span>
          <span class="text-muted small">Admin / Thống kê</span>
        </div>
        <h1 class="dashboard-title mb-0">Báo cáo & Thống kê</h1>
        <p class="dashboard-subtitle mb-0">Tổng quan đơn hàng, doanh thu và món bán chạy.</p>
      </div>
      <form method="get" class="d-flex align-items-center gap-2 flex-wrap">
        <label for="daysSel" class="form-label mb-0">Khoảng ngày:</label>
        <select id="daysSel" name="days" class="form-select form-select-sm w-auto">
          <option value="7" ${days==7? 'selected' : ''}>7 ngày</option>
          <option value="30" ${days==30? 'selected' : ''}>30 ngày</option>
          <option value="90" ${days==90? 'selected' : ''}>90 ngày</option>
          <option value="180" ${days==180? 'selected' : ''}>180 ngày</option>
          <option value="365" ${days==365? 'selected' : ''}>365 ngày</option>
        </select>
        <label for="topSel" class="form-label mb-0">Top món:</label>
        <select id="topSel" name="top" class="form-select form-select-sm w-auto">
          <option value="5" ${top==5? 'selected' : ''}>Top 5</option>
          <option value="10" ${top==10? 'selected' : ''}>Top 10</option>
          <option value="20" ${top==20? 'selected' : ''}>Top 20</option>
        </select>
        <button class="btn btn-primary btn-sm" type="submit">Áp dụng</button>
      </form>
    </div>

    <div class="row g-3">
      <div class="col-12 col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-white">
            <h5 class="mb-0">Số đơn theo ngày (${days} ngày)</h5>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty daily}">
                <div class="table-responsive">
                  <table class="table table-sm table-striped align-middle">
                    <thead class="table-light"><tr><th>Ngày</th><th class="text-end">Số đơn</th></tr></thead>
                    <tbody>
                      <c:forEach var="d" items="${daily}">
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
                <div class="alert alert-info mb-0">Không có dữ liệu.</div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <div class="col-12 col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-white">
            <h5 class="mb-0">Doanh thu theo quầy (VNĐ)</h5>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty stallRev}">
                <div class="table-responsive">
                  <table class="table table-sm table-striped align-middle">
                    <thead class="table-light"><tr><th>Quầy</th><th class="text-end">Doanh thu</th></tr></thead>
                    <tbody>
                      <c:forEach var="s" items="${stallRev}">
                        <tr>
                          <td><c:out value="${empty s.tenQuay ? ('#' + s.quayHangId) : s.tenQuay}"/></td>
                          <td class="text-end"><fmt:formatNumber value="${s.revenue}" pattern="#,##0"/></td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info mb-0">Không có dữ liệu.</div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <div class="col-12">
        <div class="card shadow-sm">
          <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Món bán chạy (Top ${top})</h5>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${not empty topDishes}">
                <div class="table-responsive">
                  <table class="table table-sm table-striped align-middle">
                    <thead class="table-light">
                      <tr>
                        <th>Món</th>
                        <th class="text-end">Số lượng</th>
                        <th class="text-end">Doanh thu (VNĐ)</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="t" items="${topDishes}">
                        <tr>
                          <td><c:out value="${t.tenMon}"/></td>
                          <td class="text-end">${t.soLuong}</td>
                          <td class="text-end"><fmt:formatNumber value="${t.doanhThu}" pattern="#,##0"/></td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info mb-0">Không có dữ liệu.</div>
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
