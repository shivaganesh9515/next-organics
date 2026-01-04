import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum OrderStatus {
  processing,
  shipped,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.processing: return 'Processing';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.processing: return Colors.orange;
      case OrderStatus.shipped: return Colors.blue;
      case OrderStatus.delivered: return AppColors.success;
      case OrderStatus.cancelled: return AppColors.error;
    }
  }
}

class OrderEntity {
  final String id;
  final DateTime date;
  final double total;
  final OrderStatus status;
  final int itemCount;
  final String firstItemName; // For preview

  const OrderEntity({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.itemCount,
    required this.firstItemName,
  });
}
