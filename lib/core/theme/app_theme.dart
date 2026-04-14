import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const primary = Color(0xFFE46F2A);
    const secondary = Color(0xFFF08A4B);
    const tertiary = Color(0xFFFFC6A6);
    const surface = Color(0xFFFFFBF7);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      secondary: secondary,
      tertiary: tertiary,
      brightness: Brightness.light,
      surface: surface,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF6F1EA),
      useMaterial3: true,
      textTheme: ThemeData.light().textTheme.copyWith(
        headlineLarge: const TextStyle(
          fontSize: 34,
          height: 1.05,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E1C1A),
        ),
        headlineSmall: const TextStyle(
          fontSize: 28,
          height: 1.1,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E1C1A),
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E1C1A),
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E1C1A),
        ),
        bodyLarge: const TextStyle(
          fontSize: 15,
          height: 1.4,
          color: Color(0xFF49433E),
        ),
        bodyMedium: const TextStyle(
          fontSize: 13,
          height: 1.4,
          color: Color(0xFF5A544E),
        ),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFCFA),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2E2A27),
          side: const BorderSide(color: Color(0xFFD9C7B8)),
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFFFF4EC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: const TextStyle(
          color: Color(0xFF5A4336),
          fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: Color(0xFFF1D3BE)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFD9C3),
        elevation: 0,
        height: 74,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE4D8CD),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2F2A27),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
