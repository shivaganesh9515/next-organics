import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_typography.dart';

/// Large hero promotional banner inspired by Swiggy
/// Features bold text, colorful background, and CTA button
class HeroPromoBanner extends StatelessWidget {
  final String mainText;
  final String ctaText;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final List<Color>? gradientColors;
  final String? imageUrl;

  const HeroPromoBanner({
    super.key,
    required this.mainText,
    this.ctaText = 'ORDER NOW',
    this.onTap,
    this.backgroundColor = const Color(0xFFFF5722),
    this.gradientColors,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 200,
      decoration: BoxDecoration(
        color: gradientColors == null ? backgroundColor : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          // Gradient Overlay for Text Readability
          if (imageUrl != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            )
          else 
            // Original Gradient Background logic if no image
             Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: gradientColors != null
                  ? LinearGradient(
                      colors: gradientColors!,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              ),
            ),

          // Decorative circles (Only if no image, to avoid clutter)
          if (imageUrl == null) ...[
            Positioned(
              top: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
          Positioned(
            top: 40,
            right: 60,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Content
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRect(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main promotional text - constrained
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          mainText,
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // CTA Button
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onTap?.call();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          ctaText,
                          style: AppTypography.labelLarge.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
