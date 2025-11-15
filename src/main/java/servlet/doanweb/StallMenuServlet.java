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
import java.util.List;

@WebServlet(name = "StallMenuServlet", urlPatterns = "/menu/stall")
public class StallMenuServlet extends HttpServlet {
    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String quayParam = req.getParameter("quayId");
        Integer quayId = null;
        try {
            if (quayParam != null && !quayParam.isBlank()) {
                quayId = Integer.parseInt(quayParam);
            }
        } catch (NumberFormatException ignored) {
        }

        if (quayId == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số quayId");
            return;
        }

        QuayHang stall = quayHangService.get(quayId);
        if (stall == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy quầy hàng");
            return;
        }

        // Lấy tất cả món của quầy; nếu byStall hỗ trợ limit = 0 hoặc giá trị đặc biệt để lấy hết
        List<MonAn> foods = monAnService.byStall(quayId, 0);

        req.setAttribute("stall", stall);
        req.setAttribute("foods", foods);
        req.getRequestDispatcher("/WEB-INF/jsp/menu-stall.jsp").forward(req, resp);
    }
}

