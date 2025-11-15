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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "FourStallsMenuServlet", urlPatterns = "/menu/stalls")
public class FourStallsMenuServlet extends HttpServlet {
    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<QuayHang> quays = quayHangService.getAll();
        req.setAttribute("quays", quays);

        Map<Integer, List<MonAn>> foodsByStall = new HashMap<>();
        if (quays != null) {
            int count = 0;
            for (QuayHang q : quays) {
                if (count >= 4) break;
                List<MonAn> foods = monAnService.byStall(q.getQuayHangId(), 0);
                foodsByStall.put(q.getQuayHangId(), foods);
                count++;
            }
        }
        req.setAttribute("foodsByStall", foodsByStall);

        req.getRequestDispatcher("/WEB-INF/jsp/menu-stalls.jsp").forward(req, resp);
    }
}

