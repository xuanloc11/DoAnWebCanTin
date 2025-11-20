package service;

import models.User;
import models.Page;
import models.PageRequest;
import repository.UserRepository;

import java.util.List;

public class UserService {
    private final UserRepository repo = new UserRepository();

    public User authenticate(String email, String password) {
        if (email == null || password == null) return null;
        User u = repo.findByEmail(email.trim());
        if (u == null) return null;
        // Demo: plaintext compare; replace with hashing in production
        return password.equals(u.getPassword()) ? u : null;
    }

    public User findByEmail(String email) {
        if (email == null) return null;
        return repo.findByEmail(email.trim());
    }

    public List<User> getAllUsers() {
        return repo.getAllUsers();
    }

    public User get(int id) {
        return repo.findById(id);
    }

    public int create(User u) {
        return repo.insert(u);
    }

    public boolean update(User u) {
        return repo.update(u);
    }

    public boolean delete(int id) {
        return repo.delete(id);
    }

    public Page<User> getPage(PageRequest pr) {
        List<User> all = repo.getAllUsers();
        int total = all.size();
        int page = pr.getPage();
        int size = pr.getSize();
        int fromIndex = Math.min(pr.getOffset(), total);
        int toIndex = Math.min(fromIndex + size, total);
        List<User> content = all.subList(fromIndex, toIndex);
        return new Page<>(content, page, size, total);
    }
}
