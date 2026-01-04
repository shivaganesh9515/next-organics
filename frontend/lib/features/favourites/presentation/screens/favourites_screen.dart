import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../products/domain/entities/product.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/favourites_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/main_scaffold.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesState = ref.watch(favouritesProvider);

    return MainScaffold(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Header
            SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 48), // Balance for search icon
                    Expanded(
                      child: Text(
                        'Favourites',
                        style: AppTypography.headingMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => context.push('/search'),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: favouritesState.favourites.isEmpty
                  ? const _EmptyFavourites()
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: favouritesState.favourites.length,
                      itemBuilder: (context, index) {
                        final product = favouritesState.favourites[index];
                        return _FavouriteItemCard(
                          key: ValueKey(product.id),
                          product: product,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavouriteItemCard extends ConsumerStatefulWidget {
  final Product product;

  const _FavouriteItemCard({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<_FavouriteItemCard> createState() => _FavouriteItemCardState();
}

class _FavouriteItemCardState extends ConsumerState<_FavouriteItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRemoving = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _removeFavourite() {
    setState(() => _isRemoving = true);
    _controller.reverse().then((_) {
      ref.read(favouritesProvider.notifier).removeFavourite(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _controller,
      child: FadeTransition(
        opacity: _controller,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/product/${widget.product.id}');
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
                // Product Image
                Hero(
                  tag: 'product-${widget.product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image, size: 40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        widget.product.name,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Rating and Delivery
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.ratingGold),
                          const SizedBox(width: 2),
                          Text(
                            '${widget.product.rating}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Text(
                            '10 min',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Price and Add to Cart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.product.finalPrice.toStringAsFixed(2)}',
                            style: AppTypography.priceMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          _AddToCartButton(product: widget.product),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Heart Icon
                _FavouriteHeartIcon(
                  onTap: _removeFavourite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavouriteHeartIcon extends StatefulWidget {
  final VoidCallback onTap;

  const _FavouriteHeartIcon({required this.onTap});

  @override
  State<_FavouriteHeartIcon> createState() => _FavouriteHeartIconState();
}

class _FavouriteHeartIconState extends State<_FavouriteHeartIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.8 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.favorite,
            color: AppColors.error,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _AddToCartButton extends ConsumerStatefulWidget {
  final Product product;

  const _AddToCartButton({required this.product});

  @override
  ConsumerState<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends ConsumerState<_AddToCartButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.mediumImpact();
        ref.read(cartProvider.notifier).addItem(widget.product, quantity: 1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.product.name} added to cart'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'View',
              onPressed: () => context.push('/cart'),
            ),
          ),
        );
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_shopping_cart, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                'Add',
                style: AppTypography.labelSmall.copyWith(
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

class _EmptyFavourites extends StatelessWidget {
  const _EmptyFavourites();

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
                Icons.favorite_outline,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No favourites yet',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save items to access them quickly',
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
        HapticFeedback.lightImpact();
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
