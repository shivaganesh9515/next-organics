import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import 'curved_header_painter.dart';

/// Premium header with gradient background, curved bottom, location, search, and cart
class CurvedHeaderContainer extends ConsumerWidget {
  final VoidCallback? onLocationTap;

  const CurvedHeaderContainer({
    super.key,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartItemCount = cartState.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return SizedBox(
      height: 100,
      child: CustomPaint(
        painter: CurvedHeaderPainter(
          gradient: const LinearGradient(
            colors: [Colors.white, AppColors.creamBackground],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                // Location Section (30%)
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: onLocationTap ?? () {
                      // TODO: Show location picker bottom sheet
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Location picker coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pillBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Deliver to',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  'Green Valley',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Search Bar (40%)
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22), // Full pill
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(
                            Icons.search,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Search for products...',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textHint,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Cart Badge (30%)
                GestureDetector(
                  onTap: () => context.push('/cart'),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.pillBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (cartItemCount > 0)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  cartItemCount > 9 ? '9+' : '$cartItemCount',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
