import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../products/domain/entities/product.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Compact quick pick card for fast one-tap adding
/// 130×180px with circular add button, minimal info
class QuickPickCard extends ConsumerStatefulWidget {
  final Product product;

  const QuickPickCard({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<QuickPickCard> createState() => _QuickPickCardState();
}

class _QuickPickCardState extends ConsumerState<QuickPickCard> {
  bool _isButtonPressed = false;

  void _handleQuickAdd() {
    setState(() => _isButtonPressed = true);
    HapticFeedback.lightImpact();
    
    // Add item to cart
    ref.read(cartProvider.notifier).addItem(widget.product);
    
    // Reset button animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _isButtonPressed = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/product/${widget.product.id}');
      },
      child: Container(
        width: 130,
        height: 180,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image (110x110, centered)
            SizedBox(
              height: 110,
              child: Center(
                child: Hero(
                  tag: 'quick-${widget.product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 110,
                        height: 110,
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 110,
                        height: 110,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image, color: Colors.grey, size: 32),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Product Name (1 line)
            Text(
              widget.product.name,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 6),
            
            // Price & Quick Add Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price
                Flexible(
                  child: Text(
                    '₹${widget.product.finalPrice.toStringAsFixed(0)}',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(width: 4),
                
                // Circular Quick Add Button
                GestureDetector(
                  onTap: _handleQuickAdd,
                  child: AnimatedScale(
                    scale: _isButtonPressed ? 0.9 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
