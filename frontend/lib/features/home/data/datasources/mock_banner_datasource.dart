import 'package:flutter/material.dart';
import '../../domain/entities/banner.dart';

class MockBannerDataSource {
  static const _delay = Duration(milliseconds: 300);

  List<HomeBanner> getBanners() {
    print('MockBannerDataSource: getBanners called (SYNC)');
    return _mockBanners;
  }

  static final List<HomeBanner> _mockBanners = [
    // 1. Hero Banner (Welcome)
    const HomeBanner(
      id: 'hero_joy',
      title: 'Experience Pure\nOrganic Joy',
      subtitle: 'Flat 50% OFF on your first order. Use code: WELCOME50',
      ctaText: 'Shop Now',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80',
      gradientColors: [Color(0xFF84CC16), Color(0xFF4D7C0F)], // Lime Green
      targetRoute: '/categories',
    ),

    // 2. Offer Banner (Vegetables)
    const HomeBanner(
      id: 'offer_veg',
      title: 'Farm Fresh Veggies',
      subtitle: 'Starting from ₹99/kg',
      ctaText: 'View All',
      imageUrl: 'https://images.unsplash.com/photo-1566385101042-1a0aa0c1268c?w=800&q=80',
      gradientColors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
      targetRoute: '/categories',
    ),

    // 3. Offer Banner (Dairy)
    const HomeBanner(
      id: 'offer_dairy',
      title: 'Pure Organic Milk',
      subtitle: 'Subscribe & Save Extra 10%',
      ctaText: 'Subscribe',
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=800&q=80',
      gradientColors: [Color(0xFF60A5FA), Color(0xFF2563EB)], // Blue
      targetRoute: '/categories',
    ),

    // 4. Offer Banner (Bakery)
    const HomeBanner(
      id: 'offer_bakery',
      title: 'Fresh Bakery',
      subtitle: 'Buy 1 Get 1 Free on Breads',
      ctaText: 'Order Now',
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80',
      gradientColors: [Color(0xFFF59E0B), Color(0xFFD97706)], // Orange
      targetRoute: '/categories',
    ),

     // 5. Offer Banner (Fruits)
    const HomeBanner(
      id: 'offer_fruits',
      title: 'Seasonal Fruits',
      subtitle: 'Juicy & Sweet - Flat 20% Off',
      ctaText: 'Grab Deal',
      imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800&q=80',
      gradientColors: [Color(0xFFF43F5E), Color(0xFFE11D48)], // Red/Pink
      targetRoute: '/categories',
    ),
  ];
}
