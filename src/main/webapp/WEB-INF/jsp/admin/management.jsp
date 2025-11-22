<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="auth" value="${requestScope.authUser != null ? requestScope.authUser : sessionScope.authUser}" />
<c:set var="isStallStaff" value="${auth != null && (auth.role eq 'truong_quay' || auth.role eq 'nhan_vien_quay')}" />
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý món ăn</title>
    <link rel="shortcut icon" href="<c:url value='/assets/img/Hcmute-Logo-Vector.svg-.png' />" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
    <style>
        .food-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .food-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
        }
        .food-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid #e9ecef;
            transition: transform 0.2s ease-in-out;
        }
        .food-image:hover {
            transform: scale(1.05);
        }
        .table-food-row {
            transition: background-color 0.15s ease-in-out;
        }
        .table-food-row:hover {
            background-color: #f8f9fa !important;
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.35rem 0.75rem;
            font-weight: 500;
        }
        .status-badge.active {
            background-color: #198754;
            color: white;
        }
        .status-badge.inactive {
            background-color: #6c757d;
            color: white;
        }
        .price-highlight {
            font-weight: 600;
            color: #0d6efd;
        }
    </style>
</head>
<body class="bg-light admin-page">
<div class="admin-shell d-flex" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main flex-grow-1 container-fluid py-3">
        <!-- Dashboard header -->
        <div class="dashboard-header mb-4 d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">🍽️ Món ăn</span>
                    <span class="text-muted small">Admin / Quản lý món ăn</span>
                </div>
                <h1 class="dashboard-title mb-0">Quản lý món ăn</h1>
                <p class="dashboard-subtitle mb-0">
                    <c:choose>
                        <c:when test="${isStallStaff}">Xem, tìm kiếm và quản lý món ăn của quầy bạn.</c:when>
                        <c:otherwise>Xem, tìm kiếm và quản lý toàn bộ món ăn trong căn tin.</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm rounded-pill">🏠 Về trang chủ</a>
                <a class="btn btn-primary btn-sm rounded-pill" href="${pageContext.request.contextPath}/admin/monan/add">
                    <span>＋</span> Thêm món ăn
                </a>
                <button id="adminThemeToggle" type="button" class="btn btn-outline-secondary btn-sm rounded-pill" aria-label="Đổi giao diện">🌓</button>
            </div>
        </div>

        <!-- Summary Cards -->
        <%
            int total = 0;
            double avgPrice = 0.0;
            int activeCount = 0;
            int inactiveCount = 0;
            if (request.getAttribute("foods") != null) {
                java.util.List<models.MonAn> foods = (java.util.List<models.MonAn>) request.getAttribute("foods");
                total = foods.size();
                if (total > 0) {
                    double sum = 0;
                    for (models.MonAn f : foods) {
                        if (f.getGia() != null) {
                            sum += f.getGia().doubleValue();
                        }
                        String status = f.getTrangThaiMon();
                        if (status == null || status.isEmpty() ||
                                "con_hang".equals(status) || "on".equals(status) ||
                                "Đang bán".equals(status) || "dang_ban".equals(status)) {
                            activeCount++;
                        } else {
                            inactiveCount++;
                        }
                    }
                    avgPrice = sum / total;
                }
            }
        %>
        <div class="row g-3 mb-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 h-100 food-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="text-muted small text-uppercase">Tổng số món</div>
                            <span class="badge bg-primary-subtle text-primary-emphasis">🍽️</span>
                        </div>
                        <h3 class="mb-0 fw-bold">
                            <%= total %>
                        </h3>
                        <div class="text-muted small mt-1">
                            <c:choose>
                                <c:when test="${isStallStaff}">Món của quầy bạn</c:when>
                                <c:otherwise>Tất cả quầy</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 h-100 food-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="text-muted small text-uppercase">Giá trung bình</div>
                            <span class="badge bg-success-subtle text-success-emphasis">💰</span>
                        </div>
                        <h3 class="mb-0 fw-bold text-success">
                            <fmt:formatNumber value="<%= avgPrice %>" pattern="#,##0"/> VNĐ
                        </h3>
                        <div class="text-muted small mt-1">Giá trung bình các món</div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 h-100 food-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="text-muted small text-uppercase">Đang hoạt động</div>
                            <span class="badge bg-success-subtle text-success-emphasis">✅</span>
                        </div>
                        <h3 class="mb-0 fw-bold text-success">
                            <%= activeCount %>
                        </h3>
                        <div class="text-muted small mt-1">Món đang bán</div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card shadow-sm border-0 h-100 food-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="text-muted small text-uppercase">Đã ngừng</div>
                            <span class="badge bg-secondary-subtle text-secondary-emphasis">⏸️</span>
                        </div>
                        <h3 class="mb-0 fw-bold">
                            <%= inactiveCount %>
                        </h3>
                        <div class="text-muted small mt-1">Món tạm ngừng</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search and Filter -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body">
                <form method="get" class="row g-3 align-items-end">
                    <div class="col-12 col-md-4">
                        <label for="searchInput" class="form-label mb-1 small text-muted fw-semibold">🔍 Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text" id="search-addon">🔎</span>
                            <input id="searchInput" class="form-control form-control-sm"
                                   placeholder="Tìm theo tên món, mô tả..."
                                   autocomplete="off" />
                            <button id="clearQuery" type="button" class="btn btn-outline-secondary btn-sm d-none" aria-label="Xóa tìm kiếm">×</button>
                        </div>
                    </div>
                    <c:if test="${not isStallStaff && not empty quayMap}">
                        <div class="col-12 col-md-3">
                            <label for="quayFilter" class="form-label mb-1 small text-muted fw-semibold">🏪 Quầy hàng</label>
                            <select id="quayFilter" class="form-select form-select-sm">
                                <option value="">Tất cả quầy</option>
                                <c:forEach var="entry" items="${quayMap}">
                                    <option value="${entry.key}" ${quay_id eq entry.key ? 'selected' : ''}>
                                        <c:out value="${entry.value}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:if>
                    <div class="col-12 col-md-5 d-flex align-items-end gap-2">
                        <button id="clearFilters" class="btn btn-outline-secondary btn-sm rounded-pill" type="button">
                            <span>🔄</span> Xóa bộ lọc
                        </button>
                        <div class="ms-auto">
                            <span id="rowCount" class="text-muted small" aria-live="polite"></span>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Foods Table -->
        <c:choose>
            <c:when test="${not empty foods}">
                <div class="card shadow-sm border-0 mb-3">
                    <div class="card-header bg-white border-0 pb-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-semibold">📋 Danh sách món ăn</h5>
                            <span class="badge bg-primary-subtle text-primary-emphasis">
                                Tổng: <strong><%= total %></strong> món
                            </span>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0" id="foodsTable">
                                <thead class="table-light" style="position:sticky;top:0;z-index:2;">
                                <tr>
                                    <th class="sortable col-id" data-key="id" data-type="number" scope="col" style="width:80px;">
                                        ID <span class="sort-ind">↕</span>
                                    </th>
                                    <th scope="col" style="width:100px;">Ảnh</th>
                                    <th class="sortable" data-key="ten" data-type="text" scope="col">Tên món</th>
                                    <th class="sortable" data-key="quay" data-type="text" scope="col">Quầy</th>
                                    <th class="sortable" data-key="gia" data-type="number" scope="col">Giá (VNĐ)</th>
                                    <th scope="col">Mô tả</th>
                                    <th scope="col" style="width:120px;">Trạng thái</th>
                                    <th scope="col" style="width:180px;" class="text-center">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="f" items="${foods}">
                                    <tr class="table-food-row"
                                        data-id="${f.monAnId}"
                                        data-quay="${empty quayMap ? f.quayHangId : (quayMap[f.quayHangId] != null ? quayMap[f.quayHangId] : f.quayHangId)}"
                                        data-ten="${f.tenMonAn}"
                                        data-gia="${f.gia}"
                                        data-mota="${fn:escapeXml(f.moTa)}">
                                        <td class="col-id fw-semibold">#${f.monAnId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty f.hinhAnhUrl}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(f.hinhAnhUrl, 'http')}">
                                                            <img alt="${f.tenMonAn}" class="food-image" src="${f.hinhAnhUrl}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img alt="${f.tenMonAn}" class="food-image" src="${pageContext.request.contextPath}${f.hinhAnhUrl}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="food-image bg-light d-flex align-items-center justify-content-center text-muted">
                                                        <small>No Image</small>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex flex-column">
                                                <strong><c:out value="${f.tenMonAn}"/></strong>
                                                <small class="text-muted">ID: ${f.monAnId}</small>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-info-subtle text-info-emphasis">
                                                <c:out value="${empty quayMap ? f.quayHangId : (quayMap[f.quayHangId] != null ? quayMap[f.quayHangId] : f.quayHangId)}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="price-highlight">
                                                <fmt:formatNumber value="${f.gia}" pattern="#,##0"/> VNĐ
                                            </span>
                                        </td>
                                        <td class="text-truncate" style="max-width: 300px;" title="${fn:escapeXml(f.moTa)}">
                                            <c:choose>
                                                <c:when test="${empty f.moTa}">
                                                    <span class="text-muted small">(Không có mô tả)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="plainDesc" value="${fn:replace(fn:replace(fn:replace(f.moTa, '<p>', ''), '</p>', ''), '&nbsp;', ' ')}" />
                                                    <c:out value="${fn:substring(plainDesc, 0, 100)}${fn:length(plainDesc) > 100 ? '...' : ''}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${f.trangThaiMon eq 'con_hang' || f.trangThaiMon eq 'on' || f.trangThaiMon eq 'Đang bán' || f.trangThaiMon eq 'dang_ban' || f.trangThaiMon == null || empty f.trangThaiMon}">
                                                    <span class="badge status-badge active">✅ Còn hàng</span>
                                                </c:when>
                                                <c:when test="${f.trangThaiMon eq 'het_hang' || f.trangThaiMon eq 'off' || f.trangThaiMon eq 'Ngừng bán' || f.trangThaiMon eq 'ngung_ban'}">
                                                    <span class="badge status-badge inactive">⏸️ Hết hàng</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge status-badge inactive">⏸️ ${f.trangThaiMon}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2 justify-content-center">
                                                <a class="btn btn-outline-primary btn-sm rounded-pill"
                                                   href="${pageContext.request.contextPath}/admin/monan/edit?id=${f.monAnId}"
                                                   title="Sửa món ăn">
                                                    <span>✏️</span> Sửa
                                                </a>
                                                <form action="${pageContext.request.contextPath}/admin/monan/delete"
                                                      method="post"
                                                      onsubmit="return confirm('Bạn có chắc muốn xóa món #${f.monAnId} (${fn:escapeXml(f.tenMonAn)})?');"
                                                      class="d-inline">
                                                    <input type="hidden" name="mon_an_id" value="${f.monAnId}" />
                                                    <button class="btn btn-outline-danger btn-sm rounded-pill" type="submit" title="Xóa món ăn">
                                                        <span>🗑️</span> Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mt-3" aria-label="Phân trang danh sách">
                    <div class="d-flex align-items-center gap-2">
                        <label for="rowsPerPage" class="form-label mb-0 small">Số dòng mỗi trang</label>
                        <select id="rowsPerPage" class="form-select form-select-sm w-auto">
                            <option value="5">5</option>
                            <option value="10" selected>10</option>
                            <option value="20">20</option>
                            <option value="50">50</option>
                        </select>
                    </div>
                    <nav>
                        <ul class="pagination pagination-sm mb-0 gap-1">
                            <li class="page-item"><button id="prevPage" class="page-link rounded-pill px-3" type="button">‹ Trước</button></li>
                            <li class="page-item disabled"><span id="pageInfo" class="page-link px-3">Trang 1</span></li>
                            <li class="page-item"><button id="nextPage" class="page-link rounded-pill px-3" type="button">Sau ›</button></li>
                        </ul>
                    </nav>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center py-5">
                        <div class="mb-3">
                            <span style="font-size: 4rem;">🍽️</span>
                        </div>
                        <h5 class="text-muted">Chưa có dữ liệu món ăn</h5>
                        <p class="text-muted small mb-3">Hãy thêm món ăn mới vào hệ thống.</p>
                        <a href="${pageContext.request.contextPath}/admin/monan/add" class="btn btn-primary rounded-pill">
                            <span>＋</span> Thêm món ăn đầu tiên
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function(){
        const table = document.getElementById('foodsTable');
        const search = document.getElementById('searchInput');
        const clearQuery = document.getElementById('clearQuery');
        const clearBtn = document.getElementById('clearFilters');
        const rowCount = document.getElementById('rowCount');
        const rowsPerSel = document.getElementById('rowsPerPage');
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        const pageInfo = document.getElementById('pageInfo');
        const themeToggle = document.getElementById('adminThemeToggle');
        const quayFilter = document.getElementById('quayFilter');

        if(!table) return;
        const tbody = table.querySelector('tbody');
        const toText = (v) => (v ?? '').toString().toLowerCase();
        let state = { page: 1, perPage: parseInt(rowsPerSel?.value || '10', 10), totalFiltered: 0 };
        let totalRows = 0;

        function updateClearQuery(){
            if (clearQuery) {
                const show = (search.value || '').trim().length > 0;
                clearQuery.classList.toggle('d-none', !show);
            }
        }

        function applyFilters(){
            const q = toText(search.value);
            const quay = quayFilter ? quayFilter.value : '';
            let matched = 0;
            tbody.querySelectorAll('tr').forEach(tr => {
                const ten = toText(tr.dataset.ten);
                const moTa = toText(tr.dataset.mota);
                const quayValue = toText(tr.dataset.quay);
                const matchText = !q || ten.includes(q) || moTa.includes(q);
                const matchQuay = !quay || quayValue.includes(toText(quay));
                const match = matchText && matchQuay;
                tr.dataset.filtered = match ? '1' : '0';
                if (match) matched++;
            });
            state.totalFiltered = matched;
            state.page = 1;
            renderPage();
            rowCount.textContent = matched + ' mục (tổng ' + totalRows + ')';
            updateClearQuery();
        }

        let sortState = { key:null, dir:1 };
        function sortBy(key, type){
            const rows = Array.from(tbody.querySelectorAll('tr[data-filtered="1"]'));
            rows.sort((a,b)=>{
                let va = a.dataset[key];
                let vb = b.dataset[key];
                if (type === 'number') { va = parseFloat(va || '0'); vb = parseFloat(vb || '0'); }
                else { va = toText(va); vb = toText(vb); }
                if (va < vb) return -sortState.dir;
                if (va > vb) return  sortState.dir;
                return 0;
            });
            rows.forEach(r=>tbody.appendChild(r));
        }

        function renderPage(){
            const per = state.perPage;
            const startIndex = (state.page - 1) * per;
            let idx = 0;
            tbody.querySelectorAll('tr').forEach(tr => {
                if (tr.dataset.filtered === '1') {
                    const inPage = idx >= startIndex && idx < startIndex + per;
                    tr.style.display = inPage ? '' : 'none';
                    idx++;
                } else {
                    tr.style.display = 'none';
                }
            });
            const totalPages = Math.max(1, Math.ceil(state.totalFiltered / per));
            prevBtn.disabled = state.page <= 1;
            nextBtn.disabled = state.page >= totalPages;
            pageInfo.textContent = 'Trang ' + state.page + ' / ' + totalPages;
        }

        document.querySelectorAll('th.sortable').forEach(th => {
            th.style.cursor = 'pointer';
            th.addEventListener('click', () => {
                const key = th.dataset.key;
                const type = th.dataset.type;
                sortState.dir = (sortState.key === key) ? -sortState.dir : 1;
                sortState.key = key;
                sortBy(key, type);
                renderPage();
                document.querySelectorAll('th.sortable .sort-ind').forEach(i=>i.textContent='↕');
                th.querySelector('.sort-ind').textContent = sortState.dir === 1 ? '↑' : '↓';
            });
        });

        search.addEventListener('input', applyFilters);
        if (clearQuery) {
            clearQuery.addEventListener('click', () => { search.value=''; applyFilters(); search.focus(); });
        }
        if (quayFilter) {
            quayFilter.addEventListener('change', applyFilters);
        }
        rowsPerSel.addEventListener('change', () => { state.perPage = parseInt(rowsPerSel.value,10); state.page = 1; renderPage(); });
        prevBtn.addEventListener('click', () => { if (state.page > 1) { state.page--; renderPage(); } });
        nextBtn.addEventListener('click', () => { state.page++; renderPage(); });
        clearBtn.addEventListener('click', ()=>{
            search.value='';
            if (quayFilter) quayFilter.value='';
            applyFilters();
        });

        // Theme toggle
        function applyTheme(theme){
            document.documentElement.setAttribute('data-bs-theme', theme);
            localStorage.setItem('adminTheme', theme);
        }
        const savedTheme = localStorage.getItem('adminTheme') || 'light';
        applyTheme(savedTheme);
        if (themeToggle) {
            themeToggle.addEventListener('click', ()=>{
                const current = document.documentElement.getAttribute('data-bs-theme') || 'light';
                applyTheme(current === 'light' ? 'dark' : 'light');
            });
        }

        // initial
        totalRows = tbody.querySelectorAll('tr').length;
        applyFilters();
    })();
</script>
</body>
</html>
