package service;

import models.Menu;
import repository.MenuRepository;
import repositoryimpl.MenuRepositoryImpl;

import java.util.List;

public class MenuService {
    private final MenuRepository repo = new MenuRepositoryImpl();

    public List<Menu> all() { return repo.getAll(); }
    public Menu get(int id) { return repo.findById(id); }
    public int create(Menu m) { return repo.insert(m); }
    public boolean update(Menu m) { return repo.update(m); }
    public boolean delete(int id) { return repo.delete(id); }
}
