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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddMenuServlet", urlPatterns = "/admin/menu/add")
public class AddMenuServlet extends HttpServlet {
    private final MenuService service = new MenuService();
    private final MonAnService monAnService = new MonAnService();
    private final MenuMonAnService linkService = new MenuMonAnService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("mode", "create");
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        List<MonAn> foods = monAnService.all();
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole()) && auth.getQuayHangId() != null) {
            Integer qid = auth.getQuayHangId();
            List<MonAn> filtered = new ArrayList<>();
            for (MonAn m : foods) if (qid.equals(m.getQuayHangId())) filtered.add(m);
            foods = filtered;
        }
        req.setAttribute("foods", foods);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/menu-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        Menu m = new Menu();
        int qid = RequestUtil.i(req, "quay_hang_id", 0);
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole()) && auth.getQuayHangId() != null) {
            qid = auth.getQuayHangId();
        }
        m.setQuayHangId(qid);
        String d = RequestUtil.s(req, "ngay_ap_dung");
        m.setNgayApDung(parseDate(d));
        m.setTenThucDon(RequestUtil.s(req, "ten_thuc_don"));
        int newId = service.create(m);

        String[] ids = req.getParameterValues("mon_an_ids");
        if (newId > 0 && ids != null) {
            for (String s : ids) {
                try {
                    int monAnId = Integer.parseInt(s);
                    linkService.add(newId, monAnId);
                } catch (NumberFormatException ignored) { }
            }
        }

        String msg = URLEncoder.encode("Đã tạo menu", StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/admin/menu?type=success&msg=" + msg);
    }

    private Date parseDate(String v){
        try { return v == null || v.isEmpty() ? null : Date.valueOf(v); } catch(Exception e){ return null; }
    }
}
