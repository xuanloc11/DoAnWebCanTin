package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.OrderService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "DeleteOrderServlet", urlPatterns = "/admin/orders/delete")
public class DeleteOrderServlet extends HttpServlet {
    private final OrderService service = new OrderService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = RequestUtil.i(req, "order_id", 0);
        if (id > 0) service.cancel(id);
        String msg = URLEncoder.encode("Đã hủy đơn hàng", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/orders?type=success&msg=" + msg);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }
}
