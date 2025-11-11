package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.QuayHangService;

import java.io.IOException;

@WebServlet(name = "QuayHangServlet", urlPatterns = "/admin/quayhang")
public class QuayHangServlet extends HttpServlet {
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("stalls", quayHangService.getAll());
        req.getRequestDispatcher("/WEB-INF/jsp/admin/quayhang.jsp").forward(req, resp);
    }
}

