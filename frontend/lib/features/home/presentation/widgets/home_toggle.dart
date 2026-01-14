import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum ActiveMode { hub, farms }

final activeModeProvider = StateProvider<ActiveMode>((ref) => ActiveMode.hub);

class HomeToggle extends ConsumerWidget {
  const HomeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMode = ref.watch(activeModeProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated Background
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: activeMode == ActiveMode.hub
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5 -
                  20, // Approx half width
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Text Labels
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ref.read(activeModeProvider.notifier).state =
                        ActiveMode.hub;
                  },
                  child: Center(
                    child: Text(
                      'Hub Store',
                      style: activeMode == ActiveMode.hub
                          ? AppTypography.labelLarge.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700)
                          : AppTypography.labelLarge
                              .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ref.read(activeModeProvider.notifier).state =
                        ActiveMode.farms;
                  },
                  child: Center(
                    child: Text(
                      'Farms',
                      style: activeMode == ActiveMode.farms
                          ? AppTypography.labelLarge.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700)
                          : AppTypography.labelLarge
                              .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
