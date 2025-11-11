<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý Menu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251022" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
    <style>
      .items-cell{ max-width:360px; }
      .item-chip{ display:inline-block; background:#f6f7f8; border:1px solid var(--border); padding:2px 6px; border-radius:999px; margin:1px 4px 1px 0; font-size:12px; }
      .muted{ color:var(--muted); }
    </style>
</head>
<body>
<div class="admin-shell" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main">
        <div class="admin-topbar">
            <div class="crumbs">Admin / Menu</div>
            <div class="admin-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-ghost btn-icon">↩ Về trang chủ</a>
                <a class="btn btn-primary btn-icon" href="${pageContext.request.contextPath}/admin/menu/add">＋ Thêm menu</a>
            </div>
        </div>
        <div class="admin-content">
            <div class="admin-head">
                <h1 class="admin-title">Quản lý Menu</h1>
            </div>
            <c:choose>
                <c:when test="${not empty menus}">
                    <div class="table-wrap">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="col-id">ID</th>
                                    <th>Ngày áp dụng</th>
                                    <th>Tên thực đơn</th>
                                    <th class="items-cell">Món</th>
                                    <th style="width:200px">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="m" items="${menus}">
                                    <c:set var="items" value="${menuItemsMap[m.menuId]}"/>
                                    <tr>
                                        <td class="col-id">${m.menuId}</td>
                                        <td><fmt:formatDate value="${m.ngayApDung}" pattern="dd/MM/yyyy"/></td>
                                        <td><c:out value="${m.tenThucDon}"/></td>
                                        <td class="items-cell">
                                            <c:choose>
                                              <c:when test="${not empty items}">
                                                <c:forEach var="it" items="${items}" varStatus="st">
                                                    <c:if test="${st.index < 3}">
                                                      <span class="item-chip"><c:out value="${it.tenMonAn}"/></span>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${fn:length(items) > 3}">
                                                  <span class="muted">+${fn:length(items) - 3} nữa</span>
                                                </c:if>
                                              </c:when>
                                              <c:otherwise>
                                                <span class="muted">(Chưa chọn món)</span>
                                              </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="table-actions" style="display:flex; gap:6px;">
                                                <a class="btn btn-small" href="${pageContext.request.contextPath}/admin/menu/edit?id=${m.menuId}">Sửa</a>
                                                <form action="${pageContext.request.contextPath}/admin/menu/delete" method="post" onsubmit="return confirm('Xóa menu này?');">
                                                    <input type="hidden" name="menu_id" value="${m.menuId}" />
                                                    <button type="submit" class="btn btn-small btn-danger">Xóa</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="muted">Chưa có dữ liệu menu.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
</body>
</html>
