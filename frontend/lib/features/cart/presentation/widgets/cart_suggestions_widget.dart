import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../home/presentation/widgets/large_product_card.dart'; // Reuse for consistency or create smaller?
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

class CartSuggestionsWidget extends ConsumerWidget {
  const CartSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(productsProvider);

    // Filter logic: Impulse buys (Price < 200 or random)
    // Exclude items already in cart? (Ideally yes, but let's keep it simple first)
    final suggestions =
        allProducts.where((p) => p.price < 200).take(5).toList();

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            'You might also like',
            style: AppTypography.headingSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            separatorBuilder: (ctx, i) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final product = suggestions[index];
              return SizedBox(
                width: 200,
                child: LargeProductCard(
                  product: product,
                  onTap: () => context.push('/product/${product.id}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
