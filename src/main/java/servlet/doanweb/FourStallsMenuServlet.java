package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.MonAn;
import models.QuayHang;
import models.Menu;
import service.MonAnService;
import service.QuayHangService;
import service.MenuService;
import service.MenuMonAnService;

import java.io.IOException;
import java.sql.Date;
import java.util.*;

@WebServlet(name = "FourStallsMenuServlet", urlPatterns = "/menu/stalls")
public class FourStallsMenuServlet extends HttpServlet {
    private final MonAnService monAnService = new MonAnService();
    private final QuayHangService quayHangService = new QuayHangService();
    private final MenuService menuService = new MenuService();
    private final MenuMonAnService menuMonAnService = new MenuMonAnService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<QuayHang> quays = quayHangService.getAll();
        req.setAttribute("quays", quays);

        Date today = new Date(System.currentTimeMillis());
        String todayStr = today.toString(); // yyyy-MM-dd
        req.setAttribute("todayLabel", todayStr);

        Map<Integer, List<MonAn>> todayFoodsByStall = new HashMap<>();

        if (quays != null && !quays.isEmpty()) {
            List<Menu> allMenus = menuService.all();
            Map<Integer, List<Menu>> menusByQuay = new HashMap<>();
            for (Menu m : allMenus) {
                if (m.getNgayApDung() == null) continue;
                String menuDateStr = m.getNgayApDung().toString();
                if (!todayStr.equals(menuDateStr)) continue; // chỉ giữ menu hôm nay (so sánh theo chuỗi ngày)
                menusByQuay.computeIfAbsent(m.getQuayHangId(), k -> new ArrayList<>()).add(m);
            }

            int count = 0;
            for (QuayHang q : quays) {
                if (count >= 4) break; // chỉ hiển thị tối đa 4 quầy
                int qid = q.getQuayHangId();

                List<Menu> todayMenus = menusByQuay.get(qid);
                if (todayMenus == null || todayMenus.isEmpty()) {
                    count++;
                    continue; // quầy này hôm nay chưa có menu
                }

                // Lấy danh sách món thuộc tất cả menu hôm nay của quầy này
                Set<Integer> monAnIds = new LinkedHashSet<>();
                for (Menu m : todayMenus) {
                    List<Integer> ids = menuMonAnService.monAnIds(m.getMenuId());
                    if (ids != null) {
                        monAnIds.addAll(ids);
                    }
                }

                List<MonAn> foods = new ArrayList<>();
                for (Integer monId : monAnIds) {
                    MonAn f = monAnService.get(monId);
                    if (f != null) {
                        foods.add(f);
                    }
                }

                if (!foods.isEmpty()) {
                    todayFoodsByStall.put(qid, foods);
                }

                count++;
            }
        }

        req.setAttribute("todayFoodsByStall", todayFoodsByStall);
        req.getRequestDispatcher("/WEB-INF/jsp/menu.jsp").forward(req, resp);
    }
}
