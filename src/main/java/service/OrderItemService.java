package service;

import models.OrderItem;
import repository.OrderItemRepository;
import repositoryimpl.OrderItemRepositoryImpl;

import java.util.List;

public class OrderItemService {
    private final OrderItemRepository repo = new OrderItemRepositoryImpl();

    public List<OrderItem> byOrder(int orderId) { return repo.findByOrderId(orderId); }
    public OrderItem get(int id) { return repo.findById(id); }
    public int create(OrderItem i) { return repo.insert(i); }
    public boolean update(OrderItem i) { return repo.update(i); }
    public boolean delete(int id) { return repo.delete(id); }
    public boolean clearOrder(int orderId) { return repo.deleteByOrderId(orderId); }
}

