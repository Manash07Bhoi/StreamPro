import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const Color colorBackground = Color(0xFF0A0A0A);
  static const Color colorSurface = Color(0xFF121212);
  static const Color colorSurface2 = Color(0xFF1A1A1A);
  static const Color colorSurface3 = Color(0xFF242424);

  // Primary / Brand Colors
  static const Color colorPrimary = Color(0xFFC026D3);
  static const Color colorSecondary = Color(0xFFDB2777);
  static const Color colorGradientStart = Color(0xFFC026D3);
  static const Color colorGradientEnd = Color(0xFFDB2777);

  // Text Colors
  static const Color colorTextPrimary = Color(0xFFFFFFFF);
  static const Color colorTextSecondary = Color(0xFF9CA3AF); // Gray-400
  static const Color colorTextMuted = Color(0xFF6B7280); // Gray-500

  // State Colors
  static const Color colorSuccess = Color(0xFF10B981); // Emerald
  static const Color colorWarning = Color(0xFFF59E0B); // Amber
  static const Color colorError = Color(0xFFEF4444); // Red

  // Borders & Effects
  static const Color colorBorder = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color colorGlow = Color(0x59C026D3); // rgba(192, 38, 211, 0.35)

  // Gradient helper
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [colorGradientStart, colorGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
