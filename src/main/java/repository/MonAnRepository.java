package repository;

import Util.DataSourceUtil;
import models.MonAn;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MonAnRepository {
    private final DataSource ds;

    public MonAnRepository() {
        this.ds = DataSourceUtil.getDataSource();
    }

    public List<MonAn> findLatest(int limit) {
        String sql = "SELECT mon_an_id, quay_hang_id, ten_mon_an, mo_ta, gia, hinh_anh_url, trang_thai_mon " +
                "FROM MonAn ORDER BY mon_an_id DESC LIMIT ?";
        List<MonAn> list = new ArrayList<>();
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query MonAn", e);
        }
        return list;
    }

    public List<MonAn> findAll() {
        String sql = "SELECT mon_an_id, quay_hang_id, ten_mon_an, mo_ta, gia, hinh_anh_url, trang_thai_mon FROM MonAn";
        List<MonAn> list = new ArrayList<>();
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to query MonAn", e);
        }
        return list;
    }

    public MonAn findById(int id) {
        String sql = "SELECT mon_an_id, quay_hang_id, ten_mon_an, mo_ta, gia, hinh_anh_url, trang_thai_mon FROM MonAn WHERE mon_an_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find MonAn by id", e);
        }
        return null;
    }

    public int insert(MonAn m) {
        String sql = "INSERT INTO MonAn (quay_hang_id, ten_mon_an, mo_ta, gia, hinh_anh_url, trang_thai_mon) VALUES (?,?,?,?,?,?)";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, m.getQuayHangId());
            ps.setString(2, m.getTenMonAn());
            ps.setString(3, m.getMoTa());
            ps.setBigDecimal(4, m.getGia() == null ? BigDecimal.ZERO : m.getGia());
            ps.setString(5, m.getHinhAnhUrl());
            ps.setString(6, m.getTrangThaiMon());
            int affected = ps.executeUpdate();
            if (affected == 0) throw new SQLException("Insert MonAn failed, no rows affected.");
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert MonAn", e);
        }
    }

    public boolean update(MonAn m) {
        String sql = "UPDATE MonAn SET quay_hang_id=?, ten_mon_an=?, mo_ta=?, gia=?, hinh_anh_url=?, trang_thai_mon=? WHERE mon_an_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, m.getQuayHangId());
            ps.setString(2, m.getTenMonAn());
            ps.setString(3, m.getMoTa());
            ps.setBigDecimal(4, m.getGia() == null ? BigDecimal.ZERO : m.getGia());
            ps.setString(5, m.getHinhAnhUrl());
            ps.setString(6, m.getTrangThaiMon());
            ps.setInt(7, m.getMonAnId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update MonAn", e);
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM MonAn WHERE mon_an_id=?";
        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete MonAn", e);
        }
    }

    public List<MonAn> findByStall(int stallId, int limit) {
        String sql = "SELECT mon_an_id, quay_hang_id, ten_mon_an, mo_ta, gia, hinh_anh_url, trang_thai_mon FROM MonAn WHERE quay_hang_id=? ORDER BY mon_an_id DESC LIMIT ?";
        List<MonAn> list = new ArrayList<>();
        try (Connection con = ds.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, stallId); ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (SQLException e) { throw new RuntimeException("Failed to query MonAn by stall", e); }
        return list;
    }

    private MonAn map(ResultSet rs) throws SQLException {
        MonAn m = new MonAn();
        m.setMonAnId(rs.getInt("mon_an_id"));
        m.setQuayHangId(rs.getInt("quay_hang_id"));
        m.setTenMonAn(rs.getString("ten_mon_an"));
        m.setMoTa(rs.getString("mo_ta"));
        BigDecimal gia = rs.getBigDecimal("gia");
        m.setGia(gia);
        m.setHinhAnhUrl(rs.getString("hinh_anh_url"));
        m.setTrangThaiMon(rs.getString("trang_thai_mon"));
        return m;
    }
}
