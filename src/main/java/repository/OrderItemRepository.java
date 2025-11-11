package repository;

import models.OrderItem;
import java.util.List;

public interface OrderItemRepository {
    List<OrderItem> findByOrderId(int orderId);
    OrderItem findById(int id);
    int insert(OrderItem item);
    boolean update(OrderItem item);
    boolean delete(int id);
    boolean deleteByOrderId(int orderId);
}
