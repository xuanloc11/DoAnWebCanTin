package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Page;
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

        // Parse pagination params
        int page = 1;
        int size = 10;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
        try { size = Integer.parseInt(req.getParameter("size")); } catch (Exception ignored) {}
        if (page <= 0) page = 1;
        if (size <= 0) size = 10;

        List<User> users = userService.getAllUsers();

        // Hiện tại không còn role nhân viên quầy, nên trưởng quầy không bị giới hạn danh sách theo quầy ở đây
        // (quyền truy cập đã được kiểm soát ở Filter và các servlet khác nếu cần)

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

        // Apply pagination on filtered list
        int total = users.size();
        int fromIndex = Math.min((page - 1) * size, total);
        int toIndex = Math.min(fromIndex + size, total);
        List<User> pageContent = users.subList(fromIndex, toIndex);
        Page<User> pageObj = new Page<>(pageContent, page, size, total);

        req.setAttribute("users", pageContent);
        req.setAttribute("page", pageObj);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/users.jsp").forward(req, resp);
    }
}
