import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Custom clipper for curved bottom edge of header
class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 24);
    
    // Create concave curve at bottom
    path.quadraticBezierTo(
      size.width / 2, // Control point X (center)
      size.height,     // Control point Y (full height)
      size.width,      // End point X (right edge)
      size.height - 24, // End point Y (same as start)
    );
    
    path.lineTo(size.width, 0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
