<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi" class="admin-page" data-bs-theme="light">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin - Quản lý món ăn</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20251021" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20251107" />
    <style>
        /* Dashboard polish */
        body.admin-page, .admin-shell { background-color: #f5f7fb; }
        .admin-main { min-height: 100vh; }
        .dashboard-header {
            backdrop-filter: blur(10px);
            background: linear-gradient(135deg, #ffffff 0%, #f6f8ff 100%);
            border-radius: 16px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.08);
            padding: 18px 20px;
        }
        .dashboard-title {
            font-size: 1.4rem;
            font-weight: 700;
        }
        .dashboard-subtitle {
            font-size: 0.9rem;
            color: #6b7280;
        }
        .stat-card {
            border-radius: 14px;
            border: 1px solid rgba(148, 163, 184, 0.25);
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
            transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
            background: #ffffff;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            border-color: rgba(59, 130, 246, 0.45);
            box-shadow: 0 18px 40px rgba(37, 99, 235, 0.15);
        }
        .stat-label { font-size: 0.78rem; text-transform: uppercase; letter-spacing: .06em; color:#6b7280; }
        .stat-value { font-size: 1.7rem; font-weight: 700; }
        .stat-chip { font-size: 0.76rem; border-radius: 999px; padding-inline: .7rem; }
        .filter-card {
            border-radius: 14px;
            border: 1px solid rgba(148, 163, 184, 0.35);
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.06);
            background: #ffffff;
        }
        #foodsTable thead th { font-size: 0.78rem; text-transform: uppercase; letter-spacing: .06em; }
        #foodsTable tbody td { font-size: 0.9rem; }
        .badge-quay { font-size: .78rem; border-radius: 999px; }
        .btn-ghost { border-radius: 999px; }
        .table-wrap-soft { border-radius: 14px; overflow: hidden; border: 1px solid rgba(148, 163, 184, 0.35); }
        .pagination-sm .page-link { border-radius: 999px !important; }
    </style>
</head>
<body class="bg-light admin-page">
<div class="admin-shell d-flex" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main flex-grow-1 container-fluid py-3">
        <!-- Dashboard header -->
        <div class="dashboard-header mb-3 d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div class="d-flex flex-column gap-1">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">Bảng điều khiển</span>
                    <span class="text-muted small">Admin / Món ăn</span>
                </div>
                <h1 class="dashboard-title mb-0">Quản lý món ăn</h1>
                <p class="dashboard-subtitle mb-0">Xem, tìm kiếm và quản lý toàn bộ món ăn trong căn tin.</p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm btn-ghost">
                    <span class="me-1">↩</span>Về trang chủ
                </a>
                <a class="btn btn-primary btn-sm rounded-pill" href="${pageContext.request.contextPath}/admin/monan/add">
                    <span class="me-1">＋</span>Thêm món ăn
                </a>
                <button id="themeToggle" type="button" class="btn btn-outline-secondary btn-sm rounded-pill" aria-label="Đổi giao diện" title="Đổi giao diện sáng/tối">🌓</button>
            </div>
        </div>

        <div class="admin-content">
            <!-- Stats cards -->
            <c:set var="total" value="${fn:length(foods)}"/>
            <div class="row g-3 mb-3">
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="stat-card p-3 h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="stat-label mb-1">Tổng số món</div>
                            <div class="stat-value">${total}</div>
                        </div>
                        <span class="stat-chip bg-primary-subtle text-primary-emphasis align-self-start mt-2">Tất cả quầy</span>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="stat-card p-3 h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="stat-label mb-1">Quầy đang quản lý</div>
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${not empty quayMap}">
                                        ${fn:length(quayMap)}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <span class="stat-chip bg-success-subtle text-success-emphasis align-self-start mt-2">Hoạt động</span>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="stat-card p-3 h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="stat-label mb-1">Giá trung bình</div>
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${not empty foods}">
                                        <fmt:formatNumber value="${avgPrice}" pattern="#,#00" />
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <span class="stat-chip bg-warning-subtle text-warning-emphasis align-self-start mt-2">Tham khảo</span>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="stat-card p-3 h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="stat-label mb-1">Trạng thái</div>
                            <div class="stat-value">${total > 0 ? 'Sẵn sàng' : 'Trống'}</div>
                        </div>
                        <span class="stat-chip bg-secondary-subtle text-secondary-emphasis align-self-start mt-2">Hệ thống</span>
                    </div>
                </div>
            </div>

            <!-- Toolbar: search + filter info -->
            <div class="filter-card mb-3" role="region" aria-label="Bộ lọc và tìm kiếm">
                <div class="card-body">
                    <div class="row g-3 align-items-end">
                        <div class="col-12 col-md-5 col-lg-4">
                            <label for="searchInput" class="form-label mb-1 small text-muted">Tìm kiếm món ăn</label>
                            <div class="input-group">
                                <span class="input-group-text" id="search-addon" aria-hidden="true">🔎</span>
                                <input id="searchInput" class="form-control" placeholder="Tìm theo tên món, mô tả..." autocomplete="off" aria-describedby="search-addon" />
                                <button id="clearQuery" type="button" class="btn btn-outline-secondary d-none" aria-label="Xóa tìm kiếm">×</button>
                            </div>
                        </div>
                        <div class="col-6 col-md-3 col-lg-2">
                            <label for="filterQuay" class="form-label mb-1 small text-muted">Quầy</label>
                            <select id="filterQuay" class="form-select form-select-sm" aria-label="Lọc theo quầy">
                                <option value="">Tất cả</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3 col-lg-2">
                            <label class="form-label mb-1 small text-muted">&nbsp;</label>
                            <button id="clearFilters" class="btn btn-outline-secondary w-100" type="button">Xóa bộ lọc</button>
                        </div>
                        <div class="col-12 col-md">
                            <div class="d-flex justify-content-md-end justify-content-start align-items-center gap-2">
                                <span id="rowCount" class="text-muted small" aria-live="polite"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table + pagination -->
            <c:choose>
                <c:when test="${not empty foods}">
                    <div class="table-wrap-soft bg-white mb-3">
                        <div class="table-responsive position-relative">
                            <table class="table table-hover table-striped table-bordered align-middle mb-0" id="foodsTable" aria-describedby="foods-help">
                                <thead class="table-light" style="position:sticky;top:0;z-index:2;">
                                <tr>
                                    <th class="sortable col-id" data-key="id" data-type="number" scope="col">ID <span class="sort-ind">↕</span></th>
                                    <th class="sortable" data-key="quay" data-type="text" scope="col">Quầy <span class="sort-ind">↕</span></th>
                                    <th class="sortable" data-key="ten" data-type="text" scope="col">Tên món <span class="sort-ind">↕</span></th>
                                    <th class="sortable" data-key="gia" data-type="number" scope="col">Giá (VND) <span class="sort-ind">↕</span></th>
                                    <th scope="col">Mô tả</th>
                                    <th scope="col">Ảnh</th>
                                    <th scope="col" class="text-nowrap">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="f" items="${foods}">
                                    <tr data-id="${f.monAnId}"
                                        data-quay="${empty quayMap ? f.quayHangId : (quayMap[f.quayHangId] != null ? quayMap[f.quayHangId] : f.quayHangId)}"
                                        data-ten="${f.tenMonAn}"
                                        data-gia="${f.gia}"
                                        data-mota="${fn:escapeXml(f.moTa)}">
                                        <td class="col-id fw-semibold">${f.monAnId}</td>
                                        <td>
                                            <span class="badge badge-quay bg-info-subtle text-info-emphasis">
                                                <c:out value="${empty quayMap ? f.quayHangId : (quayMap[f.quayHangId] != null ? quayMap[f.quayHangId] : f.quayHangId)}"/>
                                            </span>
                                        </td>
                                        <td>${f.tenMonAn}</td>
                                        <td><fmt:formatNumber value="${f.gia}" pattern="#,#00"/> VNĐ</td>
                                        <td class="text-truncate" style="max-width: 320px;"><c:out value="${f.moTa}"/></td>
                                        <td>
                                            <c:if test="${not empty f.hinhAnhUrl}">
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(f.hinhAnhUrl, 'http')}">
                                                        <img alt="${f.tenMonAn}" class="rounded border bg-white" style="width:64px;height:64px;object-fit:cover" src="${f.hinhAnhUrl}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img alt="${f.tenMonAn}" class="rounded border bg-white" style="width:64px;height:64px;object-fit:cover" src="${pageContext.request.contextPath}${f.hinhAnhUrl}" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm" role="group" aria-label="Hành động">
                                                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/monan/edit?id=${f.monAnId}">✏️ Sửa</a>
                                                <form action="${pageContext.request.contextPath}/admin/monan/delete" method="post" onsubmit="return confirm('Xóa món #${f.monAnId}?');" class="d-inline">
                                                    <input type="hidden" name="mon_an_id" value="${f.monAnId}" />
                                                    <button class="btn btn-outline-danger" type="submit">🗑️ Xóa</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info shadow-sm">Chưa có dữ liệu món ăn.</div>
                </c:otherwise>
            </c:choose>

            <!-- Pagination controls -->
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
                        <li class="page-item"><button id="prevPage" class="page-link px-3" type="button">‹ Trước</button></li>
                        <li class="page-item disabled"><span id="pageInfo" class="page-link px-3">Trang 1</span></li>
                        <li class="page-item"><button id="nextPage" class="page-link px-3" type="button">Sau ›</button></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<!-- Toast container -->
