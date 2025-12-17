import 'package:flutter/material.dart';
import '../../domain/entities/banner.dart';

import '../../../../core/services/supabase_service.dart';

class BannerRepository {
  final SupabaseService _service;

  BannerRepository(this._service);

  Future<HomeBanner> getHeroBanner() async {
    final banners = await _service.getBanners();
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
      imageUrl: 'assets/images/banner_bg.png',
      gradientColors: [Color(0xFF66BB6A), Color(0xFF43A047)],
      targetRoute: '/category/all',
    );
  }

  Future<List<HomeBanner>> getOfferBanners() async {
    final banners = await _service.getBanners();
    // Return all banners excluding the first one (for demo)
    if (banners.length > 1) {
      return banners.skip(1).toList();
    }
    
    // Fallback info
    return [];
  }
}
