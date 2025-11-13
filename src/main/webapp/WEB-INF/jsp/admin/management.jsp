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
</head>
<body class="bg-light">
<div class="admin-shell d-flex" id="adminShell">
    <%@ include file="/WEB-INF/jsp/admin/partials/sidebar.jspf" %>
    <div class="admin-main flex-grow-1 container-fluid py-3">
        <!-- Topbar / Breadcrumb + actions -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-2">
            <nav aria-label="breadcrumb" class="mb-0">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">Admin</li>
                    <li class="breadcrumb-item active" aria-current="page">Món ăn</li>
                </ol>
            </nav>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm"><span class="me-1">↩</span>Về trang chủ</a>
                <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/admin/monan/add"><span class="me-1">＋</span>Thêm món ăn</a>
                <button id="themeToggle" type="button" class="btn btn-outline-secondary btn-sm" aria-label="Đổi giao diện" title="Đổi giao diện sáng/tối">🌓</button>
            </div>
        </div>

        <div class="admin-content">
            <!-- Stats cards -->
            <c:set var="total" value="${fn:length(foods)}"/>
            <div class="row g-3 mb-3">
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <div class="text-uppercase small text-muted">Tổng món</div>
                            <div class="display-6 fw-semibold">${total}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Toolbar: search + filter info -->
            <div class="card shadow-sm mb-3" role="region" aria-label="Bộ lọc và tìm kiếm">
                <div class="card-body">
                    <div class="row g-2 align-items-center">
                        <div class="col-12 col-md-5 col-lg-4">
                            <div class="input-group">
                                <span class="input-group-text" id="search-addon" aria-hidden="true">🔎</span>
                                <label for="searchInput" class="visually-hidden">Tìm kiếm món ăn</label>
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
                        <div class="col-6 col-md-auto">
                            <button id="clearFilters" class="btn btn-outline-secondary w-100" type="button">Xóa bộ lọc</button>
                        </div>
                        <div class="col-12 col-md">
                            <span id="rowCount" class="text-muted small" aria-live="polite"></span>
                        </div>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty foods}">
                    <div class="card shadow-sm">
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
                                        <td><c:out value="${empty quayMap ? f.quayHangId : (quayMap[f.quayHangId] != null ? quayMap[f.quayHangId] : f.quayHangId)}"/></td>
                                        <td>${f.tenMonAn}</td>
                                        <td><fmt:formatNumber value="${f.gia}" pattern="#,##0"/> VNĐ</td>
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
                    <div class="alert alert-info">Chưa có dữ liệu món ăn.</div>
                </c:otherwise>
            </c:choose>

            <!-- Pagination controls -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mt-3" aria-label="Phân trang danh sách">
                <div class="d-flex align-items-center gap-2">
                    <label for="rowsPerPage" class="form-label mb-0">Số dòng mỗi trang</label>
                    <select id="rowsPerPage" class="form-select form-select-sm w-auto">
                        <option value="5">5</option>
                        <option value="10" selected>10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                    </select>
                </div>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item"><button id="prevPage" class="page-link" type="button">‹ Trước</button></li>
                        <li class="page-item disabled"><span id="pageInfo" class="page-link">Trang 1</span></li>
                        <li class="page-item"><button id="nextPage" class="page-link" type="button">Sau ›</button></li>
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
    // Apply Bootstrap-like styles without JS API
    toast.classList.add('show');
    if (type === 'success') toast.classList.add('text-bg-success');
    else if (type === 'error' || type === 'danger') toast.classList.add('text-bg-danger');
    else if (type === 'warning') toast.classList.add('text-bg-warning');
    else toast.classList.add('text-bg-secondary');
    setTimeout(()=>toast.classList.remove('show'), 2500);
    // remove query params without reloading
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
