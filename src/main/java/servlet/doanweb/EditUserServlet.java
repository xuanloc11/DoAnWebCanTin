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

@WebServlet(name = "EditUserServlet", urlPatterns = "/admin/users/edit")
public class EditUserServlet extends HttpServlet {
    private final UserService service = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = RequestUtil.i(req, "id", 0);
        User u = id > 0 ? service.get(id) : null;
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            // Only allow edit if target is staff in same stall
            if (!"nhan_vien_quay".equalsIgnoreCase(u.getRole()) || auth.getQuayHangId() == null || !auth.getQuayHangId().equals(u.getQuayHangId())) {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }
        }
        req.setAttribute("mode", "edit");
        req.setAttribute("user", u);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/user-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = RequestUtil.i(req, "user_id", 0);
        User u = service.get(id);
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;

        // Manager can only edit staff in their stall
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            if (!"nhan_vien_quay".equalsIgnoreCase(u.getRole()) || auth.getQuayHangId() == null || !auth.getQuayHangId().equals(u.getQuayHangId())) {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }
        }

        u.setHoTen(RequestUtil.s(req, "ho_ten"));
        u.setEmail(RequestUtil.s(req, "email"));
        String password = RequestUtil.s(req, "password");
        if (password != null && !password.isEmpty()) {
            u.setPassword(password);
        }
        String role = sanitizeRole(RequestUtil.s(req, "role"));
        Integer qid = null;
        String qh = RequestUtil.s(req, "quay_hang_id");
        if (qh != null && !qh.isEmpty()) {
            try { qid = Integer.parseInt(qh); } catch (NumberFormatException ignored) {}
        }
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            // Force constraints for manager actions
            role = "nhan_vien_quay";
            qid = auth.getQuayHangId();
        }
        u.setRole(role);
        u.setDonVi(RequestUtil.s(req, "don_vi"));
        u.setQuayHangId(qid);
        service.update(u);
        String msg = URLEncoder.encode("Đã lưu thay đổi", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/users?type=success&msg=" + msg);
    }

    private String sanitizeRole(String role) {
        if (role == null) return "hoc_sinh";
        String r = role.trim();
        if (r.equalsIgnoreCase("bgh_admin")) return "bgh_admin";
        if (r.equalsIgnoreCase("nhan_vien_quay")) return "nhan_vien_quay";
        if (r.equalsIgnoreCase("truong_quay")) return "truong_quay";
        if (r.equalsIgnoreCase("hoc_sinh")) return "hoc_sinh";
        return "hoc_sinh";
    }
}
