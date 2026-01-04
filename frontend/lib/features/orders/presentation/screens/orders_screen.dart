import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../../core/widgets/animations/fade_in_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/datasources/mock_order_datasource.dart';
import '../../domain/entities/order.dart';

final mockOrderDataSourceProvider = Provider((ref) => MockOrderDataSource());

final ordersProvider = FutureProvider<List<OrderEntity>>((ref) async {
  final dataSource = ref.watch(mockOrderDataSourceProvider);
  return dataSource.getOrders();
});

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return MainScaffold(
      currentIndex: 4, // Profile tab index usually, or separate
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('My Orders', style: AppTypography.headingMedium),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
        ),
        body: ordersAsync.when(
          data: (orders) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return FadeInSlide(
                delay: index * 0.1,
                child: _OrderCard(order: order),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, __) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.id}',
                style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    color: order.status.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.firstItemName + (order.itemCount > 1 ? ' + ${order.itemCount - 1} more' : ''),
            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMM d, yyyy • h:mm a').format(order.date),
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                '₹${order.total.toStringAsFixed(0)}',
                style: AppTypography.priceMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
