import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Clean home header matching reference design
/// White background, location + search + notification icons
class CurvedHomeHeader extends ConsumerWidget {
  final VoidCallback? onLocationTap;

  const CurvedHomeHeader({
    super.key,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ROW 1: Location | Search + Notification
              Row(
                children: [
                  // Location section
                  Expanded(
                    child: GestureDetector(
                      onTap: onLocationTap,
                      child: Row(
                        children: [
                          // Brand Logo
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/logo-icon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Location Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery location',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Green Valley Point',
                                        style:
                                            AppTypography.labelLarge.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 4), // Adjusted spacing
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 18, // Slightly smaller
                                      color: AppColors.textPrimary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Notification Icon
                  GestureDetector(
                    onTap: () =>
                        context.push('/notifications'), // Updated route
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 22,
                        color: AppColors
                            .textPrimary, // Simple black icon for notifications
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Profile Button (New)
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundColor: AppColors.background,
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
