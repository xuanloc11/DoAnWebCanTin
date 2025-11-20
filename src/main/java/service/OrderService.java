package service;

import models.Order;
import models.Page;
import models.PageRequest;
import repository.OrderRepository;
import repositoryimpl.OrderRepositoryImpl;

import java.util.List;

public class OrderService {
    private final OrderRepository orderRepository = new OrderRepositoryImpl();

    public List<Order> getAllOrders() { return orderRepository.getAll(); }
    public Order get(int id) { return orderRepository.findById(id); }
    public int create(Order o) { return orderRepository.insert(o); }
    public boolean update(Order o) { return orderRepository.update(o); }
    public boolean delete(int id) { return orderRepository.delete(id); }
    public boolean cancel(int id) { return orderRepository.cancel(id); }
    public boolean updateStatus(int id, String status) { return orderRepository.updateStatus(id, status); }
    public List<Order> byUser(int userId) { return orderRepository.findByUser(userId); }

    public Page<Order> getPage(PageRequest pr) {
        int offset = pr.getOffset();
        int limit = pr.getSize();
        List<Order> content = orderRepository.findPage(offset, limit);
        long total = orderRepository.countAll();
        return new Page<>(content, pr.getPage(), pr.getSize(), total);
    }
}
