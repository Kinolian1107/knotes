import 'package:flutter/material.dart';

class AppTheme {
  static const darkNavy = Color(0xFF101423);
  static const cardNavy = Color(0xFF1B2033);
  static const accentTeal = Color(0xFF1E9E81);
  static const proBannerBg = Color(0xFF2D1C4D);
  static const proBannerIcon = Color(0xFFB472FF);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkNavy,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkNavy,
      elevation: 0,
      centerTitle: true,
    ),
    cardColor: cardNavy,
    chipTheme: ChipThemeData(
      backgroundColor: cardNavy,
      selectedColor: accentTeal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentTeal,
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      primary: accentTeal,
      surface: cardNavy,
    ),
  );
}
