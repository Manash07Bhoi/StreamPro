import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.colorPrimary,
      scaffoldBackgroundColor: AppColors.colorBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.colorPrimary,
        secondary: AppColors.colorSecondary,
        surface: AppColors.colorSurface,
        error: AppColors.colorError,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.colorBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.colorTextPrimary),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.colorTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.colorSurface,
        elevation: 4,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.colorSurface,
        selectedItemColor: AppColors.colorPrimary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 32,
          letterSpacing: -0.5,
          color: AppColors.colorTextPrimary,
        ),
        displayMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 26,
          color: AppColors.colorTextPrimary,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: AppColors.colorTextPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: AppColors.colorTextPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: AppColors.colorTextPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: AppColors.colorTextPrimary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.colorTextPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.colorTextSecondary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: AppColors.colorTextSecondary,
        ),
        labelLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.1,
          color: AppColors.colorTextPrimary,
        ),
        labelMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: AppColors.colorTextPrimary,
        ),
        labelSmall: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 10,
          letterSpacing: 0.5,
          color: AppColors.colorTextPrimary,
        ),
      ),
    );
  }

  // Glassmorphic helper
  static Widget glassmorphicContainer({
    required Widget child,
    double borderRadius = 16.0,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: (0.05)),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppColors.colorBorder,
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
