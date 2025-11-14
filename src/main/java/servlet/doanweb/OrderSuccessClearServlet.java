package servlet.doanweb;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "OrderSuccessClearServlet", urlPatterns = "/order-success-clear")
public class OrderSuccessClearServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("orderSuccessIds");
            session.removeAttribute("orderSuccessTotal");
        }
        resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }
}

