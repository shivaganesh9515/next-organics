import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class Store99Section extends StatelessWidget {
  const Store99Section({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF4DB6AC)], // Teal/Forest Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // "Fresh Finds" stylized text/logo simulation
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'BIO',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Color(0xFF00695C),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Fresh Finds',
                  style: TextStyle(
                    fontFamily: 'Cursive',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                Text(
                  'Starting @ ₹49',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Horizontal List of Organic Deal Items
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                color: Colors.green[50], // Light green bg
                                child: const Icon(Icons.eco, size: 40, color: Colors.green), // Eco icon
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black26)],
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Mock Data Updates
                      Text(
                        index.isEven ? 'Fresh Spinach' : 'Organic Apples',
                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Farm Fresh',
                        style: AppTypography.labelSmall.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹99',
                            style: AppTypography.labelSmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            color: Colors.green[100],
                            child: Text('₹${index.isEven ? 49 : 69}', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.green[900]
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 10, color: Colors.green),
                            SizedBox(width: 2),
                            Text('4.8', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
