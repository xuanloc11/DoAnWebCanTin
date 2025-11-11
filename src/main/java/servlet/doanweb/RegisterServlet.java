package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;
import service.UserService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String hoTen = RequestUtil.s(req, "ho_ten");
        String email = RequestUtil.s(req, "email");
        String password = RequestUtil.s(req, "password");
        String confirm = RequestUtil.s(req, "confirm_password");

        // Basic validations
        if (hoTen == null || hoTen.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập họ tên");
            req.setAttribute("ho_ten", hoTen);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(req, resp);
            return;
        }
        if (email == null || !email.toLowerCase().endsWith("@student.hcmute.edu.vn")) {
            req.setAttribute("error", "Chỉ chấp nhận email @student.hcmute.edu.vn");
            req.setAttribute("ho_ten", hoTen);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(req, resp);
            return;
        }
        if (password == null || password.length() < 6) {
            req.setAttribute("error", "Mật khẩu tối thiểu 6 ký tự");
            req.setAttribute("ho_ten", hoTen);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(req, resp);
            return;
        }
        if (confirm == null || !password.equals(confirm)) {
            req.setAttribute("error", "Xác nhận mật khẩu không khớp");
            req.setAttribute("ho_ten", hoTen);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(req, resp);
            return;
        }

        // Uniqueness check
        if (userService.findByEmail(email) != null) {
            req.setAttribute("error", "Email đã tồn tại");
            req.setAttribute("ho_ten", hoTen);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(req, resp);
            return;
        }

        // Create user (default role: hoc_sinh; donVi/quayHangId null)
        User u = new User();
        u.setHoTen(hoTen);
        u.setEmail(email);
        u.setPassword(password);
        u.setRole("hoc_sinh");
        u.setDonVi(null);
        u.setQuayHangId(null);
        int id = userService.create(u);
        if (id <= 0) {
            req.setAttribute("error", "Không thể tạo tài khoản, vui lòng thử lại");
            req.setAttribute("ho_ten", hoTen);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(req, resp);
            return;
        }

        String msg = URLEncoder.encode("Đăng ký thành công, vui lòng đăng nhập", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/login?type=success&msg=" + msg + "&email=" + URLEncoder.encode(email, StandardCharsets.UTF_8));
    }
}
