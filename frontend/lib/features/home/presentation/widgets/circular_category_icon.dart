import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animations/animated_scale_button.dart';

/// Clean circular category icon matching reference design
/// Small white circle with icon, label below.
/// Supports custom colors for "Organic" theme consistency.
class CircularCategoryIcon extends StatelessWidget {
  final String imageUrl;
  final String label;
  final IconData? iconData; // Optional icon instead of image
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? color;

  const CircularCategoryIcon({
    super.key,
    required this.imageUrl,
    required this.label,
    this.iconData,
    this.onTap,
    this.isSelected = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleButton(
      onTap: onTap,
      child: SizedBox(
        width: 76, // Slightly wider for better text fit
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular icon container
            Container(
              width: 60, // Larger touch target
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10), // Softer shadow
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: isSelected
                    ? Border.all(color: color ?? AppColors.primary, width: 2)
                    : Border.all(
                        color: Colors.grey.shade100,
                        width: 1), // Subtle border for unselected
              ),
              child: Padding(
                // Padding for ease
                padding: const EdgeInsets.all(2.0),
                child: ClipOval(
                  child: iconData != null
                      ? Center(
                          child: Icon(
                            iconData,
                            size: 28,
                            color: isSelected
                                ? (color ?? AppColors.primary)
                                : (color ?? AppColors.textPrimary),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: AppColors.background,
                            child: const Icon(
                              Icons.eco_outlined,
                              color: AppColors.textHint,
                              size: 24,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.background,
                            child: const Icon(
                              Icons.eco_outlined,
                              color: AppColors.textHint,
                              size: 24,
                            ),
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Label
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 12,
                color: isSelected
                    ? (color ?? AppColors.textPrimary)
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: -0.2, // Tighter tracking
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Allow 2 lines for "Fruits & Veggies"
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
