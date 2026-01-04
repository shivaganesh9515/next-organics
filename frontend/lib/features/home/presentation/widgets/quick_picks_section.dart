import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/presentation/providers/products_provider.dart';
import 'quick_pick_card.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/loading_indicator.dart';

/// "Quick Picks" section for fast one-tap adding
/// Horizontal list of compact cards focused on speed
class QuickPicksSection extends ConsumerWidget {
  const QuickPicksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      data: (products) {
        // Take first 8 products for quick picks
        final quickPicks = products.take(8).toList();

        if (quickPicks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Picks ⚡',
                    style: AppTypography.displaySmall.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Daily essentials, fast add',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 12,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            
            // Horizontal Product List
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 80),
                itemCount: quickPicks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: QuickPickCard(product: quickPicks[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 240,
        child: Center(child: LoadingIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
