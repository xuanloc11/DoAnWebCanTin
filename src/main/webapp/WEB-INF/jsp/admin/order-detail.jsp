<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin - Chi tiết đơn #${order.orderId}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
  <style>
    .detail-card{ background:#fff; border:1px solid var(--border); border-radius: 14px; padding:16px; box-shadow: var(--shadow); }
    .meta{ display:grid; grid-template-columns: repeat(2, 1fr); gap:10px 16px; }
    .meta .row{ display:flex; gap:8px; }
    .meta .label{ color:var(--muted); min-width:120px; }
    .items{ margin-top:16px; }
    .items table{ width:100%; border-collapse: collapse; }
    .items th, .items td{ padding:10px 12px; border-bottom:1px solid var(--border); text-align:left; }
    .items th{ background: #fafafa; }
    .total-row{ font-weight:600; }
    .thumb{ width:44px; height:44px; object-fit:cover; border-radius:8px; border:1px solid var(--border); }
    .back{ margin-top:12px; }
    .status-badge{ display:inline-block; padding:4px 8px; border-radius:999px; font-size:12px; border:1px solid var(--border); background:#f8f9fb; }
  </style>
</head>
<body>
<div class="admin-shell" id="adminShell">
  <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
  <div class="admin-main">
    <div class="admin-topbar">
      <div class="crumbs">Admin / Đơn hàng / Chi tiết</div>
      <div class="admin-actions">
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-ghost btn-icon">↩ Danh sách</a>
      </div>
    </div>
    <div class="admin-content">
      <div class="detail-card">
        <h2>Đơn hàng #${order.orderId}</h2>
        <div class="meta" aria-label="Thông tin đơn hàng">
          <div class="row"><div class="label">Trạng thái</div>
            <div>
              <span class="status-badge">
                <c:choose>
                  <c:when test="${order.trangThaiOrder eq 'MOI_DAT'}">Mới đặt</c:when>
                  <c:when test="${order.trangThaiOrder eq 'DA_XAC_NHAN'}">Đã xác nhận</c:when>
                  <c:when test="${order.trangThaiOrder eq 'DANG_GIAO'}">Đang giao</c:when>
                  <c:when test="${order.trangThaiOrder eq 'DA_GIAO'}">Đã giao</c:when>
                  <c:otherwise><c:out value="${order.trangThaiOrder}"/></c:otherwise>
                </c:choose>
              </span>
            </div>
          </div>
          <div class="row"><div class="label">Thời gian đặt</div><div><fmt:formatDate value="${order.thoiGianDat}" pattern="dd/MM/yyyy HH:mm" /></div></div>
          <div class="row"><div class="label">Người dùng</div>
            <div>
              <c:choose>
                <c:when test="${not empty user}">
                  <strong><c:out value="${user.hoTen}"/></strong>
                  <span class="muted" style="margin-left:6px">(${user.donVi})</span>
                </c:when>
                <c:otherwise>
                  ID: ${order.userId}
                </c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="row"><div class="label">Quầy hàng</div><div><c:out value="${quay != null ? quay.tenQuayHang : order.quayHangId}"/></div></div>
          <div class="row"><div class="label">Tổng tiền (DB)</div><div><fmt:formatNumber value="${order.tongTien}" pattern="#,##0"/> ₫</div></div>
          <div class="row"><div class="label">Tổng tính lại</div><div><fmt:formatNumber value="${calcTotal}" pattern="#,##0"/> ₫</div></div>
          <div class="row" style="grid-column:1 / -1"><div class="label">Ghi chú</div><div><c:out value="${order.ghiChu}"/></div></div>
        </div>

        <div class="items" role="region" aria-label="Danh sách món">
          <h3>Món trong đơn</h3>
          <c:choose>
            <c:when test="${not empty items}">
              <table>
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Món</th>
                    <th>Đơn giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="it" items="${items}" varStatus="st">
                    <c:set var="m" value="${monMap[it.monAnId]}"/>
                    <tr>
                      <td>${st.index + 1}</td>
                      <td>
                        <div style="display:flex; align-items:center; gap:8px;">
                          <c:if test="${not empty m && not empty m.hinhAnhUrl}">
                            <c:choose>
                              <c:when test="${fn:startsWith(m.hinhAnhUrl, 'http')}">
                                <img class="thumb" src="${m.hinhAnhUrl}" alt="${m.tenMonAn}"/>
                              </c:when>
                              <c:otherwise>
                                <img class="thumb" src="${pageContext.request.contextPath}${m.hinhAnhUrl}" alt="${m.tenMonAn}"/>
                              </c:otherwise>
                            </c:choose>
                          </c:if>
                          <div>
                            <div><strong><c:out value="${m != null ? m.tenMonAn : 'Món'}"/></strong></div>
                            <div class="muted">ID món: ${it.monAnId}</div>
                          </div>
                        </div>
                      </td>
                      <td><fmt:formatNumber value="${it.donGiaMonAnLucDat}" pattern="#,##0"/> ₫</td>
                      <td>${it.soLuong}</td>
                      <td><fmt:formatNumber value="${lineTotals[it.orderItemId]}" pattern="#,##0"/> ₫</td>
                    </tr>
                  </c:forEach>
                </tbody>
                <tfoot>
                  <tr class="total-row">
                    <td colspan="4" style="text-align:right">Tổng</td>
                    <td><fmt:formatNumber value="${calcTotal}" pattern="#,##0"/> ₫</td>
                  </tr>
                </tfoot>
              </table>
            </c:when>
            <c:otherwise>
              <p class="muted">Đơn hàng chưa có món.</p>
            </c:otherwise>
          </c:choose>
        </div>
        <div class="back">
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/orders">← Quay lại danh sách</a>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
