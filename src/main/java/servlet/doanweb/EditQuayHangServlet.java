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

@WebServlet(name = "EditQuayHangServlet", urlPatterns = "/admin/quayhang/edit")
public class EditQuayHangServlet extends HttpServlet {
    private final QuayHangService service = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = RequestUtil.i(req, "id", 0);
        QuayHang q = id > 0 ? service.get(id) : null;
        if (q == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/quayhang");
            return;
        }
        req.setAttribute("mode", "edit");
        req.setAttribute("quay", q);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/quayhang-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = RequestUtil.i(req, "quay_hang_id", 0);
        QuayHang q = service.get(id);
        if (q == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/quayhang");
            return;
        }
        q.setTenQuayHang(RequestUtil.s(req, "ten_quay_hang"));
        q.setViTri(RequestUtil.s(req, "vi_tri"));
        q.setTrangThai(RequestUtil.s(req, "trang_thai"));
        service.update(q);
        String msg = URLEncoder.encode("Đã lưu thay đổi", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/quayhang?type=success&msg=" + msg);
    }
}
