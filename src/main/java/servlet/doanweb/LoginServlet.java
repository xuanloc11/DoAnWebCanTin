package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import service.UserService;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If already logged in, redirect away from the login page
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("authUser") != null) {
            String next = sanitizeNext(req);
            if (next == null) {
                User u = (User) session.getAttribute("authUser");
                // default landing: admin -> admin dashboard; others -> home
                next = (u != null && u.getRole() != null && u.getRole().equalsIgnoreCase("bgh_admin"))
                        ? "/admin/management" : "/";
            }
            resp.sendRedirect(req.getContextPath() + next);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");

        User u = userService.authenticate(email, password);
        if (u == null) {
            req.setAttribute("error", "Email hoặc mật khẩu không đúng");
            req.setAttribute("email", email);
            // Preserve next for re-render
            req.setAttribute("next", req.getParameter("next"));
            req.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp").forward(req, resp);
            return;
        }
        HttpSession session = req.getSession(true);
        session.setAttribute("authUser", u);

        String next = sanitizeNext(req);
        if (next == null) {
            // default landing: admin -> admin dashboard; others -> home
            next = (u.getRole() != null && u.getRole().equalsIgnoreCase("bgh_admin")) ? "/admin/management" : "/";
        }
        resp.sendRedirect(req.getContextPath() + next);
    }

    private String trim(String s) { return s == null ? null : s.trim(); }

    private String sanitizeNext(HttpServletRequest req) {
        String raw = req.getParameter("next");
        if (raw == null || raw.isEmpty()) return null;
        String decoded = URLDecoder.decode(raw, StandardCharsets.UTF_8);
        // Only allow app-internal paths
        if (!decoded.startsWith("/")) return null;
        // Avoid double context path if someone passed it in
        String ctx = req.getContextPath();
        if (!ctx.isEmpty() && decoded.startsWith(ctx + "/")) {
            decoded = decoded.substring(ctx.length());
        }
        // Basic normalization: collapse multiple leading slashes
        while (decoded.startsWith("//")) decoded = decoded.substring(1);
        return decoded;
    }
}
