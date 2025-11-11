package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Menu;
import models.User;
import service.MenuService;
import service.MenuMonAnService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "DeleteMenuServlet", urlPatterns = "/admin/menu/delete")
public class DeleteMenuServlet extends HttpServlet {
    private final MenuService service = new MenuService();
    private final MenuMonAnService linkService = new MenuMonAnService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = RequestUtil.i(req, "menu_id", 0);
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (id > 0) {
            Menu m = service.get(id);
            if (m != null) {
                // Manager can only delete menus of their stall
                if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
                    Integer qid = auth.getQuayHangId();
                    if (qid == null || !qid.equals(m.getQuayHangId())) {
                        resp.sendRedirect(req.getContextPath() + "/admin/menu");
                        return;
                    }
                }
                linkService.clear(id);
                service.delete(id);
            }
        }
        String msg = URLEncoder.encode("Đã xóa menu", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/menu?type=success&msg=" + msg);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/menu");
    }
}
