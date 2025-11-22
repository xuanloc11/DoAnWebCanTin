package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.MonAnService;
import service.QuayHangService;
import service.ThongKeService;



import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@WebServlet(name = "AdminDashboardServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();
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
            BigDecimal revenueToday = thongKeService.revenueToday();
            dashboard.put("revenueToday", revenueToday);
        } catch (Exception e) {
            dashboard.put("revenueToday", BigDecimal.ZERO);
        }

        try {
            List<ThongKeService.TopDish> tops = thongKeService.topDishes(5, days);
            dashboard.put("topDishes", tops != null ? tops : Collections.emptyList());
        } catch (Exception e) {
            dashboard.put("topDishes", Collections.emptyList());
        }

        try {
            List<ThongKeService.DailyCount> ordersByDay = thongKeService.ordersCountByDay(days);
            dashboard.put("ordersByDay", ordersByDay != null ? ordersByDay : Collections.emptyList());
        } catch (Exception e) {
            dashboard.put("ordersByDay", Collections.emptyList());
        }

        try {
            List<ThongKeService.StallRevenue> revenueByStall = thongKeService.revenueByStall(days);
            dashboard.put("revenueByStall", revenueByStall != null ? revenueByStall : Collections.emptyList());
        } catch (Exception e) {
            dashboard.put("revenueByStall", Collections.emptyList());
        }

        req.setAttribute("dashboard", dashboard);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(req, resp);
    }
}
