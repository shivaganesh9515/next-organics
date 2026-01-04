import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartState = ref.watch(cartProvider);
    final inCart = cartState.hasProduct(product.id);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/product/${product.id}');
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radiusMedium),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                         color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
                          child: const Icon(Icons.image_not_supported, color: AppColors.textHint),
                        ),
                      ),
                    ),
                  ),
                  // Discount Badge
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.discount,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Text(
                          '${product.discount!.toInt()}% OFF',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product Info
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.labelLarge.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.ratingStar,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating}',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textHintDark : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.hasDiscount)
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textHintDark : AppColors.textHint,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '\$${product.finalPrice.toStringAsFixed(2)}',
                            style: AppTypography.priceSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      // Add to Cart Button
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ref.read(cartProvider.notifier).addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: inCart ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Icon(
                            inCart ? Icons.check : Icons.add_shopping_cart,
                            color: inCart ? Colors.white : AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
