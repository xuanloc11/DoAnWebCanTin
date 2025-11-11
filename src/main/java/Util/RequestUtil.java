package Util;

import jakarta.servlet.http.HttpServletRequest;

import java.math.BigDecimal;

public class RequestUtil {
    public static String s(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v == null ? null : v.trim();
    }
    public static int i(HttpServletRequest req, String name, int def) {
        try { return Integer.parseInt(s(req, name)); } catch (Exception e) { return def; }
    }
    public static BigDecimal bd(HttpServletRequest req, String name, BigDecimal def) {
        try { String v = s(req, name); return v == null || v.isEmpty() ? def : new BigDecimal(v); } catch (Exception e) { return def; }
    }
}
