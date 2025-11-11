package models;

import java.math.BigDecimal;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int monAnId;
    private int soLuong;
    private BigDecimal donGiaMonAnLucDat;

    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getMonAnId() { return monAnId; }
    public void setMonAnId(int monAnId) { this.monAnId = monAnId; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public BigDecimal getDonGiaMonAnLucDat() { return donGiaMonAnLucDat; }
    public void setDonGiaMonAnLucDat(BigDecimal donGiaMonAnLucDat) { this.donGiaMonAnLucDat = donGiaMonAnLucDat; }
}

