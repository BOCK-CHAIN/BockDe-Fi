import 'package:flutter/material.dart';

class AppColors {
  // Binance brand colors
  static const Color primary = Color(0xFFF0B90B); // Binance Yellow
  static const Color secondary = Color(0xFF1E2329); // Dark background
  static const Color surface = Color(0xFF2B3139); // Card background
  static const Color cardDark = Color(0xFF1A1A1A);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB7BDC6);
  static const Color textTertiary = Color(0xFF848E9C);
  
  // Status colors
  static const Color success = Color(0xFF0ECB81); // Green for gains
  static const Color error = Color(0xFFF6465D); // Red for losses
  static const Color warning = Color(0xFFFCD535);
  
  // Background colors
  static const Color background = Color(0xFF0B0E11);
  static const Color backgroundSecondary = Color(0xFF1E2329);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      fontFamily: 'SF Pro Display',
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 12,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}