class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final int stock;
  final String unit;
  final double? discount;
  final String? vendorName;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.unit,
    this.discount,
    this.vendorName,
  });

  double get finalPrice {
    if (discount != null && discount! > 0) {
      return price * (1 - discount! / 100);
    }
    return price;
  }

  bool get hasDiscount => discount != null && discount! > 0;

  bool get inStock => stock > 0;
}
