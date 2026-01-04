import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class FloatingBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag_rounded,
            label: 'Shop',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: Icons.favorite_outline_rounded,
            activeIcon: Icons.favorite_rounded,
            label: 'Saved',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            icon: Icons.shopping_cart_outlined,
            activeIcon: Icons.shopping_cart_rounded,
            label: 'Cart',
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
            badge: 2,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        height: 72,
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic, // Snappy fade/expand
          padding: isActive 
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              : const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent, // FADE IN COLOR
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon with Scale effect on tap/active
              Stack(
                clipBehavior: Clip.none,
                children: [
                   AnimatedScale(
                     scale: isActive ? 1.0 : 0.9,
                     duration: const Duration(milliseconds: 200),
                     child: Icon(
                      isActive ? (activeIcon ?? icon) : icon,
                      size: 24,
                      color: isActive ? Colors.white : AppColors.textPrimary,
                     ),
                   ),
                   if (badge != null && badge! > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              
              if (isActive) ...[
                const SizedBox(width: 8),
                // Text Fades In
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
