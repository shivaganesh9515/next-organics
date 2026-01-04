import 'package:flutter/material.dart';

class HomeBanner {
  final String id;
  final String title;
  final String subtitle;
  final String ctaText;
  final String imageUrl;
  final List<Color> gradientColors;
  final String targetRoute;

  const HomeBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.imageUrl,
    required this.gradientColors,
    required this.targetRoute,
  });
}
