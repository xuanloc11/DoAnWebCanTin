package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.MonAn;
import models.Page;
import models.PageRequest;
import models.QuayHang;
import service.MonAnService;
import service.QuayHangService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "MonAnListServlet", urlPatterns = "/mon-an-list")
public class MonAnListServlet extends HttpServlet {

    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = trimToNull(req.getParameter("q"));
        String quayParam = req.getParameter("quay");
        Integer quayId = null;
        try { if (quayParam != null && !quayParam.isBlank()) quayId = Integer.parseInt(quayParam); } catch (Exception ignored) {}
        String status = trimToNull(req.getParameter("status"));
        String minP = req.getParameter("minPrice");
        String maxP = req.getParameter("maxPrice");
        BigDecimal minPrice = null, maxPrice = null;
        try { if (minP != null && !minP.isBlank()) minPrice = new BigDecimal(minP); } catch (Exception ignored) {}
        try { if (maxP != null && !maxP.isBlank()) maxPrice = new BigDecimal(maxP); } catch (Exception ignored) {}

        int page = 1;
        int size = 9;
        try {
            String p = req.getParameter("page");
            if (p != null) page = Integer.parseInt(p);
        } catch (Exception ignored) {}
        try {
            String s = req.getParameter("size");
            if (s != null) size = Integer.parseInt(s);
        } catch (Exception ignored) {}

        PageRequest pr = new PageRequest(page, size);
        Page<MonAn> pageResult = monAnService.page(quayId, q, status, minPrice, maxPrice, pr);
        List<QuayHang> quays = quayHangService.getAll();

        req.setAttribute("page", pageResult);
        req.setAttribute("foods", pageResult.getContent());
        req.setAttribute("quays", quays);

        req.getRequestDispatcher("/all-foods.jsp").forward(req, resp);
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}
