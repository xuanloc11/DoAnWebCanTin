package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import service.ThongKeService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminStatsServlet", urlPatterns = "/admin/stats")
public class AdminStatsServlet extends HttpServlet {
    private final ThongKeService stats = new ThongKeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = session == null ? null : (User) session.getAttribute("authUser");
        if (auth == null) {
            resp.sendRedirect(req.getContextPath() + "/login?next=/admin/stats");
            return;
        }
        // Only admin role can view global stats
        if (!"bgh_admin".equalsIgnoreCase(auth.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ admin mới truy cập được thống kê");
            return;
        }

        // Read optional filters
        int days = 30;
        String daysParam = req.getParameter("days");
        if (daysParam != null) {
            try { days = Math.max(1, Math.min(365, Integer.parseInt(daysParam))); } catch (NumberFormatException ignored) {}
        }
        int top = 10;
        String topParam = req.getParameter("top");
        if (topParam != null) {
            try { top = Math.max(1, Math.min(100, Integer.parseInt(topParam))); } catch (NumberFormatException ignored) {}
        }

        List<ThongKeService.DailyCount> daily = stats.ordersCountByDay(days);
        List<ThongKeService.StallRevenue> stallRev = stats.revenueByStall(days);
        List<ThongKeService.TopDish> topDishes = stats.topDishes(top, days);

        req.setAttribute("days", days);
        req.setAttribute("top", top);
        req.setAttribute("daily", daily);
        req.setAttribute("stallRev", stallRev);
        req.setAttribute("topDishes", topDishes);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/stats.jsp").forward(req, resp);
    }
}

