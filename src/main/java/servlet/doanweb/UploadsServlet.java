package servlet.doanweb;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(name = "UploadsServlet", urlPatterns = "/uploads/*")
public class UploadsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Map URL /uploads/... to physical file under the base uploads directory
        String rel = req.getPathInfo(); // includes leading /
        if (rel == null || rel.trim().isEmpty() || "/".equals(rel)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        // Try to read from the same base path as UploadUtil
        String base = getServletContext().getRealPath("/uploads");
        if (base == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        Path target = Paths.get(base).resolve(rel.substring(1)).normalize();
        if (!target.startsWith(base)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (!Files.exists(target) || !Files.isRegularFile(target)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String mime = Files.probeContentType(target);
        if (mime == null) mime = "application/octet-stream";
        resp.setContentType(mime);
        resp.setHeader("Cache-Control", "public, max-age=31536000, immutable");
        try (FileInputStream in = new FileInputStream(target.toFile()); OutputStream out = resp.getOutputStream()) {
            in.transferTo(out);
        }
    }
}
