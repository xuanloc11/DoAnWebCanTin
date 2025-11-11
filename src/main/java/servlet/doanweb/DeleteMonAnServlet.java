package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.MonAn;
import models.User;
import service.MonAnService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "DeleteMonAnServlet", urlPatterns = "/admin/monan/delete")
public class DeleteMonAnServlet extends HttpServlet {
    private final MonAnService service = new MonAnService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = RequestUtil.i(req, "mon_an_id", 0);
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (id > 0) {
            MonAn m = service.get(id);
            if (m != null) {
                if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
                    Integer qid = auth.getQuayHangId();
                    if (qid == null || !qid.equals(m.getQuayHangId())) {
                        resp.sendRedirect(req.getContextPath() + "/admin");
                        return;
                    }
                }
                service.delete(id);
            }
        }
        String msg = URLEncoder.encode("Đã xóa món ăn", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin?type=success&msg=" + msg);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin");
    }
}
