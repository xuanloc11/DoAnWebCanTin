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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = "/admin/orders")
public class OrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        List<Order> list = orderService.getAllOrders();
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
        req.setAttribute("orders", list);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/orders.jsp").forward(req, resp);
    }
}
