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

@WebServlet(name = "AddUserServlet", urlPatterns = "/admin/users/add")
public class AddUserServlet extends HttpServlet {
    private final UserService service = new UserService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("mode", "create");
        // nạp danh sách quầy cho dropdown
        req.setAttribute("quays", quayHangService.getAll());
        req.getRequestDispatcher("/WEB-INF/jsp/admin/user-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        User u = new User();
        u.setHoTen(RequestUtil.s(req, "ho_ten"));
        u.setEmail(RequestUtil.s(req, "email"));
        u.setPassword(RequestUtil.s(req, "password"));
        String requestedRole = RequestUtil.s(req, "role");
        String role = sanitizeRole(requestedRole);
        Integer qid = null;
        String qh = RequestUtil.s(req, "quay_hang_id");
        if (qh != null && !qh.isEmpty()) {
            try { qid = Integer.parseInt(qh); } catch (NumberFormatException ignored) {}
        }

        // Nếu là trưởng quầy, không còn tạo nhân viên quầy riêng: ép tất cả user mới về vai trò học sinh trong đơn vị của họ
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            role = "hoc_sinh";
            // có thể giữ quayHangId nếu muốn gán sinh viên vào quầy, hoặc để null tùy yêu cầu nghiệp vụ
        }

        u.setRole(role);
        u.setDonVi(RequestUtil.s(req, "don_vi"));
        u.setQuayHangId(qid);
        service.create(u);
        String msg = URLEncoder.encode("Đã tạo người dùng", StandardCharsets.UTF_8);
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
