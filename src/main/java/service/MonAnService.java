package service;

import models.MonAn;
import repository.MonAnRepository;

import java.util.List;

public class MonAnService {
    private final MonAnRepository repo = new MonAnRepository();

    public List<MonAn> latest(int limit) { return repo.findLatest(limit); }
    public List<MonAn> all() { return repo.findAll(); }

    public MonAn get(int id) { return repo.findById(id); }
    public int create(MonAn m) { return repo.insert(m); }
    public boolean update(MonAn m) { return repo.update(m); }
    public boolean delete(int id) { return repo.delete(id); }
    public List<MonAn> byStall(int stallId, int limit) { return repo.findByStall(stallId, limit); }
}
