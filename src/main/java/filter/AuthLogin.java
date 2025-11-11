package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import models.User;

@WebFilter(urlPatterns = {"/admin", "/admin/*"})
public class AuthLogin implements Filter {
    @Override
    public void init(FilterConfig filterConfig) { /* no-op */ }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Object auth = (session == null) ? null : session.getAttribute("authUser");
        User user = (auth instanceof User) ? (User) auth : null;

        if (user == null) {
            // Build next path without context path to avoid double context on redirect after login
            String ctx = req.getContextPath();
            String uri = req.getRequestURI();
            String pathOnly = uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;
            String qs = req.getQueryString();
            String nextRaw = pathOnly + (qs != null ? ("?" + qs) : "");
            String next = URLEncoder.encode(nextRaw, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/login?next=" + next);
            return;
        }

        String role = safe(user.getRole());
        String ctx = req.getContextPath();
        String uri = req.getRequestURI();
        String pathOnly = uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;

        // Admin full access
        if (isAdmin(role)) {
            chain.doFilter(request, response);
            return;
        }

        // Manager (truong_quay) scoped access
        if (isManager(role)) {
            // Deny quầy hàng structure management
            if (isQuayHangPath(pathOnly)) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            // Allow foods, menu, orders, users (filtered later in servlets) + root /admin
            if (isFoodsPath(pathOnly) || isMonAnPath(pathOnly) || isMenuPath(pathOnly) || isOrdersPath(pathOnly) || isUsersPath(pathOnly) || "/admin".equals(pathOnly)) {
                chain.doFilter(request, response);
                return;
            }
            // Block everything else
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // Staff (nhan_vien_quay) only orders access
        if (isStaff(role)) {
            if (isOrdersPath(pathOnly)) {
                chain.doFilter(request, response);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // Other roles (e.g. hoc_sinh) denied
        resp.sendRedirect(req.getContextPath() + "/");
    }

    private String safe(String r) { return r == null ? "" : r.trim().toLowerCase(); }

    private boolean isAdmin(String role) { return "bgh_admin".equalsIgnoreCase(role); }
    private boolean isStaff(String role) { return "nhan_vien_quay".equalsIgnoreCase(role); }
    private boolean isManager(String role) { return "truong_quay".equalsIgnoreCase(role); }

    private boolean isOrdersPath(String path) {
        if (path == null) return false;
        return path.startsWith("/admin/orders");
    }
    private boolean isMenuPath(String path) {
        if (path == null) return false;
        return path.startsWith("/admin/menu");
    }
    private boolean isMonAnPath(String path) {
        if (path == null) return false;
        return path.startsWith("/admin/monan");
    }
    private boolean isFoodsPath(String path) { // management listing
        if (path == null) return false;
        return path.startsWith("/admin/management") || "/admin".equals(path);
    }
    private boolean isUsersPath(String path) {
        if (path == null) return false;
        return path.startsWith("/admin/users");
    }
    private boolean isQuayHangPath(String path) {
        if (path == null) return false;
        return path.startsWith("/admin/quayhang");
    }

    @Override
    public void destroy() { /* no-op */ }
}
