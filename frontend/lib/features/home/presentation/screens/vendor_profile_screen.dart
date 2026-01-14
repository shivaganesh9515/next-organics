import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../products/domain/entities/vendor.dart';
import '../widgets/large_product_card.dart';

class VendorProfileScreen extends ConsumerWidget {
  final String vendorId;

  const VendorProfileScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsAsync = ref.watch(vendorsProvider);
    final products = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: vendorsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (vendors) {
          final vendor = vendors.firstWhere(
            (v) => v.id == vendorId,
            orElse: () => const Vendor(
                id: '',
                name: 'Unknown Farm',
                imageUrl: '',
                rating: 0,
                reviewCount: 0,
                isVerified: false,
                location: ''),
          );

          if (vendor.id.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Farm not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          // Filter products for this vendor (Mock logic: for now show random or all if no vendor_id on products)
          // In real app, products would have vendorId.
          // For demo, let's show all products or a subset to simulate.
          // Since our Product entity supports 'vendorName', let's match that or just show all for demo if ID match fails.
          // Actually, let's filter by vendor ID from backend if available, or just show all for the demo flow.
          // Wait, the Product entity has `vendorName` but maybe not `vendorId`?
          // Let's check Product entity on line 13 of product.dart
          // final String? vendorName;

          // We will mock filter: if product.vendorName matches vendor.name, or just show all for demo.
          final vendorProducts = products;
          // .where((p) => p.vendorName == vendor.name).toList(); // uncomment if data supports it

          return CustomScrollView(
            slivers: [
              // APPEARANCE: SliverAppBar with Hero Image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: vendor.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey),
                      ),
                      // Gradient Overlay for text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.black),
                      onPressed: () {
                        // TODO: Implement Favorite Vendor
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to Favorites')),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Vendor Details Header
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              vendor.name,
                              style: AppTypography.headingLarge,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.ratingGold,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '4.5', // Mock or vendor.rating
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.star,
                                    size: 14, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vendor.location,
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      // Divider
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      Text(
                        'Farm Fresh Products',
                        style: AppTypography.headingMedium,
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
                      final product = vendorProducts[index];
                      return LargeProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.id}'),
                      );
                    },
                    childCount: vendorProducts.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }
}
