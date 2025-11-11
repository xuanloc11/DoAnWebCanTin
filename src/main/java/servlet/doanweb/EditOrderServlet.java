package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "EditOrderServlet", urlPatterns = "/admin/orders/edit")
public class EditOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chức năng cập nhật đơn đã bị vô hiệu hóa. Học sinh tạo đơn, nhân viên chỉ được xem/hủy.");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chức năng cập nhật đơn đã bị vô hiệu hóa. Học sinh tạo đơn, nhân viên chỉ được xem/hủy.");
    }
}
