package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.MonAn;
import models.Order;
import models.OrderItem;
import models.QuayHang;
import models.User;
import service.MonAnService;
import service.OrderItemService;
import service.OrderService;
import service.QuayHangService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminOrderDetailServlet", urlPatterns = "/admin/orders/detail")
public class AdminOrderDetailServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final OrderItemService orderItemService = new OrderItemService();
    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = session == null ? null : (User) session.getAttribute("authUser");
        if (auth == null) { resp.sendRedirect(req.getContextPath()+"/login?next=/admin/orders"); return; }
        // Optional role check: only admin / truong_quay / nhan_vien_quay allowed
        String role = auth.getRole() == null ? "" : auth.getRole().toLowerCase();
        if (!(role.equals("bgh_admin") || role.equals("truong_quay") || role.equals("nhan_vien_quay"))) {
            resp.sendError(403, "Không có quyền xem đơn hàng"); return;
        }
        int id;
        try { id = Integer.parseInt(req.getParameter("id")); } catch (Exception e){ id = 0; }
        if (id <= 0) { resp.sendRedirect(req.getContextPath()+"/admin/orders"); return; }
        Order order = orderService.get(id);
        if (order == null) { resp.sendError(404, "Đơn hàng không tồn tại"); return; }
        // If staff/quay manager restrict to their stall
        if ((role.equals("truong_quay") || role.equals("nhan_vien_quay")) && auth.getQuayHangId() != null) {
            if (!auth.getQuayHangId().equals(order.getQuayHangId())) { resp.sendError(403, "Không thuộc quầy của bạn"); return; }
        }
        List<OrderItem> items = orderItemService.byOrder(order.getOrderId());
        Map<Integer, MonAn> monMap = new HashMap<>();
        Map<Integer, BigDecimal> lineTotals = new HashMap<>();
        BigDecimal calcTotal = BigDecimal.ZERO;
        for (OrderItem it : items) {
            MonAn m = monAnService.get(it.getMonAnId());
            if (m != null) monMap.put(it.getMonAnId(), m);
            BigDecimal line = (it.getDonGiaMonAnLucDat() == null ? BigDecimal.ZERO : it.getDonGiaMonAnLucDat()).multiply(BigDecimal.valueOf(it.getSoLuong()));
            lineTotals.put(it.getOrderItemId(), line);
            calcTotal = calcTotal.add(line);
        }
        QuayHang quay = null;
        try { quay = quayHangService.get(order.getQuayHangId()); } catch (Exception ignored) {}
        req.setAttribute("order", order);
        req.setAttribute("items", items);
        req.setAttribute("monMap", monMap);
        req.setAttribute("lineTotals", lineTotals);
        req.setAttribute("calcTotal", calcTotal);
        req.setAttribute("quay", quay);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/order-detail.jsp").forward(req, resp);
    }
}

