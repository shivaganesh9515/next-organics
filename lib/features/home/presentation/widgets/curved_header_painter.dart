import 'package:flutter/material.dart';

/// Custom painter for creating a curved bottom edge on the header
/// Creates a concave curve (inverted radius) with 24px depth at center
class CurvedHeaderPainter extends CustomPainter {
  final Color backgroundColor;
  final Gradient? gradient;

  CurvedHeaderPainter({
    this.backgroundColor = Colors.white,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Apply gradient or solid color
    if (gradient != null) {
      paint.shader = gradient!.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    } else {
      paint.color = backgroundColor;
    }

    final path = Path();
    
    // Start from top-left
    path.lineTo(0, 0);
    
    // Top edge
    path.lineTo(size.width, 0);
    
    // Right edge down to where curve starts
    path.lineTo(size.width, size.height - 24);
    
    // Curved bottom edge (concave curve - curves inward)
    // Using quadratic Bezier curve for smooth concave effect
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 12,  // Control point 1 (right quarter)
      size.width * 0.5, size.height,         // Center point (deepest curve)
    );
    
    path.quadraticBezierTo(
      size.width * 0.25, size.height - 12,  // Control point 2 (left quarter)
      0, size.height - 24,                   // Left endpoint
    );
    
    // Left edge back to top
    path.lineTo(0, 0);
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvedHeaderPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gradient != gradient;
  }
}