<div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1080;">
    <div id="toast" class="toast" role="status" aria-live="polite"></div>
</div>

<!-- Bootstrap JS (bundle) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=20251022"></script>
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
  const quaySel = document.getElementById('filterQuay');
  const themeToggle = document.getElementById('themeToggle');
  if(!table) return;
  const tbody = table.querySelector('tbody');
  const toText = (v) => (v ?? '').toString().toLowerCase();
  let state = { page: 1, perPage: parseInt(rowsPerSel?.value || '10', 10), totalFiltered: 0 };
  let totalRows = 0;

  function populateQuayOptions(){
    const seen = new Set();
    const frag = document.createDocumentFragment();
    Array.from(tbody.querySelectorAll('tr')).forEach(tr => {
      const quay = tr.dataset.quay || '';
      if (quay && !seen.has(quay)) {
        seen.add(quay);
        const opt = document.createElement('option');
        opt.value = quay;
        opt.textContent = quay;
        frag.appendChild(opt);
      }
    });
    quaySel.appendChild(frag);
  }

  function updateClearQuery(){
    if (clearQuery) {
      const show = (search.value || '').trim().length > 0;
      clearQuery.classList.toggle('d-none', !show);
    }
  }

  function applyFilters(){
    const q = toText(search.value);
    const quayFilter = (quaySel.value || '').toLowerCase();
    let matched = 0;
    tbody.querySelectorAll('tr').forEach(tr => {
      const ten = toText(tr.dataset.ten);
      const moTa = toText(tr.dataset.mota);
      const quay = toText(tr.dataset.quay);
      const matchText = !q || ten.includes(q) || moTa.includes(q);
      const matchQuay = !quayFilter || quay === quayFilter;
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
    const rows = Array.from(tbody.querySelectorAll('tr'));
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
      applyFilters();
      document.querySelectorAll('th.sortable .sort-ind').forEach(i=>i.textContent='↕');
      th.querySelector('.sort-ind').textContent = sortState.dir === 1 ? '↑' : '↓';
    });
  });

  search.addEventListener('input', applyFilters);
  quaySel.addEventListener('change', applyFilters);
  if (clearQuery) {
    clearQuery.addEventListener('click', () => { search.value=''; applyFilters(); search.focus(); });
  }
  rowsPerSel.addEventListener('change', () => { state.perPage = parseInt(rowsPerSel.value,10); state.page = 1; renderPage(); });
  prevBtn.addEventListener('click', () => { if (state.page > 1) { state.page--; renderPage(); } });
  nextBtn.addEventListener('click', () => { state.page++; renderPage(); });
  clearBtn.addEventListener('click', ()=>{ search.value=''; quaySel.value=''; applyFilters(); });

  // Theme toggle
  function applyTheme(theme){
    document.documentElement.setAttribute('data-bs-theme', theme);
    localStorage.setItem('adminTheme', theme);
  }
  const savedTheme = localStorage.getItem('adminTheme') || 'light';
  applyTheme(savedTheme);
  themeToggle.addEventListener('click', ()=>{
    const current = document.documentElement.getAttribute('data-bs-theme') || 'light';
    applyTheme(current === 'light' ? 'dark' : 'light');
  });

  // Toast from URL params
  const toast = document.getElementById('toast');
  const sp = new URLSearchParams(location.search);
  const msg = sp.get('msg');
  const type = sp.get('type') || 'success';
  if (msg && toast) {
    toast.textContent = decodeURIComponent(msg);
    toast.classList.add('show');
    if (type === 'success') toast.classList.add('text-bg-success');
    else if (type === 'error' || type === 'danger') toast.classList.add('text-bg-danger');
    else if (type === 'warning') toast.classList.add('text-bg-warning');
    else toast.classList.add('text-bg-secondary');
    setTimeout(()=>toast.classList.remove('show'), 2500);
    history.replaceState({}, '', location.pathname);
  }

  // initial
  totalRows = tbody.querySelectorAll('tr').length;
  populateQuayOptions();
  applyFilters();
})();
</script>
</body>
</html>
