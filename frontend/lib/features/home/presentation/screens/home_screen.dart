import 'package:flutter/material.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../presentation/providers/banner_provider.dart';
import '../widgets/curved_home_header.dart';
import '../widgets/large_product_card.dart';
import '../widgets/offer_banner.dart';
import '../widgets/home_toggle.dart';
import '../widgets/vendor_list_widget.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/entities/category.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    // Watch providers
    final categories = ref.watch(categoriesProvider);
    final products = ref.watch(productsProvider);
    final cartItemCount = ref.watch(cartItemCountProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final activeMode = ref.watch(activeModeProvider);

    // Filter products
    final displayedProducts = _selectedCategoryId == null
        ? products
        : products.where((p) {
            final category = categories.firstWhere(
              (c) => c.id == _selectedCategoryId,
              orElse: () => Category(
                  id: '', name: '', icon: '', imageUrl: '', productCount: 0),
            );
            return p.category.toLowerCase() == category.name.toLowerCase();
          }).toList();

    return MainScaffold(
      currentIndex: 0,
      child: Stack(
        children: [
          Container(
            color: const Color(0xFFF8F9FA),
            child: Column(
              children: [
                // Header (Address + Logo)
                const CurvedHomeHeader(),

                // Scrollable Content
                Expanded(
                  child: CustomScrollView(
                    key: ValueKey('home-scroll-$activeMode'),
                    slivers: [
                      // Toggle (Hub vs Farms)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: HomeToggle(),
                        ),
                      ),

                      // Search Bar
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: GestureDetector(
                            onTap: () => context.push('/search'),
                            child: Container(
                              height: 48,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search,
                                      color: AppColors.textSecondary, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      activeMode == ActiveMode.hub
                                          ? 'Search for products...'
                                          : 'Search for farms...',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // CONTENT SWITCHER
                      if (activeMode == ActiveMode.hub) ...[
                        // HUB STORE ITEMS
                        // Offer Banners
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              OfferBanner(
                                title: 'Fresh Farm Picks',
                                subtitle: 'Directly from local growers',
                                ctaText: 'Shop Now',
                                icon: Icons.agriculture,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),

                        // Shop by Category
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 24, 16, 12),
                                child: Text(
                                  'Shop by Category',
                                  style: AppTypography.headingMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: categories.length,
                                  separatorBuilder: (ctx, i) =>
                                      const SizedBox(width: 16),
                                  itemBuilder: (context, index) {
                                    final category = categories[index];
                                    final isSelected =
                                        _selectedCategoryId == category.id;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedCategoryId = null;
                                          } else {
                                            _selectedCategoryId = category.id;
                                          }
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.primary
                                                      .withOpacity(0.1)
                                                  : Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : Colors.grey.shade200,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: category.imageUrl,
                                                fit: BoxFit.cover,
                                                errorWidget: (c, u, e) =>
                                                    Center(
                                                  child: Text(
                                                    category.icon,
                                                    style: const TextStyle(
                                                        fontSize: 24),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            category.name,
                                            style: isSelected
                                                ? AppTypography.labelMedium
                                                    .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w700,
                                                  )
                                                : AppTypography.labelMedium
                                                    .copyWith(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Filter Info
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                            child: Row(
                              children: [
                                Text(
                                  _selectedCategoryId == null
                                      ? 'All Groceries'
                                      : 'Filtered Items',
                                  style: AppTypography.headingMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const Spacer(),
                                if (_selectedCategoryId != null)
                                  TextButton(
                                    onPressed: () {
                                      setState(
                                          () => _selectedCategoryId = null);
                                    },
                                    child: Text(
                                      'Clear',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Product List
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = displayedProducts[index];
                                return LargeProductCard(
                                  product: product,
                                  onTap: () =>
                                      context.push('/product/${product.id}'),
                                );
                              },
                              childCount: displayedProducts.length,
                            ),
                          ),
                        ),
                      ] else ...[
                        // FARM MODE - VENDORS
                        const VendorListWidget(),
                      ],

                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Cart Summary
          if (cartItemCount > 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 90,
              child: GestureDetector(
                onTap: () => context.push('/cart'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$cartItemCount ITEMS',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${cartTotal.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        'View Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white, size: 18),
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
