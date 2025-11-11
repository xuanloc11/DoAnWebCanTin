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
        if (cart == null) { resp.sendRedirect(req.getContextPath()+"/cart"); return; }

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
            resp.sendRedirect(req.getContextPath()+"/cart");
            return;
        } else if ("update".equalsIgnoreCase(action) || action == null) {
            for (Map.Entry<Integer, CartItem> e : cart.getItems().entrySet()) {
                String param = req.getParameter("qty_" + e.getKey());
                if (param != null) {
                    try { int q = Integer.parseInt(param); cart.updateItem(e.getKey(), q); } catch (NumberFormatException ignored) {}
                }
            }
        }
        resp.sendRedirect(req.getContextPath()+"/cart");
    }

    private int parseInt(String v){ try { return Integer.parseInt(v); } catch(Exception e){ return 0; } }
}
