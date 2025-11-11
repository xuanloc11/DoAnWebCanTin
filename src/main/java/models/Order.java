package models;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private int quayHangId;
    private BigDecimal tongTien;
    private Timestamp thoiGianDat;
    private String trangThaiOrder;
    private String ghiChu;

    public Order() {
    }

    public Order(int orderId, int userId, int quayHangId, BigDecimal tongTien, Timestamp thoiGianDat, String trangThaiOrder, String ghiChu) {
        this.orderId = orderId;
        this.userId = userId;
        this.quayHangId = quayHangId;
        this.tongTien = tongTien;
        this.thoiGianDat = thoiGianDat;
        this.trangThaiOrder = trangThaiOrder;
        this.ghiChu = ghiChu;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getQuayHangId() {
        return quayHangId;
    }

    public void setQuayHangId(int quayHangId) {
        this.quayHangId = quayHangId;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    }

    public Timestamp getThoiGianDat() {
        return thoiGianDat;
    }

    public void setThoiGianDat(Timestamp thoiGianDat) {
        this.thoiGianDat = thoiGianDat;
    }

    public String getTrangThaiOrder() {
        return trangThaiOrder;
    }

    public void setTrangThaiOrder(String trangThaiOrder) {
        this.trangThaiOrder = trangThaiOrder;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
