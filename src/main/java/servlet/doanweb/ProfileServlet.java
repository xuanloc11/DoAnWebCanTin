package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.User;
import models.QuayHang;
import service.OrderService;
import service.QuayHangService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProfileServlet", urlPatterns = "/profile")
public class ProfileServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = session == null ? null : (User) session.getAttribute("authUser");
        if (auth == null) {
            resp.sendRedirect(req.getContextPath() + "/login?next=/profile");
            return;
        }
        List<Order> myOrders = orderService.byUser(auth.getUserId());
        // Build map id -> name for stalls
        Map<Integer, String> quayMap = new HashMap<>();
        try {
            List<QuayHang> quays = quayHangService.getAll();
            if (quays != null) {
                for (QuayHang q : quays) quayMap.put(q.getQuayHangId(), q.getTenQuayHang());
            }
        } catch (Exception ignored) {}
        req.setAttribute("quayMap", quayMap);
        req.setAttribute("me", auth);
        req.setAttribute("orders", myOrders);
        req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, resp);
    }
}
