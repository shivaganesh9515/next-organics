import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Private constructor
  AppTypography._();

  // Premium font families
  static String get headingFont => GoogleFonts.playfairDisplay().fontFamily!;
  static String get bodyFont => GoogleFonts.dmSans().fontFamily!;

  // ========== DISPLAY STYLES (Playfair - Luxury) ==========
  
  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle displaySmall = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.2,
  );

  // ========== HEADING STYLES (Playfair) ==========
  
  static TextStyle headingLarge = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static TextStyle headingMedium = GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static TextStyle headingSmall = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  // ========== BODY STYLES (DM Sans - Clean) ==========
  
  static TextStyle bodyLarge = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // ========== LABEL STYLES (DM Sans) ==========
  
  static TextStyle labelLarge = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle labelSmall = GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // ========== SPECIAL STYLES ==========
  
  static TextStyle caption = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static TextStyle overline = GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );
  
  // Tagline style
  static TextStyle tagline = GoogleFonts.playfairDisplay(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.5,
  );

  // ========== PRICE STYLES (DM Sans Bold) ==========
  
  static TextStyle priceLarge = GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  static TextStyle priceMedium = GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static TextStyle priceSmall = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  
  // ========== PREMIUM BADGE ==========
  
  static TextStyle premiumBadge = GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );
}
