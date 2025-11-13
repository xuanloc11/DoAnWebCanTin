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
import java.math.BigDecimal;
import java.util.*;

@WebServlet(name = "ProfileServlet", urlPatterns = "/profile")
public class ProfileServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final QuayHangService quayHangService = new QuayHangService();

    // View model for grouped orders
    public static class GroupedOrderView {
        private Date thoiGianDat; // display time (from timestamp)
        private BigDecimal tongTien; // sum across stalls
        private String trangThaiTong; // single or mixed
        private List<Integer> orderIds; // underlying order ids
        private List<String> stallNames; // involved stalls

        public Date getThoiGianDat() { return thoiGianDat; }
        public void setThoiGianDat(Date thoiGianDat) { this.thoiGianDat = thoiGianDat; }
        public BigDecimal getTongTien() { return tongTien; }
        public void setTongTien(BigDecimal tongTien) { this.tongTien = tongTien; }
        public String getTrangThaiTong() { return trangThaiTong; }
        public void setTrangThaiTong(String trangThaiTong) { this.trangThaiTong = trangThaiTong; }
        public List<Integer> getOrderIds() { return orderIds; }
        public void setOrderIds(List<Integer> orderIds) { this.orderIds = orderIds; }
        public List<String> getStallNames() { return stallNames; }
        public void setStallNames(List<String> stallNames) { this.stallNames = stallNames; }
        public int getPrimaryOrderId() { return (orderIds == null || orderIds.isEmpty()) ? 0 : orderIds.get(0); }
        // Convenience joined string for JSP
        public String getStallsDisplay() {
            if (stallNames == null || stallNames.isEmpty()) return "";
            return String.join(", ", new LinkedHashSet<>(stallNames));
        }
    }

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

        // Group orders by checkout timestamp to the second (robust against DB precision)
        Map<Long, List<Order>> grouped = new LinkedHashMap<>();
        for (Order o : myOrders) {
            if (o.getThoiGianDat() == null) continue;
            long key = o.getThoiGianDat().getTime() / 1000L; // seconds
            grouped.computeIfAbsent(key, k -> new ArrayList<>()).add(o);
        }
        // Sort keys desc (newest first)
        List<Long> keys = new ArrayList<>(grouped.keySet());
        keys.sort(Comparator.reverseOrder());

        List<GroupedOrderView> views = new ArrayList<>();
        for (Long k : keys) {
            List<Order> os = grouped.get(k);
            if (os == null || os.isEmpty()) continue;
            GroupedOrderView v = new GroupedOrderView();
            v.setThoiGianDat(new Date(k * 1000L));
            BigDecimal sum = BigDecimal.ZERO;
            List<Integer> ids = new ArrayList<>();
            List<String> stalls = new ArrayList<>();
            Set<String> statuses = new LinkedHashSet<>();
            for (Order o : os) {
                ids.add(o.getOrderId());
                if (o.getTongTien() != null) sum = sum.add(o.getTongTien());
                String stallName = quayMap.getOrDefault(o.getQuayHangId(), String.valueOf(o.getQuayHangId()));
                stalls.add(stallName);
                if (o.getTrangThaiOrder() != null) statuses.add(o.getTrangThaiOrder());
            }
            v.setTongTien(sum);
            v.setOrderIds(ids);
            v.setStallNames(stalls);
            v.setTrangThaiTong(statuses.size() == 1 ? statuses.iterator().next() : "MIXED");
            views.add(v);
        }

        req.setAttribute("quayMap", quayMap);
        req.setAttribute("me", auth);
        req.setAttribute("orders", myOrders); // keep for compatibility
        req.setAttribute("groupedOrders", views);
        req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, resp);
    }
}
