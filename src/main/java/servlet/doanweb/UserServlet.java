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

        // Restrict for truong_quay: can only see staff in their own stall
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

        // Apply search filters
        String q = req.getParameter("q");
        String role = req.getParameter("role");
        if ((q != null && !q.trim().isEmpty()) || (role != null && !role.trim().isEmpty())) {
            String keyword = (q != null) ? q.trim().toLowerCase() : null;
            String roleFilter = (role != null && !role.trim().isEmpty()) ? role.trim().toLowerCase() : null;
            List<User> searched = new ArrayList<>();
            for (User u : users) {
                boolean match = true;
                if (keyword != null && !keyword.isEmpty()) {
                    String name = u.getHoTen() != null ? u.getHoTen().toLowerCase() : "";
                    String email = u.getEmail() != null ? u.getEmail().toLowerCase() : "";
                    String idStr = String.valueOf(u.getUserId());
                    match = name.contains(keyword) || email.contains(keyword) || idStr.contains(keyword);
                }
                if (match && roleFilter != null) {
                    String r = u.getRole() != null ? u.getRole().toLowerCase() : "";
                    match = r.equals(roleFilter);
                }
                if (match) searched.add(u);
            }
            users = searched;
        }

        req.setAttribute("users", users);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/users.jsp").forward(req, resp);
    }
}
