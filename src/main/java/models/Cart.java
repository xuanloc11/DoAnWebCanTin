package models;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

public class Cart {
    private int quayHangId; // kept for compatibility, not used in unified cart mode
    private Map<Integer, CartItem> items;

    public Cart(int quayHangId) {
        this.quayHangId = quayHangId;
        this.items = new HashMap<>();
    }
    // Added no-arg constructor for single session cart usage
    public Cart() {
        this.quayHangId = 0;
        this.items = new HashMap<>();
    }

    public void addItem(MonAn monAn, int soLuong) {
        if (monAn == null || soLuong <= 0) return;
        int monAnId = monAn.getMonAnId();
        CartItem existing = items.get(monAnId);
        if (existing != null) {
            existing.setSoLuong(existing.getSoLuong() + soLuong);
        } else {
            items.put(monAnId, new CartItem(monAn, soLuong));
        }
    }

    public void removeItem(int monAnId) { items.remove(monAnId); }

    public void updateItem(int monAnId, int soLuong) {
        CartItem existing = items.get(monAnId);
        if (existing == null) return;
        if (soLuong <= 0) {
            items.remove(monAnId);
        } else {
            existing.setSoLuong(soLuong);
        }
    }

    public BigDecimal getTotalPrice() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items.values()) {
            total = total.add(item.getTongGia());
        }
        return total;
    }

    public int getTotalItems() { return items.size(); }

    public int getTotalQuantity() {
        int sum = 0;
        for (CartItem ci : items.values()) sum += ci.getSoLuong();
        return sum;
    }

    public int getQuayHangId() { return quayHangId; }
    public Map<Integer, CartItem> getItems() { return items; }

    // Merge another cart's items into this cart (used for migration from cartMap)
    public void mergeFrom(Cart other) {
        if (other == null || other.items == null) return;
        for (CartItem ci : other.items.values()) {
            addItem(ci.getMonAn(), ci.getSoLuong());
        }
    }
}
