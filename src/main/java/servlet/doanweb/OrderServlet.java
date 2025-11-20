package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.User;
import service.OrderService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = "/admin/orders")
public class OrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        List<Order> list = orderService.getAllOrders();

        // Restrict for truong_quay & nhan_vien_quay: only orders for their stall
        if (auth != null && ("truong_quay".equalsIgnoreCase(auth.getRole()) || "nhan_vien_quay".equalsIgnoreCase(auth.getRole()))) {
            Integer qid = auth.getQuayHangId();
            List<Order> filtered = new ArrayList<>();
            if (qid != null) {
                for (Order o : list) {
                    if (qid.equals(o.getQuayHangId())) filtered.add(o);
                }
            }
            list = filtered;
        }

        // Apply filter params
        String q = req.getParameter("q");
        String status = req.getParameter("status");
        String from = req.getParameter("from");
        String to = req.getParameter("to");

        if ((q != null && !q.trim().isEmpty()) ||
            (status != null && !status.trim().isEmpty()) ||
            (from != null && !from.trim().isEmpty()) ||
            (to != null && !to.trim().isEmpty())) {

            String keyword = (q != null) ? q.trim().toLowerCase() : null;
            String statusFilter = (status != null && !status.trim().isEmpty()) ? status.trim().toUpperCase() : null;

            Date fromDate = null;
            Date toDate = null;
            try {
                if (from != null && !from.trim().isEmpty()) {
                    LocalDate d = LocalDate.parse(from.trim());
                    LocalDateTime dt = d.atStartOfDay();
                    fromDate = Date.from(dt.atZone(ZoneId.systemDefault()).toInstant());
                }
            } catch (Exception ignored) {}
            try {
                if (to != null && !to.trim().isEmpty()) {
                    LocalDate d = LocalDate.parse(to.trim());
                    LocalDateTime dt = d.atTime(LocalTime.MAX);
                    toDate = Date.from(dt.atZone(ZoneId.systemDefault()).toInstant());
                }
            } catch (Exception ignored) {}

            List<Order> filtered = new ArrayList<>();
            for (Order o : list) {
                boolean match = true;

                if (keyword != null && !keyword.isEmpty()) {
                    String note = o.getGhiChu() != null ? o.getGhiChu().toLowerCase() : "";
                    String idStr = String.valueOf(o.getOrderId());
                    match = note.contains(keyword) || idStr.contains(keyword);
                }

                if (match && statusFilter != null) {
                    String st = o.getTrangThaiOrder() != null ? o.getTrangThaiOrder().toUpperCase() : "";
                    match = st.equals(statusFilter);
                }

                if (match && (fromDate != null || toDate != null)) {
                    Date created = o.getThoiGianDat();
                    if (created != null) {
                        if (fromDate != null && created.before(fromDate)) match = false;
                        if (toDate != null && created.after(toDate)) match = false;
                    }
                }

                if (match) filtered.add(o);
            }
            list = filtered;
        }

        req.setAttribute("orders", list);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/orders.jsp").forward(req, resp);
    }
}
