package repositoryimpl;

import Util.DataSourceUtil;
import models.QuayHang;
import repository.QuayHangRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuayHangRepositoryImpl implements QuayHangRepository {
    @Override
    public List<QuayHang> getAll() {
        List<QuayHang> stalls = new ArrayList<>();
        String sql = "SELECT `quay_hang_id`, `ten_quay_hang`, `vi_tri`, `trang_thai` FROM `quayhang` ORDER BY `quay_hang_id`";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stalls.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query QuayHang list", e);
        }
        return stalls;
    }

    @Override
    public QuayHang findById(int id) {
        String sql = "SELECT `quay_hang_id`, `ten_quay_hang`, `vi_tri`, `trang_thai` FROM `quayhang` WHERE `quay_hang_id`=?";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find QuayHang by id", e);
        }
        return null;
    }

    @Override
    public int insert(QuayHang q) {
        String sql = "INSERT INTO `quayhang` (`ten_quay_hang`, `vi_tri`, `trang_thai`) VALUES (?,?,?)";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, q.getTenQuayHang());
            ps.setString(2, q.getViTri());
            ps.setString(3, q.getTrangThai());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert QuayHang", e);
        }
        return 0;
    }

    @Override
    public boolean update(QuayHang q) {
        String sql = "UPDATE `quayhang` SET `ten_quay_hang`=?, `vi_tri`=?, `trang_thai`=? WHERE `quay_hang_id`=?";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, q.getTenQuayHang());
            ps.setString(2, q.getViTri());
            ps.setString(3, q.getTrangThai());
            ps.setInt(4, q.getQuayHangId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update QuayHang", e);
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM `quayhang` WHERE `quay_hang_id`=?";
        try (Connection conn = DataSourceUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete QuayHang", e);
        }
    }

    private QuayHang map(ResultSet rs) throws SQLException {
        QuayHang stall = new QuayHang();
        stall.setQuayHangId(rs.getInt("quay_hang_id"));
        stall.setTenQuayHang(rs.getString("ten_quay_hang"));
        stall.setViTri(rs.getString("vi_tri"));
        stall.setTrangThai(rs.getString("trang_thai"));
        return stall;
    }
}
