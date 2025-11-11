package repository;

import java.util.List;

public interface MenuMonAnRepository {
    boolean add(int menuId, int monAnId);
    boolean remove(int menuId, int monAnId);
    boolean removeByMenu(int menuId);
    List<Integer> findMonAnIdsByMenu(int menuId);
}

