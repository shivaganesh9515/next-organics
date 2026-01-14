import '../../domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/mock_banner_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final MockBannerDataSource _dataSource;

  BannerRepositoryImpl(this._dataSource);

  @override
  Future<List<HomeBanner>> getBanners() async {
    // Mock datasource is sync, but we wrap in Future for real API compatibility
    return _dataSource.getBanners();
  }
}
