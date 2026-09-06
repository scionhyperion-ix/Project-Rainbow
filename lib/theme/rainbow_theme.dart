import 'package:flutter/material.dart';

abstract final class RainbowTheme {
  static const paper = Color(0xFFFBFBFA);
  static const ink = Color(0xFF2F2F2F);
  static const mutedInk = Color(0xFF787774);
  static const line = Color(0xFFE7E7E4);
  static const softSurface = Color(0xFFF4F4F2);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5F5B55),
      brightness: Brightness.light,
      surface: paper,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: paper,
        onSurface: ink,
        outlineVariant: line,
      ),
      scaffoldBackgroundColor: paper,
      dividerColor: line,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 31,
          height: 1.12,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.9,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 27,
          height: 1.15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.2,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.48,
          color: ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: mutedInk,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: line),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: softSurface,
        hintStyle: TextStyle(color: mutedInk),
        prefixIconColor: mutedInk,
        suffixIconColor: mutedInk,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFFCFCFCA)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: paper,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    const darkSurface = Color(0xFF191919);
    const darkCard = Color(0xFF202020);
    const darkSoft = Color(0xFF252525);
    const darkLine = Color(0xFF363636);
    const darkText = Color(0xFFF1F1EF);
    const darkMuted = Color(0xFFAAA9A5);

    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFD6D2CB),
      brightness: Brightness.dark,
      surface: darkSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: darkSurface,
        onSurface: darkText,
        outlineVariant: darkLine,
      ),
      scaffoldBackgroundColor: darkSurface,
      dividerColor: darkLine,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkText,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 31,
          height: 1.12,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.9,
          color: darkText,
        ),
        headlineMedium: TextStyle(
          fontSize: 27,
          height: 1.15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
          color: darkText,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: darkText,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.48,
          color: darkText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: darkMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: darkCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: darkLine),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: darkSoft,
        hintStyle: TextStyle(color: darkMuted),
        prefixIconColor: darkMuted,
        suffixIconColor: darkMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF595959)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkText,
          foregroundColor: darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),
    );
  }
}