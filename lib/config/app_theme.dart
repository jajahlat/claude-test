import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern Faydabook color palette
  static const Color primaryEmerald = Color(0xFF4BA67D); // Emerald Green
  static const Color accentGold = Color(0xFFD8CBAF); // Sand Gold
  static const Color surfaceIvory = Color(0xFFFAFAFA); // Ivory
  static const Color surfaceDarkCharcoal = Color(0xFF0E0E0E); // Deep Charcoal
  static const Color textDark = Color(0xFF222222); // Neutral Gray Dark
  static const Color textLight = Color(0xFFF8F8F8); // Neutral Gray Light

  // Additional supporting colors
  static const Color emeraldLight = Color(0xFF6BC29A);
  static const Color emeraldDark = Color(0xFF3A8C65);
  static const Color goldLight = Color(0xFFE5DCC8);

  // Dark mode colors
  static const Color darkBg = surfaceDarkCharcoal;
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF252525);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryEmerald,
    scaffoldBackgroundColor: surfaceIvory,
    colorScheme: const ColorScheme.light(
      primary: primaryEmerald,
      secondary: accentGold,
      tertiary: emeraldLight,
      surface: Colors.white,
      surfaceContainerHighest: surfaceIvory,
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: textDark,
      onSurface: textDark,
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
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.08),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: primaryEmerald, width: 2),
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryEmerald,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: accentGold,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: accentGold,
      secondary: primaryEmerald,
      tertiary: emeraldLight,
      surface: darkSurface,
      surfaceContainerHighest: darkCard,
      error: Color(0xFFCF6679),
      onPrimary: textDark,
      onSecondary: textLight,
      onSurface: textLight,
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
        borderRadius: BorderRadius.circular(24),
      ),
      color: darkCard,
      shadowColor: Colors.black.withOpacity(0.3),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: accentGold, width: 2),
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: accentGold,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
