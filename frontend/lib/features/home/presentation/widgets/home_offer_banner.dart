import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_typography.dart';

/// Context-aware offer banner displayed between categories and products
/// Supports multiple gradient variants and entrance animations
class HomeOfferBanner extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String ctaText;
  final VoidCallback? onTap;
  final BannerVariant variant;

  const HomeOfferBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.ctaText = 'Order Now',
    this.onTap,
    this.variant = BannerVariant.green,
  });

  @override
  State<HomeOfferBanner> createState() => _HomeOfferBannerState();
}

class _HomeOfferBannerState extends State<HomeOfferBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isTappedDown = false;

  @override
  void initState() {
    super.initState();
    
    // Entrance animation: fade + slide up
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    // Start entrance animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.variant == BannerVariant.green
        ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
        : [const Color(0xFFFFF9E6), const Color(0xFFFFECB3)];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isTappedDown = true),
            onTapUp: (_) {
              setState(() => _isTappedDown = false);
              _handleTap();
            },
            onTapCancel: () => setState(() => _isTappedDown = false),
            child: AnimatedScale(
              scale: _isTappedDown ? 0.98 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                height: 90,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Left Icon with white circular background
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Text Column (title + subtitle)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: AppTypography.labelLarge.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF555555),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // CTA (right)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.ctaText,
                          style: AppTypography.labelMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Color(0xFF2E7D32),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Banner color variants
enum BannerVariant {
  green,
  yellow,
}
