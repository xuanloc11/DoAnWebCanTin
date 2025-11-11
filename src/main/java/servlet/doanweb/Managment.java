package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.MonAnService;
import service.QuayHangService;
import models.MonAn;
import models.QuayHang;
import models.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.text.Normalizer;

@WebServlet(name = "ManagementServlet", urlPatterns = "/admin/management")
public class Managment extends HttpServlet {
    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();

    // Normalize Vietnamese/Unicode string for diacritic-insensitive comparison
    private static String normalizeVN(String s) {
        if (s == null) return null;
        String n = Normalizer.normalize(s, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", ""); // strip diacritics
        return n.trim().toLowerCase();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Object auth = (session == null) ? null : session.getAttribute("authUser");
        if (auth == null) {
            resp.sendRedirect(req.getContextPath() + "/login?next=/admin");
            return;
        }
        User user = (User) auth;
        String quayName = req.getParameter("quay_name");
        String quayIdParam = req.getParameter("quay_id");
        Integer quayId = null;
        if (quayIdParam != null && !quayIdParam.isBlank()) {
            try { quayId = Integer.parseInt(quayIdParam.trim()); } catch (NumberFormatException ignored) {}
        }

        List<MonAn> foods = monAnService.all();
        List<QuayHang> quays = quayHangService.getAll();

        // Build quầy map id -> name for display
        Map<Integer, String> quayMap = new HashMap<>();
        if (quays != null) {
            for (QuayHang q : quays) {
                quayMap.put(q.getQuayHangId(), q.getTenQuayHang());
            }
        }

        // If manager, force scope to their stall regardless of query params
        if (user != null && "truong_quay".equalsIgnoreCase(user.getRole()) && user.getQuayHangId() != null) {
            Integer targetId = user.getQuayHangId();
            List<MonAn> filtered = new ArrayList<>();
            if (foods != null) {
                for (MonAn m : foods) {
                    if (targetId.equals(m.getQuayHangId())) filtered.add(m);
                }
            }
            foods = filtered;
        } else {
            // Previous filters by quay_id or quay_name
            if (quayId != null && foods != null) {
                List<MonAn> filtered = new ArrayList<>();
                for (MonAn m : foods) {
                    if (m.getQuayHangId() == quayId) {
                        filtered.add(m);
                    }
                }
                foods = filtered;
            } else if (quayName != null && !quayName.trim().isEmpty() && foods != null && quays != null) {
                String target = normalizeVN(quayName);
                Set<Integer> allowedIds = new HashSet<>();
                for (QuayHang q : quays) {
                    String qName = q.getTenQuayHang();
                    if (qName != null && normalizeVN(qName).equals(target)) {
                        allowedIds.add(q.getQuayHangId());
                    }
                }
                if (!allowedIds.isEmpty()) {
                    List<MonAn> filtered = new ArrayList<>();
                    for (MonAn m : foods) {
                        if (allowedIds.contains(m.getQuayHangId())) {
                            filtered.add(m);
                        }
                    }
                    foods = filtered;
                } else {
                    foods = new ArrayList<>(); // no matches -> empty list
                }
            }
        }

        req.setAttribute("foods", foods);
        req.setAttribute("quayMap", quayMap);
        req.setAttribute("quay_name", quayName);
        if (quayId != null) req.setAttribute("quay_id", quayId);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/management.jsp").forward(req, resp);
    }
}
