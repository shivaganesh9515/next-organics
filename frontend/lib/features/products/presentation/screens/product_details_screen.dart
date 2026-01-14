import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/product_suggestions_widget.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  int _quantity = 1;
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    // product is now direct Product? object
    final product = ref.watch(productProvider(widget.productId));

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Product not found')),
      );
    }

    return _buildProductDetails(context, product);
  }

  Widget _buildProductDetails(BuildContext context, Product product) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Product Details',
                      style: AppTypography.headingMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image
                  Hero(
                    tag: 'product-${product.id}',
                    child: Container(
                      width: double.infinity,
                      height: 280,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.image, size: 50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Product Info Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          product.name,
                          style: AppTypography.displaySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        // Price and Discount
                        Row(
                          children: [
                            Text(
                              '₹${product.finalPrice.toStringAsFixed(0)}',
                              style: AppTypography.headingMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (product.hasDiscount) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.discount,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Discount ${product.discount!.toInt()}%',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Status Row
                        Row(
                          children: [
                            const _StatusBadge(
                              icon: Icons.delivery_dining,
                              text: 'Delivered',
                            ),
                            const SizedBox(width: 12),
                            const _StatusBadge(
                              icon: Icons.access_time,
                              text: 'Time 10 min',
                            ),
                            const SizedBox(width: 12),
                            _StatusBadge(
                              icon: Icons.star,
                              text: '${product.rating} Rating',
                              color: AppColors.ratingGold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        // Description Section
                        Text(
                          'Description',
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedCrossFade(
                          firstChild: Text(
                            product.description,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          secondChild: Text(
                            product.description,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          crossFadeState: _isDescriptionExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isDescriptionExpanded = !_isDescriptionExpanded;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            _isDescriptionExpanded
                                ? 'See less...'
                                : 'See more...',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        // SUGGESTIONS SECTION
                        ProductSuggestionsWidget(currentProduct: product),

                        const SizedBox(height: 100), // Space for bottom section
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Quantity + CTA Section (Fixed at bottom)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Quantity Selector
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onPressed: _quantity > 1
                                ? () {
                                    HapticFeedback.lightImpact();
                                    setState(() => _quantity--);
                                  }
                                : null,
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Text(
                                '$_quantity',
                                key: ValueKey<int>(_quantity),
                                style: AppTypography.headingMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          _QuantityButton(
                            icon: Icons.add,
                            onPressed: _quantity < product.stock
                                ? () {
                                    HapticFeedback.lightImpact();
                                    setState(() => _quantity++);
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Add to Cart Button
                    Expanded(
                      child: _AddToCartButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          ref.read(cartProvider.notifier).addItem(
                                product,
                                quantity: _quantity,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} added to cart',
                              ),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'View Cart',
                                onPressed: () => context.push('/cart'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _StatusBadge({
    required this.icon,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? AppColors.textSecondary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({
    required this.icon,
    this.onPressed,
  });

  @override
  State<_QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<_QuantityButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed!();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: widget.onPressed != null
                ? (_isPressed
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: widget.onPressed != null
                ? AppColors.primary
                : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _AddToCartButton({
    required this.onPressed,
  });

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            'Add to Cart',
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
