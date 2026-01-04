import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../products/domain/entities/product.dart'; 
import '../providers/products_provider.dart';

import '../../../home/presentation/widgets/hub_farm_toggle.dart';
import '../../../home/presentation/widgets/vendor_group_card.dart';
import '../../../home/presentation/widgets/grid_product_card.dart';
import '../../../../core/widgets/animations/fade_in_slide.dart'; // Animation Import

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
  final List<String> _filters = ['All', 'Price: Low to High', 'Price: High to Low', 'Best Rated'];
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Determine which provider to watch based on categoryId
    final productsAsync = widget.categoryId == 'all'
        ? ref.watch(productsProvider)
        : ref.watch(productRepositoryProvider).getProductsByCategory(widget.categoryId);

    return MainScaffold(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(widget.categoryName, style: AppTypography.headingMedium),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
            onPressed: () => context.pop(),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // 1. SEARCH BAR
            FadeInSlide(
              delay: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        'Search in ${widget.categoryName}...',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. FILTERS
            FadeInSlide(
              delay: 0.1,
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilterIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_filters[index]),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() => _selectedFilterIndex = index);
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.grey.shade200,
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  },
                ),
              ),
            ),

            // 3. TOGGLE
            FadeInSlide(
              delay: 0.15,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: HubFarmToggle(
                  isFarmMode: _isFarmMode,
                  onModeChanged: (val) => setState(() => _isFarmMode = val),
                ),
              ),
            ),
            
            // 4. CONTENT
            Expanded(
              child: _buildContent(productsAsync as List<dynamic>),
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

           return FadeInSlide(
             delay: 0.2 + (index * 0.1),
             child: Padding(
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
             ),
           );
        },
      );
    }

    // --- HUB MODE (2-Column Grid) ---
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
        return FadeInSlide(
          delay: 0.2 + (index * 0.05),
          child: GridProductCard(
            product: products[index] as Product,
            onTap: () => context.push('/product/${(products[index] as Product).id}'),
            onAddToCart: () {},
          ),
        );
      },
    );
  }
}
