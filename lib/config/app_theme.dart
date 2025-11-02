import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Sufi-inspired color palette
  static const Color primaryGreen = Color(0xFF2D5F3F); // Deep green
  static const Color primaryGold = Color(0xFFD4AF37); // Islamic gold
  static const Color accentTeal = Color(0xFF4A7C7E); // Calm teal
  static const Color bgCream = Color(0xFFF5F1E8); // Warm cream
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFFE8E8E8);

  // Dark mode colors
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: bgCream,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: primaryGold,
      tertiary: accentTeal,
      surface: Colors.white,
      background: bgCream,
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: textDark,
      onSurface: textDark,
      onBackground: textDark,
    ),

    // Typography
    textTheme: TextTheme(
      displayLarge: GoogleFonts.amiri(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      displayMedium: GoogleFonts.amiri(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineMedium: GoogleFonts.amiri(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleLarge: GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleMedium: GoogleFonts.lora(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textDark,
      ),
      bodyLarge: GoogleFonts.lora(
        fontSize: 16,
        color: textDark,
      ),
      bodyMedium: GoogleFonts.lora(
        fontSize: 14,
        color: textDark,
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: textDark),
      titleTextStyle: GoogleFonts.amiri(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
    ),

    // Card
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryGold,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: primaryGold,
      secondary: accentTeal,
      tertiary: primaryGreen,
      surface: darkSurface,
      background: darkBg,
      error: Color(0xFFCF6679),
      onPrimary: textDark,
      onSecondary: textLight,
      onSurface: textLight,
      onBackground: textLight,
    ),

    // Typography
    textTheme: TextTheme(
      displayLarge: GoogleFonts.amiri(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      displayMedium: GoogleFonts.amiri(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      headlineMedium: GoogleFonts.amiri(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      titleLarge: GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      titleMedium: GoogleFonts.lora(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textLight,
      ),
      bodyLarge: GoogleFonts.lora(
        fontSize: 16,
        color: textLight,
      ),
      bodyMedium: GoogleFonts.lora(
        fontSize: 14,
        color: textLight,
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      elevation: 0,
      iconTheme: const IconThemeData(color: textLight),
      titleTextStyle: GoogleFonts.amiri(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
    ),

    // Card
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: darkCard,
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primaryGold,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
