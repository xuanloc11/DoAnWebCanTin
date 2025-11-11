package repositoryimpl;

import Util.DataSourceUtil;
import repository.MenuMonAnRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuMonAnRepositoryImpl implements MenuMonAnRepository {
    @Override
    public boolean add(int menuId, int monAnId) {
        String sql = "INSERT INTO `Menu_MonAn` (`menu_id`, `mon_an_id`) VALUES (?,?)";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            ps.setInt(2, monAnId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to link MonAn to Menu", e);
        }
    }

    @Override
    public boolean remove(int menuId, int monAnId) {
        String sql = "DELETE FROM `Menu_MonAn` WHERE `menu_id`=? AND `mon_an_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            ps.setInt(2, monAnId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to unlink MonAn from Menu", e);
        }
    }

    @Override
    public boolean removeByMenu(int menuId) {
        String sql = "DELETE FROM `Menu_MonAn` WHERE `menu_id`=?";
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to clear links for menu", e);
        }
    }

    @Override
    public List<Integer> findMonAnIdsByMenu(int menuId) {
        String sql = "SELECT `mon_an_id` FROM `Menu_MonAn` WHERE `menu_id`=?";
        List<Integer> ids = new ArrayList<>();
        try (Connection con = DataSourceUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query mon_an_ids by menu", e);
        }
        return ids;
    }
}

