package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Order;
import service.MonAnService;
import service.OrderService;
import service.QuayHangService;
import service.ThongKeService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();
    private final OrderService orderService = new OrderService();
    private final ThongKeService thongKeService = new ThongKeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> dashboard = new HashMap<>();

        try {
            int totalFoods = monAnService.all().size();
            dashboard.put("totalFoods", totalFoods);
        } catch (Exception e) {
            dashboard.put("totalFoods", 0);
        }

        try {
            int totalStalls = quayHangService.getAll().size();
            dashboard.put("totalStalls", totalStalls);
        } catch (Exception e) {
            dashboard.put("totalStalls", 0);
        }

        int days = 7;
        long orders7d = 0L;
        long revenue7d = 0L;
        try {
            for (ThongKeService.DailyCount d : thongKeService.ordersCountByDay(days)) {
                orders7d += d.getCount();
            }
            for (ThongKeService.StallRevenue r : thongKeService.revenueByStall(days)) {
                BigDecimal rev = r.getRevenue();
                if (rev != null) revenue7d += rev.longValue();
            }
        } catch (Exception ignored) {
        }
        dashboard.put("orders7d", orders7d);
        dashboard.put("revenue7d", revenue7d);

        try {
            List<Order> allOrders = orderService.getAllOrders();
            if (allOrders != null && !allOrders.isEmpty()) {
                allOrders.sort(Comparator.comparing(Order::getThoiGianDat, Comparator.nullsLast(Comparator.naturalOrder())).reversed());
                dashboard.put("recentOrders", allOrders.subList(0, Math.min(5, allOrders.size())));
            } else {
                dashboard.put("recentOrders", Collections.emptyList());
            }
        } catch (Exception e) {
            dashboard.put("recentOrders", Collections.emptyList());
        }

        try {
            List<ThongKeService.TopDish> tops = thongKeService.topDishes(5, days);
            dashboard.put("topDishes", tops != null ? tops : Collections.emptyList());
        } catch (Exception e) {
            dashboard.put("topDishes", Collections.emptyList());
        }

        req.setAttribute("dashboard", dashboard);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(req, resp);
    }
}
