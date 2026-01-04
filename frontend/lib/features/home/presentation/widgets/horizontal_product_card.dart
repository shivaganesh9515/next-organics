import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../products/domain/entities/product.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Horizontal product card for "You Might Need" section
/// 160×240px with 60% image, product info, and morphing add button
class HorizontalProductCard extends ConsumerStatefulWidget {
  final Product product;

  const HorizontalProductCard({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<HorizontalProductCard> createState() => _HorizontalProductCardState();
}

class _HorizontalProductCardState extends ConsumerState<HorizontalProductCard> {
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
          width: 160,
          height: 240,
          padding: const EdgeInsets.all(8),
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
                child: Hero(
                  tag: 'horizontal-${widget.product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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
              ),
              
              const SizedBox(height: 6),
              
              // Product Info (40% of card)
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      widget.product.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Price + Rating Row
                    Row(
                      children: [
                        // Price
                        Text(
                          '₹${widget.product.finalPrice.toStringAsFixed(0)}',
                          style: AppTypography.priceMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
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
                              color: Color(0xFFFFB800),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.product.rating}',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Add Button / Quantity Selector
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: quantity > 0
                          ? _QuantitySelector(
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Add button that shows when product is not in cart
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
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
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
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quantity selector that shows when product is in cart
class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Decrement button
          Expanded(
            child: GestureDetector(
              onTap: quantity > 1 ? onDecrement : null,
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.remove,
                  size: 18,
                  color: quantity > 1 ? Colors.white : Colors.white54,
                ),
              ),
            ),
          ),
          
          // Quantity
          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // Increment button
          Expanded(
            child: GestureDetector(
              onTap: onIncrement,
              child: Container(
                alignment: Alignment.center,
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
