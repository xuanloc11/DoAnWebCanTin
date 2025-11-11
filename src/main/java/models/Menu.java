package models;

import java.sql.Date;

public class Menu {
    private int menuId;
    private int quayHangId;
    private Date ngayApDung; // date
    private String tenThucDon; // varchar(100)

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }

    public int getQuayHangId() { return quayHangId; }
    public void setQuayHangId(int quayHangId) { this.quayHangId = quayHangId; }

    public Date getNgayApDung() { return ngayApDung; }
    public void setNgayApDung(Date ngayApDung) { this.ngayApDung = ngayApDung; }

    public String getTenThucDon() { return tenThucDon; }
    public void setTenThucDon(String tenThucDon) { this.tenThucDon = tenThucDon; }
}
