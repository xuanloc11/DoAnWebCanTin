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
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "StallDashboardServlet", urlPatterns = "/stall/dashboard")
public class  StallDashboardServlet extends HttpServlet {

    private final ThongKeService thongKeService = new ThongKeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = (session == null) ? null : (User) session.getAttribute("authUser");
        if (auth == null || auth.getQuayHangId() == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int stallId = auth.getQuayHangId();
        int days = parseIntOrDefault(req.getParameter("days"), 7);
        int top = parseIntOrDefault(req.getParameter("top"), 5);

        List<ThongKeService.DailyCount> daily = thongKeService.ordersCountByDayForStall(days, stallId);
        BigDecimal revenue7d = thongKeService.revenueForStall(days, stallId);
        BigDecimal revenueToday = thongKeService.revenueTodayForStall(stallId);
        List<ThongKeService.TopDish> topDishes = thongKeService.topDishesForStall(top, days, stallId);

        Map<String, Object> dashboard = new HashMap<>();
        dashboard.put("stallId", stallId);
        dashboard.put("days", days);
        dashboard.put("totalOrders", daily.stream().mapToInt(ThongKeService.DailyCount::getCount).sum());
        dashboard.put("revenue7d", revenue7d);
        dashboard.put("revenueToday", revenueToday);
        dashboard.put("topDishes", topDishes);
        dashboard.put("daily", daily);

        req.setAttribute("dashboard", dashboard);
        req.setAttribute("days", days);
        req.setAttribute("top", top);

        req.getRequestDispatcher("/WEB-INF/jsp/stall/dashboard.jsp").forward(req, resp);
    }

    private int parseIntOrDefault(String s, int def){
        if (s == null || s.isBlank()) return def;
        try { return Integer.parseInt(s); } catch (NumberFormatException e){ return def; }
    }
}

