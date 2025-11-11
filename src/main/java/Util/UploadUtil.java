package Util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.Locale;

public class UploadUtil {
    public static final long MAX_IMAGE_BYTES = 8L * 1024 * 1024; // 8MB

    public static Path getBaseDir(ServletContext ctx) {
        // Priority: env var -> sysprop -> realPath(/uploads) -> user.home
        String env = System.getenv("DOANWEB_UPLOAD_DIR");
        if (env != null && !env.trim().isEmpty()) {
            return ensureDir(Paths.get(env));
        }
        String prop = System.getProperty("doanweb.upload.dir");
        if (prop != null && !prop.trim().isEmpty()) {
            return ensureDir(Paths.get(prop));
        }
        String real = ctx.getRealPath("/uploads");
        if (real != null) {
            return ensureDir(Paths.get(real));
        }
        Path home = Paths.get(System.getProperty("user.home"), "doanweb_uploads");
        return ensureDir(home);
    }

    public static String saveImage(Part part, ServletContext ctx, String subDir) throws IOException {
        if (part == null || part.getSize() <= 0) return null;
        if (part.getSize() > MAX_IMAGE_BYTES) throw new IOException("File quá lớn");
        String ct = part.getContentType();
        if (ct == null || !ct.toLowerCase(Locale.ROOT).startsWith("image/")) {
            // Fallback: allow by extension for some browsers
            String submitted = part.getSubmittedFileName();
            if (submitted == null || !isAllowedImageExt(submitted)) {
                throw new IOException("Định dạng không hỗ trợ");
            }
        }
        String submitted = part.getSubmittedFileName();
        if (submitted == null || submitted.trim().isEmpty()) return null;
        String baseName = Paths.get(submitted).getFileName().toString();
        String safeName = sanitize(baseName);
        // Optional: partition by date to avoid too many files in one directory
        LocalDate today = LocalDate.now();
        Path targetDir = getBaseDir(ctx).resolve(subDir).resolve(String.valueOf(today.getYear()))
                .resolve(String.format("%02d", today.getMonthValue()))
                .resolve(String.format("%02d", today.getDayOfMonth()));
        ensureDir(targetDir);
        String fileName = System.currentTimeMillis() + "-" + safeName;
        Path dest = targetDir.resolve(fileName);
        try (InputStream in = part.getInputStream(); FileOutputStream out = new FileOutputStream(dest.toFile())) {
            in.transferTo(out);
        }
        // Build URL path relative to context
        String urlPath = "/uploads/" + subDir + "/" + today.getYear() + "/" + String.format("%02d", today.getMonthValue()) + "/" + String.format("%02d", today.getDayOfMonth()) + "/" + fileName;
        return urlPath;
    }

    public static boolean isAllowedImageExt(String name) {
        String n = name.toLowerCase(Locale.ROOT);
        return n.endsWith(".png") || n.endsWith(".jpg") || n.endsWith(".jpeg") || n.endsWith(".gif") || n.endsWith(".webp");
    }

    public static String sanitize(String name) {
        // Remove path parts and keep only safe chars
        String n = name.replace("\\", "/");
        n = n.substring(n.lastIndexOf('/') + 1);
        n = n.replaceAll("[^a-zA-Z0-9._-]", "-");
        return n;
    }

    private static Path ensureDir(Path p) {
        try {
            Files.createDirectories(p);
        } catch (IOException e) {
            //noinspection ResultOfMethodCallIgnored
            new File(p.toString()).mkdirs();
        }
        return p;
    }
}

