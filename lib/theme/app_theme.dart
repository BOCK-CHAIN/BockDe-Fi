import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF8B5CF6);
  static const Color backgroundColor = Color(0xFF0F0F23);
  static const Color cardColor = Color(0xFF1A1A2E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color.fromARGB(255, 122, 79, 223);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.purple,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
    ),
  );
}