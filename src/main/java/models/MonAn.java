package models;

import java.math.BigDecimal;

public class MonAn {
    private int monAnId;
    private int quayHangId;
    private String tenMonAn;
    private String moTa;
    private BigDecimal gia;
    private String hinhAnhUrl;
    private String trangThaiMon;

    public MonAn() {}

    public MonAn(int monAnId, int quayHangId, String tenMonAn, String moTa, BigDecimal gia, String hinhAnhUrl, String trangThaiMon) {
        this.monAnId = monAnId;
        this.quayHangId = quayHangId;
        this.tenMonAn = tenMonAn;
        this.moTa = moTa;
        this.gia = gia;
        this.hinhAnhUrl = hinhAnhUrl;
        this.trangThaiMon = trangThaiMon;
    }

    public int getMonAnId() { return monAnId; }
    public void setMonAnId(int monAnId) { this.monAnId = monAnId; }

    public int getQuayHangId() { return quayHangId; }
    public void setQuayHangId(int quayHangId) { this.quayHangId = quayHangId; }

    public String getTenMonAn() { return tenMonAn; }
    public void setTenMonAn(String tenMonAn) { this.tenMonAn = tenMonAn; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public BigDecimal getGia() { return gia; }
    public void setGia(BigDecimal gia) { this.gia = gia; }

    public String getHinhAnhUrl() { return hinhAnhUrl; }
    public void setHinhAnhUrl(String hinhAnhUrl) { this.hinhAnhUrl = hinhAnhUrl; }

    public String getTrangThaiMon() { return trangThaiMon; }
    public void setTrangThaiMon(String trangThaiMon) { this.trangThaiMon = trangThaiMon; }

    @Override
    public String toString() {
        return "MonAn{" +
                "monAnId=" + monAnId +
                ", quayHangId=" + quayHangId +
                ", tenMonAn='" + tenMonAn + '\'' +
                ", moTa='" + moTa + '\'' +
                ", gia=" + gia +
                ", hinhAnhUrl='" + hinhAnhUrl + '\'' +
                ", trangThaiMon='" + trangThaiMon + '\'' +
                '}';
    }
}
