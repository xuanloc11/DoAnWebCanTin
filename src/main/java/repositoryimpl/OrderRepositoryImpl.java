package repositoryimpl;

import Util.DataSourceUtil;
import models.Order;
import repository.OrderRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class OrderRepositoryImpl implements OrderRepository {
    @Override
    public List<Order> getAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT `order_id`, `user_id`, `quay_hang_id`, `tong_tien`, `thoi_gian_dat`, `trang_thai_order`, `ghi_chu` FROM `Orders` ORDER BY `thoi_gian_dat` DESC";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query Orders", e);
        }
        return orders;
    }

    @Override
    public Order findById(int id) {
        String sql = "SELECT `order_id`, `user_id`, `quay_hang_id`, `tong_tien`, `thoi_gian_dat`, `trang_thai_order`, `ghi_chu` FROM `Orders` WHERE `order_id`=?";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find Order by id", e);
        }
        return null;
    }

    @Override
    public int insert(Order o) {
        String sql = "INSERT INTO `Orders` (`user_id`, `quay_hang_id`, `tong_tien`, `thoi_gian_dat`, `trang_thai_order`, `ghi_chu`) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, o.getUserId());
            // Allow NULL quay_hang_id if not set or invalid
            if (o.getQuayHangId() <= 0) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, o.getQuayHangId());
            }
            BigDecimal tongTien = o.getTongTien() == null ? BigDecimal.ZERO : o.getTongTien();
            ps.setBigDecimal(3, tongTien);
            Timestamp ts = o.getThoiGianDat() == null ? new Timestamp(System.currentTimeMillis()) : o.getThoiGianDat();
            ps.setTimestamp(4, ts);
            ps.setString(5, o.getTrangThaiOrder());
            ps.setString(6, o.getGhiChu());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to insert Order. SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode() + ", Message=" + e.getMessage());
            throw new RuntimeException("Failed to insert Order", e);
        }
        return 0;
    }

    @Override
    public boolean update(Order o) {
        String sql = "UPDATE `Orders` SET `user_id`=?, `quay_hang_id`=?, `tong_tien`=?, `thoi_gian_dat`=?, `trang_thai_order`=?, `ghi_chu`=? WHERE `order_id`=?";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, o.getUserId());
            if (o.getQuayHangId() <= 0) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, o.getQuayHangId());
            }
            ps.setBigDecimal(3, o.getTongTien() == null ? BigDecimal.ZERO : o.getTongTien());
            ps.setTimestamp(4, o.getThoiGianDat() == null ? new Timestamp(System.currentTimeMillis()) : o.getThoiGianDat());
            ps.setString(5, o.getTrangThaiOrder());
            ps.setString(6, o.getGhiChu());
            ps.setInt(7, o.getOrderId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to update Order. SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode() + ", Message=" + e.getMessage());
            throw new RuntimeException("Failed to update Order", e);
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM `Orders` WHERE `order_id`=?";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete Order", e);
        }
    }

    @Override
    public boolean cancel(int id) {
        String sql = "UPDATE `Orders` SET `trang_thai_order`='CANCELLED' WHERE `order_id`=?";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to cancel Order", e);
        }
    }

    @Override
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE `Orders` SET `trang_thai_order`=? WHERE `order_id`=?";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update order status", e);
        }
    }

    @Override
    public List<Order> findByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT `order_id`, `user_id`, `quay_hang_id`, `tong_tien`, `thoi_gian_dat`, `trang_thai_order`, `ghi_chu` FROM `Orders` WHERE `user_id`=? ORDER BY `thoi_gian_dat` DESC";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) orders.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query Orders by user", e);
        }
        return orders;
    }

    private Order map(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setQuayHangId(rs.getInt("quay_hang_id"));
        o.setTongTien(rs.getBigDecimal("tong_tien"));
        o.setThoiGianDat(rs.getTimestamp("thoi_gian_dat"));
        o.setTrangThaiOrder(rs.getString("trang_thai_order"));
        o.setGhiChu(rs.getString("ghi_chu"));
        return o;
    }
}
