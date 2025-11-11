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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UserServlet", urlPatterns = "/admin/users")
public class UserServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        List<User> users = userService.getAllUsers();
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            Integer qid = auth.getQuayHangId();
            List<User> filtered = new ArrayList<>();
            if (qid != null) {
                for (User u : users) {
                    if ("nhan_vien_quay".equalsIgnoreCase(u.getRole()) && qid.equals(u.getQuayHangId())) {
                        filtered.add(u);
                    }
                }
            }
            users = filtered;
        }
        req.setAttribute("users", users);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/users.jsp").forward(req, resp);
    }
}
