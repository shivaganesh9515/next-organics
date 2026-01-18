import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/cart_item.dart';
import '../../presentation/providers/cart_provider.dart';
import '../../../orders/data/repositories/orders_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../widgets/cart_suggestions_widget.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return MainScaffold(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Header
            SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Cart',
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
            // Content
            Expanded(
              child: cartState.items.isEmpty
                  ? const _EmptyCart()
                  : Column(
                      children: [
                        // Cart Items List
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: cartState.items.length,
                            itemBuilder: (context, index) {
                              final cartItem = cartState.items[index];
                              return _CartItemCard(
                                key: ValueKey(cartItem.product.id),
                                cartItem: cartItem,
                              );
                            },
                          ),
                        ),
                        // Price Summary
                        // Price Summary
                        _PriceSummary(cartState: cartState),

                        // Impulse Buys
                        const CartSuggestionsWidget(),
                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
            ),
            // Checkout CTA (only show if cart has items)
            if (cartState.items.isNotEmpty)
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
                    child: _BuyNowButton(
                      total: cartState.total,
                      itemCount: cartState.itemCount,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends ConsumerStatefulWidget {
  final CartItem cartItem;

  const _CartItemCard({
    super.key,
    required this.cartItem,
  });

  @override
  ConsumerState<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends ConsumerState<_CartItemCard> {
  @override
  Widget build(BuildContext context) {
    final product = widget.cartItem.product;
    final quantity = widget.cartItem.quantity;

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(cartProvider.notifier).removeItem(product.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} removed from cart'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .addItem(product, quantity: quantity);
              },
            ),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade100,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: AppColors.ratingGold),
                      const SizedBox(width: 2),
                      Text(
                        '${product.rating}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${product.finalPrice.toStringAsFixed(0)}',
                    style: AppTypography.priceMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Selector
            Column(
              children: [
                _QuantitySelector(
                  quantity: quantity,
                  maxStock: product.stock,
                  productId: product.id,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends ConsumerStatefulWidget {
  final int quantity;
  final int maxStock;
  final String productId;

  const _QuantitySelector({
    required this.quantity,
    required this.maxStock,
    required this.productId,
  });

  @override
  ConsumerState<_QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends ConsumerState<_QuantitySelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.add,
            onPressed: widget.quantity < widget.maxStock
                ? () {
                    HapticFeedback.lightImpact();
                    ref
                        .read(cartProvider.notifier)
                        .incrementQuantity(widget.productId);
                  }
                : null,
          ),
          Container(
            width: 40,
            height: 36,
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '${widget.quantity}',
                key: ValueKey<int>(widget.quantity),
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _QuantityButton(
            icon: widget.quantity == 1 ? Icons.delete_outline : Icons.remove,
            onPressed: () {
              HapticFeedback.lightImpact();
              if (widget.quantity == 1) {
                ref.read(cartProvider.notifier).removeItem(widget.productId);
              } else {
                ref
                    .read(cartProvider.notifier)
                    .decrementQuantity(widget.productId);
              }
            },
            isDelete: widget.quantity == 1,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDelete;

  const _QuantityButton({
    required this.icon,
    this.onPressed,
    this.isDelete = false,
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
          width: 40,
          height: 32,
          decoration: BoxDecoration(
            color: widget.onPressed != null
                ? (_isPressed
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent)
                : Colors.grey.shade100,
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: widget.isDelete
                ? AppColors.error
                : (widget.onPressed != null
                    ? AppColors.primary
                    : AppColors.textHint),
          ),
        ),
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final CartState cartState;

  const _PriceSummary({required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: '₹${cartState.subtotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 12),
          const _SummaryRow(
            label: 'Delivery Fee',
            value: '₹40',
          ),
          const SizedBox(height: 12),
          const _SummaryRow(
            label: 'Discount',
            value: '5%',
            isDiscount: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: 'Total',
            value: '₹${cartState.total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isDiscount;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.headingSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                )
              : AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTypography.priceMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                )
              : AppTypography.bodyLarge.copyWith(
                  color: isDiscount ? AppColors.success : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items to get started',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _BrowseProductsButton(),
          ],
        ),
      ),
    );
  }
}

class _BrowseProductsButton extends StatefulWidget {
  @override
  State<_BrowseProductsButton> createState() => _BrowseProductsButtonState();
}

class _BrowseProductsButtonState extends State<_BrowseProductsButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.push('/home');
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Browse Products',
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _BuyNowButton extends ConsumerStatefulWidget {
  final double total;
  final int itemCount;

  const _BuyNowButton({
    required this.total,
    required this.itemCount,
  });

  @override
  ConsumerState<_BuyNowButton> createState() => _BuyNowButtonState();
}

class _BuyNowButtonState extends ConsumerState<_BuyNowButton> {
  bool _isPressed = false;
  bool _isLoading = false;

  Future<void> _handleCheckout() async {
    setState(() => _isLoading = true);

    try {
      // Create order (mock)
      final cartItems = ref.read(cartProvider).items;
      await ref.read(ordersRepositoryProvider).createOrder(
            total: widget.total,
            itemCount: widget.itemCount,
            items: cartItems
                .map((e) => e.product.name)
                .toList(), // Simplified logging
          );

      if (mounted) {
        // Clear cart
        ref.read(cartProvider.notifier).clear();

        // Navigate to success
        context.go('/order-success');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isLoading ? null : (_) => setState(() => _isPressed = true),
      onTapUp: _isLoading
          ? null
          : (_) {
              setState(() => _isPressed = false);
              HapticFeedback.mediumImpact();
              _handleCheckout();
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
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Buy Now',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(₹${widget.total.toStringAsFixed(0)})',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
