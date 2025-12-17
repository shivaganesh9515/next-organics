import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/domain/entities/product.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'quantity_selector.dart';

/// Compact product card for horizontal lists and grid layouts
/// Designed for "You Might Need" and "Best Selling" sections
class ProductCardCompact extends ConsumerStatefulWidget {
  final Product product;
  final double? width;
  final double? height;

  const ProductCardCompact({
    super.key,
    required this.product,
    this.width,
    this.height,
  });

  @override
  ConsumerState<ProductCardCompact> createState() => _ProductCardCompactState();
}

class _ProductCardCompactState extends ConsumerState<ProductCardCompact> {
  bool _isTappedDown = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isTappedDown = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isTappedDown = false);
  }

  void _handleTapCancel() {
    setState(() => _isTappedDown = false);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    
    // Check if product is in cart
    final inCart = cartState.items.any((item) => item.product.id == widget.product.id);
    final quantity = inCart 
        ? cartState.items.firstWhere((item) => item.product.id == widget.product.id).quantity 
        : 0;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/product/${widget.product.id}');
      },
      child: AnimatedScale(
        scale: _isTappedDown ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width ?? 160,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image (60% of card)
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Hero(
                      tag: 'product-${widget.product.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.product.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    // Discount badge
                    if (widget.product.hasDiscount)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.discount,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${widget.product.discount!.toInt()}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Product Info (40% of card)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product name
                      Text(
                        widget.product.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Price and Rating
                      Row(
                        children: [
                          // Price
                          Text(
                            '\$${widget.product.finalPrice.toStringAsFixed(2)}',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          
                          const SizedBox(width: 6),
                          
                          // Rating
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 13,
                                color: AppColors.ratingGold,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${widget.product.rating}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Add Button or Quantity Selector
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: quantity > 0
                            ? QuantitySelector(
                                key: const ValueKey('quantity'),
                                quantity: quantity,
                                onIncrement: () {
                                  ref.read(cartProvider.notifier).addItem(widget.product);
                                },
                                onDecrement: () {
                                  ref.read(cartProvider.notifier).removeItem(widget.product.id);
                                },
                              )
                            : _AddButton(
                                key: const ValueKey('add'),
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  ref.read(cartProvider.notifier).addItem(widget.product);
                                },
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
    );
  }
}

class _AddButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AddButton({
    super.key,
    required this.onTap,
  });

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 36,
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.limeGreen : Colors.white,
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            '+ Add',
            style: AppTypography.labelLarge.copyWith(
              color: _isPressed ? AppColors.textPrimary : AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
