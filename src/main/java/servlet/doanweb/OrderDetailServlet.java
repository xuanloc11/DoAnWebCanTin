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
import java.math.BigDecimal;
import java.util.*;

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
        Order baseOrder = orderService.get(id);
        if (baseOrder == null || baseOrder.getUserId() != auth.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        // Load items for this order
        List<OrderItem> items = itemService.byOrder(baseOrder.getOrderId());
        Map<Integer, MonAn> monMap = new HashMap<>();
        for (OrderItem it : items) {
            MonAn m = monAnService.get(it.getMonAnId());
            if (m != null) monMap.put(it.getMonAnId(), m);
        }

        // Determine if multi-stall group (other orders same timestamp to the second)
        List<Order> allUserOrders = orderService.byUser(auth.getUserId());
        List<Order> sameTsOrders = new ArrayList<>();
        long baseSec = baseOrder.getThoiGianDat() == null ? -1L : baseOrder.getThoiGianDat().getTime() / 1000L;
        if (baseSec > 0) {
            for (Order o : allUserOrders) {
                if (o.getThoiGianDat() != null && (o.getThoiGianDat().getTime() / 1000L) == baseSec) {
                    sameTsOrders.add(o);
                }
            }
        }
        boolean isGrouped = sameTsOrders.size() > 1;
        // If grouped, build a merged item view across all stall orders
        List<OrderItem> mergedItems = new ArrayList<>();
        Map<Integer, MonAn> mergedMonMap = new HashMap<>();
        BigDecimal mergedTotal = BigDecimal.ZERO;
        List<String> stallNames = new ArrayList<>();
        Set<Integer> seenStalls = new HashSet<>();
        if (isGrouped) {
            for (Order o : sameTsOrders) {
                // Stall name
                try {
                    QuayHang q = quayHangService.get(o.getQuayHangId());
                    if (q != null && seenStalls.add(q.getQuayHangId())) stallNames.add(q.getTenQuayHang());
                } catch (Exception ignored) {}
                List<OrderItem> its = itemService.byOrder(o.getOrderId());
                for (OrderItem it : its) {
                    mergedItems.add(it);
                    MonAn m = monAnService.get(it.getMonAnId());
                    if (m != null) mergedMonMap.put(m.getMonAnId(), m);
                    if (it.getDonGiaMonAnLucDat() != null) {
                        mergedTotal = mergedTotal.add(it.getDonGiaMonAnLucDat().multiply(BigDecimal.valueOf(it.getSoLuong())));
                    }
                }
            }
        }

        // Resolve stall name for single order context
        String stallName = null;
        try {
            QuayHang stall = quayHangService.get(baseOrder.getQuayHangId());
            if (stall != null) stallName = stall.getTenQuayHang();
        } catch (Exception ignored) {}

        req.setAttribute("order", baseOrder);
        req.setAttribute("items", items);
        req.setAttribute("monMap", monMap);
        req.setAttribute("stallName", stallName);
        req.setAttribute("isGrouped", isGrouped);
        if (isGrouped) {
            req.setAttribute("groupOrders", sameTsOrders);
            req.setAttribute("mergedItems", mergedItems);
            req.setAttribute("mergedMonMap", mergedMonMap);
            req.setAttribute("mergedTotal", mergedTotal);
            req.setAttribute("mergedStallsDisplay", String.join(", ", new LinkedHashSet<>(stallNames)));
        }
        req.getRequestDispatcher("/WEB-INF/jsp/order-detail.jsp").forward(req, resp);
    }
}
