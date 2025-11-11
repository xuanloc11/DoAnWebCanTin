package repository;

import Util.DataSourceUtil;
import models.User;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {
    private final DataSource ds = DataSourceUtil.getDataSource();

    public User findByEmail(String email) {
        String sql = "SELECT user_id, ho_ten, email, password, role, don_vi, quay_hang_id, created_at FROM Users WHERE email = ?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query user by email", e);
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, ho_ten, email, password, role, don_vi, quay_hang_id, created_at FROM Users ORDER BY user_id";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query all users", e);
        }
        return users;
    }

    public User findById(int id) {
        String sql = "SELECT user_id, ho_ten, email, password, role, don_vi, quay_hang_id, created_at FROM Users WHERE user_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query user by id", e);
        }
        return null;
    }

    public int insert(User u) {
        String sql = "INSERT INTO Users (ho_ten, email, password, role, don_vi, quay_hang_id, created_at) VALUES (?,?,?,?,?,?,CURRENT_TIMESTAMP)";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getHoTen());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getDonVi());
            if (u.getQuayHangId() == null) ps.setNull(6, Types.INTEGER); else ps.setInt(6, u.getQuayHangId());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert user", e);
        }
    }

    public boolean update(User u) {
        String sql = "UPDATE Users SET ho_ten=?, email=?, password=?, role=?, don_vi=?, quay_hang_id=? WHERE user_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getHoTen());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getDonVi());
            if (u.getQuayHangId() == null) ps.setNull(6, Types.INTEGER); else ps.setInt(6, u.getQuayHangId());
            ps.setInt(7, u.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update user", e);
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Users WHERE user_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete user", e);
        }
    }

    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setHoTen(rs.getString("ho_ten"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setDonVi(rs.getString("don_vi"));
        int qh = rs.getInt("quay_hang_id");
        u.setQuayHangId(rs.wasNull() ? null : qh);
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
