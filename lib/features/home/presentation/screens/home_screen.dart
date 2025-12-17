import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../presentation/providers/banner_provider.dart';
import '../widgets/curved_home_header.dart';
import '../widgets/hero_promo_banner.dart';
import '../widgets/small_offer_card.dart';
import '../widgets/circular_category_icon.dart';
import '../widgets/marketplace_product_card.dart';
import '../widgets/store_99_section.dart';
import '../widgets/filter_sort_bar.dart';
import '../widgets/sticky_header_delegate.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../widgets/vendor_group_card.dart';
import '../widgets/hub_farm_toggle.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedCategoryId;
  bool _isFarmMode = false;

  @override
  Widget build(BuildContext context) {
    // Watch providers
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider);
    final heroBannerAsync = ref.watch(heroBannerProvider);
    final offerBannersAsync = ref.watch(offerBannersProvider);

    return MainScaffold(
      // Ensure index is correct for Home tab
      currentIndex: 0,
      child: Container(
        color: const Color(0xFFFAFAFA),
        child: Column(
          children: [
            // 1. Premium Curved Header (Fixed Top)
            // This stays OUTSIDE the scroll view to remain fixed at the top
            const CurvedHomeHeader(),
            
            // 2. Scrollable Content with Slivers
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // --- BANNER & PROMOS SECTION ---
                  
                  // Highlight Promotional Banner
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: heroBannerAsync.when(
                        data: (banner) => HeroPromoBanner(
                          mainText: banner.title,
                          ctaText: banner.ctaText,
                          gradientColors: banner.gradientColors,
                          onTap: () {
                             // Navigation logic here
                          },
                        ),
                        loading: () => Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: LoadingIndicator()),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  
                  // Horizontal Exclusive Offer Cards
                  SliverToBoxAdapter(
                    child: offerBannersAsync.when(
                      data: (banners) => Container(
                        height: 140,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: banners.length,
                          itemBuilder: (context, index) {
                            final banner = banners[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SmallOfferCard(
                                icon: banner.imageUrl, // Using imageUrl as icon/emoji for now
                                title: banner.title,
                                subtitle: banner.subtitle,
                                gradientColors: banner.gradientColors,
                              ),
                            );
                          },
                        ),
                      ),
                      loading: () => const SizedBox(height: 140, child: Center(child: LoadingIndicator())),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  
                  // --- HUB / FARM MODE TOGGLE (Moved Here) ---
                  SliverToBoxAdapter(
                    child: HubFarmToggle(
                      isFarmMode: _isFarmMode,
                      onModeChanged: (val) {
                        setState(() => _isFarmMode = val);
                      },
                    ),
                  ),

                  // --- CATEGORIES SECTION ---
                  
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        'Shop by Category', // Rebranded
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: categoriesAsync.when(
                      data: (categories) => SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CircularCategoryIcon(
                                imageUrl: category.imageUrl,
                                label: category.name, // Assuming backend provides updated names or we will mock logic
                                onTap: () {
                                  setState(() {
                                    if (_selectedCategoryId == category.id) {
                                      _selectedCategoryId = null;
                                    } else {
                                      _selectedCategoryId = category.id;
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 110,
                        child: Center(child: LoadingIndicator()),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  
                  // --- 99 STORE COSMIC SECTION ---
                  const SliverToBoxAdapter(child: Store99Section()),
                  
                  // --- RESTAURANTS LIST HEADER ---
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Text(
                        'Fresh from the Farm', // Rebranded
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  
                  // --- STICKY FILTER BAR (Filters Only) ---
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyHeaderDelegate(
                      child: const FilterSortBar(),
                      height: 60, // Back to regular height
                    ),
                  ),
                  
                  // --- CONTENT LIST (Hub vs Farms) ---
                  productsAsync.when(
                    data: (products) {
                      final filteredProducts = _selectedCategoryId == null
                          ? products
                          : products
                              .where((p) => p.category == _selectedCategoryId)
                              .toList();

                      if (filteredProducts.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text('No fresh produce found.'),
                            ),
                          ),
                        );
                      }

                      // 1. FARM MODE (Grouped View)
                      if (_isFarmMode) {
                        // Mock Grouping Logic (In real app, backend sends this structure)
                        final farms = {
                          'Green Earth Farm': filteredProducts.take(3).toList(),
                          'Organic Daily': filteredProducts.skip(3).take(3).toList(),
                          'Nature\'s Basket': filteredProducts.skip(1).take(3).toList(), // Overlap for demo
                        };

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final farmName = farms.keys.elementAt(index % farms.length);
                              final farmProducts = farms.values.elementAt(index % farms.length);
                              
                              if (farmProducts.isEmpty) return const SizedBox.shrink();

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: VendorGroupCard(
                                  farmName: farmName,
                                  rating: 4.5,
                                  ratingCount: 150 + (index * 20),
                                  time: '${20 + index * 5} mins',
                                  discount: '40% OFF up to ₹80',
                                  products: farmProducts,
                                  onShopTap: () {},
                                ),
                              );
                            },
                            childCount: farms.length,
                          ),
                        );
                      }

                      // 2. HUB STORE MODE (Flat List - Default)
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = filteredProducts[index];
                            return MarketplaceProductCard(
                              product: product,
                              badge: 'Fresh at ₹${product.finalPrice.toStringAsFixed(0)}',
                              deliveryTime: 'Today', 
                              showFreeDelivery: index % 2 == 0,
                            );
                          },
                          childCount: filteredProducts.length,
                        ),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: LoadingIndicator()),
                      ),
                    ),
                    error: (error, _) => SliverToBoxAdapter(
                      child: Center(child: Text('Error loading products: $error')),
                    ),
                  ),
                  
                  // Bottom Padding to ensure content isn't hidden behind bottom nav
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
