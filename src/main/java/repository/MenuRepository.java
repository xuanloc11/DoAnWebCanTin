package repository;

import models.Menu;
import java.util.List;

public interface MenuRepository {
    List<Menu> getAll();
    Menu findById(int id);
    int insert(Menu m);
    boolean update(Menu m);
    boolean delete(int id);
}
