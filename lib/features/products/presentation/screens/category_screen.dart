import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../products/domain/entities/product.dart'; // Added Product import
import '../providers/products_provider.dart';

import '../../../home/presentation/widgets/hub_farm_toggle.dart';
import '../../../home/presentation/widgets/vendor_group_card.dart';
// Ensure standard card is available for Grid

class CategoryScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  bool _isFarmMode = false;

  @override
  Widget build(BuildContext context) {
    // Determine which provider to watch based on categoryId
    final productsAsync = widget.categoryId == 'all'
        ? ref.watch(productsProvider)
        : ref.watch(productRepositoryProvider).getProductsByCategory(widget.categoryId);

    return MainScaffold(
      currentIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            // 1. TOGGLE
            HubFarmToggle(
              isFarmMode: _isFarmMode,
              onModeChanged: (val) => setState(() => _isFarmMode = val),
            ),
            
            // 2. CONTENT
            Expanded(
              child: widget.categoryId == 'all'
                  ? (productsAsync as AsyncValue).when(
                      data: (products) => _buildContent(products),
                      loading: () => const LoadingIndicator(),
                      error: (error, stack) => Center(child: Text('Error: $error')),
                    )
                  : FutureBuilder(
                      future: productsAsync as Future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const LoadingIndicator();
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        return _buildContent(snapshot.data ?? []);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<dynamic> products) {
    if (products.isEmpty) {
      return EmptyState(
        icon: Icons.category_outlined,
        title: 'No Products',
        message: 'No products found in this category',
        action: ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Go Back'),
        ),
      );
    }

    // --- FARMS MODE (Vendor Groups) ---
    if (_isFarmMode) {
      // Mock Grouping
      final farms = {
        'Green Earth Farm': products.take(3).toList(),
        'Organic Daily': products.skip(3).take(3).toList(),
        'Nature\'s Basket': products.skip(1).take(2).toList(),
      };

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: farms.length,
        itemBuilder: (context, index) {
           final farmName = farms.keys.elementAt(index % farms.length);
           final farmProducts = farms.values.elementAt(index % farms.length);
           if (farmProducts.isEmpty) return const SizedBox.shrink();

           return Padding(
             padding: const EdgeInsets.only(bottom: 16),
             child: VendorGroupCard(
               farmName: farmName,
               rating: 4.8,
               ratingCount: 120,
               time: '25 mins',
               discount: 'Free Delivery',
               products: List<Product>.from(farmProducts),
               onShopTap: () {},
             ),
           );
        },
      );
    }

    // --- HUB MODE (2-Column Grid) ---
    // User requested "2 products side by side"
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        // Use standard ProductCard for Grid to fit 2 columns
        return ProductCard(product: products[index] as Product);
      },
    );
  }
}
