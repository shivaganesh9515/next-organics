import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Small promotional offer card for horizontal scrolling
/// Uses FittedBox to prevent overflow
class SmallOfferCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final List<Color>? gradientColors;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const SmallOfferCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.backgroundColor = const Color(0xFFFF5722),
    this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: gradientColors == null ? backgroundColor : null,
          gradient: gradientColors != null
              ? LinearGradient(
                  colors: gradientColors!,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon/Emoji
              // Icon/Image
              if (icon.startsWith('http'))
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset:  const Offset(0, 2)),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(icon),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Text(
                  icon.length > 2 ? '🎁' : icon,
                  style: const TextStyle(fontSize: 28),
                ),
              const SizedBox(height: 4),
              // Title
              SizedBox(
                width: 80,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              // Subtitle
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
