package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Cart;
import models.MonAn;
import service.MonAnService;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.Map;

@MultipartConfig
@WebServlet(name = "AddToCartServlet", urlPatterns = "/cart/add")
public class AddToCartServlet extends HttpServlet {
    private final MonAnService monAnService = new MonAnService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String rawId = firstNonBlank(req.getParameter("mon_an_id"), req.getParameter("monAnId"), req.getParameter("id"));
        int monAnId = parseInt(rawId);
        int qty = Math.max(1, parseInt(req.getParameter("qty")));
        boolean ajax = isAjax(req);
        // Debug log
        System.out.println("[AddToCart] params=" + req.getParameterMap().keySet() + ", raw mon_an_id=" + rawId + ", parsed=" + monAnId + ", qty=" + qty + ", ajax=" + ajax);
        if (monAnId <= 0) {
            if (ajax) { writeJson(resp, 400, jsonError("INVALID_ID", "Thiếu hoặc sai tham số mon_an_id")); return; }
            resp.sendError(400, "Thiếu hoặc sai tham số mon_an_id"); return;
        }
        MonAn monAn = monAnService.get(monAnId);
        String back = backUrl(req);
        if (monAn == null) {
            System.out.println("[AddToCart] MonAn null for id=" + monAnId);
            if (ajax) { writeJson(resp, 400, jsonError("NOT_FOUND", "Món ăn không tồn tại")); return; }
            resp.sendRedirect(back); return;
        }
        if (isOutOfStock(monAn)) {
            if (ajax) { writeJson(resp, 409, jsonError("OUT_OF_STOCK", "Món ăn đã hết hàng")); return; }
            resp.sendRedirect(back); return;
        }
        HttpSession session = req.getSession();
        // Unified session cart
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            // Migrate old structure if exists
            @SuppressWarnings("unchecked") Map<Integer, Cart> cartMapOld = (Map<Integer, Cart>) session.getAttribute("cartMap");
            if (cartMapOld != null) {
                for (Cart c : cartMapOld.values()) cart.mergeFrom(c);
                session.removeAttribute("cartMap");
            }
            session.setAttribute("cart", cart);
        }
        cart.addItem(monAn, qty);
        if (ajax) {
            int totalQty = cart.getTotalQuantity();
            BigDecimal totalPrice = cart.getTotalPrice();
            StringBuilder sb = new StringBuilder();
            sb.append('{')
              .append("\"status\":\"ok\",")
              .append("\"monAnId\":"+monAn.getMonAnId()+",")
              .append("\"name\":\""+escape(monAn.getTenMonAn())+"\",")
              .append("\"quantityAdded\":"+qty+",")
              .append("\"cartTotals\":{")
              .append("\"totalQuantity\":"+totalQty+",")
              .append("\"totalPrice\":\""+totalPrice.toPlainString()+"\"}")
              .append(',')
              .append("\"message\":\"Đã thêm vào giỏ hàng\"")
              .append('}');
            writeJson(resp, 200, sb.toString());
            return;
        }
        resp.sendRedirect(back);
    }

    private String jsonError(String code, String message) {
        return "{\"status\":\"error\",\"code\":\""+code+"\",\"message\":\""+escape(message)+"\"}";
    }
    private String backUrl(HttpServletRequest req){ String r = req.getHeader("Referer"); return (r != null && !r.isBlank()) ? r : (req.getContextPath()+"/"); }

    private String firstNonBlank(String... vals){ if (vals == null) return null; for (String v : vals) { if (v != null && !v.isBlank()) return v; } return null; }
    private boolean isOutOfStock(MonAn m) { if (m == null) return true; String st = m.getTrangThaiMon(); if (st == null) return false; st = st.trim().toLowerCase(); return st.equals("het_hang") || st.equals("off") || st.equals("ngung_ban") || st.equals("ngừng bán"); }
    private boolean isAjax(HttpServletRequest req) { String xr = req.getHeader("X-Requested-With"); if ("XMLHttpRequest".equalsIgnoreCase(xr)) return true; String accept = req.getHeader("Accept"); if (accept != null && accept.contains("application/json")) return true; String ajaxParam = req.getParameter("ajax"); return ajaxParam != null && ("1".equals(ajaxParam) || "true".equalsIgnoreCase(ajaxParam)); }
    private void writeJson(HttpServletResponse resp, int status, String body) throws IOException { resp.setStatus(status); resp.setContentType("application/json;charset=UTF-8"); try (PrintWriter out = resp.getWriter()) { out.write(body); } }
    private String escape(String s){ if (s == null) return ""; return s.replace("\\","\\\\").replace("\"","\\\""); }
    private int parseInt(String v){ try { return Integer.parseInt(v); } catch(Exception e){ return 0; } }
}
