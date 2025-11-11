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
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name = "AddMonAnServlet", urlPatterns = "/admin/monan/add")
@MultipartConfig
public class AddMonAnServlet extends HttpServlet {
    private final MonAnService service = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("mode", "create");
        // Provide list of stalls for dropdown
        List<QuayHang> quays = quayHangService.getAll();
        req.setAttribute("quays", quays);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/monan-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        MonAn m = new MonAn();
        Integer qid = RequestUtil.i(req, "quay_hang_id", 0);
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole()) && auth.getQuayHangId() != null) {
            qid = auth.getQuayHangId();
        }
        m.setQuayHangId(qid);
        m.setTenMonAn(RequestUtil.s(req, "ten_mon_an"));
        m.setMoTa(RequestUtil.s(req, "mo_ta"));
        m.setGia(RequestUtil.bd(req, "gia", BigDecimal.ZERO));

        // Handle image: prefer uploaded file, fallback to URL
        String savedPath = null;
        try {
            Part part = null;
            try { part = req.getPart("hinh_anh"); } catch (Exception ignore) {}
            if (part != null && part.getSize() > 0) {
                savedPath = UploadUtil.saveImage(part, getServletContext(), "monan");
            }
        } catch (Exception ex) {
            String msg = URLEncoder.encode("Lỗi upload ảnh: " + ex.getMessage(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/admin?type=error&msg=" + msg);
            return;
        }
        if (savedPath != null) {
            m.setHinhAnhUrl(savedPath);
        } else {
            String url = RequestUtil.s(req, "hinh_anh_url");
            m.setHinhAnhUrl(url);
        }

        m.setTrangThaiMon(RequestUtil.s(req, "trang_thai_mon"));
        service.create(m);
        String msg = URLEncoder.encode("Đã tạo món ăn", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin?type=success&msg=" + msg);
    }
}
