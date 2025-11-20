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
import service.QuayHangService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "EditUserServlet", urlPatterns = "/admin/users/edit")
public class EditUserServlet extends HttpServlet {
    private final UserService service = new UserService();
    private final QuayHangService quayHangService = new QuayHangService();

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

        // Nếu là trưởng quầy, hiện tại không còn phân cấp nhân viên quầy riêng, cho phép chỉnh sửa thông tin cơ bản nhưng không đổi role vượt quyền
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            // Không cho trưởng quầy chỉnh tài khoản BGH admin
            if ("bgh_admin".equalsIgnoreCase(u.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }
        }

        // Đánh dấu nếu đây là tài khoản admin đang tự sửa chính mình, để JSP ẩn dropdown role
        if (auth != null && auth.getUserId() == u.getUserId() && "bgh_admin".equalsIgnoreCase(u.getRole())) {
            req.setAttribute("selfAdminEdit", true);
        }
        req.setAttribute("mode", "edit");
        req.setAttribute("user", u);
        // nạp danh sách quầy cho dropdown
        req.setAttribute("quays", quayHangService.getAll());
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

        // Trưởng quầy không được sửa tài khoản BGH admin
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole()) && "bgh_admin".equalsIgnoreCase(u.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        u.setHoTen(RequestUtil.s(req, "ho_ten"));
        u.setEmail(RequestUtil.s(req, "email"));
        String password = RequestUtil.s(req, "password");
        if (password != null && !password.isEmpty()) {
            u.setPassword(password);
        }

        String requestedRole = RequestUtil.s(req, "role");
        String role = sanitizeRole(requestedRole);

        Integer qid = null;
        String qh = RequestUtil.s(req, "quay_hang_id");
        if (qh != null && !qh.isEmpty()) {
            try { qid = Integer.parseInt(qh); } catch (NumberFormatException ignored) {}
        }

        // Nếu là trưởng quầy: không cho tự nâng quyền thành BGH admin, và không gán role vượt quyền
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            // Nếu người bị sửa là chính trưởng quầy, luôn giữ vai trò trưởng quầy
            if (auth.getUserId() == u.getUserId()) {
                role = "truong_quay";
            } else {
                // Với tài khoản khác, trưởng quầy chỉ chỉnh được thông tin, ép role về hoc_sinh hoặc giữ nguyên nếu đã là truong_quay/hoc_sinh
                if (!"truong_quay".equalsIgnoreCase(u.getRole())) {
                    role = "hoc_sinh";
                }
            }
        }

        // KHÓA: Admin không thể đổi role của chính mình, luôn giữ bgh_admin
        if (auth != null && auth.getUserId() == u.getUserId() && "bgh_admin".equalsIgnoreCase(u.getRole())) {
            role = "bgh_admin";
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
        if (r.equalsIgnoreCase("truong_quay")) return "truong_quay";
        if (r.equalsIgnoreCase("hoc_sinh")) return "hoc_sinh";
        return "hoc_sinh";
    }
}
