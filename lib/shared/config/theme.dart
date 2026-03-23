import 'package:flutter/material.dart';

class AppTheme {
  // Modern accent color - Vibrant Purple/Indigo
  static const Color _primaryDark = Color(0xFF7C3AED); // Vibrant Purple

  // Dark Theme Colors
  static const Color _backgroundDark = Color(0xFF0F172A);
  static const Color _surfaceDark = Color(0xFF1E293B);
  static const Color _surfaceVariantDark = Color(0xFF334155);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _primaryDark,
        secondary: const Color(0xFF8B5CF6),
        tertiary: const Color(0xFF06B6D4),
        surface: _surfaceDark,
        surfaceVariant: _surfaceVariantDark,
        background: _backgroundDark,
        error: const Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFFF1F5F9),
        onBackground: const Color(0xFFF1F5F9),
      ),
      scaffoldBackgroundColor: _backgroundDark,

      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFFF1F5F9),
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: Color(0xFFF1F5F9)),
      ),

      cardTheme: CardThemeData(
        color: _surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _surfaceVariantDark, width: 1),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryDark,
        foregroundColor: Colors.white,
        elevation: 8,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceVariantDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: const TextStyle(color: Color(0xFFCBD5E1)),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIconColor: _primaryDark,
        suffixIconColor: _primaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryDark, width: 2),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFFF1F5F9),
          fontWeight: FontWeight.w700,
          fontSize: 32,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFFF1F5F9),
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineSmall: TextStyle(
          color: Color(0xFFF1F5F9),
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: Color(0xFFF1F5F9),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleMedium: TextStyle(
          color: Color(0xFFF1F5F9),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFFE2E8F0),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFFCBD5E1),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Color(0xFF94A3B8),
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return _primaryDark;
            }
            return const Color(0xFFCBD5E1);
          }),
        ),
      ),
    );
  }
}
