import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock notifications data
    final notifications = [
      {
        'title': 'Order Delivered',
        'message': 'Your order #28392 has been delivered successfully. Enjoy your fresh groceries!',
        'time': '2 mins ago',
        'isRead': false,
        'icon': Icons.check_circle_outline,
        'color': AppColors.primary,
      },
      {
        'title': 'Flash Sale: 20% OFF',
        'message': 'Get 20% off on all organic vegetables today! Use code FRESH20.',
        'time': '2 hours ago',
        'isRead': false,
        'icon': Icons.local_offer_outlined,
        'color': AppColors.secondary,
      },
      {
        'title': 'Order Shipped',
        'message': 'Your order #28392 is on the way. Track it live!',
        'time': '1 day ago',
        'isRead': true,
        'icon': Icons.local_shipping_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'Welcome Gift',
        'message': 'Thanks for joining us! Here is a ₹100 voucher for your first order.',
        'time': 'Just now',
        'isRead': false,
        'icon': Icons.celebration_outlined,
        'color': Colors.purple,
      },
      {
        'title': 'Farm Update',
        'message': 'Green Valley Farm just harvested fresh strawberries. Order now!',
        'time': '4 days ago',
        'isRead': true,
        'icon': Icons.agriculture_outlined,
        'color': Colors.green.shade700,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Clear All',
              style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = notifications[index];
          final isRead = n['isRead'] as bool;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRead ? Colors.transparent : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isRead ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade100),
              boxShadow: isRead ? [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (n['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              n['title'] as String,
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            n['time'] as String,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textHint,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        n['message'] as String,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isRead ? AppColors.textSecondary : AppColors.textPrimary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 4),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
