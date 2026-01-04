import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/banner.dart';
import '../../data/repositories/banner_repository.dart';
import '../../data/datasources/mock_banner_datasource.dart';

// Mock Data Source Provider
final mockBannerDataSourceProvider = Provider((ref) => MockBannerDataSource());

// Repository Provider
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final dataSource = ref.watch(mockBannerDataSourceProvider);
  return BannerRepository(dataSource);
});

// Hero Banner Provider (SYNC)
final heroBannerProvider = Provider<HomeBanner>((ref) {
  print('PROVIDER: heroBannerProvider called (SYNC)');
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getHeroBanner();
});

// Offer Banners Provider (SYNC)
final offerBannersProvider = Provider<List<HomeBanner>>((ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getOfferBanners();
});
