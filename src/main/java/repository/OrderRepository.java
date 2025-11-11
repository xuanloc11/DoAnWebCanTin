package repository;

import models.Order;
import java.util.List;

public interface OrderRepository {
    List<Order> getAll();
    Order findById(int id);
    int insert(Order o);
    boolean update(Order o);
    boolean delete(int id);
    boolean cancel(int id); // New: mark order as cancelled instead of deleting
    boolean updateStatus(int id, String status); // New: update only status
    List<Order> findByUser(int userId); // Added for profile
}
