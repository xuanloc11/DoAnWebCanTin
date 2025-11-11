package service;

import models.QuayHang;
import repository.QuayHangRepository;
import repositoryimpl.QuayHangRepositoryImpl;

import java.util.List;

public class QuayHangService {
    private final QuayHangRepository quayHangRepository = new QuayHangRepositoryImpl();

    public List<QuayHang> getAll() {
        return quayHangRepository.getAll();
    }

    public QuayHang get(int id) {
        return quayHangRepository.findById(id);
    }

    public int create(QuayHang q) {
        return quayHangRepository.insert(q);
    }

    public boolean update(QuayHang q) {
        return quayHangRepository.update(q);
    }

    public boolean delete(int id) {
        return quayHangRepository.delete(id);
    }
}
