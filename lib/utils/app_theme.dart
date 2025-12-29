import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF7FFF00);
  static const Color darkGreen = Color(0xFF1A2F1A);
  static const Color cardGreen = Color(0xFF2A3F2A);
  static const Color borderGreen = Color(0xFF3A4A3A);
  static const Color textGrey = Color(0xFFB0B0B0);
  static const Color textDarkGrey = Color(0xFF5A6A5A);
  static const Color textMidGrey = Color(0xFF7A8A7A);

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: darkGreen,
      fontFamily: 'SF Pro Display',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textGrey,
        ),
      ),
    );
  }
}
