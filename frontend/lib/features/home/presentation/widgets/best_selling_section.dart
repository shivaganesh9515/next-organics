import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../products/presentation/providers/products_provider.dart';
import 'grid_product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/loading_indicator.dart';

/// 2-column grid "Best Selling" section with highest-rated products
class BestSellingSection extends ConsumerWidget {
  const BestSellingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      data: (products) {
        // Sort by rating and take top products
        final bestSelling = [...products]
          ..sort((a, b) => b.rating.compareTo(a.rating));
        final displayProducts = bestSelling.take(6).toList();

        if (displayProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header with exact specifications
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Best Selling 🔥',
                    style: AppTypography.displaySmall.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/category/all'),
                    child: Text(
                      'See all',
                      style: AppTypography.labelLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 2-column grid with exact specifications
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: displayProducts.length,
                itemBuilder: (context, index) {
                  return GridProductCard(
                    product: displayProducts[index],
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 400,
        child: Center(child: LoadingIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
