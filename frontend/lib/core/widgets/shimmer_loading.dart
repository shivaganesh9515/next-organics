import 'package:flutter/material.dart';

/// Premium shimmer loading effect for product cards and other elements
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  
  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF5F5F5),
                Color(0xFFFFFFFF),
                Color(0xFFF5F5F5),
                Color(0xFFEEEEEE),
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer product card placeholder
class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          Expanded(
            flex: 58,
            child: ShimmerLoading(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 12,
            ),
          ),
          const SizedBox(height: 8),
          // Text shimmers
          const ShimmerLoading(width: 100, height: 14, borderRadius: 4),
          const SizedBox(height: 6),
          const ShimmerLoading(width: 70, height: 12, borderRadius: 4),
          const SizedBox(height: 8),
          const ShimmerLoading(width: double.infinity, height: 36, borderRadius: 18),
        ],
      ),
    );
  }
}

/// Shimmer category icon placeholder
class ShimmerCategoryIcon extends StatelessWidget {
  const ShimmerCategoryIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const ClipOval(
              child: ShimmerLoading(
                width: 70,
                height: 70,
                borderRadius: 35,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const ShimmerLoading(width: 60, height: 12, borderRadius: 4),
        ],
      ),
    );
  }
}
