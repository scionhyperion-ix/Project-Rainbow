import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color _paper = Color(0xFFFBFBFA);
  static const Color _ink = Color(0xFF2F2F2F);
  static const Color _softInk = Color(0xFF787774);
  static const Color _line = Color(0xFFE9E9E7);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF37352F),
      brightness: Brightness.light,
      surface: _paper,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: _paper,
        onSurface: _ink,
        outlineVariant: _line,
      ),
      scaffoldBackgroundColor: _paper,
      dividerColor: _line,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          height: 1.15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
          color: _ink,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.2,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: _ink,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: _ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: _softInk,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          side: BorderSide(color: _line),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        elevation: 0,
        height: 68,
        backgroundColor: Color(0xFFF7F7F5),
        indicatorColor: Color(0xFFEAEAE7),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF1F1EF),
        hintStyle: TextStyle(color: _softInk),
        prefixIconColor: _softInk,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFFCFCFCA)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFD6D3CC),
      brightness: Brightness.dark,
      surface: const Color(0xFF191919),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: const Color(0xFF191919),
        onSurface: const Color(0xFFF1F1EF),
        outlineVariant: const Color(0xFF343434),
      ),
      scaffoldBackgroundColor: const Color(0xFF191919),
      dividerColor: const Color(0xFF343434),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          height: 1.15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
          color: Color(0xFFF1F1EF),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF1F1EF),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF1F1EF),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: Color(0xFFF1F1EF),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: Color(0xFFB8B8B4),
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF1F1EF),
        ),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Color(0xFF202020),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          side: BorderSide(color: Color(0xFF343434)),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        elevation: 0,
        height: 68,
        backgroundColor: Color(0xFF202020),
        indicatorColor: Color(0xFF303030),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF252525),
        hintStyle: TextStyle(color: Color(0xFF9B9B98)),
        prefixIconColor: Color(0xFF9B9B98),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFF565653)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
