import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../products/domain/entities/product.dart';
import '../widgets/large_product_card.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

class ProductSuggestionsWidget extends ConsumerWidget {
  final Product currentProduct;

  const ProductSuggestionsWidget({
    super.key,
    required this.currentProduct,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all products
    final allProducts = ref.watch(productsProvider);

    // Filter logic: Same vendor, exclude current product
    final suggestions = allProducts
        .where((p) {
          // Basic filter: same vendor name (if exists) or same category if vendor is null
          final isSameVendor = (currentProduct.vendorName != null &&
              p.vendorName == currentProduct.vendorName);
          final isSameCategory = p.category == currentProduct.category;

          // Fallback to category if vendor is null, but prioritizing vendor
          final matches =
              currentProduct.vendorName != null ? isSameVendor : isSameCategory;

          return matches && p.id != currentProduct.id;
        })
        .take(5)
        .toList(); // Limit to 5

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(
            currentProduct.vendorName != null
                ? 'More from ${currentProduct.vendorName}'
                : 'Similar Products',
            style: AppTypography.headingMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            separatorBuilder: (ctx, i) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final product = suggestions[index];
              // Using a slightly scaled down version or same card?
              // LargeProductCard is designed for vertical lists (width: double.infinity).
              // We need to constrain distinct width for horizontal list.
              return SizedBox(
                width: 200,
                child: LargeProductCard(
                  product: product,
                  onTap: () => context.push('/product/${product.id}'),
                  // We might need a "compact" mode for LargeProductCard if it's too big,
                  // but for now let's wrap it.
                  // Actually LargeProductCard might be too tall/wide.
                  // Let's rely on its internal layout but constrain width.
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
