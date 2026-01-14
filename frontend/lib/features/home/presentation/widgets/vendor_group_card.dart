import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../products/domain/entities/product.dart';

class VendorGroupCard extends StatelessWidget {
  final String farmName;
  final double rating;
  final int ratingCount;
  final String time;
  final String discount;
  final List<Product> products;
  final VoidCallback? onShopTap;

  const VendorGroupCard({
    super.key,
    required this.farmName,
    required this.rating,
    required this.ratingCount,
    required this.time,
    required this.discount,
    required this.products,
    this.onShopTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. VENDOR HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ad Badge (Optional mock)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Ad',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
              const SizedBox(width: 8),

              // Name & Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmName,
                      style: AppTypography.labelLarge.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Rating Star
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E7D32), // Green
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star,
                              size: 10, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$rating ($ratingCount+)',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Discount text
                    Row(
                      children: [
                        const Icon(Icons.local_offer,
                            size: 14, color: Color(0xFFFB8C00)),
                        const SizedBox(width: 4),
                        Text(
                          discount,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // "View Items" Arrow
              GestureDetector(
                onTap: onShopTap,
                child: const Row(
                  children: [
                    Text(
                      'Visit Farm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFB8C00), // Orange/Harvest color
                        fontSize: 13,
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        size: 16, color: Color(0xFFFB8C00)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // 2. PRODUCT SCROLLABLE LIST
          SizedBox(
            height: 240, // Height for product card
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  width: 140, // Fixed width for scrollable cards
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[100],
                            image: DecorationImage(
                              image: NetworkImage(product.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Veg Icon overlay
                          child: Stack(
                            children: [
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(Icons.eco,
                                      size: 12, color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Price
                      Text(
                        '₹${product.finalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),

                      const Spacer(),

                      // ADD Button
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${product.name} added to cart')),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'ADD',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
