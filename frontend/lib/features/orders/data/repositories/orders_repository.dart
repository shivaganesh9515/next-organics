import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/entities/order.dart';

/// Repository for managing orders
class OrdersRepository {
  final LoggerService _logger;

  OrdersRepository(this._logger);

  /// Simulate creating an order
  Future<void> createOrder({
    required double total,
    required int itemCount,
    required List<dynamic> items, // Cart items
  }) async {
    try {
      _logger.d('Creating order with total: $total, items: $itemCount');

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, this would call Supabase:
      // await supabase.from('orders').insert({...});

      _logger.i('Order created successfully (Mock)');
    } catch (e) {
      _logger.e('Failed to create order', e);
      throw Exception('Failed to create order');
    }
  }
}

// Provider
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(LoggerService());
});
