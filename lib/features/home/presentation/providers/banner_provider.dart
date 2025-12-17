import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/banner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';

// Service Provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(Supabase.instance.client);
});

// Repository Provider
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  return BannerRepository(service);
});

// Hero Banner Provider
final heroBannerProvider = FutureProvider<HomeBanner>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getHeroBanner();
});

// Offer Banners Provider
final offerBannersProvider = FutureProvider<List<HomeBanner>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getOfferBanners();
});
