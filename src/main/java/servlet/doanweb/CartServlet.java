package servlet.doanweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Cart;
import models.CartItem;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet(name = "CartServlet", urlPatterns = "/cart")
public class CartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            req.setAttribute("cartEmpty", Boolean.TRUE);
        } else {
            req.setAttribute("cart", cart);
        }
        req.getRequestDispatcher("/WEB-INF/jsp/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            if (isAjax(req)) {
                writeJson(resp, 0, 0, 0);
            } else {
                resp.sendRedirect(req.getContextPath()+"/cart");
            }
            return;
        }

        String removeParam = req.getParameter("remove");
        String action = req.getParameter("action");
        if (removeParam != null && !removeParam.isBlank()) {
            int monId = parseInt(removeParam);
            cart.removeItem(monId);
        } else if ("remove".equalsIgnoreCase(action)) {
            int monId = parseInt(req.getParameter("mon_id"));
            cart.removeItem(monId);
        } else if ("clear".equalsIgnoreCase(action)) {
            session.removeAttribute("cart");
            if (isAjax(req)) {
                writeJson(resp, 0, 0, 0);
            } else {
                resp.sendRedirect(req.getContextPath()+"/cart");
            }
            return;
        } else if ("update".equalsIgnoreCase(action) || action == null) {
            for (Map.Entry<Integer, CartItem> e : cart.getItems().entrySet()) {
                String param = req.getParameter("qty_" + e.getKey());
                if (param != null) {
                    try {
                        int q = Integer.parseInt(param);
                        cart.updateItem(e.getKey(), q);
                    } catch (NumberFormatException ignored) {}
                }
            }
        }

        if (isAjax(req)) {
            int totalQuantity = 0;
            for (CartItem item : cart.getItems().values()) {
                totalQuantity += item.getSoLuong();
            }
            long totalPrice = cart.getTotalPrice().longValue();
            writeJson(resp, totalPrice, totalPrice, totalQuantity);
        } else {
            resp.sendRedirect(req.getContextPath()+"/cart");
        }
    }

    private int parseInt(String v){ try { return Integer.parseInt(v); } catch(Exception e){ return 0; } }

    private boolean isAjax(HttpServletRequest req) {
        String ajax = req.getParameter("ajax");
        if ("1".equals(ajax) || "true".equalsIgnoreCase(ajax)) return true;
        String header = req.getHeader("X-Requested-With");
        return header != null && "XMLHttpRequest".equalsIgnoreCase(header);
    }

    private void writeJson(HttpServletResponse resp, long subtotal, long total, int totalQuantity) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            out.print('{');
            out.print("\"subtotal\":" + subtotal + ',');
            out.print("\"total\":" + total + ',');
            out.print("\"totalQuantity\":" + totalQuantity);
            out.print('}');
        }
    }
}
