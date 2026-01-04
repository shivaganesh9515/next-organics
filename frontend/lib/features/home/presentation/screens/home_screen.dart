import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../presentation/providers/banner_provider.dart';
import '../widgets/curved_home_header.dart';
import '../widgets/circular_category_icon.dart';
import '../widgets/grid_product_card.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/banner.dart';
import '../widgets/hero_promo_banner.dart';
import '../widgets/small_offer_card.dart';
import '../widgets/hub_farm_toggle.dart';
import '../widgets/vendor_group_card.dart';
import '../../../../core/widgets/animations/fade_in_slide.dart'; // Animation import

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Mock categories based on reference image
  final List<Map<String, dynamic>> _mockCategories = [
    {
      'label': 'Vegetables',
      'icon': Icons.eco_outlined,
      'color': AppColors.categoryVeggies
    },
    {
      'label': 'Fruits',
      'icon': Icons.apple_outlined,
      'color': AppColors.categoryFruits
    },
    {
      'label': 'Dairy',
      'icon': Icons.water_drop_outlined,
      'color': AppColors.categoryDairy
    },
    {
      'label': 'Bakery',
      'icon': Icons.bakery_dining_outlined,
      'color': AppColors.categoryPantry
    },
    {
      'label': 'Essentials',
      'icon': Icons.kitchen_outlined,
      'color': AppColors.textSecondary
    },
  ];

  final List<String> _filters = ['All', 'Newest', 'Popular', 'Discount', 'Best Rated'];
  int _selectedFilterIndex = 0;

  bool _isFarmMode = false;
  int _selectedCategoryIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Watch providers
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider);
    final heroBannerAsync = ref.watch(heroBannerProvider);
    final offerBannersAsync = ref.watch(offerBannersProvider);

    return MainScaffold(
      currentIndex: 0,
      child: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // 1. Premium Header (Fixed Top)
            const CurvedHomeHeader(),
            
            // 2. Scrollable Content
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // --- SEARCH BAR (New) ---
                  SliverToBoxAdapter(
                    child: FadeInSlide(
                      delay: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: GestureDetector(
                          onTap: () => context.push('/search'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24), // Pill-ish shape
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: AppColors.textSecondary, size: 22),
                                const SizedBox(width: 12),
                                Text(
                                  'Search organic products...',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- HERO BANNER ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      // Direct access, no .when()
                      child: FadeInSlide(
                        delay: 0.1,
                        child: HeroPromoBanner(
                          mainText: heroBannerAsync.title, // heroBannerAsync is now the Banner object
                          ctaText: heroBannerAsync.ctaText,
                          gradientColors: heroBannerAsync.gradientColors,
                          imageUrl: heroBannerAsync.imageUrl,
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),

                  // --- OFFERS LIST (Restored) ---
                  SliverToBoxAdapter(
                    child: FadeInSlide(
                      delay: 0.15,
                      child: Container(
                        height: 140, 
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: offerBannersAsync.length,
                          itemBuilder: (context, index) {
                            final banner = offerBannersAsync[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SmallOfferCard(
                                icon: banner.imageUrl,
                                title: banner.title,
                                subtitle: banner.subtitle,
                                gradientColors: banner.gradientColors,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  // --- CATEGORIES ROW (Moved Up) ---
                  SliverToBoxAdapter(
                    child: FadeInSlide(
                      delay: 0.2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _mockCategories.length,
                            itemBuilder: (context, index) {
                              final category = _mockCategories[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: CircularCategoryIcon(
                                  imageUrl: '',
                                  iconData: category['icon'],
                                  label: category['label'],
                                  color: category['color'], // Pass color
                                  isSelected: _selectedCategoryIndex == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryIndex = 
                                          _selectedCategoryIndex == index ? -1 : index;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- HUB / FARM TOGGLE (Moved Down) ---
                  SliverToBoxAdapter(
                    child: FadeInSlide(
                      delay: 0.25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: HubFarmToggle(
                          isFarmMode: _isFarmMode,
                          onModeChanged: (val) {
                            setState(() => _isFarmMode = val);
                          },
                        ),
                      ),
                    ),
                  ),

                  // --- POPULAR ITEMS HEADER ---
                  SliverToBoxAdapter(
                    child: FadeInSlide(
                      delay: 0.3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isFarmMode ? 'Farm Fresh Group' : 'Popular Items',
                              style: AppTypography.headingMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('See All', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- FILTERS (New) ---
                  SliverToBoxAdapter(
                    child: FadeInSlide(
                      delay: 0.35,
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filters.length,
                          itemBuilder: (context, index) {
                            final isSelected = _selectedFilterIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
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
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                  ),
                                ),
                                showCheckmark: false,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)), // Spacer

                  // --- CONTENT (Hub vs Farm Logic Restored) ---
                  // Direct access, no .when()
                  Builder(
                    builder: (context) {
                      final products = productsAsync; // productsAsync is now List<Product>
                      
                      // Filter by category if selected
                      // For now using mock category index mapping or simplified logic
                      
                      if (_isFarmMode) {
                        // RE-IMPLEMENT FARM GROUPING MOCK
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final farmNames = ['Green Valley Farms', 'Sunrise Organics', 'Nature\'s Best'];
                              final farmOffsets = [0, 5, 10]; // Skip products for variety
                              
                              if (index >= farmNames.length) return null;

                              return FadeInSlide(
                                delay: 0.4 + (index * 0.1),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: VendorGroupCard(
                                    farmName: farmNames[index],
                                    rating: 4.8 - (index * 0.1),
                                    ratingCount: 120 + (index * 50),
                                    time: '${25 + (index * 5)} mins',
                                    discount: '${20 + (index * 5)}% OFF',
                                    products: products.skip(farmOffsets[index]).take(3).toList(),
                                    onShopTap: () {},
                                  ),
                                ),
                              );
                            },
                            childCount: 3, 
                          ),
                        );
                      }
                      
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = products[index];
                              return FadeInSlide(
                                delay: 0.4 + (index * 0.05), // Staggered grid
                                child: GridProductCard(
                                  product: product,
                                  onTap: () {
                                    // Nav logic
                                    context.push('/product/${product.id}');
                                  },
                                  onAddToCart: () {},
                                ),
                              );
                            },
                            childCount: products.length,
                          ),
                        ),
                      );
                    },
                  ),
                  
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
