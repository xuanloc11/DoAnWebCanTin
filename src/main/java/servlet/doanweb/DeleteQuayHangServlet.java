package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.QuayHangService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "DeleteQuayHangServlet", urlPatterns = "/admin/quayhang/delete")
public class DeleteQuayHangServlet extends HttpServlet {
    private final QuayHangService service = new QuayHangService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = RequestUtil.i(req, "quay_hang_id", 0);
        if (id > 0) {
            service.delete(id);
        }
        String msg = URLEncoder.encode("Đã xóa quầy hàng", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/quayhang?type=success&msg=" + msg);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/quayhang");
    }
}

