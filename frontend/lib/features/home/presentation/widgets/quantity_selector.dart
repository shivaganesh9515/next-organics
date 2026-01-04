import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Animated quantity selector with (+) and (-) buttons
/// Used when user adds product to cart
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.limeGreen,
        borderRadius: BorderRadius.circular(18), // Full pill shape
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Minus button
          _QuantityButton(
            icon: Icons.remove,
            onTap: () {
              HapticFeedback.lightImpact();
              onDecrement();
            },
          ),
          
          // Quantity display
          Container(
            constraints: const BoxConstraints(minWidth: 28),
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          
          // Plus button
          _QuantityButton(
            icon: Icons.add,
            onTap: () {
              HapticFeedback.lightImpact();
              onIncrement();
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<_QuantityButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
