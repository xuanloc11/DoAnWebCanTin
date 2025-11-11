package repository;

import models.QuayHang;
import java.util.List;

public interface QuayHangRepository {
    List<QuayHang> getAll();
    QuayHang findById(int id);
    int insert(QuayHang q);
    boolean update(QuayHang q);
    boolean delete(int id);
}
