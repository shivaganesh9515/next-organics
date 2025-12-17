import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors - Fresh Green Palette (Updated to match Header)
  static const Color primary = Color(0xFF2E7D32); // Organic Deep Green (Header)
  static const Color primaryLight = Color(0xFF66BB6A); // Fresh Leaf Green (Header Gradient)
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primarySurface = Color(0xFFE8F5E9);
  
  // Lime Green Accent (Active states from reference design)
  static const Color limeGreen = Color(0xFFB8F545);
  static const Color limeGreenLight = Color(0xFFD4FA8C);

  // Secondary Colors - Orange Accent
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color secondaryDark = Color(0xFFF57C00);

  // Neutral Colors - Light Mode
  static const Color background = Color(0xFFF5F3ED);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Neutral Colors - Dark Mode
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textHintDark = Color(0xFF757575);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Dividers and Borders
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // Rating Star
  static const Color ratingStar = Color(0xFFFFC107);
  static const Color ratingGold = Color(0xFFFFB800);

  // Discount Badge
  static const Color discount = Color(0xFFE91E63);

  // ===== HOME SCREEN REDESIGN COLORS =====
  
  // Backgrounds
  static const Color creamBackground = Color(0xFFF8F6F3);
  static const Color lightGraySection = Color(0xFFFAFAFA);
  static const Color limeGreenShadow = Color(0x40C8E85F); // 25% opacity for glow
  
  // Category-specific Colors (for unique category icons)
  static const Color categoryMeats = Color(0xFF8B4513);
  static const Color categoryVeggies = Color(0xFF4CAF50);
  static const Color categoryFruits = Color(0xFFFF9800);
  static const Color categoryBakery = Color(0xFFD4A574);
  static const Color categoryDairy = Color(0xFF64B5F6);
  static const Color categoryOrganic = Color(0xFF7CB342);
  
  // Banner Card Gradients (Yellow variant for offers)
  static const Color bannerYellowStart = Color(0xFFFFF9E6);
  static const Color bannerYellowEnd = Color(0xFFFFECB3);
  
  // Banner Card Gradients (Green variant for eco/delivery)
  static const Color bannerGreenStart = Color(0xFFE8F5E9);
  static const Color bannerGreenEnd = Color(0xFFC8E6C9);
  
  // UI Element Colors
  static const Color pillBackground = Color(0xFFF0F0F0); // For unselected states
  static const Color iconGray = Color(0xFF999999); // For inactive icons
}
