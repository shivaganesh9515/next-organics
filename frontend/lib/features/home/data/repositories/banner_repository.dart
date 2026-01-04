import 'package:flutter/material.dart';
import '../../domain/entities/banner.dart';
import '../datasources/mock_banner_datasource.dart';

class BannerRepository {
  final MockBannerDataSource _dataSource;

  BannerRepository(this._dataSource);

  HomeBanner getHeroBanner() {
    final banners = _dataSource.getBanners();
    // Return the first "Hero" banner, or a fallback
    if (banners.isNotEmpty) {
      return banners.first; 
    }
    
    // Fallback if DB is empty
    return const HomeBanner(
      id: 'fallback',
      title: 'FRESH\nHARVEST',
      subtitle: 'Organic & Local',
      ctaText: 'SHOP NOW',
      imageUrl: 'assets/images/banner_bg.png', // Ensure this exists or use network
      gradientColors: [Color(0xFF66BB6A), Color(0xFF43A047)],
      targetRoute: '/category/all',
    );
  }

  List<HomeBanner> getOfferBanners() {
    final banners = _dataSource.getBanners();
    // Return all banners excluding the first one (for demo)
    if (banners.length > 1) {
      return banners.skip(1).toList();
    }
    
    // Fallback info
    return [];
  }
}
