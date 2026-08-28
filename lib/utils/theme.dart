import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/vs.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF1A0B2E);
  static const Color accentGold = Color(0xFFFFD700);
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color cardPurple = Color(0xFF2A1545);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: primaryPurple,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryPurple,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: accentGold,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardThemeData(
      color: cardPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: accentGold, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGold,
        foregroundColor: primaryPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textLight),
      bodyMedium: TextStyle(color: textLight),
      titleLarge: TextStyle(color: accentGold, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardPurple,
      selectedItemColor: accentGold,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
  );

  static Map<String, TextStyle> get codeTheme {
    return vsTheme;
  }
}
