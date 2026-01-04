import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========== PRIMARY - LIME GREEN ==========
  static const Color primary = Color(0xFF84CC16);        // Lime green
  static const Color primaryLight = Color(0xFFA3E635);   // Lighter lime
  static const Color primaryDark = Color(0xFF65A30D);    // Darker lime
  static const Color primarySurface = Color(0xFFECFCCB); // Very light lime

  // ========== BACKGROUNDS ==========
  static const Color background = Color(0xFFF5F7F2);     // Soft off-white/cream
  static const Color surface = Color(0xFFFFFFFF);        // Pure white
  static const Color surfaceVariant = Color(0xFFF8F9F6);
  static const Color creamBackground = Color(0xFFF5F7F2);

  // ========== TEXT ==========
  static const Color textPrimary = Color(0xFF1A1A1A);    // Near black
  static const Color textSecondary = Color(0xFF6B7280);  // Gray
  static const Color textHint = Color(0xFF9CA3AF);       // Light gray

  // Dark Mode (keeping for compatibility)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textHintDark = Color(0xFF6B7280);

  // ========== SEMANTIC ==========
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ========== UI ELEMENTS ==========
  static const Color divider = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);
  
  static const Color ratingStar = Color(0xFFFBBF24);     // Yellow star
  static const Color ratingGold = Color(0xFFFFB800);
  static const Color discount = Color(0xFF84CC16);       // Same as primary for discount badges

  // ========== NAVIGATION ==========
  static const Color navBackground = Color(0xFFFFFFFF);  // White
  static const Color navActive = Color(0xFF84CC16);      // Lime green
  static const Color navInactive = Color(0xFF9CA3AF);    // Gray

  // ========== CATEGORY ICONS ==========
  static const Color categoryVeggies = Color(0xFF22C55E);
  static const Color categoryFruits = Color(0xFFF59E0B);
  static const Color categoryDairy = Color(0xFF60A5FA);
  static const Color categoryPantry = Color(0xFFD4A574);
  static const Color categoryOrganic = Color(0xFF84CC16);

  // ========== SECONDARY - KEEPING FOR BADGES ==========
  static const Color secondary = Color(0xFFE07A5F);      // Terracotta for variety
  static const Color secondaryLight = Color(0xFFF2A391);
  static const Color secondaryDark = Color(0xFFBC5D46);
  
  // Gold (for compatibility)
  static const Color gold = Color(0xFFC9A959);
  static const Color goldLight = Color(0xFFE8D5A3);
  static const Color goldDark = Color(0xFFB8860B);
  
  // Lime accents
  static const Color limeGreen = Color(0xFF84CC16);
  static const Color limeGreenLight = Color(0xFFA3E635);

  // ========== GRADIENTS ==========
  static const List<Color> premiumGradient = [
    Color(0xFF84CC16),
    Color(0xFFA3E635),
  ];
  
  static const List<Color> goldGradient = [
    Color(0xFFC9A959),
    Color(0xFFE8D5A3),
  ];
  
  static const List<Color> bannerGradient = [
    Color(0xFFECFCCB),
    Color(0xFFA3E635),
  ];
}

