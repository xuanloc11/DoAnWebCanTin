document.addEventListener('DOMContentLoaded', () => {
  const collapseBtn = document.getElementById('collapseBtn');
  const adminShell = document.querySelector('.admin-shell');
  const collapseText = collapseBtn.querySelector('.collapse-text');

  collapseBtn.addEventListener('click', () => {
    adminShell.classList.toggle('collapsed');
    const isCollapsed = adminShell.classList.contains('collapsed');
    collapseBtn.setAttribute('aria-expanded', !isCollapsed);
    if (collapseText) {
        collapseText.textContent = isCollapsed ? 'Mở rộng' : 'Thu gọn';
    }
  });
});

