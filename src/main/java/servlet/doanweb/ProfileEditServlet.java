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

@WebServlet(name = "ProfileEditServlet", urlPatterns = "/profile/edit")
public class ProfileEditServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = session == null ? null : (User) session.getAttribute("authUser");
        if (auth == null) {
            resp.sendRedirect(req.getContextPath() + "/login?next=/profile/edit");
            return;
        }
        req.setAttribute("me", auth);
        req.getRequestDispatcher("/WEB-INF/jsp/profile-edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = session == null ? null : (User) session.getAttribute("authUser");
        if (auth == null) {
            resp.sendRedirect(req.getContextPath() + "/login?next=/profile/edit");
            return;
        }
        String hoTen = param(req, "ho_ten");
        String donVi = param(req, "don_vi");
        String password = param(req, "password");
        boolean changed = false;
        if (!hoTen.isBlank()) { auth.setHoTen(hoTen); changed = true; }
        if (!donVi.isBlank()) { auth.setDonVi(donVi); changed = true; }
        if (!password.isBlank()) { auth.setPassword(password); changed = true; }
        if (changed) {
            userService.update(auth);
            session.setAttribute("authUser", auth); // refresh session copy
            resp.sendRedirect(req.getContextPath() + "/profile?type=success&msg=Cập%20nhật%20thành%20công");
        } else {
            resp.sendRedirect(req.getContextPath() + "/profile/edit?type=warn&msg=Không%20có%20thay%20đổi");
        }
    }

    private String param(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v == null ? "" : v.trim();
    }
}

