package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Cart;
import models.CartItem;
import models.Order;
import models.OrderItem;
import models.User;
import service.OrderService;
import service.OrderItemService;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutServlet", urlPatterns = "/checkout")
public class CheckoutServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final OrderItemService orderItemService = new OrderItemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) { resp.sendRedirect(req.getContextPath()+"/cart"); return; }
        req.setAttribute("cart", cart);
        req.setAttribute("items", cart.getItems().values());
        req.setAttribute("total", cart.getTotalPrice());
        req.getRequestDispatcher("/WEB-INF/jsp/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        User auth = (User) session.getAttribute("authUser");
        if (cart == null || cart.getItems().isEmpty()) { resp.sendRedirect(req.getContextPath()+"/cart"); return; }
        if (auth == null) { resp.sendRedirect(req.getContextPath()+"/login?next=/checkout"); return; }

        // Group cart items by stall (quayHangId)
        Map<Integer, List<CartItem>> groups = new LinkedHashMap<>();
        for (CartItem ci : cart.getItems().values()) {
            int qh = (ci.getMonAn() != null) ? ci.getMonAn().getQuayHangId() : 0;
            groups.computeIfAbsent(qh, k -> new ArrayList<>()).add(ci);
        }

        String ghiChu = req.getParameter("ghi_chu");
        Timestamp now = Timestamp.from(Instant.now());
        List<Integer> createdOrderIds = new ArrayList<>();
        boolean failed = false;

        for (Map.Entry<Integer, List<CartItem>> e : groups.entrySet()) {
            if (failed) break;
            int quayHangId = e.getKey();
            List<CartItem> items = e.getValue();

            BigDecimal groupTotal = BigDecimal.ZERO;
            for (CartItem ci : items) {
                BigDecimal itemTotal = ci.getTongGia();
                groupTotal = groupTotal.add(itemTotal == null ? BigDecimal.ZERO : itemTotal);
            }

            Order o = new Order();
            o.setUserId(auth.getUserId());
            o.setQuayHangId(quayHangId);
            o.setTongTien(groupTotal);
            o.setThoiGianDat(now);
            o.setTrangThaiOrder("MOI_DAT");
            o.setGhiChu(ghiChu);

            int newOrderId = orderService.create(o);
            if (newOrderId <= 0) { failed = true; break; }
            createdOrderIds.add(newOrderId);

            for (CartItem ci : items) {
                OrderItem oi = new OrderItem();
                oi.setOrderId(newOrderId);
                oi.setMonAnId(ci.getMonAn().getMonAnId());
                oi.setSoLuong(ci.getSoLuong());
                BigDecimal price = (ci.getMonAn().getGia() == null) ? BigDecimal.ZERO : ci.getMonAn().getGia();
                oi.setDonGiaMonAnLucDat(price);
                int itemId = orderItemService.create(oi);
                if (itemId <= 0) { failed = true; break; }
            }
        }

        if (failed) {
            for (Integer oid : createdOrderIds) {
                try { orderItemService.clearOrder(oid); } catch (Exception ignored) {}
                try { orderService.delete(oid); } catch (Exception ignored) {}
            }
            resp.sendRedirect(req.getContextPath() + "/checkout?error=1");
            return;
        }

        session.setAttribute("orderSuccessIds", createdOrderIds);
        session.setAttribute("orderSuccessTotal", cart.getTotalPrice());
        session.removeAttribute("cart");
        resp.sendRedirect(req.getContextPath() + "/order-success.jsp");
    }

    private int parseInt(String v){ try { return Integer.parseInt(v); } catch(Exception e){ return 0; } }
}
