import '../../domain/repositories/banner_repository.dart';
import '../datasources/mock_banner_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final MockBannerDataSource _dataSource;

  BannerRepositoryImpl(this._dataSource);

  @override
  Future<List<Banner>> getBanners() {
    return _dataSource.getBanners();
  }
}
