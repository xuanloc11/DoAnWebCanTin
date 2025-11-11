package models;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String hoTen;
    private String email;
    private String password;
    private String role; // e.g., admin, user
    private String donVi;
    private Integer quayHangId;
    private Timestamp createdAt;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getDonVi() { return donVi; }
    public void setDonVi(String donVi) { this.donVi = donVi; }

    public Integer getQuayHangId() { return quayHangId; }
    public void setQuayHangId(Integer quayHangId) { this.quayHangId = quayHangId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
