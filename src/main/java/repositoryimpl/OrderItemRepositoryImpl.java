package repositoryimpl;

import Util.DataSourceUtil;
import models.OrderItem;
import repository.OrderItemRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemRepositoryImpl implements OrderItemRepository {
    @Override
    public List<OrderItem> findByOrderId(int orderId) {
        String sql = "SELECT `order_item_id`, `order_id`, `mon_an_id`, `so_luong`, `don_gia_mon_an_luc_dat` FROM `OrderItems` WHERE `order_id`=?";
        List<OrderItem> list = new ArrayList<>();
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query OrderItems by order_id", e);
        }
        return list;
    }

    @Override
    public OrderItem findById(int id) {
        String sql = "SELECT `order_item_id`, `order_id`, `mon_an_id`, `so_luong`, `don_gia_mon_an_luc_dat` FROM `OrderItems` WHERE `order_item_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find OrderItem by id", e);
        }
        return null;
    }

    @Override
    public int insert(OrderItem item) {
        String sql = "INSERT INTO `OrderItems` (`order_id`, `mon_an_id`, `so_luong`, `don_gia_mon_an_luc_dat`) VALUES (?,?,?,?)";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getMonAnId());
            ps.setInt(3, item.getSoLuong());
            ps.setBigDecimal(4, item.getDonGiaMonAnLucDat());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert OrderItem", e);
        }
    }

    @Override
    public boolean update(OrderItem item) {
        String sql = "UPDATE `OrderItems` SET `order_id`=?, `mon_an_id`=?, `so_luong`=?, `don_gia_mon_an_luc_dat`=? WHERE `order_item_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getMonAnId());
            ps.setInt(3, item.getSoLuong());
            ps.setBigDecimal(4, item.getDonGiaMonAnLucDat());
            ps.setInt(5, item.getOrderItemId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update OrderItem", e);
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM `OrderItems` WHERE `order_item_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete OrderItem", e);
        }
    }

    @Override
    public boolean deleteByOrderId(int orderId) {
        String sql = "DELETE FROM `OrderItems` WHERE `order_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete OrderItems by order_id", e);
        }
    }

    private OrderItem map(ResultSet rs) throws SQLException {
        OrderItem i = new OrderItem();
        i.setOrderItemId(rs.getInt("order_item_id"));
        i.setOrderId(rs.getInt("order_id"));
        i.setMonAnId(rs.getInt("mon_an_id"));
        i.setSoLuong(rs.getInt("so_luong"));
        i.setDonGiaMonAnLucDat(rs.getBigDecimal("don_gia_mon_an_luc_dat"));
        return i;
    }
}
