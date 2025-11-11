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
        Order o = new Order();
        o.setUserId(auth.getUserId());
        // Derive quayHangId from first cart item to satisfy FK if needed
        int derivedQh = 0;
        for (CartItem ci : cart.getItems().values()) { derivedQh = ci.getMonAn().getQuayHangId(); break; }
        o.setQuayHangId(derivedQh);
        o.setTongTien(cart.getTotalPrice());
        o.setThoiGianDat(Timestamp.from(Instant.now()));
        o.setTrangThaiOrder("MOI_DAT");
        o.setGhiChu(req.getParameter("ghi_chu"));
        int newOrderId = orderService.create(o);
        if (newOrderId > 0) {
            for (CartItem ci : cart.getItems().values()) {
                OrderItem oi = new OrderItem();
                oi.setOrderId(newOrderId);
                oi.setMonAnId(ci.getMonAn().getMonAnId());
                oi.setSoLuong(ci.getSoLuong());
                BigDecimal price = ci.getMonAn().getGia() == null ? BigDecimal.ZERO : ci.getMonAn().getGia();
                oi.setDonGiaMonAnLucDat(price);
                orderItemService.create(oi);
            }
            // Clear entire cart
            session.removeAttribute("cart");
            resp.sendRedirect(req.getContextPath() + "/?order=success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=1");
        }
    }

    private int parseInt(String v){ try { return Integer.parseInt(v); } catch(Exception e){ return 0; } }
}
