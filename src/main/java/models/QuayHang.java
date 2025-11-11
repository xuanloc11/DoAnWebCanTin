package models;

public class QuayHang {
    private int quayHangId;
    private String tenQuayHang;
    private String viTri;
    private String trangThai; // varchar(20)

    public QuayHang() {}

    public QuayHang(int quayHangId, String tenQuayHang, String viTri, String trangThai) {
        this.quayHangId = quayHangId;
        this.tenQuayHang = tenQuayHang;
        this.viTri = viTri;
        this.trangThai = trangThai;
    }

    public int getQuayHangId() { return quayHangId; }
    public void setQuayHangId(int quayHangId) { this.quayHangId = quayHangId; }

    public String getTenQuayHang() { return tenQuayHang; }
    public void setTenQuayHang(String tenQuayHang) { this.tenQuayHang = tenQuayHang; }

    public String getViTri() { return viTri; }
    public void setViTri(String viTri) { this.viTri = viTri; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}
