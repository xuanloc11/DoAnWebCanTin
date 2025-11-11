package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.User;
import service.OrderService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Set;

@WebServlet(name = "UpdateOrderStatusServlet", urlPatterns = "/admin/orders/status")
public class UpdateOrderStatusServlet extends HttpServlet {
    private final OrderService service = new OrderService();
    private static final Set<String> ALLOWED = Set.of("MOI_DAT", "DA_XAC_NHAN", "DANG_GIAO", "DA_GIAO");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = RequestUtil.i(req, "order_id", 0);
        String status = RequestUtil.s(req, "status");
        String redirect = req.getContextPath() + "/admin/orders";
        if (id <= 0 || status == null || !ALLOWED.contains(status)) {
            String msg = URLEncoder.encode("Trạng thái không hợp lệ", StandardCharsets.UTF_8);
            resp.sendRedirect(redirect + "?type=error&msg=" + msg);
            return;
        }
        // Scope check for manager/staff
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (auth != null && ("truong_quay".equalsIgnoreCase(auth.getRole()) || "nhan_vien_quay".equalsIgnoreCase(auth.getRole()))) {
            Order o = service.get(id);
            Integer qid = auth.getQuayHangId();
            if (o == null || qid == null || !qid.equals(o.getQuayHangId())) {
                String msg = URLEncoder.encode("Không được phép", StandardCharsets.UTF_8);
                resp.sendRedirect(redirect + "?type=error&msg=" + msg);
                return;
            }
        }
        boolean ok = service.updateStatus(id, status);
        String type = ok ? "success" : "error";
        String msg = URLEncoder.encode(ok ? "Đã cập nhật trạng thái" : "Cập nhật thất bại", StandardCharsets.UTF_8);
        resp.sendRedirect(redirect + "?type=" + type + "&msg=" + msg);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }
}
