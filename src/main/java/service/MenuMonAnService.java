package service;

import repository.MenuMonAnRepository;
import repositoryimpl.MenuMonAnRepositoryImpl;

import java.util.List;

public class MenuMonAnService {
    private final MenuMonAnRepository repo = new MenuMonAnRepositoryImpl();

    public boolean add(int menuId, int monAnId) { return repo.add(menuId, monAnId); }
    public boolean remove(int menuId, int monAnId) { return repo.remove(menuId, monAnId); }
    public boolean clear(int menuId) { return repo.removeByMenu(menuId); }
    public boolean removeByMonAn(int monAnId) { return repo.removeByMonAn(monAnId); }
    public List<Integer> monAnIds(int menuId) { return repo.findMonAnIdsByMenu(menuId); }
}

