class Vendor {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String location;

  const Vendor({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.location,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] as String,
      name: json['shop_name'] as String? ??
          json['name'] as String? ??
          'Unknown Farm',
      imageUrl: json['shop_image_url'] ?? 'https://via.placeholder.com/150',
      rating: 4.5, // Mock default or fetch from reviews table
      reviewCount: 100, // Mock default
      isVerified: json['status'] == 'approved',
      location: json['address'] ?? 'Local Farm',
    );
  }
}
