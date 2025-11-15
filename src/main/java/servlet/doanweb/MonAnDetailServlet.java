package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.MonAn;
import models.QuayHang;
import service.MonAnService;
import service.QuayHangService;

import java.io.IOException;

@WebServlet(name = "MonAnDetailServlet", urlPatterns = "/mon-an")
public class MonAnDetailServlet extends HttpServlet {

    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        MonAn monAn = null;
        String quayTen = null;

        if (idParam != null && !idParam.isBlank()) {
            try {
                int id = Integer.parseInt(idParam);
                monAn = monAnService.get(id);
                if (monAn != null && monAn.getQuayHangId() != 0) {
                    QuayHang q = quayHangService.get(monAn.getQuayHangId());
                    if (q != null) {
                        quayTen = q.getTenQuayHang();
                    }
                }
            } catch (NumberFormatException ignored) {
            }
        }

        req.setAttribute("food", monAn);
        req.setAttribute("quayTen", quayTen);
        req.getRequestDispatcher("/monan-detail.jsp").forward(req, resp);
    }
}
