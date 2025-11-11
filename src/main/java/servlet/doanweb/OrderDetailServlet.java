package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.OrderItem;
import models.MonAn;
import models.User;
import models.QuayHang;
import service.OrderService;
import service.OrderItemService;
import service.MonAnService;
import service.QuayHangService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderDetailServlet", urlPatterns = "/profile/order")
public class OrderDetailServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final OrderItemService itemService = new OrderItemService();
    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = session == null ? null : (User) session.getAttribute("authUser");
        if (auth == null) {
            resp.sendRedirect(req.getContextPath() + "/login?next=/profile");
            return;
        }
        int id;
        try { id = Integer.parseInt(req.getParameter("id")); } catch (Exception e){ id = 0; }
        if (id <= 0) { resp.sendRedirect(req.getContextPath() + "/profile"); return; }
        Order o = orderService.get(id);
        if (o == null || o.getUserId() != auth.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }
        List<OrderItem> items = itemService.byOrder(o.getOrderId());
        Map<Integer, MonAn> monMap = new HashMap<>();
        for (OrderItem it : items) {
            MonAn m = monAnService.get(it.getMonAnId());
            if (m != null) monMap.put(it.getMonAnId(), m);
        }
        // Resolve stall name
        String stallName = null;
        try {
            models.QuayHang stall = quayHangService.get(o.getQuayHangId());
            if (stall != null) stallName = stall.getTenQuayHang();
        } catch (Exception ignored) {}
        req.setAttribute("order", o);
        req.setAttribute("items", items);
        req.setAttribute("monMap", monMap);
        req.setAttribute("stallName", stallName);
        req.getRequestDispatcher("/WEB-INF/jsp/order-detail.jsp").forward(req, resp);
    }
}
