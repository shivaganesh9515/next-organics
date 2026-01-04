import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular icon container
            Container(
              width: 56,
              height: 56,
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
                border: isSelected 
                    ? Border.all(color: color ?? AppColors.primary, width: 2)
                    : null,
              ),
              child: iconData != null
                  ? Icon(
                      iconData,
                      size: 26,
                      color: isSelected 
                          ? (color ?? AppColors.primary) 
                          : (color ?? AppColors.textPrimary),
                    )
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: 56,
                        height: 56,
                        placeholder: (context, url) => Container(
                          color: AppColors.background,
                          child: Icon(
                            Icons.eco_outlined,
                            color: AppColors.textHint,
                            size: 24,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.background,
                          child: Icon(
                            Icons.eco_outlined,
                            color: AppColors.textHint,
                            size: 24,
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
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
