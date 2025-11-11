package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.QuayHang;
import service.QuayHangService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "AddQuayHangServlet", urlPatterns = "/admin/quayhang/add")
public class AddQuayHangServlet extends HttpServlet {
    private final QuayHangService service = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("mode", "create");
        req.getRequestDispatcher("/WEB-INF/jsp/admin/quayhang-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        QuayHang q = new QuayHang();
        q.setTenQuayHang(RequestUtil.s(req, "ten_quay_hang"));
        q.setViTri(RequestUtil.s(req, "vi_tri"));
        String trangThai = RequestUtil.s(req, "trang_thai");
        q.setTrangThai(trangThai == null || trangThai.isEmpty() ? "active" : trangThai);
        service.create(q);
        String msg = URLEncoder.encode("Đã tạo quầy hàng", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/quayhang?type=success&msg=" + msg);
    }
}
