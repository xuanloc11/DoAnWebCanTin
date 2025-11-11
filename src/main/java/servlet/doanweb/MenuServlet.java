package servlet.doanweb;

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
import service.MenuMonAnService;
import service.MonAnService;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "MenuServlet", urlPatterns = "/admin/menu")
public class MenuServlet extends HttpServlet {
    private final MenuService service = new MenuService();
    private final MenuMonAnService linkService = new MenuMonAnService();
    private final MonAnService monAnService = new MonAnService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Menu> menus = service.all();
        HttpSession session = req.getSession(false);
        User auth = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (auth != null && "truong_quay".equalsIgnoreCase(auth.getRole())) {
            Integer qid = auth.getQuayHangId();
            if (qid != null) {
                List<Menu> filtered = new ArrayList<>();
                for (Menu m : menus) if (qid.equals(m.getQuayHangId())) filtered.add(m);
                menus = filtered;
            } else {
                menus = Collections.emptyList();
            }
        }
        req.setAttribute("menus", menus);
        Map<Integer, List<MonAn>> itemsMap = new HashMap<>();
        for (var m : menus) {
            List<Integer> ids = linkService.monAnIds(m.getMenuId());
            List<MonAn> items = new ArrayList<>();
            for (Integer id : ids) {
                MonAn it = monAnService.get(id);
                if (it != null) items.add(it);
            }
            itemsMap.put(m.getMenuId(), items);
        }
        req.setAttribute("menuItemsMap", itemsMap);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/menus.jsp").forward(req, resp);
    }
}
