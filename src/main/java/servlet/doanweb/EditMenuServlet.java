package servlet.doanweb;

import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Menu;
import models.MonAn;
import models.User;
import service.MenuService;
import service.MonAnService;
import service.MenuMonAnService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.util.*;

@WebServlet(name = "EditMenuServlet", urlPatterns = "/admin/menu/edit")
public class EditMenuServlet extends HttpServlet {
    private final MenuService service = new MenuService();
    private final MonAnService monAnService = new MonAnService();
    private final MenuMonAnService linkService = new MenuMonAnService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = RequestUtil.i(req, "id", 0);
        Menu m = id > 0 ? service.get(id) : null;
        if (m == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/menu");
            return;
        }
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            Integer qid = auth.getQuayHangId();
            if (qid == null || !qid.equals(m.getQuayHangId())) {
                resp.sendRedirect(req.getContextPath() + "/admin/menu");
                return;
            }
        }
        req.setAttribute("mode", "edit");
        req.setAttribute("menu", m);
        List<MonAn> foods = monAnService.all();
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole()) && auth.getQuayHangId() != null) {
            Integer qid = auth.getQuayHangId();
            List<MonAn> filtered = new ArrayList<>();
            for (MonAn it : foods) if (qid.equals(it.getQuayHangId())) filtered.add(it);
            foods = filtered;
        }
        req.setAttribute("foods", foods);
        List<Integer> selected = linkService.monAnIds(m.getMenuId());
        Map<Integer, Boolean> selectedMap = new HashMap<>();
        for (Integer i : selected) selectedMap.put(i, Boolean.TRUE);
        req.setAttribute("selectedMap", selectedMap);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/menu-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = RequestUtil.i(req, "menu_id", 0);
        Menu m = service.get(id);
        if (m == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/menu");
            return;
        }
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            Integer qid = auth.getQuayHangId();
            if (qid == null || !qid.equals(m.getQuayHangId())) {
                resp.sendRedirect(req.getContextPath() + "/admin/menu");
                return;
            }
        }
        int qid = RequestUtil.i(req, "quay_hang_id", m.getQuayHangId());
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole()) && auth.getQuayHangId() != null) {
            qid = auth.getQuayHangId();
        }
        m.setQuayHangId(qid);
        m.setNgayApDung(parseDate(RequestUtil.s(req, "ngay_ap_dung")));
        m.setTenThucDon(RequestUtil.s(req, "ten_thuc_don"));
        service.update(m);

        // Reset links
        linkService.clear(m.getMenuId());
        String[] ids = req.getParameterValues("mon_an_ids");
        if (ids != null) {
            for (String s : ids) {
                try {
                    int monAnId = Integer.parseInt(s);
                    linkService.add(m.getMenuId(), monAnId);
                } catch (NumberFormatException ignored) { }
            }
        }

        String msg = URLEncoder.encode("Đã lưu thay đổi", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/menu?type=success&msg=" + msg);
    }

    private Date parseDate(String v){
        try { return v == null || v.isEmpty() ? null : Date.valueOf(v); } catch(Exception e){ return null; }
    }
}
