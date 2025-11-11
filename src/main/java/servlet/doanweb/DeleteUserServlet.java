package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import service.UserService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "DeleteUserServlet", urlPatterns = "/admin/users/delete")
public class DeleteUserServlet extends HttpServlet {
    private final UserService service = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = RequestUtil.i(req, "user_id", 0);
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (id > 0) {
            User target = service.get(id);
            if (target != null) {
                if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
                    // Only allow delete if staff in same stall
                    if (!"nhan_vien_quay".equalsIgnoreCase(target.getRole()) || auth.getQuayHangId() == null || !auth.getQuayHangId().equals(target.getQuayHangId())) {
                        resp.sendRedirect(req.getContextPath() + "/admin/users");
                        return;
                    }
                }
                service.delete(id);
            }
        }
        String msg = URLEncoder.encode("Đã xóa người dùng", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/users?type=success&msg=" + msg);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
