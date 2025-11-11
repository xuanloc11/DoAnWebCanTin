package repositoryimpl;

import Util.DataSourceUtil;
import models.Menu;
import repository.MenuRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuRepositoryImpl implements MenuRepository {
    @Override
    public List<Menu> getAll() {
        String sql = "SELECT `menu_id`, `quay_hang_id`, `ngay_ap_dung`, `ten_thuc_don` FROM `menus` ORDER BY `ngay_ap_dung` DESC, `menu_id` DESC";
        List<Menu> list = new ArrayList<>();
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query menus", e);
        }
        return list;
    }

    @Override
    public Menu findById(int id) {
        String sql = "SELECT `menu_id`, `quay_hang_id`, `ngay_ap_dung`, `ten_thuc_don` FROM `menus` WHERE `menu_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find menu by id", e);
        }
        return null;
    }

    @Override
    public int insert(Menu m) {
        String sql = "INSERT INTO `menus` (`quay_hang_id`, `ngay_ap_dung`, `ten_thuc_don`) VALUES (?,?,?)";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, m.getQuayHangId());
            ps.setDate(2, m.getNgayApDung());
            ps.setString(3, m.getTenThucDon());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert menu", e);
        }
    }

    @Override
    public boolean update(Menu m) {
        String sql = "UPDATE `menus` SET `quay_hang_id`=?, `ngay_ap_dung`=?, `ten_thuc_don`=? WHERE `menu_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, m.getQuayHangId());
            ps.setDate(2, m.getNgayApDung());
            ps.setString(3, m.getTenThucDon());
            ps.setInt(4, m.getMenuId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update menu", e);
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM `menus` WHERE `menu_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete menu", e);
        }
    }

    private Menu map(ResultSet rs) throws SQLException {
        Menu m = new Menu();
        m.setMenuId(rs.getInt("menu_id"));
        m.setQuayHangId(rs.getInt("quay_hang_id"));
        m.setNgayApDung(rs.getDate("ngay_ap_dung"));
        m.setTenThucDon(rs.getString("ten_thuc_don"));
        return m;
    }
}
