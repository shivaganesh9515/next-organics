import '../../domain/entities/order.dart';

class MockOrderDataSource {
  static const _delay = Duration(milliseconds: 500);

  Future<List<OrderEntity>> getOrders() async {
    await Future.delayed(_delay);
    return _mockOrders;
  }

  static final List<OrderEntity> _mockOrders = [
    OrderEntity(
      id: 'ORD-2026-001',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      total: 1249.0,
      status: OrderStatus.processing,
      itemCount: 4,
      firstItemName: 'Fresh Organic Apples (1kg)',
    ),
    OrderEntity(
      id: 'ORD-2025-892',
      date: DateTime.now().subtract(const Duration(days: 2)),
      total: 450.0,
      status: OrderStatus.delivered,
      itemCount: 2,
      firstItemName: 'Organic Whole Milk',
    ),
    OrderEntity(
      id: 'ORD-2025-756',
      date: DateTime.now().subtract(const Duration(days: 15)),
      total: 2100.0,
      status: OrderStatus.delivered,
      itemCount: 8,
      firstItemName: 'Mixed Nuts (500g)',
    ),
     OrderEntity(
      id: 'ORD-2025-601',
      date: DateTime.now().subtract(const Duration(days: 30)),
      total: 899.0,
      status: OrderStatus.cancelled,
      itemCount: 3,
      firstItemName: 'Green Tea Box',
    ),
  ];
}
