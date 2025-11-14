package service;

import Util.DataSourceUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ThongKeService {
    private final javax.sql.DataSource ds = DataSourceUtil.getDataSource();

    public static class DailyCount {
        private LocalDate date; private int count;
        public DailyCount(LocalDate date, int count){ this.date = date; this.count = count; }
        public LocalDate getDate(){ return date; }
        public int getCount(){ return count; }
        // Helper for JSP fmt:formatDate
        public java.sql.Date getDateSql(){ return date == null ? null : java.sql.Date.valueOf(date); }
    }

    public static class StallRevenue {
        private Integer quayHangId; private String tenQuay; private BigDecimal revenue;
        public StallRevenue(Integer id, String name, BigDecimal rev){ this.quayHangId = id; this.tenQuay = name; this.revenue = rev; }
        public Integer getQuayHangId(){ return quayHangId; }
        public String getTenQuay(){ return tenQuay; }
        public BigDecimal getRevenue(){ return revenue; }
    }

    public static class TopDish {
        private Integer monAnId; private String tenMon; private long soLuong; private BigDecimal doanhThu;
        public TopDish(Integer id, String ten, long qty, BigDecimal rev){ this.monAnId = id; this.tenMon = ten; this.soLuong = qty; this.doanhThu = rev; }
        public Integer getMonAnId(){ return monAnId; }
        public String getTenMon(){ return tenMon; }
        public long getSoLuong(){ return soLuong; }
        public BigDecimal getDoanhThu(){ return doanhThu; }
    }

    private static Timestamp cutoffDays(int days){
        long ms = System.currentTimeMillis() - (long) Math.max(0, days) * 24L * 60L * 60L * 1000L;
        return new Timestamp(ms);
    }

    public List<DailyCount> ordersCountByDay(int days){
        String sql = "SELECT DATE(o.thoi_gian_dat) AS d, COUNT(*) AS c " +
                "FROM Orders o WHERE o.thoi_gian_dat >= ? AND (o.trang_thai_order IS NULL OR o.trang_thai_order <> 'CANCELLED') " +
                "GROUP BY DATE(o.thoi_gian_dat) ORDER BY d";
        List<DailyCount> out = new ArrayList<>();
        try (Connection con = ds.getConnection(); PreparedStatement ps = con.prepareStatement(sql)){
            ps.setTimestamp(1, cutoffDays(days));
            try (ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                    Date d = rs.getDate("d");
                    int c = rs.getInt("c");
                    out.add(new DailyCount(d.toLocalDate(), c));
                }
            }
        } catch (SQLException e){ throw new RuntimeException("Failed to compute orders per day", e); }
        return out;
    }

    public List<StallRevenue> revenueByStall(int days){
        String sql = "SELECT o.quay_hang_id AS id, q.ten_quay_hang AS name, SUM(COALESCE(o.tong_tien,0)) AS rev " +
                "FROM Orders o LEFT JOIN quayhang q ON o.quay_hang_id = q.quay_hang_id " +
                "WHERE o.thoi_gian_dat >= ? AND (o.trang_thai_order IS NULL OR o.trang_thai_order <> 'CANCELLED') " +
                "GROUP BY o.quay_hang_id, q.ten_quay_hang ORDER BY rev DESC";
        List<StallRevenue> out = new ArrayList<>();
        try (Connection con = ds.getConnection(); PreparedStatement ps = con.prepareStatement(sql)){
            ps.setTimestamp(1, cutoffDays(days));
            try (ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                    Integer id = (Integer) rs.getObject("id");
                    String name = rs.getString("name");
                    BigDecimal rev = rs.getBigDecimal("rev");
                    out.add(new StallRevenue(id, name, rev == null ? BigDecimal.ZERO : rev));
                }
            }
        } catch (SQLException e){ throw new RuntimeException("Failed to compute revenue by stall", e); }
        return out;
    }

    public List<TopDish> topDishes(int limit, int days){
        String sql = "SELECT i.mon_an_id AS id, m.ten_mon_an AS name, SUM(i.so_luong) AS qty, " +
                "SUM(i.so_luong * COALESCE(i.don_gia_mon_an_luc_dat,0)) AS rev " +
                "FROM OrderItems i JOIN Orders o ON i.order_id = o.order_id " +
                "LEFT JOIN MonAn m ON i.mon_an_id = m.mon_an_id " +
                "WHERE o.thoi_gian_dat >= ? AND (o.trang_thai_order IS NULL OR o.trang_thai_order <> 'CANCELLED') " +
                "GROUP BY i.mon_an_id, m.ten_mon_an ORDER BY qty DESC LIMIT ?";
        List<TopDish> out = new ArrayList<>();
        try (Connection con = ds.getConnection(); PreparedStatement ps = con.prepareStatement(sql)){
            ps.setTimestamp(1, cutoffDays(days));
            ps.setInt(2, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                    Integer id = (Integer) rs.getObject("id");
                    String name = rs.getString("name");
                    long qty = rs.getLong("qty");
                    BigDecimal rev = rs.getBigDecimal("rev");
                    out.add(new TopDish(id, name, qty, rev == null ? BigDecimal.ZERO : rev));
                }
            }
        } catch (SQLException e){ throw new RuntimeException("Failed to compute top dishes", e); }
        return out;
    }
}
