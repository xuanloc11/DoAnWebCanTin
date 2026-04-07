# Đồ án Web Căn tin

Ứng dụng web quản lý và đặt món tại căn tin (ví dụ trường đại học), gồm giao diện khách hàng (xem món, giỏ hàng, đặt hàng) và khu vực quản trị (món ăn, thực đơn, đơn hàng, người dùng, quầy hàng).

## Công nghệ

| Thành phần | Phiên bản / Ghi chú |
|------------|---------------------|
| Java | 24 |
| Build | Maven (`packaging: war`) |
| Web | Jakarta Servlet 6.x, JSP, JSTL |
| CSDL | MySQL 8 (JDBC qua `mysql-connector-java`) |
| Máy chủ ứng dụng | Apache Tomcat (khuyến nghị bản hỗ trợ Jakarta EE 10 / Servlet 6) |

## Tính năng chính

- **Khách truy cập / người dùng**: trang chủ, danh sách món, chi tiết món, thực đơn theo quầy, giỏ hàng, thanh toán, đăng ký / đăng nhập, hồ sơ và xem chi tiết đơn hàng.
- **Quản trị** (`/admin/*`): bảng điều khiển, thống kê, CRUD món ăn, menu (thực đơn), đơn hàng, người dùng, quầy hàng; cập nhật trạng thái đơn.
- **Phân quyền** (filter `AuthLogin`):
  - `bgh_admin`: toàn quyền khu vực admin.
  - `truong_quay`: quản lý món, menu, đơn, người dùng; **không** truy cập các đường dẫn quản lý quầy hàng (`/admin/quayhang`).

## Yêu cầu trước khi chạy

1. **JDK 24** (khớp với `maven.compiler` trong `pom.xml`).
2. **MySQL** đang chạy, đã tạo database (mặc định trong code: tên `cantin`).
3. **Apache Tomcat** để triển khai file `.war`.

> Repository hiện **không** kèm script SQL. Bạn cần có schema và dữ liệu mẫu phù hợp với các bảng mà ứng dụng sử dụng (người dùng, món ăn, menu, đơn hàng, v.v.).

## Cấu hình cơ sở dữ liệu

Chuỗi kết nối mặc định trỏ tới:

- Host: `localhost:3306`
- Database: `cantin`
- User / mật khẩu: được khai báo trong:
  - `src/main/webapp/META-INF/context.xml` (DataSource JNDI `jdbc/cantinDS`)
  - `src/main/java/Util/DataSourceUtil.java` (fallback khi lookup JNDI thất bại)

**Trước khi deploy**, hãy đổi user, mật khẩu và URL cho khớp môi trường của bạn (và tránh commit mật khẩu thật nếu repo công khai).

## Build và chạy

### Biên dịch gói WAR

Tại thư mục gốc dự án:

```bash
mvn clean package
```

File xuất ra: `target/doanweb-1.0-SNAPSHOT.war` (tên có thể thay đổi theo `artifactId` / `version` trong `pom.xml`).

### Triển khai trên Tomcat

1. Copy file `.war` vào thư mục `webapps` của Tomcat (hoặc cấu hình deploy qua IDE).
2. Đảm bảo MySQL đã chạy và database `cantin` sẵn sàng.
3. Khởi động Tomcat, truy cập ứng dụng theo context path (thường `http://localhost:8080/doanweb-1.0-SNAPSHOT/` hoặc tên bạn đặt khi deploy).

### Maven Wrapper (Windows)

Nếu dùng `mvnw.cmd`:

```powershell
.\mvnw.cmd clean package
```

## Cấu trúc thư mục (rút gọn)

```
src/main/java/          # Servlet, filter, service, repository, model
src/main/webapp/        # JSP, tài nguyên tĩnh (CSS, JS, hình ảnh)
src/main/webapp/WEB-INF/
src/main/webapp/META-INF/context.xml   # DataSource Tomcat
pom.xml
```

## Ghi chú bảo mật

Mật khẩu database đang nằm trong mã nguồn / `context.xml` để tiện môi trường phát triển. Với môi trường production, nên chuyển sang biến môi trường hoặc cấu hình riêng không đưa lên Git.

## Giấy phép & tác giả

Dự án phục vụ mục đích học tập (đồ án). Thông tin tác giả có thể xuất hiện trong metadata trang (ví dụ `index.jsp`).
