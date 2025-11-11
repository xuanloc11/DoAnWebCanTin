package models;

import java.math.BigDecimal;

public class CartItem {
    private MonAn monAn;
    private int soLuong;

    public CartItem(MonAn monAn, int soLuong) {
        this.monAn = monAn;
        this.soLuong = soLuong;
    }

    // Getter & Setter
    public MonAn getMonAn() { return monAn; }
    public void setMonAn(MonAn monAn) { this.monAn = monAn; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    // Hàm tiện ích để lấy tổng giá của item này
    public BigDecimal getTongGia() {
        BigDecimal gia = (monAn == null || monAn.getGia() == null) ? BigDecimal.ZERO : monAn.getGia();
        return gia.multiply(BigDecimal.valueOf(soLuong));
    }
}
