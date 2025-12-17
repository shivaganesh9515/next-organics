import '../../domain/entities/banner.dart';

class MockBannerDataSource {
  static const _delay = Duration(milliseconds: 300);

  Future<List<Banner>> getBanners() async {
    await Future.delayed(_delay);
    return _mockBanners;
  }

  static final List<Banner> _mockBanners = [
    const Banner(
      id: 'banner1',
      title: 'Fresh Organic Produce',
      imageUrl: 'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800',
    ),
    const Banner(
      id: 'banner2',
      title: '30% Off on Dairy Products',
      imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=800',
    ),
    const Banner(
      id: 'banner3',
      title: 'Healthy Snacks Collection',
      imageUrl: 'https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=800',
    ),
  ];
}
