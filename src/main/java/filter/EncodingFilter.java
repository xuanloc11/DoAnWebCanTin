package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class EncodingFilter implements Filter {
    private static final String UTF_8 = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding(UTF_8);
        response.setCharacterEncoding(UTF_8);

        chain.doFilter(request, response);

        // After downstream processing, ensure HTML responses declare charset
        if (response instanceof HttpServletResponse && request instanceof HttpServletRequest) {
            HttpServletResponse res = (HttpServletResponse) response;
            HttpServletRequest req = (HttpServletRequest) request;
            String ct = res.getContentType();
            if (ct == null) {
                String uri = req.getRequestURI();
                if (uri.endsWith(".jsp") || uri.endsWith("/") || uri.endsWith(".html") || uri.equals(req.getContextPath()) ) {
                    res.setContentType("text/html; charset=" + UTF_8);
                }
            } else if (ct.startsWith("text/html") && !ct.toLowerCase().contains("charset")) {
                res.setContentType("text/html; charset=" + UTF_8);
            }
        }
    }

    @Override
    public void destroy() { }
}
