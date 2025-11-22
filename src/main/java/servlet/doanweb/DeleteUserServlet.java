package servlet.doanweb;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.User;
import service.OrderItemService;
import service.OrderService;
import service.UserService;

@WebServlet(name = "DeleteUserServlet", urlPatterns = "/admin/users/delete")
public class DeleteUserServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final OrderService orderService = new OrderService();
    private final OrderItemService orderItemService = new OrderItemService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = RequestUtil.i(req, "user_id", 0);
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;

        if (id > 0) {
            User target = userService.get(id);
            if (target != null) {
                // Check permission
                if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
                    if ("bgh_admin".equalsIgnoreCase(target.getRole())) {
                        resp.sendRedirect(req.getContextPath() + "/admin/users");
                        return;
                    }
                }

                try {
                    // Step 1: Get all orders of this user
                    List<Order> userOrders = orderService.byUser(id);

                    // Step 2: Delete all OrderItems for each order
                    for (Order order : userOrders) {
                        orderItemService.clearOrder(order.getOrderId());
                    }

                    // Step 3: Delete all Orders of this user
                    orderService.deleteByUserId(id);

                    // Step 4: Finally delete the user
                    userService.delete(id);

                    String msg = URLEncoder.encode("Đã xóa người dùng và tất cả đơn hàng liên quan", StandardCharsets.UTF_8);
                    resp.sendRedirect(req.getContextPath() + "/admin/users?type=success&msg=" + msg);
                } catch (Exception e) {
                    e.printStackTrace();
                    String msg = URLEncoder.encode("Lỗi khi xóa người dùng: " + e.getMessage(), StandardCharsets.UTF_8);
                    resp.sendRedirect(req.getContextPath() + "/admin/users?type=error&msg=" + msg);
                }
            } else {
                String msg = URLEncoder.encode("Không tìm thấy người dùng", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/admin/users?type=error&msg=" + msg);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
