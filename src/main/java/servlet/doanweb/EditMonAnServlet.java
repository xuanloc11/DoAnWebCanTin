package servlet.doanweb;

import Util.RequestUtil;
import Util.UploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import models.MonAn;
import models.User;
import service.MonAnService;
import service.QuayHangService;
import models.QuayHang;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name = "EditMonAnServlet", urlPatterns = "/admin/monan/edit")
@MultipartConfig
public class EditMonAnServlet extends HttpServlet {
    private final MonAnService service = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = RequestUtil.i(req, "id", 0);
        MonAn m = id > 0 ? service.get(id) : null;
        if (m == null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            if (auth.getQuayHangId() == null || !auth.getQuayHangId().equals(m.getQuayHangId())) {
                resp.sendRedirect(req.getContextPath() + "/admin");
                return;
            }
        }
        req.setAttribute("mode", "edit");
        req.setAttribute("monan", m);
        List<QuayHang> quays = quayHangService.getAll();
        req.setAttribute("quays", quays);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/monan-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int id = RequestUtil.i(req, "mon_an_id", 0);
        MonAn m = service.get(id);
        if (m == null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            if (auth.getQuayHangId() == null || !auth.getQuayHangId().equals(m.getQuayHangId())) {
                resp.sendRedirect(req.getContextPath() + "/admin");
                return;
            }
        }
        m.setQuayHangId(RequestUtil.i(req, "quay_hang_id", m.getQuayHangId()));
        m.setTenMonAn(RequestUtil.s(req, "ten_mon_an"));
        m.setMoTa(RequestUtil.s(req, "mo_ta"));
        m.setGia(Util.RequestUtil.bd(req, "gia", m.getGia() == null ? java.math.BigDecimal.ZERO : m.getGia()));

        // Image: if new file uploaded -> replace; else if URL provided -> set; else keep existing
        try {
            Part part = null;
            try { part = req.getPart("hinh_anh"); } catch (Exception ignore) {}
            if (part != null && part.getSize() > 0) {
                String newUpload = UploadUtil.saveImage(part, getServletContext(), "monan");
                if (newUpload != null) m.setHinhAnhUrl(newUpload);
            } else {
                String url = RequestUtil.s(req, "hinh_anh_url");
                if (url != null && !url.isEmpty()) m.setHinhAnhUrl(url);
            }
        } catch (Exception ex) {
            String msg = URLEncoder.encode("Lỗi upload ảnh: " + ex.getMessage(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/admin?type=error&msg=" + msg);
            return;
        }

        m.setTrangThaiMon(RequestUtil.s(req, "trang_thai_mon"));
        service.update(m);
        String msg = URLEncoder.encode("Đã lưu thay đổi", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin?type=success&msg=" + msg);
    }
}
