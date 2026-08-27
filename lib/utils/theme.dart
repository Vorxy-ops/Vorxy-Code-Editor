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
    cardTheme: CardTheme(
      color: cardPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: accentGold, width: 1),
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

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF1A0B2E),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1A0B2E), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A0B2E),
        foregroundColor: Colors.white,
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
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Color(0xFF1A0B2E), fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF1A0B2E),
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
  );

  static Map<String, TextStyle> get codeTheme {
    return vsTheme;
  }
}
