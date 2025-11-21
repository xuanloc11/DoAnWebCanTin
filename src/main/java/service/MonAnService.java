package service;

import models.MonAn;
import models.Page;
import models.PageRequest;
import repository.MonAnRepository;

import java.math.BigDecimal;
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

    public Page<MonAn> page(Integer quayId, String q, String status, BigDecimal minPrice, BigDecimal maxPrice, PageRequest pr) {
        return repo.findPage(quayId, q, status, minPrice, maxPrice, pr);
    }
}
